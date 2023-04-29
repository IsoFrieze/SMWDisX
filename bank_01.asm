    ORG $018000

DATA_018000:
    db $80,$40,$20,$10,$08,$04,$02,$01        ; AND table, used by the line-guided sprites.

IsTouchingObjSide:
    LDA.W SpriteBlockedDirs,X                 ; \ Set A to lower two bits of; Subroutine (JSR) to check if a sprite is touching the sides of a solid block.
    AND.B #$03                                ; / current sprite's Position Status
    RTS

IsOnGround:
    LDA.W SpriteBlockedDirs,X                 ; \ Set A to bit 2 of; Subroutine (JSR) to check if a sprite is touching the top of a solid block.
    AND.B #$04                                ; / current sprite's Position Status
    RTS

IsTouchingCeiling:
    LDA.W SpriteBlockedDirs,X                 ; \ Set A to bit 3 of; Subroutine (JSR) to check if a sprite is touching the bottom of a solid block.
    AND.B #$08                                ; / current sprite's Position Status
    RTS

UpdateYPosNoGvtyW:
    PHB                                       ; Subroutine (JSL) to update a sprite's Y position without applying gravity.
    PHK
    PLB
    JSR SubSprYPosNoGrvty
    PLB
    RTL

UpdateXPosNoGvtyW:
    PHB                                       ; Subroutine (JSL) to update a sprite's X position without applying gravity.
    PHK
    PLB
    JSR SubSprXPosNoGrvty
    PLB
    RTL

UpdateSpritePos:
    PHB                                       ; Subroutine (JSL) to update a sprite's position and apply gravity. Also processes object interaction if set to do so.
    PHK
    PLB
    JSR SubUpdateSprPos
    PLB
    RTL

SprSprInteract:
    PHB                                       ; Subroutine (JSL) to check for interaction between a sprite and all other sprites.
    PHK
    PLB
    JSR SubSprSprInteract
    PLB
    RTL

SprSpr_MarioSprRts:
    PHB                                       ; Subroutine (JSL) to process interaction between a sprite and both other sprites and Mario.
    PHK
    PLB
    JSR SubSprSpr_MarioSpr
    PLB
    RTL

GenericSprGfxRt0:
    PHB                                       ; Subroutine (JSL) to get graphics for some sprites. This one creates four 8x8 tiles in a 16x16 arrangement.
    PHK
    PLB
    JSR SubSprGfx0Entry0
    PLB
    RTL

InvertAccum:
    EOR.B #$FF                                ; \ Set A to -A; Subroutine (JSR) to invert the accumulator.
    INC A                                     ; /
    RTS

CODE_01804E:
; Subroutine to draw a smoke/dust sprite at the sprite's position. Specifically meant for sliding smoke from friction.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if in air; If the sprite is not blocked on any side, return.
    BEQ Return018072                          ; /
    LDA.B TrueFrame
    AND.B #$03                                ; Only calculate once every 4 frames, completely ignore if the level is slippery.
    ORA.B LevelIsSlippery
    BNE Return018072
    LDA.B #$04                                ; Distance from the sprite's left side to spawn the smoke.
    STA.B _0
    LDA.B #$0A                                ; Distance below the sprite's top to spawn the smoke.
    STA.B _1
CODE_018063:
    JSR IsSprOffScreen                        ; If the sprite is offscreen, don't bother calculating.
    BNE Return018072
    LDY.B #$03
CODE_01806A:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_018073                           ; Look for an empty smoke sprite slot, return if none are found.
    DEY
    BPL CODE_01806A
Return018072:
    RTS

CODE_018073:
    LDA.B #$03                                ; Draw sliding smoke...
    STA.W SmokeSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    ADC.B _0
    STA.W SmokeSpriteXPos,Y                   ; ...at the sprite's position...
    LDA.B SpriteYPosLow,X
    ADC.B _1
    STA.W SmokeSpriteYPos,Y
    LDA.B #$13                                ; ...for 19 frames.
    STA.W SmokeSpriteTimer,Y
    RTS

CODE_01808C:
    PHB                                       ; Routine for running all the standard and cluster sprite routines.
    PHK
    PLB
    LDA.W IsCarryingItem
    STA.W CarryingFlag                        ; Reset carrying enemy flag; Refresh some addresses:
    STZ.W IsCarryingItem                      ; Carrying something flag
    STZ.W StandOnSolidSprite                  ; Standing on top of a sprite flag
    STZ.W PlayerInCloud                       ; Riding cloud flag
    LDA.W CurrentYoshiSlot                    ; Yoshi's sprite slot
    STA.W YoshiIsLoose
    STZ.W CurrentYoshiSlot
    LDX.B #$0B
  - STX.W CurSpriteProcess
    JSR CODE_0180D2                           ; Run each standard sprite's routine.
    JSR HandleSprite
    DEX
    BPL -
    LDA.W ActivateClusterSprite
    BEQ +                                     ; Run cluster sprite routines.
    JSL CODE_02F808
  + LDA.W CurrentYoshiSlot
    BNE +                                     ; Reset some Yoshi-related flags if no Yoshi exists anymore.
    STZ.W PlayerRidingYoshi
    STZ.W ScrShakePlayerYOffset
  + PLB
    RTL

IsSprOffScreen:
    LDA.W SpriteOffscreenX,X                  ; \ A = Current sprite is offscreen; Subroutine to check if a sprite is offscreen, both horizontally and vertically.
    ORA.W SpriteOffscreenVert,X               ; /
    RTS

CODE_0180D2:
    PHX                                       ; In all sprite routines, X = current sprite; Subroutine to decrement all timers and get the OAM slot for the sprite.
    TXA
    LDX.W SpriteMemorySetting                 ; $1692 = Current Sprite memory settings
    CLC                                       ; \
    ADC.L DATA_07F0B4,X                       ; |Add $07:F0B4,$1692 to sprite index.  i.e. minimum one tile allotted to each sprite
    TAX                                       ; |the bytes read go straight to the OAM indexes; Get the OAM index for the sprite.
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
    BEQ +                                     ; |; Decrement misc sprite tables if the game isn't frozen and the sprite is functioning.
    DEC.W SpriteMisc1558,X                    ; |; Affects: $1540, $154C, $1558, $1564, $15AC, $163E, $1FE2
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
    LDA.W SpriteStatus,X                      ; Call a routine based on the sprite's status; Primary routine for handling all sprite states.
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
; Sprite status pointers.
; 0 - Empty
; 1 - Just spawned
; 2 - Killed and falling offscreen
; 3 - Killed by smush (Rex, Koopa, classic Goomba, P-switch)
; 4 - Killed with a spinjump
; 5 - Killed by lava
; 6 - Turned into a coin by a goal tape
; 7 - In Yoshi's mouth
; 8 - Alive/normal (-> CallSpriteMain)
; 9 - Stationary/carryable
; A - Kicked/thrown
; B - Carried
; C - Carried into the goal tape (turned into powerup)
; Routine to permanently erase a sprite from a level (sprite status 0).
    LDA.B #$FF                                ; \ Permanently erase sprite:; Tell the game not to respawn the sprite ever again.
    STA.W SpriteLoadIndex,X                   ; | By changing the sprite's index into the level tables
Return018156:
    RTS                                       ; / the actual sprite won't get marked for reloading

HandleGoalPowerup:
; Routine to handle a powerup spawned from an item carried into a goal tape (sprite status C).
    JSR CallSpriteMain                        ; Run MAIN code for the powerup.
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    DEC.B SpriteYSpeed,X
    DEC.B SpriteYSpeed,X
    JSR IsOnGround                            ; Apply, uh, more gravity.
    BEQ +
    JSR SetSomeYSpeed__
  + RTS

HandleSprLvlEnd:
    JSL LvlEndSprCoins                        ; Redirect to handle a sprite turned into a coin by a goal tape (sprite status 6).
    RTS

CallSpriteInit:
    LDA.B #$08                                ; \ Sprite status = Normal; Routine to initialize a sprite (sprite status 1).
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
; Sprite INIT pointers.
; 00 - Green shell-less Koopa
; 01 - Red shell-less Koopa
; 02 - Blue shell-less Koopa
; 03 - Yellow shell-less Koopa
; 04 - Green Koopa
; 05 - Red Koopa
; 06 - Blue Koopa
; 07 - Yellow Koopa
; 08 - Green winged Koopa, flying
; 09 - Green winged Koopa, bouncing
; 0A - Red winged Koopa, vertical
; 0B - Red winged Koopa, horizontal
; 0C - Yellow winged Koopa
; 0D - Bob-Omb
; 0E - Keyhole
; 0F - Goomba
; 10 - Winged Goomba
; 11 - Buzzy Beetle
; 12 - Unused
; 13 - Spiny
; 14 - Falling Spiny
; 15 - Fish, horizontal
; 16 - Fish, vertical
; 17 - Fish, flying (spawned by sprite D1)
; 18 - Fish, jumping
; 19 - Display text from level message 1
; 1A - Classic Piranha Plant
; 1B - Bouncing Football
; 1C - Bullet Bill
; 1D - Hopping flame
; 1E - Lakitu
; 1F - Magikoopa
; 20 - Magikoopa's magic
; 21 - Moving coin
; 22 - Green vertical net Koopa
; 23 - Red vertical net Koopa
; 24 - Green horizontal net Koopa
; 25 - Red horizontal net Koopa
; 26 - Thwomp
; 27 - Thwimp
; 28 - Big Boo
; 29 - Koopa Kid
; 2A - Upside-down Piranha Plant
; 2B - Sumo Brother's lightning
; 2C - Yoshi egg
; 2D - Baby Yoshi
; 2E - Spike Top
; 2F - Portable springboard
; 30 - Dry Bones that throws bones
; 31 - Bony Beetle
; 32 - Dry Bones that stays on ledges
; 33 - Podoboo/vertical fireball
; 34 - Boss fireball
; 35 - Yoshi
; 36 - Unused
; 37 - Boo
; 38 - Eerie (straight)
; 39 - Eerie (wave)
; 3A - Urchin (fixed distance)
; 3B - Urchin (wall detect)
; 3C - Urchin (wall follow)
; 3D - Rip Van Fish
; 3E - P-switch
; 3F - Para-Goomba
; 40 - Para-Bomb
; 41 - Dolphin (long jump)
; 42 - Dolphin (short jump)
; 43 - Dolphin (vertical)
; 44 - Torpedo Ted
; 45 - Directional coins
; 46 - Diggin' Chuck
; 47 - Swimming/jumping fish
; 48 - Diggin' Chuck's rock
; 49 - Growing/shrinking pipe
; 4A - Goal Sphere
; 4B - Pipe-dwelling Lakitu
; 4C - Exploding block
; 4D - Monty Mole (ground-dwelling)
; 4E - Monty Mole (ledge-dwelling)
; 4F - Jumping Piranha Plant
; 50 - Jumping Piranha Plant (fireballs)
; 51 - Ninji
; 52 - Moving Ghost House hole (note: changed to $0185B7 in LM v2.53+)
; 53 - Throwblock
; 54 - Revolving door for climbing net
; 55 - Checkerboard platform (horizontal)
; 56 - Flying rock platform (horizontal)
; 57 - Checkerboard platform (vertical)
; 58 - Flying rock platform (vertical)
; 59 - Turnblock bridge (horz/vert)
; 5A - Turnblock bridge (horz only)
; 5B - Floating brown platform
; 5C - Floating checkerboard platform
; 5D - Small orange floating platform
; 5E - Large orange floating platform
; 5F - Swinging brown platform
; 60 - Flat switch palace switch
; 61 - Skull raft
; 62 - Brown line-guided platform
; 63 - Brown/checkered line-guided platform
; 64 - Line-guided rope mechanism
; 65 - Chainsaw (line-guided)
; 66 - Upside-down chainsaw (line-guided)
; 67 - Grinder (line-guided)
; 68 - Fuzzy (line-guided)
; 69 - Unused
; 6A - Coin game cloud
; 6B - Wall springboard (left wall)
; 6C - Wall springboard (right wall)
; 6D - Invisible solid block
; 6E - Dino-Rhino
; 6F - Dino-Torch
; 70 - Pokey
; 71 - Super Koopa (red cape)
; 72 - Super Koopa (yellow cape)
; 73 - Super Koopa (ground/feather)
; 74 - Mushroom
; 75 - Flower
; 76 - Star
; 77 - Feather
; 78 - 1up mushroom
; 79 - Growing vine
; 7A - Firework
; 7B - Goal tape
; 7C - Peach
; 7D - P-Balloon
; 7E - Flying red coin
; 7F - Flying golden mushroom
; 80 - Key
; 81 - Changing item
; 82 - Bonus game sprite
; 83 - Flying question block (left)
; 84 - Flying question block (back and forth)
; 85 - Unused
; 86 - Wiggler
; 87 - Lakitu's cloud
; 88 - Winged cage
; 89 - Layer 3 Smash
; 8A - Yoshi's House bird
; 8B - Puff of smoke from Yoshi's House
; 8C - Side exit enable
; 8D - Ghost house exit sign and door
; 8E - Invisible "Warp Hole"
; 8F - Scale platforms
; 90 - Large green gas bubble
; 91 - Chargin' Chuck
; 92 - Splittin' Chuck
; 93 - Bouncin' Chuck
; 94 - Whistlin' Chuck
; 95 - Clappin' Chuck
; 96 - Chargin' Chuck (unused)
; 97 - Puntin' Chuck
; 98 - Pitchin' Chuck
; 99 - Volcano Lotus
; 9A - Sumo Brother
; 9B - Hammer Bro.
; 9C - Hammer Bro. platform
; 9D - Bubble
; 9E - Ball 'n' Chain
; 9F - Banzai Bill
; A0 - Bowser
; A1 - Bowser's bowling ball
; A2 - MechaKoopa
; A3 - Rotating gray platform
; A4 - Floating spike ball
; A5 - Sparky/Fuzzy (wall follow)
; A6 - Hothead
; A7 - Iggy's ball
; A8 - Blargg
; A9 - Reznor
; AA - Fishbone
; AB - Rex
; AC - Wooden spike (down)
; AD - Wooden spike (up)
; AE - Fishin' Boo
; AF - Boo Block
; B0 - Reflecting stream of Boo Buddies
; B1 - Creating/eating block
; B2 - Falling spike
; B3 - Bowser statue fireball
; B4 - Grinder (ground)
; B5 - Falling Podoboo (unused)
; B6 - Reflecting Podoboo
; B7 - Carrot Top Lift (up-right)
; B8 - Carrot Top Lift (up-left)
; B9 - Info Box
; BA - Timed Lift
; BB - Moving castle block
; BC - Bowser statue
; BD - Sliding Blue Koopa
; BE - Swooper
; BF - Mega Mole
; C0 - Sinking gray platform on lava
; C1 - Flying gray turnblocks
; C2 - Blurp
; C3 - Porcu-Puffer
; C4 - Falling gray platform
; C5 - Big Boo BossBig Boo Boss
; C6 - Spotlight/disco ball
; C7 - Invisible mushroom
; C8 - Light switch
; Sinking gray platform INIT
    INC.B SpriteYPosLow,X                     ; Lower the sprite two pixels from its spawn point.
    INC.B SpriteYPosLow,X
Return018313:
    RTS

InitBowserStatue:
; Bowser statue INIT
    INC.W SpriteMisc157C,X                    ; Face left.
    JSR InitExplodingBlk                      ; Get the type of statue based on its X position.
    STY.B SpriteTableC2,X
    CPY.B #$02
    BNE +                                     ; If the jumping statue, change its palette to palette 8.
    LDA.B #$01
    STA.W SpriteOBJAttribute,X
  + RTS

InitTimedPlat:
; Timed lift INIT
    LDY.B #$3F                                ; Timer for the 1-second platform.
    LDA.B SpriteXPosLow,X
    AND.B #$10
    BNE +
    LDY.B #$FF                                ; Timer for the 4-second platform.
  + TYA
    STA.W SpriteMisc1570,X
    RTS


YoshiPal:
    db $09,$07,$05,$07

InitYoshiEgg:
; Yoshi egg palettes, indexed by X position.
    LDA.B SpriteXPosLow,X                     ; Colored Yoshi egg INIT
    LSR A
    LSR A
    LSR A
    LSR A                                     ; Decide egg color based on the egg's position.
    AND.B #$03
    TAY
    LDA.W YoshiPal,Y
    STA.W SpriteOBJAttribute,X
    INC.W SpriteMisc187B,X                    ; Set flag to not hatch immediately.
    RTS


DATA_01834C:
    db $10,$F0

InitDiagBouncer:
; X speeds for the reflecting boo/podoboo. Order is right, left.
; Reflecting Boo Buddies INIT / Reflecting Podoboo INIT
    JSR FaceMario                             ; Direct toward Mario.
    LDA.W DATA_01834C,Y                       ; Get initial X speed.
    STA.B SpriteXSpeed,X
    LDA.B #$F0                                ; Initial Y speed.
    STA.B SpriteYSpeed,X
    RTS

InitWoodSpike:
    LDA.B SpriteYPosLow,X                     ; Wooden spike INIT (downwards)
    SEC
    SBC.B #$40
    STA.B SpriteYPosLow,X                     ; Raise the spike upwards 4 tiles from its spawn position.
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    RTS

InitWoodSpike2:
; Wooden spike INIT (upwards)
    JMP InitMontyMole                         ; Set the spike to initially move down/up based on its X position.

InitBowserScene:
    JSL CODE_03A0F1                           ; Bowser INIT (redirect)
    RTS

InitSumoBrother:
    LDA.B #$03                                ; Sumo Bro. INIT
    STA.B SpriteTableC2,X
    LDA.B #$70                                ; Initial timer for animation. NOTE: 4E = lift leg; 2F = shoot lightning; 00 = turn and walk
  - STA.W SpriteMisc1540,X
    RTS

InitSlidingKoopa:
    LDA.B #$04                                ; Sliding Blue Koopa INIT
    BRA -

InitGrowingPipe:
    LDA.B #$40                                ; Growing/shrinking pipe INIT
    STA.W SpriteMisc1534,X
    RTS

InitBanzai:
    JSR SubHorizPos                           ; Banzai Bill INIT
    TYA                                       ; Only allow the sprite to spawn on the right of Mario.
    BNE +                                     ; If it's to the left, erase it immediately.
    JMP OffScrEraseSprite

  + LDA.B #!SFX_KAPOW                         ; Shooting Banzai Bill SFX.
    STA.W SPCIO3                              ; / Play sound effect
    RTS

InitBallNChain:
; Ball 'n' Chain INIT
    LDA.B #$38                                ; Radius of the circle that the ball part moves in.
    BRA +

InitGreyChainPlat:
; Gray platform on a chain INIT.
    LDA.B #$30                                ; Radius of the circle that the platform part moves in.
  + STA.W SpriteMisc187B,X
    RTS


ExplodingBlkSpr:
    db $15,$0F,$00,$04

InitExplodingBlk:
; Sprites for the exploding block to spawn.
    LDA.B SpriteXPosLow,X                     ; Exploding block INIT. Also used as a subroutine by the Bowser statue and bubble sprites.
    LSR A
    LSR A
    LSR A
    LSR A                                     ; Get the sprite number for the block to spawn based on its X position.
    AND.B #$03
    TAY
    LDA.W ExplodingBlkSpr,Y
    STA.B SpriteTableC2,X
    RTS


DATA_0183B3:
    db $80,$40

InitScalePlats:
; X position offsets for the mushroom scale platforms.
    LDA.B SpriteYPosLow,X                     ; Mushroom scales INIT
    STA.W SpriteMisc1534,X                    ; Back up the spawn Y position.
    LDA.W SpriteYPosHigh,X
    STA.W SpriteMisc151C,X
    LDA.B SpriteXPosLow,X
    AND.B #$10
    LSR A
    LSR A
    LSR A
    LSR A
    TAY                                       ; Set the X position for the second platform based on the spawn X position.
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_0183B3,Y
    STA.B SpriteTableC2,X
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteMisc1602,X
    RTS

InitMsg_SideExit:
; Display Message 1 INIT
    LDA.B #$28                                ; \ Set current sprite's "disable contact with other sprites" timer to x28; How many frames to wait before displaying the message.
    STA.W SpriteMisc1564,X                    ; /; NOTE: When spawning with Mario, 00/01 will not work, and 02 will display the message before Mario.
    RTS

InitYoshi:
; Yoshi INIT.
    DEC.W SpriteMisc160E,X                    ; Initialize the sprite slot in Yoshi's mouth to null (#$FF).
    INC.W SpriteMisc157C,X                    ; Face left.
    LDA.W CarryYoshiThruLvls
    BEQ Return0183EE                          ; If the player already has a Yoshi, erase this one.
    STZ.W SpriteStatus,X
Return0183EE:
    RTS


DATA_0183EF:
    db $08

DATA_0183F0:
    db $00,$08

InitSpikeTop:
    JSR SubHorizPos                           ; Initial X/Y speeds for wall-following sprites and Urchins.
; X uses indices 0/1, Y uses 1/2.
    TYA                                       ; Spike Top INIT.
    EOR.B #$01
    ASL A
    ASL A                                     ; Set initial direction of movement towards Mario.
    ASL A                                     ; Also clear the flag for being in water.
    ASL A
    JSR CODE_01841D
    STZ.W SpriteInLiquid,X
    BRA CODE_01840E

InitUrchinWallFllw:
    INC.B SpriteYPosLow,X                     ; Urchin, wall-following INIT
    BNE InitFuzzBall_Spark                    ; Shift a pixel down.
    INC.W SpriteYPosHigh,X
InitFuzzBall_Spark:
    JSR InitUrchin                            ; Fuzzy/Sparky INIT
CODE_01840E:
    LDA.W SpriteMisc151C,X
    EOR.B #$10                                ; Store the initial direction of movement.
    STA.W SpriteMisc151C,X
    LSR A
    LSR A
    STA.B SpriteTableC2,X
    RTS

InitUrchin:
    LDA.B SpriteXPosLow,X                     ; Urchin INIT (also shared by Fuzzy/Sparky).
CODE_01841D:
    LDY.B #$00
    AND.B #$10
    STA.W SpriteMisc151C,X
    BNE +                                     ; Move down (vertically) if on an even X position,
    INY                                       ; right (horizontally) if on an odd.
  + LDA.W DATA_0183EF,Y
    STA.B SpriteXSpeed,X
    LDA.W DATA_0183F0,Y
    STA.B SpriteYSpeed,X
InitRipVanFish:
    INC.W SpriteInLiquid,X                    ; Tell the game the sprite starts in water.
    RTS

InitKey_BabyYoshi:
; Key INIT / Baby Yoshi INIT
    LDA.B #$09                                ; \ Sprite status = Carryable; Give it carryable status.
    STA.W SpriteStatus,X                      ; /
    RTS

InitChangingItem:
    INC.B SpriteTableC2,X                     ; Roulette block INIT
Return01843D:
    RTS

InitPeaBouncer:
    LDA.B SpriteXPosLow,X                     ; Wall springboard INIT
    SEC
    SBC.B #$08
    STA.B SpriteXPosLow,X                     ; Move the springboard up 8 pixels from the spawn position.
    LDA.W SpriteXPosHigh,X
    SBC.B #$00
    STA.W SpriteXPosHigh,X
    RTS

InitPSwitch:
    LDA.B SpriteXPosLow,X                     ; \ $151C,x = Blue/Silver,; P-switch INIT
    LSR A                                     ; | depending on initial X position
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |; Get the P-switch type based on its X position.
    AND.B #$01                                ; |
    STA.W SpriteMisc151C,X                    ; /
    TAY                                       ; \ Store appropriate palette to RAM
    LDA.W PSwitchPal,Y                        ; |
    STA.W SpriteOBJAttribute,X                ; /
    LDA.B #$09                                ; \ Sprite status = Carryable; Make carryable.
    STA.W SpriteStatus,X                      ; /
    RTS


PSwitchPal:
    db $06,$02

ADDR_018468:
    JMP OffScrEraseSprite                     ; YXPPCCCT for the P-switches. Blue, silver.

InitLakitu:
    LDY.B #$09                                ; Lakitu INIT.
CODE_01846D:
    CPY.W CurSpriteProcess
    BEQ CODE_018484
    LDA.W SpriteStatus,Y
    CMP.B #$08                                ; If a Lakitu or Lakitu cloud already exists, don't allow a second one to spawn.
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
    STZ.W SpriteWillAppear                    ; Clear some addresses relating to sprite respawn generators.
    STZ.W CurrentGenerator
    LDA.B SpriteYPosLow,X
    STA.W SpriteRespawnYPos                   ; Respawn the Lakitu at the same height as its spawn position after being killed.
    LDA.W SpriteYPosHigh,X
    STA.W SpriteRespawnYPos+1
    JSL FindFreeSprSlot
    BMI InitMontyMole                         ; Find an empty slot for Lakitu's cloud. If there isn't one, let the Lakitu spawn anyway (why, Nintendo?).
    STY.W LakituCloudSlot
    LDA.B #$87                                ; \ Sprite = Lakitu Cloud
    STA.W SpriteNumber,Y                      ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y                    ; Spawn Lakitu's cloud at Lakitu's position.
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    PLX
    STZ.W LakituCloudTimer                    ; Clear the Lakitu cloud's evaporation timer.
InitMontyMole:
    LDA.B SpriteXPosLow,X                     ; Monty Mole INIT. Also used by several other sprites.
    AND.B #$10                                ; Change some characteristic of the sprite based on its X position.
    STA.W SpriteMisc151C,X
    RTS

InitCreateEatBlk:
; Creating/eating block INIT
    LDA.B #$FF                                ; Set the sprite to start out stationary.
    STA.W BlockSnakeActive
    BRA InitMontyMole

InitBulletBill:
    JSR SubHorizPos                           ; Bullet Bill INIT
    TYA                                       ; Shoot toward Mario.
    STA.B SpriteTableC2,X
    LDA.B #$10
    STA.W SpriteMisc1540,X
    RTS

InitClappinChuck:
    LDA.B #$08                                ; Clappin' Chuck INIT
    BRA +

InitPitchinChuck:
    LDA.B SpriteXPosLow,X                     ; Pitchin' Chuck INIT
    AND.B #$30
    LSR A
    LSR A                                     ; Set the number of baseballs to throw depending on the Chuck's X position.
    LSR A
    LSR A
    STA.W SpriteMisc187B,X
    LDA.B #$0A
    BRA +

InitPuntinChuck:
    LDA.B #$09                                ; Puntin' Chuck INIT
    BRA +

InitWhistlinChuck:
    LDA.B #$0B                                ; Whistlin' Chuck INIT
    BRA +

InitChuck:
    LDA.B #$05                                ; Bouncin' Chuck INIT / Splittin' Chuck INIT
    BRA +

InitDigginChuck:
    LDA.B #$30                                ; Diggin' Chuck INIT
    STA.W SpriteMisc1540,X
    LDA.B SpriteXPosLow,X
    AND.B #$10
    LSR A                                     ; Pointless, as it gets overridden immediately.
    LSR A                                     ; Seems like the game originally had the Diggin' Chuck's direction depend on its X position.
    LSR A
    LSR A
    STA.W SpriteMisc157C,X
    LDA.B #$04
  + STA.B SpriteTableC2,X
    JSR FaceMario
    LDA.W DATA_018526,Y                       ; Set initial animation frame for the Chuck's head, based on which side of him Mario is on.
    STA.W SpriteMisc151C,X
    RTS


DATA_018526:
    db $00,$04

InitSuperKoopa:
; Initial animation frames for the Chuck's head (looking right/left).
; Swooping Super Koopa INIT
    LDA.B #$28                                ; Initial Y speed of the swooping Super Koopas.
    STA.B SpriteYSpeed,X
    BRA FaceMario

InitSuperKoopaFthr:
    JSR FaceMario                             ; Ground Super Koopa INIT
    LDA.B SpriteXPosLow,X
    AND.B #$10                                ; If at an even X position, leave the Koopa alone..
    BEQ +
    LDA.B #$10                                ; \ Can be jumped on
    STA.W SpriteTweakerA,X                    ; /
    LDA.B #$80                                ; Set some tweaker bytes for the non-cape Super Koopa
    STA.W SpriteTweakerB,X                    ; (to have it die when jumped on and not spawn a cape).
    LDA.B #$10
    STA.W SpriteTweakerE,X
    RTS

  + INC.W SpriteMisc1534,X                    ; Set flag to indicate the Koopa's cape should flash.
    RTS

InitPokey:
; Pokey INIT
    LDA.B #$1F                                ; \ If on Yoshi, $C2,x = #$1F; Number of segments to give the Pokey when riding Yoshi, bitwise (---x xxxx). Max is 5 (1F).
    LDY.W PlayerRidingYoshi                   ; | (5 segments, 1 bit each)
    BNE +                                     ; |
    LDA.B #$07                                ; | If not on Yoshi, $C2,x = #$07; Number of segments to give the Pokey when not riding Yoshi, bitwise (---x xxxx). Max is 5 (1F).
  + STA.B SpriteTableC2,X                     ; /   (3 segments, 1 bit each)
    BRA FaceMario

InitDinos:
    LDA.B #$04                                ; Dino Rhino INIT
    STA.W SpriteMisc151C,X
InitBomb:
; Bob-omb INIT
    LDA.B #$FF                                ; Number of frames to wait before exploding.
    STA.W SpriteMisc1540,X
    BRA FaceMario

InitBubbleSpr:
; Bubble INIT
    JSR InitExplodingBlk                      ; Pick the sprite inside the bubble based on its X position.
    STY.B SpriteTableC2,X
    DEC.W SpriteMisc1534,X
    BRA FaceMario

InitGrnBounceKoopa:
    LDA.B SpriteYPosLow,X                     ; Bouncing green Koopa INIT
    AND.B #$10                                ; Get its bounce height based on its spawn Y position.
    STA.W SpriteMisc160E,X
InitStandardSprite:
    JSL GetRand                               ; Standard sprite INIT. Used by all Koopas, Goombas, Buzzy Beetles, Spinies, and the Hopping Flame.
    STA.W SpriteMisc1570,X
FaceMario:
    JSR SubHorizPos                           ; Subroutine to make a sprite face Mario.
    TYA
    STA.W SpriteMisc157C,X
Return018583:
    RTS

InitBowsersFire:
; Bowser statue fireball INIT
    LDA.B #!SFX_FIRESPIT                      ; Spawn flame SFX.
    STA.W SPCIO3                              ; / Play sound effect
    BRA FaceMario

InitPowerUp:
    INC.B SpriteTableC2,X                     ; Powerup INIT
    RTS

InitFishbone:
    JSL GetRand                               ; Fishbone INIT
    AND.B #$1F
    STA.W SpriteMisc1540,X
    JMP FaceMario

InitDownPiranha:
    ASL.W SpriteOBJAttribute,X                ; Upside-down Piranha Plant INIT
    SEC                                       ; Set the bit used by the plant's GFX routine to make it use two tiles properly.
    ROR.W SpriteOBJAttribute,X
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$10
    STA.B SpriteYPosLow,X                     ; Shift the plant down one block from its spawn position.
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,X
InitPiranha:
    LDA.B SpriteXPosLow,X                     ; \ Center sprite between two tiles; Classic Piranha Plant INIT / Jumping Piranha Plant INIT / Pipe-Dwelling Lakitu INIT
    CLC                                       ; |; Offset the plant half a block right of its spawn position.
    ADC.B #$08                                ; |
    STA.B SpriteXPosLow,X                     ; /
    DEC.B SpriteYPosLow,X                     ; [NOTE: in LM v2.53+, the moving Ghost House hole enters here as well]
    LDA.B SpriteYPosLow,X
    CMP.B #$FF                                ; Shift the plant down a pixel.
    BNE Return0185C2
    DEC.W SpriteYPosHigh,X
Return0185C2:
    RTS

CallSpriteMain:
    STZ.W SpriteXMovement                     ; CallSpriteMain; Run MAIN sprite routine.
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
; Sprite MAIN pointers.
; 00 - Green shell-less Koopa
; 01 - Red shell-less Koopa
; 02 - Blue shell-less Koopa
; 03 - Yellow shell-less Koopa
; 04 - Green Koopa
; 05 - Red Koopa
; 06 - Blue Koopa
; 07 - Yellow Koopa
; 08 - Green winged Koopa, flying
; 09 - Green winged Koopa, bouncing
; 0A - Red winged Koopa, vertical
; 0B - Red winged Koopa, horizontal
; 0C - Yellow winged Koopa
; 0D - Bob-Omb
; 0E - Keyhole
; 0F - Goomba
; 10 - Winged Goomba
; 11 - Buzzy Beetle
; 12 - Unused
; 13 - Spiny
; 14 - Falling Spiny
; 15 - Fish, horizontal
; 16 - Fish, vertical
; 17 - Fish, flying (spawned by sprite D1)
; 18 - Fish, jumping
; 19 - Display text from level message 1
; 1A - Classic Piranha Plant
; 1B - Football
; 1C - Bullet Bill
; 1D - Hopping flame
; 1E - Lakitu
; 1F - Magikoopa
; 20 - Magikoopa's magic
; 21 - Moving coin
; 22 - Green vertical net Koopa
; 23 - Red vertical net Koopa
; 24 - Green horizontal net Koopa
; 25 - Red horizontal net Koopa
; 26 - Thwomp
; 27 - Thwimp
; 28 - Big Boo
; 29 - Koopa Kid
; 2A - Upside-down Piranha Plant
; 2B - Sumo Brother's lightning
; 2C - Yoshi egg
; 2D - Baby Yoshi
; 2E - Spike Top
; 2F - Portable springboard
; 30 - Dry Bones that throws bones
; 31 - Bony Beetle
; 32 - Dry Bones that stays on ledges
; 33 - Podoboo/vertical fireball
; 34 - Boss fireball
; 35 - Yoshi
; 36 - Unused
; 37 - Boo
; 38 - Eerie (straight)
; 39 - Eerie (wave)
; 3A - Urchin (fixed distance)
; 3B - Urchin (wall detect)
; 3C - Urchin (wall follow)
; 3D - Rip Van Fish
; 3E - P-switch
; 3F - Para-Goomba
; 40 - Para-Bomb
; 41 - Dolphin (long jump)
; 42 - Dolphin (short jump)
; 43 - Dolphin (vertical)
; 44 - Torpedo Ted
; 45 - Directional coins
; 46 - Diggin' Chuck
; 47 - Swimming/jumping fish
; 48 - Diggin' Chuck's rock
; 49 - Growing/shrinking pipe
; 4A - Goal Sphere
; 4B - Pipe-dwelling Lakitu
; 4C - Exploding block
; 4D - Monty Mole (grownd-dwelling)
; 4E - Monty Mole (ledge-dwelling)
; 4F - Jumping Piranha Plant
; 50 - Jumping Piranha Plant (fireballs)
; 51 - Ninji
; 52 - Moving Ghost House hole
; 53 - Throwblock
; 54 - Revolving door for climbing net
; 55 - Checkerboard platform (horizontal)
; 56 - Flying rock platform (horizontal)
; 57 - Checkerboard platform (vertical)
; 58 - Flying rock platform (vertical)
; 59 - Turnblock bridge (horz/vert)
; 5A - Turnblock bridge (horz only)
; 5B - Floating brown platform
; 5C - Floating checkerboard platform
; 5D - Small orange floating platform
; 5E - Large orange floating platform
; 5F - Swinging brown platform
; 60 - Flat switch palace switch
; 61 - Skull raft
; 62 - Brown line-guided platform
; 63 - Brown/checkered line-guided platform
; 64 - Line-guided rope mechanism
; 65 - Chainsaw (line-guided)
; 66 - Upside-down chainsaw (line-guided)
; 67 - Grinder (line-guided)
; 68 - Fuzzy (line-guided)
; 69 - Unused
; 6A - Coin game cloud
; 6B - Wall springboard (left wall)
; 6C - Wall springboard (right wall)
; 6D - Invisible solid block
; 6E - Dino-Rhino
; 6F - Dino-Torch
; 70 - Pokey
; 71 - Super Koopa (red cape)
; 72 - Super Koopa (yellow cape)
; 73 - Super Koopa (ground/feather)
; 74 - Mushroom
; 75 - Flower
; 76-  Star
; 77 - Feather
; 78 - 1up mushroom
; 79 - Growing vine
; 7A - Firework
; 7B - Goal tape
; 7C - Peach
; 7D - P-Balloon
; 7E - Flying red coin
; 7F - Flying golden mushroom
; 80 - Key
; 81 - Changing item
; 82 - Bonus game sprite
; 83 - Flying question block (left)
; 84 - Flying question block (back and forth)
; 85 - Unused
; 86 - Wiggler
; 87 - Lakitu's cloud
; 88 - Winged cage
; 89 - Layer 3 Smash
; 8A - Yoshi's House bird
; 8B - Puff of smoke from Yoshi's House
; 8C - Side exit enable
; 8D - Ghost house exit sign and door
; 8E - Invisible "Warp Hole"
; 8F - Scale platforms
; 90 - Large green gas bubble
; 91 - Chargin' Chuck
; 92 - Splittin' Chuck
; 93 - Bouncin' Chuck
; 94 - Whistlin' Chuck
; 95 - Clappin' Chuck
; 96 - Chargin' Chuck (unused)
; 97 - Puntin' Chuck
; 98 - Pitchin' Chuck
; 99 - Volcano Lotus
; 9A - Sumo Brother
; 9B - Hammer Bro.
; 9C - Hammer Bro. platform
; 9D - Bubble
; 9E - Ball 'n' Chain
; 9F - Banzai Bill
; A0 - Bowser
; A1 - Bowser's bowling ball
; A2 - MechaKoopa
; A3 - Rotating gray platform
; A4 - Floating spike ball
; A5 - Sparky/Fuzzy (wall follow)
; A6 - Hothead
; A7 - Iggy's ball
; A8 - Blargg
; A9 - Reznor
; AA - Fishbone
; AB - Rex
; AC - Wooden spike (down)
; AD - Wooden spike (up)
; AE - Fishin' Boo
; AF - Boo Block
; B0 - Reflecting stream of Boo Buddies
; B1 - Creating/eating block
; B2 - Falling spike
; B3 - Bowser statue fireball
; B4 - Grinder (ground)
; B5 - Falling Podoboo (unused)
; B6 - Reflecting Podoboo
; B7 - Carrot Top Lift (up-right)
; B8 - Carrot Top Lift (up-left)
; B9 - Info Box
; BA - Timed Lift
; BB - Moving castle block
; BC - Bowser statue
; BD - Sliding Koopa
; BE - Swooper
; BF - Mega Mole
; C0 - Sinking gray platform on lava
; C1 - Flying gray turnblocks
; C2 - Blurp
; C3 - Porcu-Puffer
; C4 - Falling gray platform
; C5 - Big Boo BossBig Boo Boss
; C6 - Spotlight/disco ball
; C7 - Invisible mushroom
; C8 - Light switch
    JSL InvisBlk_DinosMain                    ; Invisible solid block, Dino Rhino, Dino Torch redirect
    RTS

GoalSphere:
; Goal sphere MAIN
    JSR SubSprGfx2Entry1                      ; Draw the sprite.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; If sprites are frozen, return.
    BNE +                                     ; /
    LDA.B TrueFrame
    AND.B #$1F                                ; Make the sphere glitter.
    ORA.B SpriteLock
    JSR CODE_01B152
    JSR MarioSprInteractRt
    BCC +                                     ; If Mario touches the sphere, delete the sprite and end the level.
    STZ.W SpriteStatus,X
    LDA.B #$FF
    STA.W EndLevelTimer                       ; Start goal walk.
    STA.W MusicBackup
    LDA.B #!BGM_BOSSCLEAR                     ; SFX for the goal sphere music.
    STA.W SPCIO2                              ; / Change music
  + RTS

InitReznor:
    JSL ReznorInit                            ; Reznor INIT (redirect)
    RTS

Bank3SprHandler:
    JSL Bnk3CallSprMain                       ; Redirect for sprites in bank 03.
    RTS

BanzaiBnCGrayPlat:
    JSL Banzai_Rotating                       ; Ball 'n' Chain, Banzai Bill, gray platform on a chain redirect
    RTS

BubbleWithSprite:
    JSL BubbleSpriteMain                      ; Bubble redirect
    RTS

HammerBrother:
    JSL HammerBrotherMain                     ; Hammer Bro. redirect
    RTS

FlyingPlatform:
    JSL FlyingPlatformMain                    ; Hammer Bro. platform redirect
    RTS

InitHammerBrother:
; Hammer Bro. INIT
    JSL Return02DA59                          ; Do nothing at all (Might as well be NOPs); NOTE: Spritetool uses this as a custom sprite initialization routine.
    RTS

VolcanoLotus:
    JSL VolcanoLotusMain                      ; Volcano Lotus redirect
    RTS

SumoBrother:
    JSL SumoBrotherMain                       ; Sumo Bro. redirect
    RTS

SumosLightning:
    JSL SumosLightningMain                    ; Sumo Bro. Lightning redirect
    RTS

JumpingPiranha:
    JSL JumpingPiranhaMain                    ; Jumping Piranha Plant redirect
    RTS

GasBubble:
    JSL GasBubbleMain                         ; Green gas bubble redirect
    RTS

    JSL SumoBrotherMain                       ; Unused call to main Sumo Brother routine; Never jumped to.
    RTS                                       ; Directional coins redirect

DirectionalCoins:
    JSL DirectionCoinsMain
    RTS

ExplodingBlock:
    JSL ExplodingBlkMain                      ; Exploding block redirect
    RTS

ScalePlatforms:
    JSL ScalePlatformMain                     ; Scale platforms redirect
    RTS

InitFloatingSkull:
    JSL FloatingSkullInit                     ; Floating skulls INIT (redirect)
    RTS

FloatingSkulls:
    JSL FloatingSkullMain                     ; Floating skulls redirect
    RTS

GhostHouseExit:
    JSL GhostExitMain                         ; Ghost House exit redirect
    RTS

WarpBlocks:
    JSL WarpBlocksMain                        ; Invisible warp hole redirect
    RTS

Pokey:
    JSL PokeyMain                             ; Pokey redirect
    RTS

RedSuperKoopa:
    JSL SuperKoopaMain                        ; Red swooping Super Koopa redirect
    RTS

YellowSuperKoopa:
    JSL SuperKoopaMain                        ; Yellow swooping Super Koopa redirect
    RTS

FeatherSuperKoopa:
    JSL SuperKoopaMain                        ; Feathered/normal Super Koopa redirect
    RTS

PipeLakitu:
    JSL PipeLakituMain                        ; Pipe-dwelling Lakitu redirect
    RTS

DigginChuck:
    JSL ChucksMain                            ; Diggin' Chuck redirect
    RTS

SwimJumpFish:
    JSL SwimJumpFishMain                      ; Swimming/jumping fish redirect
    RTS

DigginChucksRock:
    JSL ChucksRockMain                        ; Diggin' Chuck's rock redirect
    RTS

GrowingPipe:
    JSL GrowingPipeMain                       ; Growing/shrinking pipe redirect
    RTS

YoshisHouseBirds:
    JSL BirdsMain                             ; Yoshi's House birds redirect
    RTS

YoshisHouseSmoke:
    JSL SmokeMain                             ; Yoshi's House smoke redirect
    RTS

SideExit:
    JSL SideExitMain                          ; Side exit redirect
    RTS

InitWiggler:
    JSL WigglerInit                           ; Wiggler INIT (redirect)
    RTS

Wiggler:
    JSL WigglerMain                           ; Wiggler redirect
    RTS

CoinCloud:
    JSL CoinCloudMain                         ; Coin game cloud redirect
    RTS

TorpedoTed:
    JSL TorpedoTedMain                        ; Torpedo Ted redirect
    RTS

Layer3Smash:
    PHB                                       ; Layer 3 Smash redirect
    LDA.B #$02
    PHA
    PLB
    JSL Layer3SmashMain
    PLB
    RTS

PeaBouncer:
    PHB                                       ; Wall springboard redirect
    LDA.B #$02
    PHA
    PLB
    JSL PeaBouncerMain
    PLB
    RTS

RipVanFish:
    PHB                                       ; Rip Van Fish redirect
    LDA.B #$02
    PHA
    PLB
    JSL RipVanFishMain
    PLB
    RTS

WallFollowers:
    PHB                                       ; Spike Top, Urchin, HotHead and Sparky/Fuzzy redirect
    LDA.B #$02
    PHA
    PLB
    JSL WallFollowersMain
    PLB
    RTS

Return018869:
    RTS

Chucks:
    JSL ChucksMain                            ; Chargin', Splittin', Bouncin', Whistlin', Clappin', Puntin', and Pitchin' Chuck redirect
    RTS

InitWingedCage:
    PHB                                       ; \ Do nothing at all; Layer 3 Winged Cage INIT (redirect)
    LDA.B #$02                                ; | (Might as well be NOPs)
    PHA                                       ; |
    PLB                                       ; |
    JSL Return02CBFD                          ; |
    PLB                                       ; /
    RTS

WingedCage:
    PHB                                       ; Layer 3 Winged Cage redirect
    LDA.B #$02
    PHA
    PLB
    JSL WingedCageMain
    PLB
    RTS

Dolphin:
    PHB                                       ; Dolphin redirect
    LDA.B #$02
    PHA
    PLB
    JSL DolphinMain
    PLB
    RTS

InitMovingLedge:
; Moving Ghost House hole INIT
    DEC.B SpriteYPosLow,X                     ; NOTE: with Lunar Magic v2.53+, this is unused,
    RTS                                       ; and $0185B7 is instead used for initialization.

MovingLedge:
    JSL MovingLedgeMain                       ; Moving Ghost House hole redirect
    RTS

JumpOverShells:
    TXA                                       ; \ Process every 4 frames; Subroutine to make the yellow Koopa jump over shells.
    EOR.B TrueFrame                           ; |; Divide detection across four frames. If not the right frame, return.
    AND.B #$03                                ; |
    BNE Return0188AB                          ; /
    LDY.B #$09                                ; \ Loop over sprites:
JumpLoopStart:
    LDA.W SpriteStatus,Y                      ; |
    CMP.B #$0A                                ; | If sprite status = kicked, try to jump it; Look for a sprite that's been thrown. Return if none exists.
    BEQ HandleJumpOver                        ; |
JumpLoopNext:
    DEY                                       ; |
    BPL JumpLoopStart                         ; /
Return0188AB:
    RTS

HandleJumpOver:
    LDA.W SpriteXPosLow,Y                     ; Store some clipping values.
    SEC
    SBC.B #$1A
    STA.B _0                                  ; $00 - Clipping X displacement lo
    LDA.W SpriteXPosHigh,Y
    SBC.B #$00
    STA.B _8                                  ; $08 - Clipping X displacement hi
    LDA.B #$44
    STA.B _2                                  ; $02 - Clipping width
    LDA.W SpriteYPosLow,Y
    STA.B _1                                  ; $01 - Clipping Y displacement lo
    LDA.W SpriteYPosHigh,Y
    STA.B _9                                  ; $09 - Clipping Y displacement hi
    LDA.B #$10
    STA.B _3                                  ; $03 - Clipping height
    JSL GetSpriteClippingA
    JSL CheckForContact                       ; Check if the shell is close enough to the Koopa. If not, loop back and check for any other shells.
    BCC JumpLoopNext                          ; If not close to shell, go back to main loop
    JSR IsOnGround                            ; \ If sprite not on ground, go back to main loop; If the shell is not on the ground, loop back and check for any other shells.
    BEQ JumpLoopNext                          ; /
    LDA.W SpriteMisc157C,Y                    ; \ If sprite not facing shell, don't jump
    CMP.W SpriteMisc157C,X                    ; |; If the Koopa and shell are moving in the same direction, return.
    BEQ +                                     ; /
    LDA.B #$C0                                ; \ Finally set jump speed; Speed that the yellow Koopa jumps at.
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
; X speeds for sprites 00-13. First two are when the "move fast" bit below is clear; second two are when set.
; Various properties for the sprites 00-13. Format: ak?? jfls
; a = animate twice as fast in air, k = use 32x16 tilemap (also draws wings on sprites 08+), ?? = unknown/unused?
; j = jump over shells, f = follow Mario, l = stay on ledges, s = move faster
; Shell-less Koopa misc RAM:
; $C2   - Used as various timers:
; Set to #$20 for any Koopa when kicking a shell, including flipping one over. Used to show the "kick" animation.
; Set to #$0F for a shell when it's entered and starts to shake, after which it turns into a Koopa.
; Set to the value in $1540 || $1558 for a non-shell sprite when it gets kicked by a blue Koopa.
; Set to the value in $1540 || $1558 for a shell while stunned.
; $151C - Red/blue Koopas use it a flag that says they've walked off a ledge and need to turn.
; $1528 - Sliding flag. Set by shell-less Koopas when sliding, and for shells when a blue Koopa is catching it.
; $1534 - Set to #$01 for the blue Koopa while it's catching a shell and being pushed by it.
; $1540 - Stun timer, set under a variety of conditions:
; Set to #$20 for a Koopa when squished, for the squish graphic.
; Set to #$1F for any sprite when killed via a spinjump, for the cloud graphic.
; Set to #$02 for a shell on the frame a Koopa is knocked out of it, cleared the next frame.
; Set to #$FF for a shell when flipped upside down, to determine when the Koopa should jump out.
; Set to #$FF for a shell-less Koopa when killed through pretty much any means.
; Set to #$FF for Goombas, Bob-ombs, and MechaKoopas when they're kicked by a blue Koopa.
; $1558 - Used for various timers.
; Set to #$08 for a Koopa when squished.
; Set to #$20 for a shell-less Koopa jumping into a shell. The Koopa enters the shell when it hits #$01, if possible.
; Set to #$10 for a shell when it's entered and starts to shake, after which it turns into a Koopa.
; Set to #$40 for any sprite when sinking in lava, after which it's erased.
; Also used as a general timer to decide if normal functions are interrupted:
; Set to #$20 for a blue Koopa when it stops to kick a shell.
; Set to #$20 for any Koopa when kicking a shell, including flipping it over.
; $1564 - Timer to disable sprite contact with other sprites.
; Set to #$08 for a shell when kicked by a blue Koopa.
; Set to #$21 for a blue Koopa when it stops to kick a shell.
; $1570 - Frame counter for animation, as well as for when player-following Koopas should turn.
; $157C - Direction of horizontal movement. 00 = right, 01 = left
; $1594 - Shell-less Koopas and shells set this to each other's sprite slots when one is jumping into the other.
; $15AC - Timer to tell the sprite to turn around. Set to #$08 when turning, decrases every frame.
; $1602 - Animation frame to use.
; 0/1 = walking, 2 = turning, 4 = kick shell, 5/6 = stunned
; $160E - Used for kicking shells.
; For blue Koopas: sprite slot of the shell that the blue Koopa is kicking.
; For shells: sprite ID of the shell-less Koopa that jumped into them.
; $163E - Timer for when the Koopa is kicked out of a shell. Note that this is set when the Koopa stops, not while it's sliding. It's cleared at #$80.
; Set to #$FF when a non-blue Koopa is kicked out of a shell and has stopped sliding. Cleared at #$80, after which the Koopa starts walking.
; Set to #$A0 when a blue Koopa is kicked out of a shell and has stopped sliding. Cleared at #$80, after which the Koopa starts walking.
; Set to #$20 for a blue Koopa when it stops to kick a shell. The shell is actually kicked when the timer reaches #$01.
; $187B - If non-zero, the shell becomes a disco shell. Set when a yellow Koopa jumps into a shell.
; Shell-less Koopa MAIN
    LDA.B SpriteLock                          ; \ If sprites aren't locked,; If the game is NOT frozen, branch.
    BEQ CODE_018952                           ; / branch to $8952
CODE_018908:
    LDA.W SpriteMisc163E,X                    ;COME BACK HERE ON NOT STATIONARY BRANCH
    CMP.B #$80                                ; Skip if the Koopa's stun timer is not >= 80.
    BCC +
    LDA.B SpriteLock                          ; \ If sprites are locked,; Skip if the game is frozen.
    BNE +                                     ; / branch to $891F
CODE_018913:
    JSR SetAnimationFrame
    LDA.W SpriteMisc1602,X                    ; \
    CLC                                       ; |Increase sprite's image by x05; Animate stunned Koopa (frames 5/6)
    ADC.B #$05                                ; |
    STA.W SpriteMisc1602,X                    ; /
  + JSR CODE_018931                           ; Handle contact with Mario (hurt if blue Koopa, else kick-kill it).
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    JSR IsOnGround                            ; \ If sprite is on edge (on ground),; Stop the Koopa and don't let it fall through the ground.
    BEQ +                                     ; |Sprite Y Speed = 0
    STZ.B SpriteYSpeed,X                      ; /
  + JMP CODE_018B03                           ; Process interaction with other sprites and draw graphics, then return.

CODE_018931:
    LDA.B SpriteNumber,X                      ; \; Handle interaction between Mario and a stunned Koopa.
    CMP.B #$02                                ; |If sprite isn't Blue shelless Koopa,
    BNE CODE_01893C                           ; / branch to $893C; If the blue Koopa and in contact with it, hurt Mario.
    JSR MarioSprInteractRt
    BRA Return018951

CODE_01893C:
    ASL.W SpriteTweakerD,X
    SEC
    ROR.W SpriteTweakerD,X
    JSR MarioSprInteractRt                    ; If not the blue Koopa and in contact with it, kick-kill it.
    BCC +
    JSR CODE_01B12A
  + ASL.W SpriteTweakerD,X
    LSR.W SpriteTweakerD,X
Return018951:
    RTS

CODE_018952:
; Shell-less Koopa routine when the game is not frozen; check stunned.
    LDA.W SpriteMisc163E,X                    ;CODE RUNA T START?; Branch if the Koopa is not stunned nor stationary.
    BEQ CODE_0189B4                           ;SKIP IF $163E IS ZERO FOR SPRITE.  IS KICKING SHELL TIMER / GENREAL TIME
    CMP.B #$80
    BNE CODE_01896B
    JSR FaceMario                             ; If the stun timer is 80, unstun the sprite.
    LDA.B SpriteNumber,X                      ; \; If not the blue Koopa, make it jump in the air too.
    CMP.B #$02                                ; |If sprite is Blue shelless Koopa,
    BEQ +                                     ; |Set Y speed to xE0
    LDA.B #$E0                                ; |; Speed to make the Koopa jump when flipping upright.
    STA.B SpriteYSpeed,X                      ; /
  + STZ.W SpriteMisc163E,X                    ;ZERO KICKING SHELL TIMER
CODE_01896B:
    CMP.B #$01
    BNE CODE_018908
    LDY.W SpriteMisc160E,X                    ;IT KICKS THIS? !@#
    LDA.W SpriteStatus,Y
    CMP.B #$09                                ;IF NOT STATIONARY, BRANCH; Jump back and handle basic functionality if:
    BNE CODE_018908                           ; This is not a blue Koopa just about to kick a shell/goomba/etc.
    LDA.B SpriteXPosLow,X                     ;KOOPA BLUE KICK SHELL!; The state of the sprite being kicked isn't still 09 (stationary/carryable).
    SEC                                       ; The Koopa isn't close enough to the sprite.
    SBC.W SpriteXPosLow,Y
    CLC
    ADC.B #$12
    CMP.B #$24
    BCS CODE_018908
    JSR PlayKickSfx                           ; Play the kick sound effect.
    JSR CODE_01A755                           ; Set $C2/$1558 to #$20.
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01A6D7,Y                       ; Kick the sprite in the direction the Koopa is facing.
    LDY.W SpriteMisc160E,X
    STA.W SpriteXSpeed,Y
    LDA.B #$0A                                ; \ Sprite status = Kicked; Set the sprite to a kicked status.
    STA.W SpriteStatus,Y                      ; /
    LDA.W SpriteMisc1540,Y                    ; As it happens, both of these should be zero.
    STA.W SpriteTableC2,Y
    LDA.B #$08                                ; Disable contact with other sprites for 8 frames after being kicked.
    STA.W SpriteMisc1564,Y
    LDA.W SpriteTweakerD,Y
    AND.B #$10                                ; If it can't be kicked like a shell (i.e. Goombas, Bob-ombs, etc.), kick it slightly upwards.
    BEQ CODE_0189B4
    LDA.B #$E0                                ; Y speed to give non-shell sprites when kicked by a blue Koopa.
    STA.W SpriteYSpeed,Y
CODE_0189B4:
; Not stunned; check sliding.
    LDA.W SpriteMisc1528,X                    ; If the Koopa is not sliding, skip this code.
    BEQ CODE_018A15
    JSR IsTouchingObjSide
    BEQ +                                     ; If the Koopa hits the the side of a block, stop.
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
  + JSR IsOnGround
    BEQ CODE_0189E6
    LDA.B LevelIsSlippery
    CMP.B #$01
    LDA.B #$02                                ; Apply friction to the sliding Koopa, with slipperiness factored in.
    BCC +
    LSR A
  + STA.B _0
    LDA.B SpriteXSpeed,X
    CMP.B #$02                                ; If the Koopa's speed is less than #$02, branch to stop sliding.
    BCC CODE_0189FD
    BPL +
    CLC
    ADC.B _0
    CLC
    ADC.B _0                                  ; Decelerate the Koopa.
  + SEC                                       ; Subtract #$02 in a normal level, #$01 in a slippery level.
    SBC.B _0
    STA.B SpriteXSpeed,X
    JSR CODE_01804E                           ; Spawn sliding smoke sprites at the Koopa's position.
CODE_0189E6:
    STZ.W SpriteMisc1570,X                    ; Don't animate.
    JSR CODE_018B43                           ; Run the shared routine.
    LDA.B #$E6                                ; Tile to use for the blue Koopas when they're knocked out of a shell.
    LDY.B SpriteNumber,X                      ; \ Branch if Blue shelless
    CPY.B #$02                                ; |
    BEQ +                                     ; /
    LDA.B #$86                                ; Tile to use for the green/red/yellow Koopas when they're knocked out of a shell.
  + LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    STA.W OAMTileNo+$100,Y
    RTS

CODE_0189FD:
    JSR IsOnGround                            ;KOOPA CODE; If the sprite is not on the ground, branch.
    BEQ CODE_018A0F
    LDA.B #$FF                                ; How many frames the green/red/yellow Koopas are stunned for after being knocked out of a shell (+#$80).
    LDY.B SpriteNumber,X
    CPY.B #$02
    BNE +
    LDA.B #$A0                                ; How many frames the blue Koopas are stunned for after being knocked out of a shell (+#$80).
  + STA.W SpriteMisc163E,X
CODE_018A0F:
    STZ.W SpriteMisc1528,X                    ; Track that the Koopa is no longer sliding.
    JMP CODE_018913                           ; Return back for stunned Koopa interaction.

CODE_018A15:
; Not sliding; check catching.
    LDA.W SpriteMisc1534,X                    ; Branch if the the sprite isn't catching a shell/goomba/etc.
    BEQ CODE_018A88
    LDY.W SpriteMisc160E,X
    LDA.W SpriteStatus,Y
    CMP.B #$0A                                ; Clear the "catching" flag and branch if the shell has stopped.
    BEQ CODE_018A29
    STZ.W SpriteMisc1534,X
    BRA CODE_018A62

CODE_018A29:
; Blue Koopa is catching a shell (or Goomba/Bob-omb/MechaKoopa).
    STA.W SpriteMisc1528,Y                    ; Set the sliding flag.
    JSR IsTouchingObjSide
    BEQ +
    LDA.B #$00                                ; If the Koopa is pushed into a solid block, clear the X speed for both sprites.
    STA.W SpriteXSpeed,Y
    STA.B SpriteXSpeed,X
  + JSR IsOnGround
    BEQ CODE_018A62
    LDA.B LevelIsSlippery
    CMP.B #$01
    LDA.B #$02                                ; Apply friction to both sprites, with slipperiness factored in.
    BCC +
    LSR A
  + STA.B _0
    LDA.W SpriteXSpeed,Y
    CMP.B #$02                                ; If the shell's speed is less than #$02, branch to stop sliding.
    BCC CODE_018A69
    BPL +
    CLC
    ADC.B _0
    CLC
    ADC.B _0                                  ; Decelerate the two sprites.
  + SEC                                       ; Subtract #$02 in a normal level, #$01 in a slippery level.
    SBC.B _0
    STA.W SpriteXSpeed,Y
    STA.B SpriteXSpeed,X
    JSR CODE_01804E                           ; Spawn sliding smoke sprites at the Koopa's position.
CODE_018A62:
    STZ.W SpriteMisc1570,X                    ; Don't animate.
    JSR CODE_018B43                           ; Run the shared routine.
    RTS

CODE_018A69:
    LDA.B #$00                                ; Blue Koopa has just stopped a shell (or Goomba/Bob-omb/MechaKoopa).
    STA.B SpriteXSpeed,X                      ; Clear both sprites' X speed.
    STA.W SpriteXSpeed,Y
    STZ.W SpriteMisc1534,X                    ; Clear catching flag.
    LDA.B #$09                                ; \ Sprite status = Carryable; Make the sprite stationary/carryable.
    STA.W SpriteStatus,Y                      ; /
    PHX
    TYX
    JSR CODE_01AA0B
    LDA.W SpriteMisc1540,X                    ; If the sprite is a Goomba/Bob-omb/MechaKoopa, reset their stun timer to #$FF.
    BEQ +
    LDA.B #$FF
    STA.W SpriteMisc1540,X
  + PLX
CODE_018A88:
; Not catching; check kicking/flipping.
    LDA.B SpriteTableC2,X                     ; If the Koopa is not kicking/flipping a shell, branch.
    BEQ CODE_018A9B
    DEC.B SpriteTableC2,X
    CMP.B #$08
    LDA.B #$04                                ; Animation frame to use when it kicks a shell (including to flip a shell over).
    BCS +
    LDA.B #$00                                ; Animation frame to use for a few frames after kicking before it starts moving again.
  + STA.W SpriteMisc1602,X
    BRA CODE_018B00                           ; Run the shared routine.

CODE_018A9B:
    LDA.W SpriteMisc1558,X                    ; Not kicking/flipping; check entering.
    CMP.B #$01                                ; If not about to enter a shell, branch to the general sprite code.
    BNE Spr0to13Main
    LDY.W SpriteMisc1594,X                    ;SHELL TO INTERACT WITH???
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BCC +
    LDA.W SpriteYSpeed,Y
    BMI +                                     ; Return if:
    LDA.W SpriteNumber,Y                      ; \ Return if Coin sprite; The shell is no longer alive.
    CMP.B #$21                                ; |; The shell has Y speed.
    BEQ +                                     ; /; The shell turned into a coin.
    JSL GetSpriteClippingA                    ; The Koopa and shell aren't touching anymore.
    PHX
    TYX
    JSL GetSpriteClippingB
    PLX
    JSL CheckForContact
    BCC +
    JSR OffScrEraseSprite                     ; Erase the Koopa.
    LDY.W SpriteMisc1594,X
    LDA.B #$10                                ; Number of frames to shake the Koopa shell for after a Koopa enters it.
    STA.W SpriteMisc1558,Y
    LDA.B SpriteNumber,X                      ; Track the sprite ID of the Koopa that just jumped into the shell.
    STA.W SpriteMisc160E,Y                    ;SPRITE NUMBER TO DEAL WITH ?
  + RTS

; Bob-Omb misc RAM:
; $C2   - Set equal to the stun timer when the Bob-omb is kicked or capespinned. Does not decrement.
; $1534 - Set to #$01 when it explodes.
; $1540 - Explosion countdown timer. If the Bob-omb is stationary/carryable, it'll start flashing when the timer is below #$40 and will explode at #$00.
; Set to #$FF on spawn. At #$00, it becomes stationary/carryable and resets the timer to #$40.
; Set to #$FF when it's kicked by a blue Koopa.
; Set to #$FF when it's hit/kicked by Mario.
; Set to #$80 when spawned from a para-Bomb.
; $1558 - Timer for sinking in lava.
; $1564 - Timer to disable sprite contact with other sprites. Specifically set when stopped, dropped, or kicked.
; $1570 - Frame counter for animation.
; $157C - Direction of horizontal movement. 00 = right, 01 = left
; $15AC - Timer to tell the sprite to turn around. Set to #$08 when turning, decreases every frame.
; $1602 - Animation frame to use.
; 0/1 = walking, 02 = turning
  - PHB                                       ; \ Change Bob-omb into explosion; Bob-omb explosion subroutine.
    LDA.B #$02                                ; |
    PHA                                       ; |
    PLB                                       ; |
    JSL ExplodeBombRt                         ; |; Go blow up.
    PLB                                       ; |
    RTS                                       ; /

Bobomb:
; Bob-omb MAIN
    LDA.W SpriteMisc1534,X                    ; \ Branch if exploding; If exploding, use the subroutine for that instead.
    BNE -                                     ; /
    LDA.W SpriteMisc1540,X                    ; \ Branch if not set to explode; If not exploding yet and hasn't finished counting down the stun timer, run the general sprite code.
    BNE Spr0to13Start                         ; /
    LDA.B #$09                                ; \ Sprite status = Stunned; Else, stop it and make it carryable when it's about to explode.
    STA.W SpriteStatus,X                      ; /; (relevant code at $019624)
    LDA.B #$40                                ; \ Time until explosion = #$40; Stun the Bob-omb and set immediately set to flash.
    STA.W SpriteMisc1540,X                    ; /
    JMP SubSprGfx2Entry1                      ; Draw sprite; Draw a 1-tile 16x16 sprite.

Spr0to13Start:
; Starting MAIN for: All normal Koopas, Yellow Winged Koopas, Bob-ombs, Goombas, Buzzy Beetles, and Spinies.
    LDA.B SpriteLock                          ; \ If sprites locked...; If the game is not frozen, branch to the MAIN.
    BEQ Spr0to13Main                          ; |
CODE_018B00:
    JSR MarioSprInteractRt                    ; | ...interact with Mario; Process standard Mario-Sprite interaction.
CODE_018B03:
    JSR SubSprSprInteract                     ; | ...interact with sprites; Process interaction with other sprites.
    JSR Spr0to13Gfx                           ; | ...draw sprite; Draw graphics.
    RTS                                       ; / Return

Spr0to13Main:
; Shared routine for most sprites 0 to 13.
    JSR IsOnGround                            ; \ If sprite on ground...; Branch if the sprite is not on ground.
    BEQ CODE_018B2E                           ; |
    LDY.B SpriteNumber,X                      ; |
    LDA.W Spr0to13Prop,Y                      ; | Set sprite X speed
    LSR A                                     ; |
    LDY.W SpriteMisc157C,X                    ; |
    BCC +                                     ; |
    INY                                       ; | Increase index if sprite set to go fast
    INY                                       ; |
; Set the sprite's X speed, depending on the type of slope it's standing on.
  + LDA.W Spr0to13SpeedX,Y                    ; |; If the corresponding property bit is set, the sprite will move a bit faster.
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
    AND.W SpriteBlockedDirs,X                 ; |; If the sprite walks into the side of a block, stop it.
    AND.B #$03                                ; |
    BEQ +                                     ; |
    STZ.B SpriteXSpeed,X                      ; / ...Sprite X Speed = 0
  + JSR IsTouchingCeiling                     ; \ If touching ceiling...
    BEQ CODE_018B43                           ; |; If the sprite is touching a ceiling, zero its Y speed.
    STZ.B SpriteYSpeed,X                      ; / ...Sprite Y Speed = 0
CODE_018B43:
; Primary code for handling most sprites in 00-13.
    JSR SubOffscreen0Bnk1                     ; Erase if offscreen.
    JSR SubUpdateSprPos                       ; Apply speed to position; Update X/Y position, apply gravity, and process interaction with blocks.
    JSR SetAnimationFrame                     ; Set the animation frame; Handle 2-frame animation.
    JSR IsOnGround                            ; \ Branch if not on ground; If the sprite is not on the ground, branch.
    BEQ SpriteInAir                           ; /
; Sprite is on the ground.
    JSR SetSomeYSpeed__                       ; Set the sprite's ground Y speed (#$00 or #$18 depending on flat or slope).
    STZ.W SpriteMisc151C,X                    ; For sprites that stay on ledges: you're currently on a ledge.
    LDY.B SpriteNumber,X                      ; \
    LDA.W Spr0to13Prop,Y                      ; | If follow Mario is set...
    PHA                                       ; |; Follow Mario if set to do so.
    AND.B #$04                                ; |; Don't turn if not time to or already facing Mario.
    BEQ +                                     ; |
    LDA.W SpriteMisc1570,X                    ; | ...and time until turn == 0...
    AND.B #$7F                                ; |; How often to poll for Mario's direction.
    BNE +                                     ; |
    LDA.W SpriteMisc157C,X                    ; |
    PHA                                       ; |
    JSR FaceMario                             ; | ...face Mario
    PLA                                       ; | If was facing the other direction...
    CMP.W SpriteMisc157C,X                    ; |
    BEQ +                                     ; |
    LDA.B #$08                                ; | ...set turning timer; Turn around.
    STA.W SpriteMisc15AC,X                    ; /
  + PLA                                       ; \ If jump over shells is set call routine
    AND.B #$08                                ; |; If the sprite is set to jump over shells (yellow Koopas), run the code for that.
    BEQ +                                     ; |
    JSR JumpOverShells                        ; |
  + BRA CODE_018BB0                           ; /

SpriteInAir:
    LDY.B SpriteNumber,X                      ; Sprite is in midair.
    LDA.W Spr0to13Prop,Y                      ; \ If flutter wings is set...
    BPL CODE_018B90                           ; |; If set to do so, animate the sprite twice as fast in mid-air.
    JSR SetAnimationFrame                     ; | ...set frame...; (only winged yellow Koopas)
    BRA +                                     ; | ...and don't zero out $1570,x

CODE_018B90:
    STZ.W SpriteMisc1570,X                    ; /
  + LDA.W Spr0to13Prop,Y                      ; \ If stay on ledges is set...
    AND.B #$02                                ; |
    BEQ CODE_018BB0                           ; |
    LDA.W SpriteMisc151C,X                    ; | todo: what are all these?
    ORA.W SpriteMisc1558,X                    ; |
    ORA.W SpriteMisc1528,X                    ; |; If the sprite is set to turn on ledges and is not having a special function run, flip its direction.
    ORA.W SpriteMisc1534,X                    ; |
    BNE CODE_018BB0                           ; |
    JSR FlipSpriteDir                         ; | ...change sprite direction
    LDA.B #$01                                ; |
    STA.W SpriteMisc151C,X                    ; /
CODE_018BB0:
    LDA.W SpriteMisc1528,X                    ; On-ground code rejoins here.
    BEQ CODE_018BBA
    JSR CODE_018931                           ; If the sprite is not sliding, process standard interaction with Mario.
    BRA +                                     ; If the sprite is sliding, process the kick-kill interaction with Mario.

CODE_018BBA:
    JSR MarioSprInteractRt                    ; Interact with Mario
  + JSR SubSprSprInteract                     ; Interact with other sprites; Process interaction with other sprites; turn around if it hits something.
    JSR FlipIfTouchingObj                     ; Change direction if touching an object
Spr0to13Gfx:
    LDA.W SpriteMisc157C,X                    ; \ Store sprite direction; Routine to handle graphics for sprites 00-13.
    PHA                                       ; /
    LDY.W SpriteMisc15AC,X                    ; \ If turning timer is set...
    BEQ CODE_018BDE                           ; |
    LDA.B #$02                                ; | ...set turning image
    STA.W SpriteMisc1602,X                    ; |
    LDA.B #$00                                ; |; If the sprite's turn timer is non-zero, turn it around.
    CPY.B #$05                                ; | If turning timer >= 5...; The actual turn occurs on frame 3 of the animation.
    BCC +                                     ; |
    INC A                                     ; | ...flip sprite direction (temporarily)
  + EOR.W SpriteMisc157C,X                    ; |
    STA.W SpriteMisc157C,X                    ; /
CODE_018BDE:
    LDY.B SpriteNumber,X                      ; \ Branch if sprite is 2 tiles high
    LDA.W Spr0to13Prop,Y                      ; |
    AND.B #$40                                ; |; If the sprite is set to use 16x16 graphics, then draw the sprite with such and return.
    BNE CODE_018BEC                           ; /
    JSR SubSprGfx2Entry1                      ; \ Draw 1 tile high sprite and return
    BRA +                                     ; /

CODE_018BEC:
; Sprite uses 16x32 graphics, not 16x16.
    LDA.W SpriteMisc1602,X                    ; \ Nothing?; If in an odd frame of animation, carry is set.
    LSR A                                     ; /
    LDA.B SpriteYPosLow,X                     ; \ Y position -= #$0F (temporarily)
    PHA                                       ; |
    SBC.B #$0F                                ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    PHA                                       ; |
    SBC.B #$00                                ; |; Draw 32x16 graphics for the sprite.
    STA.W SpriteYPosHigh,X                    ; /
    JSR SubSprGfx1                            ; Draw sprite
    PLA                                       ; \ Restore Y position
    STA.W SpriteYPosHigh,X                    ; |
    PLA                                       ; |
    STA.B SpriteYPosLow,X                     ; /
    LDA.B SpriteNumber,X                      ; \ Add wings if sprite number > #$08
    CMP.B #$08                                ; |; Draw wings for sprites 08-0C (would also draw for 0D-13, but those aren't 32x16).
    BCC +                                     ; |
    JSR KoopaWingGfxRt                        ; /
  + PLA                                       ; \ Restore sprite direction
    STA.W SpriteMisc157C,X                    ; /
    RTS

SpinyEgg:
; Falling Spiny misc RAM:
; $1558 - Timer for sinking in lava.
; $1570 - Frame counter for animation.
; $157C - Direction of horizontal movement. 00 = right, 01 = left
; $15AC - Timer to tell the sprite to turn around. Set to #$08 when turning, decreases every frame.
; $1602 - Animation frame to use.
; 0/1 = spinning
; Falling spiny MAIN
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Skip to just draw graphics if game frozen.
    BNE CODE_018C44                           ; /
    LDA.W SpriteStatus,X
    CMP.B #$08                                ; If the sprite is dead, branch.
    BNE CODE_018C44
    JSR SetAnimationFrame
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    DEC.B SpriteYSpeed,X                      ; Decrease gravity effect; also prevents it from accelerating in water.
    JSR IsOnGround
    BEQ +
    LDA.B #$13                                ; \ Sprite = Spiny; Sprite to spawn when a Spiny hits the ground.
    STA.B SpriteNumber,X                      ; /; If the sprite hits the ground, turn it into a normal spiny.
    JSL InitSpriteTables                      ; Reset sprite tables
    JSR FaceMario
    JSR CODE_0197D5
  + JSR FlipIfTouchingObj                     ; Flip if walking into a block.
    JSR SubSprSpr_MarioSpr                    ; Process interaction with Mario and other sprites.
CODE_018C44:
    JSR SubOffscreen0Bnk1
    LDA.B #$02                                ; Draw the spiny with a single 8x8 tile X/Y flipped.
    JSR SubSprGfx0Entry0
    RTS

GreenParaKoopa:
; Green Parakoopa misc RAM:
; $1558 - Timer for sinking in lava.
; $1570 - Frame counter for animation.
; $157C - Direction of horizontal movement. 00 = right, 01 = left
; $15AC - Timer to tell the sprite to turn around. Set to #$08 when turning, decreases every frame.
; $1602 - Animation frame to use.
; 0/1 = walking, 02 = turning
; $160E - Bounce height for the bouncing Koopa. 00 = high, 10 = low
; Green Parakoopa MAIN. Used by both the flying and bouncing ones.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; If sprites are locked, just draw the graphics.
    BNE CODE_018CB7                           ; /
    LDY.W SpriteMisc157C,X
    LDA.W Spr0to13SpeedX,Y
    EOR.W SpriteSlope,X
    ASL A
    LDA.W Spr0to13SpeedX,Y                    ; Set X speed. If it bounces against a slope, slow it down correspondingly.
    BCC +                                     ; Kind of dumb though since the Koopa only gets slowed down for the frame it touches the slope.
    CLC
    ADC.W SpriteSlope,X
  + STA.B SpriteXSpeed,X
    TYA
    INC A
    AND.W SpriteBlockedDirs,X                 ; \ If touching object,; If the Koopa lands against a very steep slope, stop it and turn it around.
    AND.B #$03                                ; |
    BEQ +                                     ; |
    STZ.B SpriteXSpeed,X                      ; / Sprite X Speed = 0
  + LDA.B SpriteNumber,X                      ; \ If flying left Green Koopa...
    CMP.B #$08                                ; |; Branch if the bouncing Koopa, not the flying one.
    BNE CODE_018C8C                           ; |
    JSR SubSprXPosNoGrvty                     ; | Update X position; Update the flying Parakoopa's position and speed without gravity.
    LDY.B #$FC                                ; |; Upwards Y speed for the flying Koopa.
    LDA.W SpriteMisc1570,X                    ; | Y speed = #$FC or #$04,
    AND.B #$20                                ; | depending on 1570,x; How often to change the flying Koopa's Y speed.
    BEQ +                                     ; |
    LDY.B #$04                                ; |; Downwards Y speed for the flying Koopa.
  + STY.B SpriteYSpeed,X                      ; |
    JSR SubSprYPosNoGrvty                     ; / Update Y position
    BRA +

CODE_018C8C:
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    DEC.B SpriteYSpeed,X
  + JSR SubSprSpr_MarioSpr                    ; Process interaction with other sprites and Mario.
    JSR IsTouchingCeiling
    BEQ +                                     ; If it hits a ceiling, clear Y speed.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + JSR IsOnGround                            ; If it hits the ground, make it bounce.
    BEQ CODE_018CAE
    JSR SetSomeYSpeed__                       ; (pointless)
    LDA.B #$D0                                ; Y speed to give the low bouncing Parakoopa when it hits the ground.
    LDY.W SpriteMisc160E,X
    BNE +
    LDA.B #$B0                                ; Y speed to give the high bouncing Parakoopa when it hits the ground.
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
; Acceleration values for the flying red Parakoopas. Affects both X and Y speeds!
; Max speeds for the flying red Parakoopas. Affects both X and Y speeds!
; Red Parakoopa misc RAM:
; $C2   - Timer for acceleration. Increments while accelerating; the Koopa's speed gets updated every 4th value.
; $151C - Direction of next acceleration. Even = -, odd = +.
; $1540 - Timer for how long to wait before applying acceleration again. Set to #$30 each time $151C increments.
; $1570 - Frame counter for animation.
; $157C - Direction of horizontal movement. 00 = right, 01 = left
; $15AC - Timer to tell the sprite to turn around. Set to #$08 when turning, decreases every frame.
; $1602 - Animation frame to use.
; 0/1 = walking, 02 = turning
; Red horizontal Parakoopa MAIN
    JSR SubOffscreen1Bnk1                     ; Process offscreen from -$40 to +$A0.
    BRA +

RedVertParaKoopa:
; Red vertical Parakoopa MAIN
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
  + LDA.B SpriteLock                          ; \ Branch if sprites locked; If sprites are locked, just draw the graphics.
    BNE CODE_018D2A                           ; /
    LDA.W SpriteMisc157C,X
    PHA
    JSR UpdateDirection
    PLA                                       ; If the sprite's direction of movement isn't the same as the one it's facing, turn it around.
    CMP.W SpriteMisc157C,X
    BEQ +
    LDA.B #$08                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
  + JSR SetAnimationFrame
    LDA.B SpriteNumber,X
    CMP.B #$0A                                ; Branch if not the vertical Koopa.
    BNE CODE_018CEA
    JSR SubSprYPosNoGrvty
    BRA CODE_018CFD

CODE_018CEA:
    LDY.B #$FC                                ; Upwards Y speed for the horizontal Koopa.
    LDA.W SpriteMisc1570,X
    AND.B #$20                                ; How often to change the horizontal Koopa's Y speed.
    BEQ +
    LDY.B #$04                                ; Downwards Y speed for the horizontal Koopa.
  + STY.B SpriteYSpeed,X                      ; Update the Koopa's position and speed without gravity.
    JSR SubSprYPosNoGrvty
    JSR SubSprXPosNoGrvty
CODE_018CFD:
    LDA.W SpriteMisc1540,X                    ; Branch if the Koopa is currently not accelerating.
    BNE +
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    AND.B #$03                                ; Affect the Koopa's speed every 3 frames.
    BNE +
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X                      ; Accelerate the Koopa.
    CLC
    ADC.W DATA_018CBA,Y
    STA.B SpriteYSpeed,X
    STA.B SpriteXSpeed,X
    CMP.W DATA_018CBC,Y
    BNE +                                     ; If the Koopa has reached max speed, stop accelerating for a bit.
    INC.W SpriteMisc151C,X
    LDA.B #$30                                ; How many frames to wait before accelerating again.
    STA.W SpriteMisc1540,X
  + JSR SubSprSpr_MarioSpr
CODE_018D2A:
    JSR CODE_018CB7                           ; Draw graphics.
    RTS

WingedGoomba:
; Winged Goomba misc RAM:
; $C2   - Frame counter to decide when to turn toward Mario. Increments every frame.
; $151C - Counter for the Goomba's hops. Counts up to 03, and then clears when the Goomba does a large jump.
; $1540 - Timer to wait a bit before starting to hop again. Set to a random value #$50-#$7F when the Goomba does a large jump.
; $1558 - Timer for sinking in lava.
; $1570 - Animation timer for the Goomba's wings. Increments every frame while $1540 is non-zero.
; Increases two extra times each frame when rising during the large jump.
; Cleared when the Goomba lands after the large jump.
; $157C - Direction of horizontal movement. 00 = right, 01 = left
; $15AC - Timer to tell the sprite to turn around. Set to #$08 when turning, decreases every frame.
; $1602 - Animation frame to use.
; 0/1 = walking, 02 = turning
; Winged Goomba MAIN
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteLock
    BEQ +                                     ; If sprites are locked, just draw the graphics.
    JSR CODE_018DAC
    RTS

  + JSR CODE_018DBB                           ; Set X speed.
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    DEC.B SpriteYSpeed,X
    LDA.B SpriteTableC2,X
    LSR A
    LSR A                                     ; Animate walking.
    LSR A
    AND.B #$01
    STA.W SpriteMisc1602,X
    JSR CODE_018DAC                           ; Draw graphics.
    INC.B SpriteTableC2,X
    LDA.W SpriteMisc151C,X
    BNE +
    LDA.B SpriteYSpeed,X                      ; If the Goomba is rising during a big hop, animate its wings thrice as fast.
    BPL +
    INC.W SpriteMisc1570,X
    INC.W SpriteMisc1570,X
  + INC.W SpriteMisc1570,X
    JSR IsTouchingCeiling
    BEQ +                                     ; If the Goomba hits a ceiling, clear its Y speed.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + JSR IsOnGround                            ; If the Goomba isn't on the ground, branch.
    BEQ CODE_018DA5
    LDA.B SpriteTableC2,X
    AND.B #$3F                                ; How many frames to wait before turning toward Mario.
    BNE +
    JSR FaceMario
  + JSR SetSomeYSpeed__                       ; Set ground Y speed.
    LDA.W SpriteMisc151C,X
    BNE +                                     ; If the Goomba has just landed after a big jump, don't animate its wings.
    STZ.W SpriteMisc1570,X
  + LDA.W SpriteMisc1540,X                    ; Wait a bit after a big jump before starting to hop again.
    BNE CODE_018DA5
    INC.W SpriteMisc151C,X
    LDY.B #$F0                                ; Y speed for a normal hop.
    LDA.W SpriteMisc151C,X
    CMP.B #$04                                ; Number of times the Goomba hops before it does a big jump.
    BNE +
    STZ.W SpriteMisc151C,X
    JSL GetRand
    AND.B #$3F                                ; Get a random number of frames (#$50-#$7F) to wait before hopping again.
    ORA.B #$50
    STA.W SpriteMisc1540,X
    LDY.B #$D0                                ; Y speed for a large hop.
  + STY.B SpriteYSpeed,X
CODE_018DA5:
    JSR FlipIfTouchingObj
    JSR SubSprSpr_MarioSpr
    RTS

CODE_018DAC:
; Winged Goomba graphics subroutine.
    JSR GoombaWingGfxRt                       ; Draw wings.
    LDA.W SpriteOAMIndex,X
    CLC                                       ; Increase the Goomba's OAM slot.
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    JMP SubSprGfx2Entry1                      ; Draw a single 16x16 tile.

CODE_018DBB:
; Subroutine to set the X speed for the Winged Goomba, Hopping Flame, and powerups.
    LDA.B #$F8                                ; X speed when going left.
    LDY.W SpriteMisc157C,X
    BNE +
    LDA.B #$08                                ; X speed when going right.
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
; Goomba wing X offsets. First eight are going left, second are right.
; Each set is then split into two sets of four: first is stretched, second is folded.
; Each of those is then split into two sets of two: first is animation frame 0, second is frame 1.
; Goomba wing Y offsets. First four are stretched, second are folded.
; The first two of each set are for animation frame 0, the second are frame 1.
    JSR GetDrawInfoBnk1                       ; YXPPCCCT settings for the Goomba wings.
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    AND.B #$02                                ; Tile numbers for the Goomba wings.
    CLC
    ADC.W SpriteMisc1602,X
; Tile sizes for the Goomba wings.
; Scratch RAM used: $00-$05
; Subroutine to draw wings on the Goomba.
; Line the Goomba's wing animation up with the turns in its normal animation.
    STA.B _5                                  ; $05 = 00/01/02/03
    ASL A                                     ; $02 = 00/02/04/06
    STA.B _2
    LDA.W SpriteMisc157C,X                    ; $04 = direction (0/1)
    STA.B _4
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDX.B #$01                                ; Draw 2 wings.
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
    CLC                                       ; Get X offset for the wing tile.
    ADC.W DATA_018DC7,X
    STA.W OAMTileXPos+$100,Y
    PLX
    LDA.B _1
    CLC                                       ; Get Y offset for the wing tile.
    ADC.W DATA_018DD7,X
    STA.W OAMTileYPos+$100,Y
    LDX.B _5
    LDA.W GoombaWingTiles,X                   ; Get the tile number for the wing.
    STA.W OAMTileNo+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W GoombaWingTileSize,X                ; Get the tile size for the wing.
    STA.W OAMTileSize+$40,Y
    PLY
    LDX.B _3
    LDA.B _4
    LSR A
    LDA.W GoombaWingGfxProp,X
    BCS +                                     ; Get the YXPPCCCT settings for the wing.
    EOR.B #$40                                ; X flip if facing right.
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
; Draw two tile of no defined size.
    LDA.B #$02                                ; Subroutine to make 2-frame animations for sprites every 8 frames.
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
; Y speeds for the Piranha Plants.
; In pipe; going down; out of pipe; going up.
; Timings for how long the plant stays in each phase.
; In pipe; going down; out of pipe; going up.
; Piranha Plant misc RAM:
; $C2   - Increments each time the plant changes phase. 00 = in pipe; 01 = exiting pipe; 02 = out of pipe; 03 = entering pipe.
; $1540 - Timer for how long the plant waits before shifting direction. Set to either #$20 or #$30 each phase change.
; $1570 - Frame counter for animation.
; $1594 - Sets to #$01 when Mario is close to the plant. Tells it to stay in the pipe, turn invisible, and don't interact with Mario.
; $1602 - Animation frame to use.
; 0/1 = biting
; Classic Piranha Plant MAIN / Upside-Down Piranha Plant MAIN
    LDA.W SpriteMisc1594,X                    ; \ Don't draw the sprite if in pipe and Mario naerby; Don't draw the plant if its being forced to stay inside the pipe.
    BNE CODE_018E9A                           ; /
    LDA.B SpriteProperties                    ; \ Set sprite to go behind objects
    PHA                                       ; | for the graphics routine
    LDA.W SpriteOnYoshiTongue,X               ; |
    BNE +                                     ; |; Unless it's being eaten by Yoshi, go behind objects.
    LDA.B #!OBJ_Priority1                     ; |
    STA.B SpriteProperties                    ; /
  + JSR SubSprGfx1                            ; Draw the sprite; Draw a 16x32 sprite.
    LDY.W SpriteOAMIndex,X                    ; \ Modify the palette and page of the stem
    LDA.W OAMTileAttr+$108,Y                  ; |; Set the plant's vine to use palette D on GFX page 1.
    AND.B #$F1                                ; |; Note: the classic piranha plant does not correctly handle this,
    ORA.B #$0B                                ; |; and will edit the OAM data to another sprite's tiles instead.
    STA.W OAMTileAttr+$108,Y                  ; /
    PLA                                       ; \ Restore value of $64
    STA.B SpriteProperties                    ; /
CODE_018E9A:
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; If sprites are frozen, return.
    BNE Return018EC7                          ; /
    JSR SetAnimationFrame
    LDA.W SpriteMisc1594,X                    ; \ Don't don't process interactions if in pipe and Mario nearby
    BNE +                                     ; |; Only process interaction with Mario if it's not stuck inside a pipe.
    JSR SubSprSpr_MarioSpr                    ; /
  + LDA.B SpriteTableC2,X                     ; \ Y = Piranha state
    AND.B #$03                                ; |
    TAY                                       ; /
    LDA.W SpriteMisc1540,X                    ; \ Change state if it's time; If the stun timer is 0, then move to the next movement phase.
    BEQ ChangePiranhaState                    ; /
    LDA.W PiranhaSpeed,Y                      ; Load Y speed
    LDY.B SpriteNumber,X                      ; \ Invert speed if upside-down piranha
    CPY.B #$2A                                ; |
    BNE +                                     ; |; Get the movement speed for the plant.
    EOR.B #$FF                                ; |; If it's the upside-down one, invert the speed.
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
    LDA.B _F                                  ; |; If the plant is inside the pipe and Mario is close enough, keep it stuck inside the pipe.
    CLC                                       ; |
    ADC.B #$1B                                ; |; Distance to the left of the plant Mario has to be.
    CMP.B #$37                                ; |; Distance to the right of the above point Mario has to be.
    LDA.B #$01                                ; |
    STA.W SpriteMisc1594,X                    ; | ...and set $1594,x if so
    BCC +                                     ; |
CODE_018EE1:
    STZ.W SpriteMisc1594,X                    ; /
    LDY.B _0                                  ; \ Set time in state
    LDA.W PiranTimeInState,Y                  ; |
    STA.W SpriteMisc1540,X                    ; /; Set the stun timer and move to the next state.
    INC.B SpriteTableC2,X                     ; Go to next state
  + RTS

CODE_018EEF:
    LDY.B #$07                                ; \ Find a free extended sprite slot; Subroutine to find an extended sprite slot. Used by the Hopping Flame and Yoshi's fireballs.
CODE_018EF1:
    LDA.W ExtSpriteNumber,Y
    BEQ CODE_018F07                           ; Loop until an empty slot is found.
    DEY
    BPL CODE_018EF1
    DEC.W ExtSpriteSlotIdx
    BPL +
    LDA.B #$07                                ; If all the extended sprite slots are filled, overwrite one.
    STA.W ExtSpriteSlotIdx
  + LDY.W ExtSpriteSlotIdx
  - RTS

CODE_018F07:
    LDA.W SpriteOffscreenX,X                  ; If the sprite is offscreen, uh, return either way.
    BNE -
    RTS

HoppingFlame:
; Hopping Flame misc RAM:
; $1540 - Timer for waiting to hop. Set to a random number #$1F-#$3F each time it lands.
; $1558 - Timer for sinking in lava. The flame disappears in a cloud of smoke though, so this never actually hits 0.
; $1570 - Frame counter for animation.
; $157C - Direction of horizontal movement. 00 = right, 01 = left
; $1602 - Animation frame to use.
; 0/1 = fire
; $176F - Extended sprite timer for how long the small fires should last.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; If sprites are frozen, just draw graphics.
    BNE CODE_018F49                           ; /
    INC.W SpriteMisc1602,X
    JSR SetAnimationFrame
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    DEC.B SpriteYSpeed,X
    JSR CODE_018DBB                           ; Set X speed.
    ASL.B SpriteXSpeed,X
    JSR IsOnGround
    BEQ CODE_018F43
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    JSR SetSomeYSpeed__                       ; Clear X and Y speed if on the ground.
    LDA.W SpriteMisc1540,X                    ; If the stun timer is zero, then it landed and the stun timer needs to be reset.
    BEQ CODE_018F38                           ; If the stun timer is one, then make it hop.
    DEC A
    BNE CODE_018F43
    JSR CODE_018F50
    BRA CODE_018F43

CODE_018F38:
    JSL GetRand
    AND.B #$1F                                ; The flame has just landed; set the stun timer to a random number #$1F-#$3F.
    ORA.B #$20
    STA.W SpriteMisc1540,X
CODE_018F43:
    JSR FlipIfTouchingObj
    JSR MarioSprInteractRt
CODE_018F49:
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR SubSprGfx2Entry1                      ; Draw a 16x16 tile.
    RTS

CODE_018F50:
    JSL GetRand                               ; Make the flame hop.
    AND.B #$0F                                ; Give it a random Y speed #$D0-#$DF.
    ORA.B #$D0
    STA.B SpriteYSpeed,X
    LDA.W RandomNumber
    AND.B #$03                                ; Decide whether to jump toward Mario or go straight.
    BNE +
    JSR FaceMario
  + JSR IsSprOffScreen                        ; If the sprite goes offscreen, don't spawn a flame.
    BNE +
    JSR CODE_018EEF                           ; Find an empty extended sprite slot.
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteXPosHigh,Y                 ; Put the small fire at the hopping flame's position.
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$08
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$03                                ; \ Extended sprite = Hopping flame's flame; Make the actual flame.
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B #$FF                                ; Set the timer for how long the flame lasts.
    STA.W ExtSpriteMisc176F,Y
  + RTS

Lakitu:
; Lakitu misc RAM:
; $C2   - Set to #$01 for the cloud while Mario is riding in it.
; $151C - Set to #$10 for the Lakitu if it's fishing with a 1up.
; Set to #$10 for the cloud if the Lakitu is killed by a fireball.
; $1534 - Used to decide which way to accelerate the cloud vertically. Even = +, odd = -.
; $1540 - Used as a timer for erasing the cloud sprite after the Lakitu is killed.
; Set to #$1F for the Lakitu when killed by jumping on it.
; $154C - Timer to not make Mario enter the cloud again after jumping out.
; $1558 - Timer for how long to show the Lakitu's throwing animation. Set to #$1F each time he throws.
; $157C - Direction of horizontal movement. 00 = right, 01 = left
; $1602 - Animation frame to use. Only used by the Lakitu, not the cloud.
; 0 = normal, 1 = killed/falling, 2 = throwing
; $160E - Set for the cloud to the Lakitu's sprite slot.
    LDY.B #$00                                ; Lakitu MAIN (note: most of its code is handled by the actual cloud)
    LDA.W SpriteMisc1558,X
    BEQ +
    LDY.B #$02                                ; Set the animation frame based on whether the Lakitu is throwing a Spiny.
  + TYA
    STA.W SpriteMisc1602,X
    JSR SubSprGfx1                            ; Draw a 16x32 sprite.
    LDA.W SpriteMisc1558,X
    BEQ +
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM; If the Lakitu isn't throwing, shift its body up 3 pixels?
    LDA.W OAMTileYPos+$104,Y
    SEC
    SBC.B #$03
    STA.W OAMTileYPos+$104,Y
  + LDA.W SpriteMisc151C,X
    BEQ SubSprSpr_MarioSpr                    ; If fishing with a 1up, draw and handle interaction with that.
    JSL CODE_02E672
SubSprSpr_MarioSpr:
    JSR SubSprSprInteract                     ; Subroutine to register interaction between two sprites as well as one sprite and Mario.
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
; YXPPCCCT properties for each of the Bullet Bills.
; Animation frames for each Bullet Bill direction.
; X speeds for each Bullet Bill direction.
; Y speeds for each Bullet Bill direction.
; Bullet Bill misc RAM:
; $C2   - Direction being shot in.
; 00 = right     01 = left        02 = up         03 = down
; 04 = up-right  05 = down-right  06 = down-left  07 = up-left
; $1540 - Sends the Bullet Bill behind objects while non-zero. Set to #$10 when it spawns.
; $157C - Always 1. Setting to 0 will make it face backwards.
; $1602 - Animation frame to use.
; 0 = horizontal, 1 = vertical, 2 = diagonal up, 3 = diagonal down
    LDA.B #$01                                ; Bullet Bill MAIN
    STA.W SpriteMisc157C,X
    LDA.B SpriteLock                          ; \ Branch if sprites locked; If sprites are frozen, just draw graphics.
    BNE +                                     ; /
    LDY.B SpriteTableC2,X
    LDA.W BulletGfxProp,Y                     ; \ Store gfx properties into palette byte
    STA.W SpriteOBJAttribute,X                ; /
    LDA.W DATA_018FCF,Y
    STA.W SpriteMisc1602,X                    ; Set graphics and speeds for each type of Bullet Bill.
    LDA.W BulletSpeedX,Y                      ; \ Set X speed
    STA.B SpriteXSpeed,X                      ; /
    LDA.W BulletSpeedY,Y                      ; \ Set Y speed
    STA.B SpriteYSpeed,X                      ; /
    JSR SubSprXPosNoGrvty                     ; \ Update position
    JSR SubSprYPosNoGrvty                     ; /
    JSR CODE_019140                           ; Process interaction with objects...? (afaik this should only do water/lava interaction...)
    JSR SubSprSpr_MarioSpr                    ; Interact with Mario and sprites; Process interaction with sprites and Mario.
  + JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos                          ; Erase it if it goes offscreen vertically.
    CMP.B #$F0
    BCC +
    STZ.W SpriteStatus,X
  + LDA.W SpriteMisc1540,X
    BEQ +
    JMP CODE_019546                           ; Draw a 16x16 sprite. Send it behind objects if the stun timer is set.

  + JMP SubSprGfx2Entry1


DATA_01902E:
    db $40,$10

DATA_019030:
    db $03,$01

SubUpdateSprPos:
; Sprite max Y speed (normal, water)
; Sprite gravity (normal, water)
; JSL located at $01802A
; Routine to update a sprite's position and apply gravity, as well as interact with objects if set to do so.
    JSR SubSprYPosNoGrvty                     ; Update the sprite's Y position.
    LDY.B #$00
    LDA.W SpriteInLiquid,X
    BEQ +
    INY
    LDA.B SpriteYSpeed,X
    BPL +                                     ; Limit the sprite's rising Y speed in water to -18.
    CMP.B #$E8
    BCS +
    LDA.B #$E8
    STA.B SpriteYSpeed,X
  + LDA.B SpriteYSpeed,X
    CLC                                       ; Apply gravity to the sprite's Y speed.
    ADC.W DATA_019030,Y
    STA.B SpriteYSpeed,X
    BMI +
    CMP.W DATA_01902E,Y
    BCC +                                     ; Limit the sprite's falling Y speed to either 40 (air) or 10 (water).
    LDA.W DATA_01902E,Y
    STA.B SpriteYSpeed,X
  + LDA.B SpriteXSpeed,X
    PHA
    LDY.W SpriteInLiquid,X
    BEQ +
    ASL A
    ROR.B SpriteXSpeed,X
    LDA.B SpriteXSpeed,X
    PHA                                       ; If the sprite is in water, slow it down to 3/4s of its normal speed.
    STA.B _0
    ASL A
    ROR.B _0
    PLA
    CLC
    ADC.B _0
    STA.B SpriteXSpeed,X
  + JSR SubSprXPosNoGrvty                     ; Update the sprite's X position.
    PLA
    STA.B SpriteXSpeed,X
    LDA.W SpriteDisableObjInt,X
    BNE +                                     ; Process object interaction if set to do so.
    JSR CODE_019140
    RTS

  + STZ.W SpriteBlockedDirs,X
    RTS

FlipIfTouchingObj:
    LDA.W SpriteMisc157C,X                    ; \ If touching an object in the direction; Subroutine to turn a sprite around if it hits an object.
    INC A                                     ; | that the sprite is moving...
    AND.W SpriteBlockedDirs,X                 ; |
    AND.B #$03                                ; |
    BEQ +                                     ; |
    JSR FlipSpriteDir                         ; | ...flip direction
  + RTS                                       ; /

FlipSpriteDir:
; Subroutine to change the direction of a sprite's movement.
    LDA.W SpriteMisc15AC,X                    ; \ Return if turning timer is set; If it's already turning, return.
    BNE +                                     ; /
    LDA.B #$08                                ; \ Set turning timer; Set the turning timer.
    STA.W SpriteMisc15AC,X                    ; /
CODE_0190A2:
    LDA.B SpriteXSpeed,X                      ; \ Invert speed
    EOR.B #$FF                                ; |
    INC A                                     ; |
    STA.B SpriteXSpeed,X                      ; /; Invert the sprite's speed.
    LDA.W SpriteMisc157C,X                    ; \ Flip sprite direction
    EOR.B #$01                                ; |
    STA.W SpriteMisc157C,X                    ; /
  + RTS

GenericSprGfxRt2:
    PHB                                       ; JSL wrapper for SubSprGFX2Entry1. This routine draws a single 16x16.
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
; X positions of the sprite/object clippings.
; Every set of 4 bytes here points to which pixels the sprite uses to interact with layers,
; relative to its X position ($E4).
; Y positions of the sprite/object clippings.
; Every set of 4 bytes here points to which pixels the sprite uses to interact with layers,
; relative to its Y position ($D8).
; Sprite-object interaction routine.
    PHB                                       ; Note that it while it sets the blocked bits, it does not handle them,
    PHK                                       ; except for sprites set to "not get stuck in walls".
    PLB                                       ; The bits should be handled from within the sprite instead.
    JSR CODE_019140
    PLB
    RTL

CODE_019140:
    STZ.W SpriteBlockOffset
    STZ.W SpriteBlockedDirs,X                 ; Set sprite's position status to 0 (in air)
    STZ.W SpriteSlope,X
    STZ.W TileGenerateTrackA                  ; Clear blocked bits, slope offset, and layer being interacted with, and preserve in-water flag.
    LDA.W SpriteInLiquid,X
    STA.W SpriteInterIndex
    STZ.W SpriteInLiquid,X
    JSR CODE_019211                           ; Handle sprite buoyancy for Layer 1.
    LDA.B ScreenMode                          ; Vertical level flag; Branch down if not set to interact with Layer 2/3.
    BPL CODE_0191BE
    INC.W TileGenerateTrackA
    LDA.B SpriteXPosLow,X                     ; \ Sprite's X position += $26
    CLC                                       ; | for call to below routine
    ADC.B Layer23XRelPos                      ; |
    STA.B SpriteXPosLow,X                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    ADC.B Layer23XRelPos+1                    ; |
    STA.W SpriteXPosHigh,X                    ; /; Get position offset to Layer 2/3.
    LDA.B SpriteYPosLow,X                     ; \ Sprite's Y position += $28
    CLC                                       ; | for call to below routine
    ADC.B Layer23YRelPos                      ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    ADC.B Layer23YRelPos+1                    ; |
    STA.W SpriteYPosHigh,X                    ; /
    JSR CODE_019211                           ; Handle sprite buoyancy for Layer 2/3.
    LDA.B SpriteXPosLow,X                     ; \ Restore sprite's original position
    SEC                                       ; |
    SBC.B Layer23XRelPos                      ; |
    STA.B SpriteXPosLow,X                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    SBC.B Layer23XRelPos+1                    ; |
    STA.W SpriteXPosHigh,X                    ; |; Restore position.
    LDA.B SpriteYPosLow,X                     ; |
    SEC                                       ; |
    SBC.B Layer23YRelPos                      ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    SBC.B Layer23YRelPos+1                    ; |
    STA.W SpriteYPosHigh,X                    ; /
    LDA.W SpriteBlockedDirs,X
    BPL CODE_0191BE
    AND.B #$03                                ; If on top of Layer 2 and not blocked on right/left...
    BNE CODE_0191BE
    LDY.B #$00
    LDA.W Layer2DXPos                         ; \ A = -$17BF
    EOR.B #$FF                                ; |
    INC A                                     ; |
    BPL +
    DEY
  + CLC                                       ; Move the sprite with Layer 2.
    ADC.B SpriteXPosLow,X
    STA.B SpriteXPosLow,X
    TYA
    ADC.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,X
CODE_0191BE:
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Don't get stuck in walls" is not set; Get carryable sprites out of walls.
    BPL +                                     ; /
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object; Skip sprite if
    AND.B #$03                                ; |; not set to avoid getting stuck in walls
    BEQ +                                     ; /; not blocked on a side
    TAY                                       ; being eaten by Yoshi
    LDA.W SpriteOnYoshiTongue,X
    BNE +
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W Return019283,Y
    STA.B SpriteXPosLow,X                     ; Push back from the block.
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_019285,Y
    STA.W SpriteXPosHigh,X
    LDA.B SpriteXSpeed,X
    BNE +
    LDA.W SpriteBlockedDirs,X                 ; If it has no X speed, clear side blocked status.
    AND.B #$FC
    STA.W SpriteBlockedDirs,X
  + LDA.W SpriteInLiquid,X                    ; Handle water/lava splash.
    EOR.W SpriteInterIndex                    ; If the sprite hasn't just moved into or out of water, return.
    BEQ Return019210
if ver_is_lores(!_VER)                        ;\================= J, U, SS, & E0 ==============
    ASL A                                     ;!
    LDA.W SpriteTweakerC,X                    ;! \ TODO: Unknown Bit A...
    AND.B #$40                                ;! | ... may be related to cape; Return if the sprite isn't set to show a water splash or is set to briefly not show the graphic.
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
    BIT.W IRQNMICommand                       ; If the sprite is entering lava or in a Mode 7 room, branch to show the correct splash.
    BMI +
    JSL CODE_0284C0                           ; Show a water splash.
    RTS

  + JSL CODE_028528                           ; Show a lava splash.
Return019210:
    RTS

CODE_019211:
; Object interaction check. This first part is the sprite buoyancy routine.
    LDA.W SpriteBuoyancy                      ; Skip if sprite buoyancy is not enabled.
    BEQ CODE_01925B
    LDA.B LevelIsWater                        ; Branch to always apply buoyancy in a water level.
    BNE CODE_019258
    LDY.B #$3C
    JSR CODE_01944D                           ; Branch if the tile being touched is on page 0.
    BEQ CODE_019233
    LDA.W Map16TileNumber
    CMP.B #$6E
    BCC CODE_01925B                           ; Skip if the tile is not a slope in water.
    JSL CODE_00F04D
    LDA.W Map16TileNumber
    BCC CODE_01925B
    BCS CODE_01923A
CODE_019233:
    LDA.W Map16TileNumber
    CMP.B #$06                                ; Skip if the tile is not a water tile (000-005).
    BCS CODE_01925B
CODE_01923A:
    TAY                                       ; Sprite is in water and buoyancy is enabled.
    LDA.W SpriteInLiquid,X
    ORA.B #$01
    CPY.B #$04
    BNE CODE_019258
    PHA
    LDA.B SpriteNumber,X                      ; \ Branch if Yoshi
    CMP.B #$35                                ; |
    BEQ CODE_019252                           ; /; Set bit 0 of $164A for the sprite.
    LDA.W SpriteTweakerD,X                    ; \ Branch if "Process interaction every frame"; If in lava, also set bit 7.
    AND.B #$02                                ; | is set; If in lava and not invincible to lava, kill the sprite too.
    BNE +                                     ; /
CODE_019252:
    JSR CODE_019330
  + PLA
    ORA.B #$80
CODE_019258:
    STA.W SpriteInLiquid,X
CODE_01925B:
    LDA.W SpriteTweakerE,X                    ; Routine joins back up here; handle other object interaction.
    BMI Return019210
    LDA.W TileGenerateTrackA
    BEQ CODE_01926F                           ; Return if the sprite is set to not interact with objects,
    BIT.W SpriteBuoyancy                      ; or if it's touching Layer 2 but interaction with Layer 2 is disabled.
    BVS Return0192C0
    LDA.W SpriteTweakerC,X                    ; \ TODO: Return if Unknown Bit B is set
    BMI Return0192C0                          ; /
CODE_01926F:
    JSR CODE_0192C9                           ; Process vertical block interaction.
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Don't get stuck in walls" is not set
    BPL +                                     ; /
    LDA.B SpriteXSpeed,X                      ; \ Branch if sprite has X speed...; Process horizontal block interaction for all sprites in the direction they're moving.
    ORA.W SpriteMisc15AC,X                    ; | ...or sprite is turning
    BNE +                                     ; /
    LDA.B TrueFrame                           ; Process horizontal block interaction for carryable sprites not moving horizontally.
    JSR CODE_01928E                           ; Alternates between left and right interaction every frame.
Return019283:
    RTS


    db $FC

DATA_019285:
    db $04,$FF,$00

; Distance to push a carryable sprite to the side if inside a block.
; Blocked right, blocked left; low bytes, high bytes.
; Routine to process horizontal block interaction for sprites.
  + LDA.B SpriteXSpeed,X                      ; If not moving horizontally, return.
    BEQ Return0192C0
    ASL A                                     ; Result: 0 = right, 1 = left
    ROL A
CODE_01928E:
    AND.B #$01                                ; Add in stationary carryable sprites here.
    TAY
    JSR CODE_019441                           ; Get and preserve the high byte of the tile the sprite is touching horizontally.
    STA.W SprMap16TouchHorizHigh
    BEQ +
    LDA.W Map16TileNumber
    CMP.B #$11                                ; Skip if not tiles 111-16D.
    BCC +
    CMP.B #$6E
    BCS +
    JSR CODE_019425                           ; Preserve the position of the block, and set sprite blocked status.
    LDA.W Map16TileNumber                     ; Preserve the low byte of the tile (111-16D only).
    STA.W Map16TileDestroy
    LDA.W TileGenerateTrackA
    BEQ +
    LDA.W SpriteBlockedDirs,X                 ; If the tile is on Layer 2, set the bit for touching its side.
    ORA.B #$40
    STA.W SpriteBlockedDirs,X
  + LDA.W Map16TileNumber                     ; Preserve the low byte of the tile the sprite is touching horizontally.
    STA.W SprMap16TouchHorizLow
Return0192C0:
    RTS


    db $FE,$02,$FF,$00

DATA_0192C5:
    db $01,$FF

DATA_0192C7:
    db $00,$FF

CODE_0192C9:
; Unused?
; Speed (lo) that sprites get pushed with on tiles 10C/10D, the conveyors.
; Speed (hi) that sprites get pushed with on tiles 10C/10D, the conveyors.
    LDY.B #$02                                ; Routine to process vertical block interaction for sprites.
    LDA.B SpriteYSpeed,X                      ; Result: 2 = down, 3 = up (or stationary).
    BPL +
    INY
  + JSR CODE_019441                           ; Get and preserve the high byte of the tile the sprite is touching vertically.
    STA.W SprMap16TouchVertHigh
    PHP
    LDA.W Map16TileNumber                     ; Preserve the low byte of the tile the sprite is touching vertically.
    STA.W SprMap16TouchVertLow
    PLP
    BEQ Return01930F
    LDA.W Map16TileNumber
    CPY.B #$02
    BEQ CODE_019310
    CMP.B #$11
    BCC Return01930F                          ; Return if the tile is on page 0, or not tile 111-16D and not a tileset-specific solid tile.
    CMP.B #$6E                                ; Alternatively, branch to the next routine if the sprite is moving down onto a tile on page 1.
    BCC CODE_0192F9
    CMP.W SolidTileStart
    BCC Return01930F
    CMP.W SolidTileEnd
    BCS Return01930F
CODE_0192F9:
    JSR CODE_019425                           ; Preserve the position of the block, and set sprite blocked status.
    LDA.W Map16TileNumber
    STA.W Map16TileHittable
    LDA.W TileGenerateTrackA
    BEQ Return01930F
    LDA.W SpriteBlockedDirs,X                 ; If the tile was on Layer 2, set the corresponding blocked-from-below bit.
    ORA.B #$20
    STA.W SpriteBlockedDirs,X
Return01930F:
    RTS

CODE_019310:
    CMP.B #$59                                ; Sprite is moving downward onto a tile on page 1.
    BCC CODE_01933B
    CMP.B #$5C
    BCS CODE_01933B                           ; Branch if not tiles 159-15B and not in tilesets 03/0E.
    LDY.W ObjectTileset                       ; (In other words, if not the tileset-specific lava.)
    CPY.B #$0E
    BEQ CODE_019323
    CPY.B #$03
    BNE CODE_01933B
CODE_019323:
    LDA.B SpriteNumber,X                      ; \ Branch if sprite == Yoshi
    CMP.B #$35                                ; |
    BEQ CODE_019330                           ; /; If not invincible to lava, kill the sprite.
    LDA.W SpriteTweakerD,X                    ; \ Branch if "Process interaction every frame"
    AND.B #$02                                ; | is set
    BNE CODE_01933B                           ; /
CODE_019330:
    LDA.B #$05                                ; \ Sprite status = #$05 ???
    STA.W SpriteStatus,X                      ; /
    LDA.B #$40                                ; Set status to burning in lava, and set the sinking timer.
    STA.W SpriteMisc1558,X
    RTS

CODE_01933B:
; Touching a non-lava tile.
    CMP.B #$11                                ; Branch if touching a ledge (100-110)
    BCC CODE_0193B0
    CMP.B #$6E                                ; Branch if touching a solid block (111-16D)
    BCC CODE_0193B8
    CMP.B #$D8                                ; Branch if touching a non-slope tile (1D8-1FF; not 16E-1D7)
    BCS CODE_019386
    JSL CODE_00FA19
    LDA.B [_5],Y                              ; Get the pixel offset distance.
    CMP.B #$10                                ; Return as blank if #$10 (a full block; very steep slopes only).
    BEQ Return0193AF                          ; Branch as a non-slope tile if greater than #$10 (i.e. an upside-down slope or the "inside" area of the bottom very steep tile).
    BCS CODE_019386
    LDA.B _0
    CMP.B #$0C
    BCS CODE_01935D                           ; Return as blank if more than 4 pixels from the bottom of the block and below the pixel offset distance (i.e. don't force on top).
    CMP.B [_5],Y
    BCC Return0193AF
CODE_01935D:
    LDA.B [_5],Y                              ; Preserve pixel offset distance.
    STA.W SpriteBlockOffset
    PHX
    LDX.B _8
    LDA.L DATA_00E53D,X                       ; Store the value for the slope the sprite is on.
    PLX
    STA.W SpriteSlope,X
    CMP.B #$04
    BEQ CODE_019375
    CMP.B #$FC
    BNE CODE_019384
CODE_019375:
    EOR.B SpriteXSpeed,X                      ; If the sprite is moving towards (or is stationary on) a very steep slope,
    BPL +                                     ; flip its direction and push it down the slope.
    LDA.B SpriteXSpeed,X
    BEQ +
    JSR FlipSpriteDir
  + JSL CODE_03C1CA
CODE_019384:
    BRA CODE_0193B8                           ; Make solid.

CODE_019386:
    LDA.B _C                                  ; Sprite is touching a corner tile (1D8-1FF) or an upside-down slope.
    AND.B #$0F                                ; Treat as blank if not touching the top area of the tile (within 5 pixels).
    CMP.B #$05
    BCS Return0193AF
    LDA.W SpriteStatus,X                      ; \ Return if sprite status == Killed
    CMP.B #$02                                ; |
    BEQ Return0193AF                          ; /
    CMP.B #$05                                ; \ Return if sprite status == #$05; Return if the sprite is dead and falling, sinking in lava, or being carried.
    BEQ Return0193AF                          ; /
    CMP.B #$0B                                ; \ Return if sprite status == Carried
    BEQ Return0193AF                          ; /
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$01
    STA.B SpriteYPosLow,X                     ; Move the sprite slightly upwards.
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSR CODE_0192C9                           ; Process vertical block interaction (so that it doesn't sink through the ground).
Return0193AF:
    RTS

CODE_0193B0:
    LDA.B _C                                  ; Sprite is touching a ledge.
    AND.B #$0F                                ; Return if touching the top of the ledge.
    CMP.B #$05                                ; Range for the top of the ledge.
    BCS Return019424
CODE_0193B8:
    LDA.W SpriteTweakerE,X                    ; Sprite is touching a solid block, or is on top of a ledge/slope.
    AND.B #$04                                ; Branch if the sprite has "weird ground behavior".
    BNE CODE_019414
    LDA.W SpriteStatus,X                      ; \ Return if sprite status == Killed
    CMP.B #$02                                ; |
    BEQ Return019424                          ; /
    CMP.B #$05                                ; \ Return if sprite status == #$05; Return as blank if the sprite is dead and falling, sinking in lava, or being carried.
    BEQ Return019424                          ; /
    CMP.B #$0B                                ; \ Return if sprite status == Carried
    BEQ Return019424                          ; /
    LDY.W Map16TileNumber
    CPY.B #$0C
    BEQ CODE_0193D9                           ; Branch if not tiles 10C/10D (ledge conveyors).
    CPY.B #$0D
    BNE CODE_019405
CODE_0193D9:
    LDA.B TrueFrame
    AND.B #$03
    BNE CODE_019405
    JSR IsTouchingObjSide
    BNE CODE_019405                           ; Branch if not touching an object's side and not in tileset 2 (rope 1) or 8 (rope 3).
    LDA.W ObjectTileset                       ; Even if it is, run the below code only once every 4 frames.
    CMP.B #$02
    BEQ ADDR_0193EF
    CMP.B #$08
    BNE CODE_019405
ADDR_0193EF:
    TYA                                       ; Code to make sprites move when placed on conveyor belts (10C/10D).
    SEC
    SBC.B #$0C
    TAY
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_0192C5,Y
    STA.B SpriteXPosLow,X                     ; Push the sprite a pixel to the left/right.
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_0192C7,Y
    STA.W SpriteXPosHigh,X
CODE_019405:
; Not a conveyor.
    LDA.W SpriteOnYoshiTongue,X               ; Branch if on Yoshi's tongue.
    BNE CODE_019414
    LDA.B SpriteYPosLow,X
    AND.B #$F0
    CLC                                       ; Shift sprite on top of the tile.
    ADC.W SpriteBlockOffset
    STA.B SpriteYPosLow,X
CODE_019414:
    JSR CODE_019435                           ; Set blocked bit for being blocked below.
    LDA.W TileGenerateTrackA
    BEQ Return019424
    LDA.W SpriteBlockedDirs,X                 ; If the tile was on Layer 2, set corresponding blocked bit as well.
    ORA.B #$80
    STA.W SpriteBlockedDirs,X
Return019424:
    RTS

CODE_019425:
    LDA.B _A                                  ; Short subroutine to store a block's pposition in $98-$9B and set the blocked status for it.
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
    ORA.W DATA_019134,Y                       ; Set blocked status.
    STA.W SpriteBlockedDirs,X
    RTS

CODE_019441:
; Scratch RAM returns:
; $00 - Block position for clipping, in the format #$YX.
; $01 - Temporary duplicate of $0A.
; $0A - Clipping X position, low.
; $0B - Clipping X position, high.
; $0C - Clipping Y position, low.
; $0D - Clipping Y position, high.
; $0F - Side being touched. 0 = right, 1 = left, 2 = down, 3 = up
; Subroutine to find the Map16 number a sprite is touching. Returns the high byte in A, and the low in $1693.
    STY.B _F                                  ; Can be 00-03; Usage: side in Y. 0 = right, 1 = left, 2 = down, 3 = up
    LDA.W SpriteTweakerA,X                    ; \ Y = $1656,x (Upper 4 bits) + $0F (Lower 2 bits)
    AND.B #$0F                                ; |
    ASL A                                     ; |
    ASL A                                     ; |
    ADC.B _F                                  ; |
    TAY                                       ; /
CODE_01944D:
    LDA.W TileGenerateTrackA                  ; Jump here instead to use a specified clipping index.
    INC A                                     ; Branch if running horizontal interaction.
    AND.B ScreenMode                          ; Else, running vertical interaction.
    BEQ CODE_0194BF
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W SpriteObjClippingY,Y
    STA.B _C
    AND.B #$F0
    STA.B _0                                  ; Store 16-bit vertical clipping position to $0C/$0D.
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    CMP.B LevelScrLength                      ; If below the bottom of the level, return and treat as water.
    BCS CODE_0194B4
    STA.B _D
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W SpriteObjClippingX,Y
    STA.B _A
    STA.B _1                                  ; Store 16-bit horizontal clipping position to $0A/$0B.
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    CMP.B #$02                                ; If off the sides of the level, return and treat as water.
    BCS CODE_0194B4
    STA.B _B
    LDA.B _1
    LSR A
    LSR A
    LSR A                                     ; Store block position in #$YX format to $00.
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
    STA.B _5                                  ; Get lower two bytes of the Map16 pointer.
    LDA.L DATA_00BABC,X
    LDY.W TileGenerateTrackA
    BEQ +
    LDA.L DATA_00BACA,X
  + ADC.B _B
    STA.B _6
    JSR CODE_019523
    RTS

CODE_0194B4:
    LDY.B _F                                  ; Return touched block as water. Used if the sprite goes offscreen.
    LDA.B #$00
    STA.W Map16TileNumber                     ; Set the space outside of the level to act like water (tile 000) for sprites.
    STA.W SpriteBlockOffset
    RTS

CODE_0194BF:
    LDA.B SpriteYPosLow,X                     ; Find the Map16 number a sprite is touching on specifically a horizontal layer.
    CLC
    ADC.W SpriteObjClippingY,Y
    STA.B _C
    AND.B #$F0                                ; Store 16-bit vertical clipping position to $0C/$0D.
    STA.B _0
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _D
    REP #$20                                  ; A->16
    LDA.B _C
    CMP.W #$01B0                              ; If below the screen, return and treat as water.
    SEP #$20                                  ; A->8
    BCS CODE_0194B4
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W SpriteObjClippingX,Y
    STA.B _A                                  ; Store current clipping position in $0A/$0B.
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
    LDA.L DATA_00BA70,X                       ; Get the index to the block in Map16 data.
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
    LDA.B [_5]                                ; Find what type of block the sprite is touching.
    STA.W Map16TileNumber                     ; Get the proper Acts-Like setting in the process.
    INC.B _7
    LDA.B [_5]
    JSL CODE_00F545
    LDY.B _F
    CMP.B #$00
    RTS

HandleSprStunned:
    LDA.B SpriteNumber,X                      ; \ Branch if not Yoshi shell; Routine to handle sprites in the stationary/carryable/stunned state (sprite status 9).
    CMP.B #$2C                                ; /; If not sprite 2C (Yoshi egg), branch.
    BNE CODE_019554
    LDA.B SpriteTableC2,X                     ; This never seems to be set for the Yoshi egg, so always branch. (?)
    BEQ CODE_01956A
CODE_019546:
    LDA.B SpriteProperties                    ; \ Temporarily set $64 = #$10...
    PHA                                       ; |
    LDA.B #!OBJ_Priority1                     ; |
    STA.B SpriteProperties                    ; |; Draw the sprite behind objects.
    JSR SubSprGfx2Entry1                      ; | ...and call gfx routine
    PLA                                       ; |
    STA.B SpriteProperties                    ; /
    RTS

CODE_019554:
    CMP.B #$2F                                ; \ If Spring Board...; If sprite 2F (springboard), return to normal status.
    BEQ SetNormalStatus2                      ; | ...Unused Sprite 85...
    CMP.B #$85                                ; | ...or Balloon,; If sprite 85 (unused), return to normal status.
    BEQ SetNormalStatus2                      ; | Set Status = Normal...
    CMP.B #$7D                                ; |  ...and jump to $01A187; If not sprite 7D (P-balloon), branch.
    BNE CODE_01956A                           ; |
    STZ.B SpriteYSpeed,X                      ; | Balloon Y Speed = 0; Zero the P-balloon's Y speed.
SetNormalStatus2:
    LDA.B #$08                                ; |
    STA.W SpriteStatus,X                      ; |; Return the springboard and P-balloon to normal status, then draw its graphics.
    JMP CODE_01A187                           ; /

CODE_01956A:
    LDA.B SpriteLock                          ; \ If sprites locked,; Routine for all stunned sprites except springboards and P-balloons.
    BEQ +                                     ; | jump to $0195F5; If sprites are locked, then skip object/sprite/Mario interaction and movement.
    JMP CODE_0195F5                           ; /

  + JSR CODE_019624                           ; Handle stun timer related routines.
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    JSR IsOnGround
    BEQ CODE_019598                           ; If the sprite is on the ground, process ground interaction.
    JSR CODE_0197D5
    LDA.B SpriteNumber,X
    CMP.B #$16                                ; \ If Vertical or Horizontal Fish,
    BEQ ADDR_019589                           ; |; Return sprites 15 and 16 (fish) to normal status.
    CMP.B #$15                                ; | jump to $019562; (seems to be unused?)
    BNE +                                     ; |
ADDR_019589:
    JMP SetNormalStatus2                      ; /

  + CMP.B #$2C                                ; \ Branch if not Yoshi Egg
    BNE CODE_019598                           ; /; Initialize the Yoshi egg's hatching sequence when it hits the ground and return it to normal status.
    LDA.B #$F0                                ; \ Set upward speed; Only applies to ? block eggs, and the speed doesn't actually affect anything.
    STA.B SpriteYSpeed,X                      ; /
    JSL CODE_01F74C
CODE_019598:
    JSR IsTouchingCeiling
    BEQ +                                     ; If the sprite hits a ceiling, send it back downwards.
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
    LDA.W SpriteYPosHigh,X                    ; |; If the sprite isn't also touching the side of a block, make it interact with the block.
    STA.B TouchBlockYPos+1                    ; /; i.e. this is the code that lets you actually hit a block with a carryable sprite.
    LDA.W SpriteBlockedDirs,X
    AND.B #$20                                ; Why it matters that the side isn't being touched, who knows.
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
    CMP.B #$0D                                ; | (Koopa Troopas); If the sprite is touching the side of a block and is not a shell, then interact with that block.
    BCC +                                     ; |
    JSR CODE_01999E                           ; /
  + LDA.B SpriteXSpeed,X
    ASL A
    PHP                                       ; Make the sprite bounce backwards from the wall at 1/4th of its speed.
    ROR.B SpriteXSpeed,X
    PLP
    ROR.B SpriteXSpeed,X
CODE_0195F2:
    JSR SubSprSpr_MarioSpr                    ; Interact with Mario and other sprites.
CODE_0195F5:
    JSR CODE_01A187                           ; Draw graphics, and handle stunned sprite routines.
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    RTS


    db $00,$00,$00,$00,$04,$05,$06,$07
    db $00,$00,$00,$00,$04,$05,$06,$07
    db $00,$00,$00,$00,$04,$05,$06,$07
    db $00,$00,$00,$00,$04,$05,$06,$07
SpriteKoopasSpawn:
    db $00,$00,$00,$00,$00,$01,$02,$03

CODE_019624:
; Unused table.
; Sprites spawned from a stunned shell. First four bytes are unused.
    LDA.B SpriteNumber,X                      ; \ Branch away if sprite isn't a Bob-omb; Subroutine to handle routines relating to the stun timer for stunned sprites.
    CMP.B #$0D                                ; |; If not sprite 0D (Bob-omb), branch.
    BNE CODE_01965C                           ; /
    LDA.W SpriteMisc1540,X                    ; \ Branch away if it's not time to explode
    CMP.B #$01                                ; |; If the Bob-omb's timer isn't 01, then branch becuase it's not set to explode.
    BNE +                                     ; /
    LDA.B #!SFX_KAPOW                         ; \ Bomb sound effect; SFX for the Bob-omb explosion.
    STA.W SPCIO3                              ; /
    LDA.B #$01                                ; Set the Bob-omb's exploding flag.
    STA.W SpriteMisc1534,X
    LDA.B #$40                                ; \ Set explosion timer; How long the Bob-omb's explosion should last.
    STA.W SpriteMisc1540,X                    ; /
    LDA.B #$08                                ; \ Set normal status; Run the explosion in a normal status.
    STA.W SpriteStatus,X                      ; /
    LDA.W SpriteTweakerE,X                    ; \ Set to interact with other sprites
    AND.B #$F7                                ; |; Don't let Yoshi eat the explosion and don't let it turn into a coin after a goal post.
    STA.W SpriteTweakerE,X                    ; /
    RTS

  + CMP.B #$40
    BCS +
    ASL A                                     ; If the Bob-omb's timer is less than #$40, then make it flash.
    AND.B #$0E                                ; Either way, return afterwards.
    EOR.W SpriteOBJAttribute,X
    STA.W SpriteOBJAttribute,X
  + RTS

CODE_01965C:
    LDA.W SpriteMisc1540,X                    ; Not a Bob-omb. This part checks if it's shell with a Koopa inside, that is about to turn into a normal Koopa.
    ORA.W SpriteMisc1558,X                    ; Duplicate the stun timer to $C2. No real reason for this (maybe?), but it happens.
    STA.B SpriteTableC2,X
    LDA.W SpriteMisc1558,X
    BEQ CODE_01969C
    CMP.B #$01                                ; Essentially, branch if this is not a shell
    BNE CODE_01969C                           ; or there is not a Koopa currently jumping into it.
    LDY.W SpriteMisc1594,X                    ; Of course, it doesn't explicitely check this, which results in some odd bugs.
    LDA.W SpriteOnYoshiTongue,Y
    BNE CODE_01969C
    JSL LoadSpriteTables
    JSR FaceMario
    ASL.W SpriteOBJAttribute,X                ; Clear the shell's Y flip.
    LSR.W SpriteOBJAttribute,X
    LDY.W SpriteMisc160E,X                    ; Turn the shell into a Koopa. If a yellow Koopa entered it, turn it into a disco shell.
    LDA.B #$08
    CPY.B #$03                                ; Koopa sprite ID that makes a disco shell.
    BNE +
    INC.W SpriteMisc187B,X
    LDA.W SpriteTweakerC,X                    ; \ Disable fireball/cape killing
    ORA.B #$30                                ; |; Disable cape/fireball killing.
    STA.W SpriteTweakerC,X                    ; /
    LDA.B #$0A                                ; \ Sprite status = Kicked
  + STA.W SpriteStatus,X                      ; /
  - RTS

CODE_01969C:
; Not a shell turning into a Koopa. Check other stunned sprite routines.
    LDA.W SpriteMisc1540,X                    ; \ Return if stun timer == 0; If the sprite's stun timer isn't set, return.
    BEQ -                                     ; /; (i.e. it's not a stunned Goomba, Koopa, MechaKoopa, etc.)
    CMP.B #$03                                ; \ If stun timer == 3, un-stun the sprite
    BEQ UnstunSprite                          ; /; If the stun timer is not #$03 or #$01, handle the stun timer as usual.
    CMP.B #$01                                ; \ Every other frame, increment the stall timer
    BNE IncrmntStunTimer                      ; /  to emulates a slower timer
UnstunSprite:
    LDA.B SpriteNumber,X                      ; \ Branch if Buzzy Beetle; Routine to unstun a sprite.
    CMP.B #$11                                ; |; Sprite 11 (Buzzy Beetle): Return to normal status.
    BEQ SetNormalStatus                       ; /
    CMP.B #$2E                                ; \ Branch if Spike Top; Sprite 2E (Spike Top?): Return to normal status.
    BEQ SetNormalStatus                       ; /
    CMP.B #$2D                                ; \ Return if Baby Yoshi; Sprite 2D (Baby Yoshi): Stay stunned.
    BEQ Return0196CA                          ; /
    CMP.B #$A2                                ; \ Branch if MechaKoopa; Sprite A2 (MechaKoopa): Return to normal status.
    BEQ SetNormalStatus                       ; /
    CMP.B #$0F                                ; \ Branch if Goomba; Sprite 0F (Goomba): Return to normal status.
    BEQ SetNormalStatus                       ; /
    CMP.B #$2C                                ; \ Branch if Yoshi Egg; Sprite 2C (Yoshi Egg): Stay stunned.
    BEQ Return0196CA                          ; /
    CMP.B #$53                                ; \ Branch if not Throw Block; Sprite 04-07 (Shells): Spawn a Koopa. [note: the BNE is why stun glitch happens]
    BNE GeneralResetSpr                       ; /; Yellow koopas also spawn a coin.
    JSR CODE_019ACB                           ; Set throw block to vanish; Sprite 53 (Throwblock): Erase it with a cloud of smoke.
Return0196CA:
    RTS

SetNormalStatus:
    LDA.B #$08                                ; \ Sprite Status = Normal; Subroutine to return a sprite to normal status.
    STA.W SpriteStatus,X                      ; /
    ASL.W SpriteOBJAttribute,X                ; \ Clear vertical flip bit; Reset Y flip.
    LSR.W SpriteOBJAttribute,X                ; /
    RTS

IncrmntStunTimer:
    LDA.B TrueFrame                           ; \ Increment timer every other frame; Subroutine to counter the stun timer every other frame.
    AND.B #$01                                ; |; Increment the stun timer every other frame.
    BNE +                                     ; |; Since the stun timer decrements EVERY frame, what this is actually doing is decrementing every two frames.
    INC.W SpriteMisc1540,X                    ; |
  + RTS                                       ; /

GeneralResetSpr:
; Subroutine to spawn a sprite from a shell when unstunning (includes being knocked out from bouncing on).
    JSL FindFreeSprSlot                       ; \ Return if no free sprite slot found; Return if no empty slots.
    BMI Return0196CA                          ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B SpriteNumber,X                      ; \ Store sprite number for shelless koopa
    TAX                                       ; |; Spawn the Koopa corresponding to the shell's ID.
    LDA.W SpriteKoopasSpawn,X                 ; |
    STA.W SpriteNumber,Y                      ; /
    TYX                                       ; \ Reset sprite tables
    JSL InitSpriteTables                      ; |
    LDX.W CurSpriteProcess                    ; /
    LDA.B SpriteXPosLow,X                     ; \ Shelless Koopa position = Koopa position
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.W SpriteXPosHigh,Y                    ; |; Make sure it spawns at the same position as the shell.
    LDA.B SpriteYPosLow,X                     ; |
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.W SpriteYPosHigh,Y                    ; /
    LDA.B #$00                                ; \ Direction = 0; Face the koopa right.
    STA.W SpriteMisc157C,Y                    ; /
    LDA.B #$10                                ; Briefly disable sprite contact for the Koopa.
    STA.W SpriteMisc1564,Y
    LDA.W SpriteInLiquid,X
    STA.W SpriteInLiquid,Y                    ; Share RAM for being in water + being stunned.
    LDA.W SpriteMisc1540,X
    STZ.W SpriteMisc1540,X
    CMP.B #$01                                ; Branch if the koopa is being spawned from being knocked out of the shell, not shaking itself out.
    BEQ +
    LDA.B #$D0                                ; \ Set upward speed; Y speed for a shell-less Koopa when it jumps out of a shell.
    STA.W SpriteYSpeed,Y                      ; /
    PHY                                       ; \ Make Shelless Koopa face away from Mario
    JSR SubHorizPos                           ; |
    TYA                                       ; |
    EOR.B #$01                                ; |
    PLY                                       ; |
    STA.W SpriteMisc157C,Y                    ; /; Face away from Mario.
    PHX                                       ; \ Set Shelless X speed
    TAX                                       ; |
    LDA.W Spr0to13SpeedX,X                    ; |
    STA.W SpriteXSpeed,Y                      ; |
    PLX                                       ; /
    RTS

  + PHY                                       ; Spawning a koopa from a shell and about to unstun.
    JSR SubHorizPos
    LDA.W DATA_0197AD,Y
    STY.B _0
    PLY                                       ; Give Koopa an X speed away from Mario.
    STA.W SpriteXSpeed,Y
    LDA.B _0
    EOR.B #$01
    STA.W SpriteMisc157C,Y
    STA.B _1
    LDA.B #$10
    STA.W SpriteMisc154C,Y                    ; Disable player contact and set sliding flag for the Koopa.
    STA.W SpriteMisc1528,Y
    LDA.B SpriteNumber,X                      ; \ If Yellow Koopa...
    CMP.B #$07                                ; |; Return if not knocking out a yellow Koopa.
    BNE Return019775                          ; |
    LDY.B #$08                                ; | ...find free sprite slot...
CODE_01976D:
    LDA.W SpriteStatus,Y                      ; |; Spawn a coin too.
    BEQ SpawnMovingCoin                       ; | ...and spawn moving coin
    DEY                                       ; |
    BPL CODE_01976D                           ; /
Return019775:
    RTS

SpawnMovingCoin:
    LDA.B #$08                                ; \ Sprite status = normal; Routine to spawn a moving coin when a yellow koopa is hit.
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
; X speeds to give Koopas spawned when knocked out of a shell.
; Bounce speeds for carryable sprites when hitting the ground. Indexed by Y speed divided by 4.
; Goombas in particular use the values starting at the $00s here.
    LDA.B SpriteXSpeed,X                      ; Subroutine to make carryable sprites bounce when they hit the ground.
    PHP
    BPL +
    JSR InvertAccum
  + LSR A                                     ; Halve the sprite's X speed.
    PLP
    BPL +
    JSR InvertAccum
  + STA.B SpriteXSpeed,X
    LDA.B SpriteYSpeed,X
    PHA                                       ; Set a normal ground Y speed.
    JSR SetSomeYSpeed__
    PLA
    LSR A
    LSR A
    TAY
    LDA.B SpriteNumber,X                      ; \ If Goomba, Y += #$13
    CMP.B #$0F                                ; |
    BNE +                                     ; |
    TYA                                       ; |; Make Goombas bounce extra high.
    CLC                                       ; |
    ADC.B #$13                                ; |
    TAY                                       ; /
  + LDA.W DATA_0197AF,Y
    LDY.W SpriteBlockedDirs,X                 ; Get the Y speed to make the sprite bounce at when it hits the ground.
    BMI +
    STA.B SpriteYSpeed,X
  + RTS

CODE_019806:
; Shell misc RAM:
; $C2   - If set to a non-zero value, there is a Koopa inside the shell. Set in a few ways:
; Set to #$0F when it's entered and starts to shake, after which it turns into a Koopa.
; Always set to #$01 when a Koopa is inside the shell. Also applies to disco shells.
; Set to the value in $1540 or $1558 for a shell while stunned.
; $151C - When in disco shell form, if set, the shell will not follow Mario.
; $1528 - Sliding flag. Set when a blue Koopa is catching it.
; $1540 - Stun timer. Set to #$02 for a shell on the frame a Koopa is knocked out of it, cleared the next frame.
; Set to #$FF when capespinned with a Koopa inside, or when spawned from a block. At zero, the Koopa jumps out.
; $154C - Timer for disabling interaction with Mario and other sprites. Set under a few circumstances:
; Set to #$2C when spawned from a block.
; Set to #$08 when picked up.
; Set to #$10 when dropping or throwing.
; $1558 - Used for various timers.
; Set to #$10 when it's entered by a Koopa and starts to shake, after which it turns into a Koopa.
; Set to #$40 when sinking in lava.
; $1564 - Timer to disable sprite contact with other sprites. Set to #$08 when kicked by a blue Koopa.
; $1570 - Frame counter for animation, as well as for when player-following Koopas should turn.
; $157C - Direction of horizontal movement. 00 = right, 01 = left
; $1594 - Shell-less Koopas and shells set this to each other's sprite slots when one is jumping into the other.
; $15AC - Timer to tell the sprite to turn around. Set to #$08 when turning, decrases every frame.
; Also set to #$10 when spawned from a block for some reason.
; $1602 - Animation frame to use.
; 6/7/8 = shell
; $160E - When a shell-less Koopa jumps into the shell, this is set to its sprite ID.
; $1626 - Number of consecutive enemies the shell has killed.
; $187B - If non-zero, the shell functions as a disco shell.
; NOTE: These also apply to sprite 09, not just 04-07.
; Carryable shell MAIN.
    LDA.B #$06                                ; Default animation frame.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    BNE CODE_01980F
    LDA.B #$08                                ; Animation frame when turning while Mario is holding it.
CODE_01980F:
    STA.W SpriteMisc1602,X
    LDA.W SpriteOAMIndex,X
    PHA
    BEQ +                                     ; Increase OAM index if the shell doesn't already have an index of 0?
    CLC                                       ; (it does this to draw the eyes on top, although I don't know why it ignores 0)
    ADC.B #$08
  + STA.W SpriteOAMIndex,X
    JSR SubSprGfx2Entry1                      ; Draw a 16x16 sprite.
    PLA
    STA.W SpriteOAMIndex,X
    LDA.W OWLevelTileSettings+$49             ; If the Special World is passed, return.
    BMI Return0198A6                          ; (don't shake / display Koopa eyes)
    LDA.W SpriteMisc1602,X
    CMP.B #$06                                ; If the opening in the shell's graphics isn't facing the screen, return.
    BNE Return0198A6
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1558,X                    ; If the shell is being entered by a Koopa, make it shake.
    BNE CODE_019842
    LDA.W SpriteMisc1540,X                    ; Or if the shell already has a Koopa hiding inside, make it shake when it's about to emerge.
    BEQ Return0198A6                          ; (else, return the routine)
    CMP.B #$30                                ; At what time the Koopa shell begins to shake when a Koopa is hiding inside..
    BCS +
CODE_019842:
    LSR A                                     ; Make the Koopa shell shake.
    LDA.W OAMTileXPos+$108,Y
    ADC.B #$00
    BCS +
    STA.W OAMTileXPos+$108,Y
  + LDA.B SpriteNumber,X                      ; \ Branch away if a Buzzy Beetle
    CMP.B #$11                                ; |
    BEQ Return0198A6                          ; /; If the shell is a Buzzy Beetle or offscreen, return (don't draw Koopa eyes).
    JSR IsSprOffScreen
    BNE Return0198A6
    LDA.W SpriteOBJAttribute,X
    ASL A
    LDA.B #$08                                ; Y offset of the Koopa eyes when the shell is upside down.
    BCC +
    LDA.B #$00                                ; Y offset of the Koopa eyes when the shell is rightside up.
  + STA.B _0
    LDA.W OAMTileXPos+$108,Y
    CLC
    ADC.B #$02
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$04                                ; Set X/Y position.
    STA.W OAMTileXPos+$104,Y
    LDA.W OAMTileYPos+$108,Y
    CLC
    ADC.B _0
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    PHY
    LDY.B #$64                                ; Koopa shell eye tile (open)
    LDA.B EffFrame
    AND.B #$F8
    BNE +
    LDY.B #$4D                                ; Koopa shell eye tile (closed)
  + TYA                                       ; Set tile numbers.
    PLY
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$104,Y
    LDA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y                  ; Set YXPPCCCT.
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY                                       ; Set tile size.
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
Return0198A6:
    RTS


    db $E0,$20

CODE_0198A9:
; X speeds to give the disco shell when it bumps into a wall.
    LDA.B SpriteLock                          ; Disco shell MAIN (see the actual shell's MAIN for misc ram)
    BEQ +                                     ; If the game is frozen, just draw graphics.
    JMP CODE_019A2A

  + JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    LDA.W SpriteMisc151C,X
    AND.B #$1F                                ; Follow Mario, except when $151C is non-zero. Likely a beta remnant?
    BNE +
    JSR FaceMario
  + LDA.B SpriteXSpeed,X
    LDY.W SpriteMisc157C,X                    ; If not at max speed, accelerate the disco Shell accordingly.
    CPY.B #$00
    BNE CODE_0198D0
    CMP.B #$20                                ; Maximum speed rightward for the disco shell.
    BPL +
    INC.B SpriteXSpeed,X
    INC.B SpriteXSpeed,X
    BRA +

CODE_0198D0:
    CMP.B #$E0                                ; Maximum speed leftward for the disco shell.
    BMI +
    DEC.B SpriteXSpeed,X
    DEC.B SpriteXSpeed,X
  + JSR IsTouchingObjSide
    BEQ +
    PHA
    JSR CODE_01999E
    PLA                                       ; If it hits the side of a block, interact with the block and bump it up to maximum X speed.
    AND.B #$03
    TAY
    LDA.W Return0198A6,Y
    STA.B SpriteXSpeed,X
  + JSR IsOnGround
    BEQ +
    JSR SetSomeYSpeed__                       ; If on the ground, set its Y speed to 10. (useless JSR)
    LDA.B #$10
    STA.B SpriteYSpeed,X
  + JSR IsTouchingCeiling
    BEQ +                                     ; If it hits a ceiling, clear its Y speed.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.B TrueFrame
    AND.B #$01
    BNE +
    LDA.W SpriteOBJAttribute,X                ; Cycle through the palettes every other frame.
    INC A
    INC A
    AND.B #$CF
    STA.W SpriteOBJAttribute,X
  + JMP CODE_01998C


    db $F0,$EE,$EC

HandleSprKicked:
    LDA.W SpriteMisc187B,X                    ; Routine to handle a sprite being kicked (sprite status A). Serves as a MAIN for many carryable sprites.
    BEQ +                                     ; Jump to the code above if it's a shell set to become a disco shell.
    JMP CODE_0198A9

  + LDA.W SpriteTweakerD,X
    AND.B #$10
    BEQ +                                     ; If it can be kicked like a shell, set the stun timer and return to carryable status, then draw graphics.
    JSR CODE_01AA0B
    JMP CODE_01A187

  + LDA.W SpriteMisc1528,X                    ; Kicked shell MAIN (see other main for misc ram; this routine also includes Buzzy Beetle shells and throwblocks)
    BNE +
    LDA.B SpriteXSpeed,X
    CLC                                       ; If not being caught by a Koopa, return the shell to carryable state if it somehow slows down enough.
    ADC.B #$20                                ; (how to do this, though, is a mystery)
    CMP.B #$40
    BCS +
    JSR CODE_01AA0B
  + STZ.W SpriteMisc1528,X
    LDA.B SpriteLock
    ORA.W SpriteMisc163E,X                    ; If sprites are frozen or (?) is happening, just draw graphics.
    BEQ +
    JMP CODE_01998F

  + JSR UpdateDirection
    LDA.W SpriteSlope,X
    PHA
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    PLA
    BEQ CODE_019969
    STA.B _0
    LDY.W SpriteInLiquid,X
    BNE CODE_019969
    CMP.W SpriteSlope,X                       ; If the sprite has just gone onto a slope, is not in water, and is moving faster than the slopes's angle,
    BEQ CODE_019969                           ; then make it "bounce" slightly off the slope.
    EOR.B SpriteXSpeed,X
    BMI CODE_019969
    LDA.B #$F8                                ; \ Set upward speed
    STA.B SpriteYSpeed,X                      ; /
    BRA CODE_019975

CODE_019969:
    JSR IsOnGround
    BEQ CODE_019984                           ; If on the ground, set its Y speed to 10. (useless JSR)
    JSR SetSomeYSpeed__
    LDA.B #$10                                ; \ Set downward speed; [Change to #$0C to make it never fall in one-tile gaps, and #$28 to make it always (#$19 if not sprinting)]
    STA.B SpriteYSpeed,X                      ; /
CODE_019975:
    LDA.W SprMap16TouchHorizLow
    CMP.B #$B5
    BEQ CODE_019980
    CMP.B #$B4                                ; If the shell hits a purple triangle, send it flying in the air.
    BNE CODE_019984
CODE_019980:
    LDA.B #$B8                                ; Y speed to give the shell.
    STA.B SpriteYSpeed,X
CODE_019984:
    JSR IsTouchingObjSide
    BEQ CODE_01998C                           ; If it hits the side of a block, handle interaction with it.
    JSR CODE_01999E
CODE_01998C:
    JSR SubSprSpr_MarioSpr                    ; Process interaction with Mario and other sprites.
CODE_01998F:
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteNumber,X                      ; \ Branch if throw block sprite
    CMP.B #$53                                ; |
    BEQ +                                     ; /; If the sprite is a throwblock, process its normal stunned routine simultaneously.
    JMP CODE_019A2A                           ; Else, draw shell graphics.

  + JMP StunThrowBlock

CODE_01999E:
; Subroutine for thrown sprites interacting with the sides of blocks.
    LDA.B #!SFX_BONK                          ; SFX for hitting a block with any sprite.
    STA.W SPCIO0                              ; / Play sound effect
    JSR CODE_0190A2                           ; Invert the sprite's X speed.
    LDA.W SpriteOffscreenX,X
    BNE +
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.B #$14
    CMP.B #$1C
    BCC +
    LDA.W SpriteBlockedDirs,X                 ; If it's far enough on-screen, make it actually interact with the block.
    AND.B #$40                                ; i.e. this is the code that lets you actually hit a block with a thrown sprite.
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
    CMP.B #$53                                ; |; If the sprite is a throwblock, shatter it.
    BNE +                                     ; |
    JSR BreakThrowBlock                       ; /
  + RTS

BreakThrowBlock:
; Subroutine to shatter a throwblock.
    STZ.W SpriteStatus,X                      ; Free up sprite slot; Erase the throwblock.
    LDY.B #$FF                                ; Is this for the shatter routine??
CODE_0199E1:
    JSR IsSprOffScreen                        ; \ Return if off screen; Subroutine to create shatter particles. Y contains the timer for the particles
    BNE +                                     ; /
    LDA.B SpriteXPosLow,X                     ; \ Store Y position in $9A-$9B
    STA.B TouchBlockXPos                      ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Store X position in $98-$99
    STA.B TouchBlockYPos                      ; |
    LDA.W SpriteYPosHigh,X                    ; |; If the sprite is on-screen, then create the shattered block effect.
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
; Equivalent routine in bank 2 at $02FFD1.
    LDA.W SpriteBlockedDirs,X                 ; Subroutine to set Y speed for a sprite when on the ground.
    BMI CODE_019A10
    LDA.B #$00                                ; \ Sprite Y speed = #$00 or #$18
    LDY.W SpriteSlope,X                       ; | Depending on 15B8,x ???; If standing on a slope or Layer 2, give the sprite a Y speed of #$18.
    BEQ +                                     ; |; Else, clear its Y speed.
CODE_019A10:
    LDA.B #$18                                ; |
  + STA.B SpriteYSpeed,X                      ; /
    RTS

UpdateDirection:
; Equivalent routine in bank 2 at $02C126.
    LDA.B #$00                                ; \ Subroutine: Set direction from speed value; Subroutine to update a sprite's direction based on its current X speed.
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
; Animation frames for a spinning shell.
; YXPPCCCT properties for each frame.
    LDA.B SpriteTableC2,X                     ; Subroutine to draw a spinning shell's graphics.
    STA.W SpriteMisc1558,X
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    TAY
    PHY
    LDA.W ShellAniTiles,Y                     ; Animate the spinning shell.
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
; Tile numbers for the smoke cloud spawned when a sprite is killed by a spinjump.
; Misc RAM usage:
; $1540 - Lifespan timer for the smoke cloud.
; Routine to handle a sprite killed by a spinjump (sprite status 4)
    LDA.W SpriteMisc1540,X                    ; \ Erase sprite if time up; Erase the sprite and return if the cloud's timer runs out.
    BEQ SpinJumpEraseSpr                      ; /
    JSR SubSprGfx2Entry1                      ; Call generic gfx routine; Draw a 16x16 sprite.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1540,X                    ; \ Load tile based on timer
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    AND.B #$03                                ; |; Replace the tile number in OAM.
    PHX                                       ; |
    TAX                                       ; |
    LDA.W SpinJumpSmokeTiles,X                ; |
    PLX                                       ;  /
    STA.W OAMTileNo+$100,Y                    ; Overwrite tile
    STA.W OAMTileAttr+$100,Y                  ; \ Overwrite properties
    AND.B #$30                                ; |; Clear all bits from YXPPCCCT except priority.
    STA.W OAMTileAttr+$100,Y                  ; /; Has a typo: probably supposed to be an "LDA $0303,y" on the first line. Works fine regardless, though.
    RTS

SpinJumpEraseSpr:
    JSR OffScrEraseSprite                     ; Permanently kill the sprite; Time to erase a sprite killed from a spinjump.
    RTS

CODE_019A7B:
; Misc RAM usage:
; $1558 - Timer for sinking.
; Routine to handle a sprite killed by lava (sprite status 5).
    LDA.W SpriteMisc1558,X                    ; If the sprite wasn't set to sink in lava for some reason, just completely erase it.
    BEQ SpinJumpEraseSpr
    LDA.B #$04                                ; Sinking Y speed.
    STA.B SpriteYSpeed,X
    ASL.W SpriteTweakerF,X                    ; Ignore walls.
    LSR.W SpriteTweakerF,X
    LDA.B SpriteXSpeed,X
    BEQ CODE_019A9D                           ; Slow down the sprite horizontally.
    BPL CODE_019A94
    INC.B SpriteXSpeed,X
    BRA CODE_019A9D                           ; [change to BRA #$02 to fix a bug where sprites will slide through blocks when moving left]

CODE_019A94:
    DEC.B SpriteXSpeed,X
    JSR IsTouchingObjSide
    BEQ CODE_019A9D                           ; Clear X speed if it hits a block (...but only when going right)
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
CODE_019A9D:
    LDA.B #$01                                ; Send the sprite behind objects.
    STA.W SpriteBehindScene,X
HandleSprKilled:
    LDA.B SpriteNumber,X                      ; \ If Wiggler, call main sprite routine; Routine to kill a sprite and knock it offscreen (sprite statue 2). Also used by the lava routine.
    CMP.B #$86                                ; |; If sprite 86 (Wiggler), handle its death routine from within its MAIN code.
    BNE +                                     ; |
    JMP CallSpriteMain                        ; /

  + CMP.B #$1E                                ; \ If Lakitu, $18E0 = #$FF
    BNE +                                     ; |; If sprite 1E (Lakitu), set the timer for its cloud.
    LDY.B #$FF                                ; |
    STY.W LakituCloudTimer                    ; /
  + CMP.B #$53                                ; \ If Throw Block sprite...
    BNE +                                     ; |; If sprite 53 (throwblock), shatter it.
    JSR BreakThrowBlock                       ; | ...break block...
    RTS                                       ; / ...and return

  + CMP.B #$4C                                ; \ If Exploding Block Enemy
    BNE +                                     ; |; If sprite 4C (exploding block), make it explode.
    JSL CODE_02E463                           ; /
  + LDA.W SpriteTweakerA,X                    ; \ If "disappears in puff of smoke" is set...
    AND.B #$80                                ; |; Branch if the sprite doesn't disappear in a cloud of smoke.
    BEQ +                                     ; |
CODE_019ACB:
    LDA.B #$04                                ; | ...Sprite status = Spin Jump Killed...; Subroutine to make a sprite poof. Used by the throwblock, P-switch, Bowser's fire, some sprites in lava, and spinjumped sprites.
    STA.W SpriteStatus,X                      ; |; Erase the sprite in a cloud of smoke.
    LDA.B #$1F                                ; | ...Set Time to show smoke cloud...
    STA.W SpriteMisc1540,X                    ; |
    RTS                                       ; / ... and return

  + LDA.B SpriteLock                          ; \ Branch if sprites locked; Kill the sprite by having it fall offscreen.
    BNE +                                     ; /; If sprites aren't locked, update X/Y position, apply gravity, and process interaction with blocks.
    JSR SubUpdateSprPos
  + JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR HandleSpriteDeath                     ; Draw the sprite's death graphics.
    RTS

HandleSprSmushed:
; Routine to handle "smushing" a sprite (sprite status 3).
    LDA.B SpriteLock                          ; \ Branch if sprites locked; If sprites are frozen, just draw graphics.
    BNE CODE_019AFE                           ; /
    LDA.W SpriteMisc1540,X                    ; \ Free sprite slot when timer runs out
    BNE +                                     ; |; Erase the sprite once the stun timer runs out.
    STZ.W SpriteStatus,X                      ; /
    RTS

  + JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    JSR IsOnGround
    BEQ CODE_019AFE                           ; If on the ground, set a Y speed and clear its X speed.
    JSR SetSomeYSpeed__
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
CODE_019AFE:
    LDA.B SpriteNumber,X                      ; \ If Dino Torch...
    CMP.B #$6F                                ; |; If not the Dino Torch, branch to display a mirrored 8x8.
    BNE +                                     ; |
    JSR SubSprGfx2Entry1                      ; | ...call standard gfx routine...; Create a 16x16 sprite.
    LDY.W SpriteOAMIndex,X                    ; |
    LDA.B #$AC                                ; | ...and replace the tile with #$AC; Tile number to use for the squished Dino Torch.
    STA.W OAMTileNo+$100,Y                    ; |
    RTS                                       ; / Return

  + JMP SmushedGfxRt                          ; Call smushed gfx routine

HandleSpriteDeath:
    LDA.W SpriteTweakerD,X                    ; \ If the main routine handles the death state...; Subroutine to handle sprite death graphics (HandleSprKilled and HandleSprLava)
    AND.B #$01                                ; |; If the regular kill routine is interrupted by the Tweaker bytes, return to sprite main.
    BEQ +                                     ; |
    JMP CallSpriteMain                        ; / ...jump to the main routine

  + STZ.W SpriteMisc1602,X                    ; Set to the sprite's default animation frame.
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Death frame 2 tiles high"
    AND.B #$20                                ; | is NOT set; Branch if the sprite's death frame is 16x16 (not 32x16).
    BEQ CODE_019B64                           ; /
    LDA.W SpriteTweakerB,X                    ; \ Branch if "Use shell as death frame"
    AND.B #$40                                ; | is set; Branch if the sprite uses a shell as the death frame.
    BNE CODE_019B5F                           ; /
    LDA.B SpriteNumber,X                      ; \ Branch if Lakitu
    CMP.B #$1E                                ; |
    BEQ CODE_019B3D                           ; /
    CMP.B #$4B                                ; \ If Pipe Lakitu,; If sprite 4B (pipe Lakitu), send it behind scenery as it dies.
    BNE CODE_019B44                           ; |; Additionally, use animation frame 1 for both it and sprite 1E (Lakitu).
    LDA.B #$01                                ; | set behind scenery flag
    STA.W SpriteBehindScene,X                 ; /
CODE_019B3D:
    LDA.B #$01                                ; For all other sprites, just make its graphics face left.
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
    LDA.B #!OBJ_Priority1                     ; | temorarily set layer priority for gfx routine; Draw a 32x16 sprite, behind objects if applicable.
  + STA.B SpriteProperties                    ; |
    JSR SubSprGfx1                            ; | Draw sprite
    PLA                                       ; |
    STA.B SpriteProperties                    ; /
    RTS

CODE_019B5F:
; Sprite uses shell as a death frame.
    LDA.B #$06                                ; Set animation frame for the shell.
    STA.W SpriteMisc1602,X
CODE_019B64:
    LDA.B #$00                                ; Sprite uses a 16x16 death frame.
    CPY.B #$1C
    BEQ +                                     ; If the sprite's index to $1938 is #$1C, flip X?
    LDA.B #$80
  + STA.B _0
    LDA.B SpriteProperties                    ; \ If sprite is behind scenery,
    PHA                                       ; |
    LDY.W SpriteBehindScene,X                 ; |
    BEQ +                                     ; |
    LDA.B #!OBJ_Priority1                     ; | temorarily set layer priority for gfx routine
  + STA.B SpriteProperties                    ; |; Draw a 16x16 sprite. Send behind objects if applicable.
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
; Various tilemaps for sprites. Indexed by the value from $019C7F + $1602 (*2 if 16x32, *4 if 4 8x8s).
; opa (2-byte)
; ell (1-byte, but indexed from above)
; ell-less Koopa (fourth byte unused)
; ell-less blue Koopa (fourth byte unused)
; ra-goomba
; omba
; ra-bomb
; b-omb
; assic / Jumping Piranha Plant
; otball
; llet Bill
; iny
; iny egg (4-byte)
; ?
; zzy Beetle
; ?
; zzy Beetle shell
; ike Top
; pping Flame
; kitu
; ving Ledge Hole?
; gikoopa
; rowblock / exploding turnblock
; imbing Koopa
; sh
; ?
; wimp (4-byte)
; ?
; ringboard (4-byte)
; ?
; ny Beetle
; ?
; doboo (4-byte)
; nused]
; shi
; nused]
; rie
; o
; p Van Fish
; rtical Dolphin
; ggin' Chuck's Rock
; nty Mole
; dge-dwelling Monty Mole's Dirt, ? Sphere
; ound-dwelling Monty Mole's Dirt (4-byte)
; mo Bros. Lightning
; nji
; Table of indices to the above table, indexed by sprite ID.
; X displacements for each 8x8 in the first shared GFX routine.
; Y displacements for each 8x8 in the first shared GFX routine.
; YXPPCCCT bytes for tiles in the first shared GFX routine (four 8x8s). p = normal in the representations.
; 00 - pp   |      pq   |      qp
; pp   | 04 - pq   | 05 - qp
; 08 - pq   |      qq
; bd   | 0C - pp
; 10 - qp   |      qq
; db   | 14 - qq
; Misc RAM input:
; $1602 - Animation frame.
; Scratch RAM setup:
; A = Index (divided by 4) to the YXPPCCCT properties table.
; Y = Additional Y position offset for the graphics, when using Entry1.
; Scratch RAM usage and output:
; $00 = Tile X offset.
; $01 = Tile Y offset.
; $02 = Index to the sprite tilemap table.
; $03 = General YXPPCCCT for the sprite.
; $04 = Used to count the 8x8 tiles. Returns with #$00.
; $05 = A; index (divided by 4) to the YXPPCCCT properties table.
; $0F = Y; additional Y offset.
; JSL located at $018042.
    LDY.B #$00                                ; The first shared GFX routine. This creates 4 8x8 tiles in a 16x16 block.
SubSprGfx0Entry1:
    STA.B _5
    STY.B _F
    JSR GetDrawInfoBnk1
    LDY.B _F
    TYA
    CLC                                       ; Add Y position offset to the draw position.
    ADC.B _1
    STA.B _1
    LDY.B SpriteNumber,X
    LDA.W SpriteMisc1602,X
    ASL A                                     ; $02 = Index to the tilemap table for the tile.
    ASL A
    ADC.W SprTilemapOffset,Y
    STA.B _2
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties                    ; $03 = YXPPCCCT.
    STA.B _3
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$03                                ; $04 = Counter for the current tile being drawn.
    STA.B _4
    PHX
  - LDX.B _4
    LDA.B _0
    CLC                                       ; Store X position.
    ADC.W GeneralSprDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position.
    ADC.W GeneralSprDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.B _2
    CLC
    ADC.B _4                                  ; Store tile number.
    TAX
    LDA.W SprTilemap,X
    STA.W OAMTileNo+$100,Y
    LDA.B _5
    ASL A
    ASL A
    ADC.B _4                                  ; Store YXPPCCCT.
    TAX
    LDA.W GeneralSprGfxProp,X
    ORA.B _3
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for all 4 tiles.
    INY
    DEC.B _4
    BPL -
    PLX
    LDA.B #$03
    LDY.B #$00                                ; Draw 4 8x8 tiles.
    JSR FinishOAMWriteRt
    RTS

GenericSprGfxRt1:
; Misc RAM input:
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame.
    PHB                                       ; The second shared GFX routine. This one creates 2 16x16 tiles in a 16x32 block, with the second one tile below the base position.
    PHK
    PLB
    JSR SubSprGfx1
    PLB
    RTL

SubSprGfx1:
    LDA.W SpriteOBJAttribute,X
    BPL +                                     ; Branch to appropriate GFX routine, based on whether the sprite is Y flipped.
    JSR SubSprGfx1Hlpr1
    RTS

  + JSR GetDrawInfoBnk1                       ; Sprite is not Y flipped.
    LDA.W SpriteMisc157C,X                    ; $02 = X flip.
    STA.B _2
    TYA
    LDY.B SpriteNumber,X
    CPY.B #$0F                                ; Increase OAM index by #$04 for sprites 00-0E (for Parakoopa wings?)
    BCS +
    ADC.B #$04
  + TAY
    PHY
    LDY.B SpriteNumber,X
    LDA.W SpriteMisc1602,X
    ASL A                                     ; Get index to the tilemap table for the tile.
    CLC
    ADC.W SprTilemapOffset,Y
    TAX
    PLY
    LDA.W SprTilemap,X
    STA.W OAMTileNo+$100,Y                    ; Store lower tile numbers for the two tiles.
    LDA.W SprTilemap+1,X
    STA.W OAMTileNo+$104,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    CLC                                       ; Store Y positions for the two tiles.
    ADC.B #$10
    STA.W OAMTileYPos+$104,Y
CODE_019DA9:
    LDA.B _0                                  ; Both routines share the below part.
    STA.W OAMTileXPos+$100,Y                  ; Store X position.
    STA.W OAMTileXPos+$104,Y
    LDA.W SpriteMisc157C,X
    LSR A
    LDA.B #$00
    ORA.W SpriteOBJAttribute,X
    BCS +                                     ; Store YXPPCCCT.
    ORA.B #!OBJ_XFlip
  + ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    ORA.W SpriteOffscreenX,X                  ; Set size as two 16x16s.
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    JSR CODE_01A3DF                           ; Check for individual tiles being offscreen, and hide them if so.
    RTS

SubSprGfx1Hlpr1:
    JSR GetDrawInfoBnk1                       ; Sprite is Y flipped.
    LDA.W SpriteMisc157C,X                    ; $02 = X flip.
    STA.B _2
    TYA
    CLC                                       ; Increase OAM index by #$08 for some reason.
    ADC.B #$08
    TAY
    PHY
    LDY.B SpriteNumber,X
    LDA.W SpriteMisc1602,X
    ASL A                                     ; Get index to the tilemap table for the tile.
    CLC
    ADC.W SprTilemapOffset,Y
    TAX
    PLY
    LDA.W SprTilemap,X
    STA.W OAMTileNo+$104,Y                    ; Store lower tile numbers for the two tiles.
    LDA.W SprTilemap+1,X
    STA.W OAMTileNo+$100,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    CLC                                       ; Store Y positions for the two tiles.
    ADC.B #$10
    STA.W OAMTileYPos+$104,Y
    JMP CODE_019DA9                           ; Jump back to finish the routine.


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
; X displacements (lo) for the Parakoopa wings.
; NOTE: This (and all the below tables!) are ALSO used for the flying ? block wings and flying Yoshi wings.
; X displacements (hi) for the Parakoopa wings.
; Y displacements for the Parakoopa wings.
; Tilemap for the Parakoopa wings.
; YXPPCCCT for the Parakoopa wings.
; Size of the Parakoopa wings tiles (00 = 8x8, 02 = 16x16).
; Misc RAM returns:
; $00 - Wing low X position within the level
; $01 - Wing low Y position
; $02 - Animation frame (0 or 1; basically, extend or contract)
; $04 - Koopa high X position within the level
    LDY.B #$00                                ; \ If not on ground, $02 = animation frame (00 or 01); Subroutine to draw wings for sprites 08-0C.
    JSR IsOnGround                            ; | else, $02 = 0
    BNE CODE_019E35                           ; |
    LDA.W SpriteMisc1602,X                    ; |
    AND.B #$01                                ; |
    TAY                                       ; |
CODE_019E35:
    STY.B _2                                  ; /; Generic subroutine to draw wings, ignoring animation frame or ground interaction.
CODE_019E37:
    LDA.W SpriteOffscreenVert,X               ; \ Return if offscreen vertically; Don't draw if vertically offscreen.
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
    ADC.W KoopaWingDispXHi,X                  ; |; Upload the wing's X position.
    PHA                                       ; |
    LDA.B _0                                  ; |
    SEC                                       ; |
    SBC.B Layer1XPos                          ; |
    STA.W OAMTileXPos+$100,Y                  ; /
    PLA                                       ; \ Return if off screen horizontally
    SBC.B Layer1XPos+1                        ; |; Return if horizontally offscreen.
    BNE +                                     ; /
    LDA.B _1                                  ; \ Store Y position (relative to screen)
    SEC                                       ; |
    SBC.B Layer1YPos                          ; |; Upload the wing's Y position.
    CLC                                       ; |
    ADC.W KoopaWingDispY,X                    ; |
    STA.W OAMTileYPos+$100,Y                  ; /
    LDA.W KoopaWingTiles,X                    ; \ Store tile; Upload the tile.
    STA.W OAMTileNo+$100,Y                    ; /
    LDA.B SpriteProperties                    ; \ Store tile properties
    ORA.W KoopaWingGfxProp,X                  ; |; Upload the YXPPCCCT.
    STA.W OAMTileAttr+$100,Y                  ; /
    TYA
    LSR A
    LSR A                                     ; Set the tile size.
    TAY
    LDA.W KoopaWingTileSize,X                 ; \ Store tile size
    STA.W OAMTileSize+$40,Y                   ; /
  + PLX
Return019E94:
    RTS

CODE_019E95:
    LDA.B SpriteYPosLow,X                     ; Subroutine to draw wings for the flying ? blocks, as well as the actual Yoshi wings.
    PHA
    CLC
    ADC.B #$02
    STA.B SpriteYPosLow,X                     ; Offset the wings vertically from the sprite.
    LDA.W SpriteYPosHigh,X
    PHA
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B SpriteXPosLow,X
    PHA
    SEC
    SBC.B #$02
    STA.B SpriteXPosLow,X                     ; Offset the wings horizontally from the sprite.
    LDA.W SpriteXPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.W SpriteOAMIndex,X
    PHA
    CLC                                       ; Increase OAM slot.
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    LDA.W SpriteMisc157C,X
    PHA
    STZ.W SpriteMisc157C,X
    LDA.W SpriteMisc1570,X
    LSR A                                     ; Upload the left wing to OAM.
    LSR A
    LSR A
    AND.B #$01
    TAY
    JSR CODE_019E35
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.B SpriteXPosLow,X                     ; Offset the right wing.
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.W SpriteOAMIndex,X
    CLC                                       ; Increase OAM slot.
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    INC.W SpriteMisc157C,X                    ; Upload the right wing to OAM.
    JSR CODE_019E37
    PLA
    STA.W SpriteMisc157C,X
    PLA
    STA.W SpriteOAMIndex,X
    PLA
    STA.W SpriteXPosHigh,X                    ; Restore the sprite position, direction, and OAM slot.
    PLA
    STA.B SpriteXPosLow,X
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    RTS

SubSprGfx2Entry0:
    STA.B _4                                  ; Alternate entry to the third shared GFX routine which allows for adding to the YXPPCCCT byte.
    BRA +

SubSprGfx2Entry1:
; Misc RAM input:
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame.
; JSL located at $0190B2
    STZ.B _4                                  ; The third shared GFX routine. This one creates a single 16x16 tile.
  + JSR GetDrawInfoBnk1
    LDA.W SpriteMisc157C,X
    STA.B _2
    LDY.B SpriteNumber,X
    LDA.W SpriteMisc1602,X
    CLC
    ADC.W SprTilemapOffset,Y                  ; Set tile number.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    TAX
    LDA.W SprTilemap,X
    STA.W OAMTileNo+$100,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _0
    STA.W OAMTileXPos+$100,Y                  ; Set X/Y offsets.
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.W SpriteMisc157C,X
    LSR A
    LDA.B #$00
    ORA.W SpriteOBJAttribute,X
    BCS +                                     ; Set YXPPCCCT.
    EOR.B #!OBJ_XFlip                         ; Flip X if the sprite is facing left.
  + ORA.B _4
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    ORA.W SpriteOffscreenX,X                  ; Draw a 16x16.
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
; X low position offsets for sprites from Mario when carrying them.
; Right, left, turning (< 1), turning (< 2, > 1), turning (> 2), centered.
; X high position offsets for sprites from Mario when carrying them.
; X low byte offsets from Mario to drop sprites at.
; X high byte offsets from Mario to drop sprites at.
; Base X speeds for carryable sprites when kicked/thrown.
; Third and fourth bytes are when spit out by Yoshi.
; Routine to handle carried sprites (sprite status B).
    JSR CODE_019F9B                           ; Run specific sprite routines.
    LDA.W PlayerTurningPose
    BNE CODE_019F83
    LDA.W YoshiInPipeSetting                  ; \ Branch if Yoshi going down pipe
    BNE CODE_019F83                           ; /; If turning while sliding, going down a pipe, or otherwise facing the screen,
    LDA.W FaceScreenTimer                     ; \ Branch if Mario facing camera; center the item on Mario, and change OAM index to #00.
    BEQ +                                     ; /; (to make it go in front of Mario).
CODE_019F83:
    STZ.W SpriteOAMIndex,X
  + LDA.B SpriteProperties
    PHA
    LDA.W YoshiInPipeSetting                  ; If going down a pipe, send behind objects.
    BEQ +
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + JSR CODE_01A187                           ; Draw graphics and handle basic routines.
    PLA
    STA.B SpriteProperties
    RTS


DATA_019F99:
    db $FC,$04

CODE_019F9B:
; Base X speeds for carryable sprites when dropped.
    LDA.B SpriteNumber,X                      ; \ Branch if not Balloon; Running carryable-sprite-specific routines; first up is P-balloon.
    CMP.B #$7D                                ; |; Branch if not the P-balloon.
    BNE CODE_019FE0                           ; /
    LDA.B TrueFrame
    AND.B #$03                                ; How quickly the P-balloon timer decrements.
    BNE CODE_019FBE
    DEC.W PBalloonTimer                       ; Decrement the timer, and end the balloon if it passes 0.
    BEQ CODE_019FC4
    LDA.W PBalloonTimer
    CMP.B #$30                                ; At what time the deflating animation for the P-balloon starts.
    BCS CODE_019FBE
    LDY.B #$01
    AND.B #$04
    BEQ +                                     ; Handle the deflating animation.
    LDY.B #$09
  + STY.W PBalloonInflating
CODE_019FBE:
    LDA.B PlayerAnimation                     ; \ Branch if no Mario animation sequence in progress
    CMP.B #$01                                ; |; End the balloon if Mario takes damage.
    BCC +                                     ; /
CODE_019FC4:
    STZ.W PBalloonInflating
    JMP OffScrEraseSprite

  + PHB                                       ; Balloon Mario routine.
    LDA.B #$02
    PHA
    PLB
    JSL CODE_02D214                           ; Handle control and speeds.
    PLB
    JSR CODE_01A0B1                           ; Handle position in relation to Mario.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$F0                                ; Stick the balloon's graphics offscreen (they still get drawn for some reason).
    STA.W OAMTileYPos+$100,Y
    RTS

CODE_019FE0:
; Carrying sprite other than P-balloon (i.e. actually carrying something).
    JSR CODE_019140                           ; Handle interaction with blocks.
    LDA.B PlayerAnimation                     ; \ Branch if no Mario animation sequence in progress
    CMP.B #$01                                ; |
    BCC +                                     ; /
    LDA.W YoshiInPipeSetting                  ; \ Branch if in pipe; If Mario let go of it (not thrown), return to stationary status.
    BNE +                                     ; /
    LDA.B #$09                                ; \ Sprite status = Stunned
    STA.W SpriteStatus,X                      ; /
    RTS

  + LDA.W SpriteStatus,X                      ; \ Return if sprite status == Normal
    CMP.B #$08                                ; |; If the sprite returned to normal status (e.g. Goombas un-stunning), return.
    BEQ Return01A014                          ; /
    LDA.B SpriteLock                          ; \ Jump if sprites locked
    BEQ +                                     ; |; If the game is frozen, just handle offset from Mario.
    JMP CODE_01A0B1                           ; /

  + JSR CODE_019624                           ; Handle stun timer routines.
    JSR SubSprSprInteract                     ; Handle interaction with other sprites.
    LDA.W YoshiInPipeSetting
    BNE CODE_01A011
    BIT.B byetudlrHold                        ; If X/Y are held or Mario is going down a pipe, offset the sprite from his position.
    BVC +                                     ; Else, branch to let go of the sprite.
CODE_01A011:
    JSR CODE_01A0B1
Return01A014:
    RTS

  + STZ.W SpriteMisc1626,X                    ; Subroutine to handle letting go of a sprite.
    LDY.B #$00                                ; Base Y speed to give sprites when kicking them.
    LDA.B SpriteNumber,X                      ; \ Branch if not Goomba
    CMP.B #$0F                                ; |
    BNE +                                     ; /; Reset the sprite's Y speed.
    LDA.B PlayerInAir                         ; If kicking a Goomba on the ground, punt it slightly into the air.
    BNE +
    LDY.B #$EC                                ; Base Y speed give Goombas when kicking them on the ground.
  + STY.B SpriteYSpeed,X
    LDA.B #$09                                ; \ Sprite status = Carryable; Return to carryable status.
    STA.W SpriteStatus,X                      ; /
    LDA.B byetudlrHold
    AND.B #$08                                ; Branch if holding up.
    BNE CODE_01A068
    LDA.B SpriteNumber,X                      ; \ Branch if sprite >= #$15
    CMP.B #$15                                ; |
    BCS CODE_01A041                           ; /
    LDA.B byetudlrHold
    AND.B #$04                                ; If not a Goomba or shell, don't kick by default.
    BEQ CODE_01A079                           ; If holding down, never kick.
    BRA CODE_01A047                           ; If holding left/right and not down, always kick.

CODE_01A041:
    LDA.B byetudlrHold
    AND.B #$03
    BNE CODE_01A079
CODE_01A047:
    LDY.B PlayerDirection                     ; Gently dropping a sprite (holding down, or release a non-shell/goomba sprite).
    LDA.B PlayerXPosNow
    CLC
    ADC.W DATA_019F67,Y                       ; Fix offset from Mario (in case of turning).
    STA.B SpriteXPosLow,X
    LDA.B PlayerXPosNow+1
    ADC.W DATA_019F69,Y
    STA.W SpriteXPosHigh,X
    JSR SubHorizPos
    LDA.W DATA_019F99,Y
    CLC                                       ; Set X speed.
    ADC.B PlayerXSpeed+1
    STA.B SpriteXSpeed,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    BRA CODE_01A0A6

CODE_01A068:
    JSL CODE_01AB6F                           ; Kicking a sprite upwards (holding up).
    LDA.B #$90                                ; Y speed to give sprites kicked upwards.
    STA.B SpriteYSpeed,X
    LDA.B PlayerXSpeed+1
    STA.B SpriteXSpeed,X                      ; Give the sprite half Mario's speed.
    ASL A
    ROR.B SpriteXSpeed,X
    BRA CODE_01A0A6

CODE_01A079:
    JSL CODE_01AB6F                           ; Kicking a sprite sideways (holding left/right, or releasing a shell/Goomba).
    LDA.W SpriteMisc1540,X
    STA.B SpriteTableC2,X
    LDA.B #$0A                                ; \ Sprite status = Kicked; Set thrown status.
    STA.W SpriteStatus,X                      ; /
    LDY.B PlayerDirection
    LDA.W PlayerRidingYoshi
    BEQ +
    INY
    INY
  + LDA.W ShellSpeedX,Y
    STA.B SpriteXSpeed,X                      ; Set X speed to throw the sprite at; take base speed, and add half Mario's speed if moving in the same direction as him.
    EOR.B PlayerXSpeed+1                      ; For whatever reason, if Mario is throwing the item while on Yoshi, the base speed will be faster.
    BMI CODE_01A0A6                           ; (not that you can do that without a glitch...)
    LDA.B PlayerXSpeed+1
    STA.B _0
    ASL.B _0
    ROR A
    CLC
    ADC.W ShellSpeedX,Y
    STA.B SpriteXSpeed,X
CODE_01A0A6:
    LDA.B #$10                                ; Number of frames to disable contact with Mario for when kicking any carryable sprite.
    STA.W SpriteMisc154C,X
    LDA.B #$0C                                ; Show Mario's kicking pose.
    STA.W KickingTimer
    RTS

CODE_01A0B1:
; Scratch RAM usage and output:
; $00 - Mario X position, low
; $01 - Mario X position, high
; $02 - Mario Y position, low
; $03 - Mario Y position, high
    LDY.B #$00                                ; Subroutine to offset a carryable sprite from Mario's position.
    LDA.B PlayerDirection                     ; \ Y = Mario's direction; Get 0 = right, 1 = left.
    BNE +                                     ; |
    INY                                       ; /
  + LDA.W FaceScreenTimer
    BEQ +
    INY
    INY                                       ; Set Y = 2/3 or 3/4 when turning.
    CMP.B #$05
    BCC +
    INY
  + LDA.W YoshiInPipeSetting
    BEQ CODE_01A0CD
    CMP.B #$02
    BEQ CODE_01A0D4
CODE_01A0CD:
    LDA.W PlayerTurningPose                   ; If turning while sliding, going down a vertical pipe, or climbing, set Y = 5.
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
  + LDA.W PlayerXPosNext,Y                    ; \ $00 = Mario's X position; Decide whether to use Mario's position on the next frame,
    STA.B _0                                  ; |; or if on a revolving brown platform, current frame.
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
    STA.B SpriteXPosLow,X                     ; Offset horizontally from Mario.
    LDA.B _1
    ADC.W DATA_019F61,Y
    STA.W SpriteXPosHigh,X
    LDA.B #$0D                                ; Y offset when big.
    LDY.B PlayerIsDucking                     ; \ Branch if ducking
    BNE CODE_01A111                           ; /
    LDY.B Powerup                             ; \ Branch if Mario isn't small; Offset vertically from Mario.
    BNE +                                     ; /
CODE_01A111:
    LDA.B #$0F                                ; Y offset when ducking or small.
  + LDY.W PickUpItemTimer
    BEQ +
    LDA.B #$0F                                ; Y offset when picking up an item.
  + CLC
    ADC.B _2
    STA.B SpriteYPosLow,X
    LDA.B _3
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B #$01
    STA.W IsCarryingItem                      ; Set the flag for carrying an item.
    STA.W CarryingFlag                        ; Set carrying enemy flag
    RTS

StunGoomba:
    LDA.B EffFrame                            ; Stunned Goomba MAIN
    LSR A
    LSR A
    LDY.W SpriteMisc1540,X
    CPY.B #$30                                ; Animate the Goomba.
    BCC +
    LSR A
  + AND.B #$01
    STA.W SpriteMisc1602,X
    CPY.B #$08
    BNE +
    JSR IsOnGround                            ; Make the Goomba hop upwards when the stun timer gets low enough.
    BEQ +
    LDA.B #$D8                                ; Y-speed to give the Goomba.
    STA.B SpriteYSpeed,X
  + LDA.B #$80                                ; Draw an upside-down 16x16 sprite.
    JMP SubSprGfx2Entry0

StunMechaKoopa:
    LDA.B Layer1XPos                          ; Stunned MechaKoopa GFX subroutine.
    PHA
    LDA.W SpriteMisc1540,X
    CMP.B #$30                                ; Shake the MechaKoopa when the stun timer gets low.
    BCS +
    AND.B #$01
    EOR.B Layer1XPos
    STA.B Layer1XPos
  + JSL CODE_03B307                           ; Draw the MechaKoopa.
    PLA
    STA.B Layer1XPos
CODE_01A169:
    LDA.W SpriteStatus,X                      ; \ If sprite status == Carried,; Turn a sprite away from Mario when carried. Used by MechaKoopas, keys, and Baby Yoshi.
    CMP.B #$0B                                ; |
    BNE +                                     ; |; Turn the sprite away from Mario if carried.
    LDA.B PlayerDirection                     ; | Sprite direction = Opposite direction of Mario
    EOR.B #$01                                ; |
    STA.W SpriteMisc157C,X                    ; /
  + RTS

StunFish:
    JSR SetAnimationFrame                     ; Stunned fish GFX subroutine (unused?...)
    LDA.W SpriteOBJAttribute,X
    ORA.B #$80                                ; Flip it upside down.
    STA.W SpriteOBJAttribute,X
    JSR SubSprGfx2Entry1                      ; Draw a 16x16 sprite.
    RTS

CODE_01A187:
    LDA.W SpriteTweakerD,X                    ; \ Branch if sprite changes into a shell; Routine to handle graphics for stunned sprites, as well as basic routines for some sprites.
    AND.B #$08                                ; |; Branch if set to turn into a shell when stunned. Useless since it branches to this anyway.
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
    BEQ StunYoshiEgg                          ; Branch to the corresponding routines for stunned sprites.
    CMP.B #$80
    BEQ StunKey
    CMP.B #$7D                                ; Don't do anything with the balloon.
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
    LDY.W SpriteOAMIndex,X                    ; |; Unused routine for sprite 85. May have originally been a Dry Bones?
    LDA.B #$47                                ; | Set OAM with tile #$47
    STA.W OAMTileNo+$100,Y                    ; /
    RTS

CODE_01A1D0:
    JSR CODE_019806                           ; Carryable shell GFX subroutine (redirect)
Return01A1D3:
    RTS

StunThrowBlock:
; Throwblock misc RAM:
; $C2   - Duplicate of $1540.
; $1540 - Timer for how long the throwblock lasts.
; Also used as a timer for its smoke cloud when it times out. Set to #$20 when it poofs.
; $154C - Timer for disabling interaction with Mario. Set under a few circumstances:
; Set to #$08 when picked up.
; Set to #$10 when dropping or throwing.
; $1558 - Timer for sinking in lava. The throwblock explodes on contact with lava though so this isn't really used.
; $157C - Direction the sprite is facing, though it's never modified by the sprite.
    LDA.W SpriteMisc1540,X                    ; Throwblock GFX subroutine.
    CMP.B #$40
    BCS CODE_01A1DE                           ; Slow down the throwblock's flashing colors if the stun timer is nearly out.
    LSR A
    BCS StunYoshiEgg
CODE_01A1DE:
    LDA.W SpriteOBJAttribute,X
    INC A
    INC A                                     ; Cycle through the palettes.
    AND.B #$0F
    STA.W SpriteOBJAttribute,X
StunYoshiEgg:
; Yoshi egg GFX subroutine (+throwblock).
    JSR SubSprGfx2Entry1                      ; Draw a 16x16 sprite.
    RTS

StunBomb:
; Stunned Bob-omb GFX subroutine.
    JSR SubSprGfx2Entry1                      ; Draw a 16x16 sprite.
    LDA.B #$CA                                ; Tile used for the stunned Bob-omb.
    BRA CODE_01A222

StunKey:
; Key GFX subroutine.
    JSR CODE_01A169                           ; Face away from Mario when carried.
    JSR SubSprGfx2Entry1                      ; Draw a 16x16 sprite.
    LDA.B #$EC                                ; Tile used for the key.
    BRA CODE_01A222

StunPow:
; P-switch misc RAM:
; $151C - P-switch type (0 = blue, 1 = silver)
; $1540 - Timer for the P-switch's smoke cloud. Set to #$20 when it poofs.
; $154C - Timer for disabling interaction with Mario. Set under a few circumstances:
; Set to #$2C when spawned from a block.
; Set to #$08 when picked up.
; Set to #$10 when dropping or throwing.
; Set to #$08 when pressed; will reset to #$08 when it hits zero.
; $157C - Always 1. Setting to 0 will make the switch backwards.
; $15AC - Set to #$0F when the P-switch is spawned from a block.
; $163E - Timer for erasing a pressed P-switch. Set to #$20 when it's pressed.
; Actual P-switch MAIN
    LDY.W SpriteMisc163E,X                    ; Branch if not pressed.
    BEQ CODE_01A218
    CPY.B #$01                                ; Branch if pressed and not disappearing.
    BNE +
    JMP CODE_019ACB                           ; Make it go poof.

; P-switch is pressed.
  + JSR SmushedGfxRt                          ; Draw a smushed P-switch.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileAttr+$100,Y
    AND.B #$FE                                ; Useless. Seems like the P-switch used to use the second GFX page.
    STA.W OAMTileAttr+$100,Y
    RTS

CODE_01A218:
; P-switch is not pressed.
    LDA.B #$01                                ; Face left, always.
    STA.W SpriteMisc157C,X
    JSR SubSprGfx2Entry1                      ; Draw a 16x16 sprite.
    LDA.B #$42                                ; Tile to use for the P-switch.
CODE_01A222:
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    STA.W OAMTileNo+$100,Y
    RTS

StunSpringBoard:
; Stunned springboard GFX subroutine (used on the first frame Mario kicks it).
    JMP CODE_01E6F0                           ; Draw graphics.

StunBabyYoshi:
; Baby Yoshi misc RAM:
; $154C - Timer for disabling interaction with Mario. Set under a few circumstances:
; Set to #$08 when picked up.
; Set to #$10 when dropping, throwing, or kicking.
; $1570 - Counter for how many sprites the baby Yoshi has eaten.
; $157C - Direction the sprite is facing. 00 = right, 01 = left
; $1594 - Affects the value of the 1up spawned from hitting a goal tape; 0 = 1up, 1 = 2up, 2 = 3up (3+ = glitched).
; Not normally possible to set, however, so essentially unused.
; $1602 - Animation frame to use.
; 0 = normal, 1 = eating, 2 = swallowing, 3 = gulping/idle
; $160E - Sprite slot that the baby Yoshi is eating. Set to FF when null.
; $163E - Timer for baby Yoshi eating something. Set to #$38 when starting.
; Baby Yoshi MAIN
    LDA.B SpriteLock                          ; \ Branch if sprites locked; If sprites are frozen, just draw graphics.
    BNE CODE_01A27B                           ; /
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    STA.B _0
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.B _8                                  ; Get the position of Baby Yoshi's mouth.
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$08
    STA.B _1
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _9
    JSL CODE_02B9FA                           ; Process interaction with berries.
    JSL CODE_02EA4E                           ; Process interaction with sprites.
    LDA.W SpriteMisc163E,X                    ; Branch if currently eating something.
    BNE CODE_01A27E
    DEC A
    STA.W SpriteMisc160E,X
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status != Stunned
    CMP.B #$09                                ; |
    BNE +                                     ; /; If the Yoshi is not being carried and is on the ground, make it bounce.
    JSR IsOnGround
    BEQ +
    LDA.B #$F0                                ; Speed the Baby Yoshi bounces at.
    STA.B SpriteYSpeed,X
  + LDY.B #$00
    LDA.B EffFrame
    AND.B #$18
    BNE +                                     ; Handle Baby Yoshi's idle animation.
    LDY.B #$03
  + TYA
    STA.W SpriteMisc1602,X
CODE_01A27B:
    JMP CODE_01A34F

CODE_01A27E:
; Baby Yoshi is in the process of eating something.
    STZ.W SpriteOAMIndex,X                    ; Change OAM index to #$00, to send in front of all other sprites.
    CMP.B #$20                                ; Branch if it's time to actually swallow the sprite.
    BEQ +
    JMP CODE_01A30A

  + LDY.W SpriteMisc160E,X                    ; Subroutine for Baby Yoshi swallowing a sprite.
    LDA.B #$00                                ; \ Clear sprite status; Erase the sprite being eaten.
    STA.W SpriteStatus,Y                      ; /
    LDA.B #!SFX_GULP                          ; SFX for baby Yoshi swallowing.
    STA.W SPCIO0                              ; / Play sound effect
    LDA.W SpriteMisc160E,Y                    ; If the sprite has $160E set (i.e. it's a berry, not a mushroom), don't grow instantly.
    BNE CODE_01A2F4
    LDA.W SpriteNumber,Y                      ; \ Branch if not Changing power up
    CMP.B #$81                                ; |
    BNE +                                     ; /
    LDA.B EffFrame
    LSR A                                     ; If eating sprite 81 (roulette item), get the actual powerup being eaten.
    LSR A                                     ; (no real point in this though?)
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W ChangingItemSprite,Y
  + CMP.B #$74
    BCC CODE_01A2F4                           ; If baby Yoshi eats a powerup, instantly grow. Else, branch.
    CMP.B #$78
    BCS CODE_01A2F4
CODE_01A2B5:
    STZ.W YoshiSwallowTimer                   ; Subroutine to grow an adult Yoshi. Used by both baby Yoshi and eggs.
    STZ.W YoshiHasWingsEvt                    ; No Yoshi wings
    LDA.B #$35                                ; \ Sprite = Yoshi
    STA.W SpriteNumber,X                      ; /; Make a grown Yoshi.
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #!SFX_YOSHI                         ; SFX for Yoshi growing up.
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B SpriteYPosLow,X
    SBC.B #$10
    STA.B SpriteYPosLow,X                     ; Spawn the adult Yoshi a tile higher than the baby Yoshi.
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
    LDA.B #$40                                ; How long Yoshi's growing animation lasts.
    STA.W YoshiGrowingTimer
    RTS

CODE_01A2F4:
    INC.W SpriteMisc1570,X                    ; Baby Yoshi ate something other than a powerup.
    LDA.W SpriteMisc1570,X
    CMP.B #$05                                ; How many sprites baby Yoshi has to eat to grow. Change with $03C0A2 as well.
    BNE CODE_01A300
    BRA CODE_01A2B5                           ; Make him grow up.

CODE_01A300:
; Baby Yoshi is not grown up yet.
    JSL CODE_05B34A                           ; Give Mario a coin.
    LDA.B #$01                                ; How many points Mario gets when baby Yoshi eats something (200).
    JSL GivePoints
CODE_01A30A:
    LDA.W SpriteMisc163E,X
    LSR A
    LSR A
    LSR A                                     ; Pick the animation frame to use.
    TAY
    LDA.W DATA_01A35A,Y
    STA.W SpriteMisc1602,X
    STZ.B _1
    LDA.W SpriteMisc163E,X
    CMP.B #$20                                ; If the sprite Yoshi is eating no longer exists, branch and just draw graphics.
    BCC CODE_01A34F
    SBC.B #$10
    LSR A
    LSR A
    LDY.W SpriteMisc157C,X
    BEQ +
    EOR.B #$FF
    INC A
    DEC.B _1                                  ; Drag the sprite horizontally toward the baby Yoshi.
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
    STA.W SpriteYPosLow,Y                     ; Center the sprite vertically at the baby Yoshi's mouth.
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,Y
CODE_01A34F:
    JSR CODE_01A169                           ; Face away from Mario when carried.
    JSR SubSprGfx2Entry1                      ; Draw a 16x16 sprite.
    JSL CODE_02EA25                           ; Prepare it for DMA upload.
    RTS


DATA_01A35A:
    db $00,$03,$02,$02,$01,$01,$01

DATA_01A361:
    db $10,$20

DATA_01A363:
    db $01,$02

GetDrawInfoBnk1:
; Animation frames for baby Yoshi's eating animation. Indexed by the timer divided by 8.
; Y position offsets to the bottom of a sprite, for checking if offscreen.
; Bits to set in $186C, for each tile of a two-tile sprite.
; Misc RAM returns:
; Y   = OAM index (from $0300)
; $00 = Sprite X position relative to the screen border
; $01 = Sprite Y position relative to the screen border
; Also sets $15A0, $15C4, and $186C.
; GetDrawInfo routine. Gets various GFX-related addresses.
    STZ.W SpriteOffscreenVert,X               ; Initialize offscreen flags.
    STZ.W SpriteOffscreenX,X
    LDA.B SpriteXPosLow,X
    CMP.B Layer1XPos
    LDA.W SpriteXPosHigh,X                    ; Check if offscreen horizontally, and set the flag if so.
    SBC.B Layer1XPos+1
    BEQ +
    INC.W SpriteOffscreenX,X
  + LDA.W SpriteXPosHigh,X
    XBA
    LDA.B SpriteXPosLow,X
    REP #$20                                  ; A->16
    SEC
    SBC.B Layer1XPos
    CLC                                       ; Handle horizontal offscreen flag for 4 tiles offscreen. (-40 to +40)
    ADC.W #$0040                              ; If so, return the sprite's graphical routine.
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
    ADC.W DATA_01A361,Y                       ; Check if vertically offscreen, and set the flag if so.
    PHP                                       ; If the sprite has a two-tile death frame, $186C's bits will be set for each tile.
    CMP.B Layer1YPos                          ; Top tile = bit 0
    ROL.B _0                                  ; Bottom tile = bit 1
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
; Sprite more than 4 tiles offscreen.
    PLA                                       ; Return the sprite's routine (i.e. don't draw).
    PLA
  + LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM; Return sprite onscreen.
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0                                  ; Return onscreen position in $00 and $01, and OAM index in Y.
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    RTS

CODE_01A3DF:
; Check whether tiles being drawn are actually on the screen, and don't draw if not.
    LDA.W SpriteOffscreenVert,X               ; Return if on-screen.
    BEQ Return01A40A
    PHX
    LSR A
    BCC +
    PHA
    LDA.B #$01
    STA.W OAMTileSize+$40,Y
    TYA                                       ; Draw bottom tile if on-screen.
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
    TYA                                       ; Draw top tile if on-screen.
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
; How close sprites need to be vertically to interact with each other.
; The first is for clipping values 00, 10, 20, or 30. The second is for all others.
; Scratch RAM usage:
; $00-$03
; Misc RAM usage:
; $157C - Horizontal direction the sprite is facing, for status 8 (0 = right, 1 = left)
; $15AC - Timer for turning the sprite around, for status 8.
; JSL located at $018032
    TXA                                       ; Sprite-sprite interaction routine.
    BEQ Return01A40A
    TAY                                       ; Return if in slot 0; sprites only interact with slots below them.
    EOR.B TrueFrame                           ; \ Return every other frame; For other slots, alternate processing with sprites each frame.
    LSR A                                     ; |
    BCC Return01A40A                          ; /
    DEX                                       ; Check interaction with the slot below.
CODE_01A417:
    LDA.W SpriteStatus,X                      ; \ Jump to $01A4B0 if; Main loop here.
    CMP.B #$08                                ; | sprite status < 8; Don't process interaction with dead sprites; loop and move to next slot.
    BCS +                                     ; |
    JMP CODE_01A4B0                           ; /

  + LDA.W SpriteTweakerE,X                    ; Checking an alive sprite.
    ORA.W SpriteTweakerE,Y
    AND.B #$08                                ; Skip to the next slot if:
    ORA.W SpriteMisc1564,X                    ; either sprite doesn't interact with other sprites
    ORA.W SpriteMisc1564,Y                    ; either sprite has contact temporarily disabled
    ORA.W SpriteOnYoshiTongue,X               ; the sprite initiating the interaction is being eaten
    ORA.W SpriteBehindScene,X                 ; the sprites are on two different layers (i.e. behind scenery)
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
    REP #$20                                  ; A->16; Move to the next slot if the sprites aren't horizontally within a tile of each other.
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
    INX                                       ; Move to the next slot if the sprites aren't vertically close to each other.
  + LDA.W SpriteYPosLow,Y                     ; Exactly how close they need to be depends on their sprite clipping values.
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
    JSR CODE_01A4BA                           ; Process interaction.
CODE_01A4B0:
    DEX
    BMI +                                     ; Move to next slot and loop. If all slots are done, return.
    JMP CODE_01A417

  + LDX.W CurSpriteProcess                    ; X = Sprite index; Return the routine.
    RTS

CODE_01A4BA:
; Sprites are touching; the below blocks use a series of branches to determine code to run.
    LDA.W SpriteStatus,Y                      ; \ Branch if sprite 2 status == Normal; They're all extremely similar and mainly based on the sprite state (08-0B), so I'll just
    CMP.B #$08                                ; |; include comments for the blocks and not the individual lines.
    BEQ CODE_01A4CE                           ; /
    CMP.B #$09                                ; \ Branch if sprite 2 status == Carryable
    BEQ CODE_01A4E2                           ; /
    CMP.B #$0A                                ; \ Branch if sprite 2 status == Kicked
    BEQ CODE_01A506                           ; /
    CMP.B #$0B                                ; \ Branch if sprite 2 status == Carried
    BEQ CODE_01A51A                           ; /
    RTS

CODE_01A4CE:
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status == Normal; Sprite A is in normal status (08).
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
    LDA.W SpriteBlockedDirs,Y                 ; \ Branch if on ground; Sprite A is in carryable status (09).
    AND.B #$04                                ; |; Branch if on the ground.
    BNE CODE_01A4F2                           ; /
    LDA.W SpriteNumber,Y                      ; \ Branch if Goomba
    CMP.B #$0F                                ; |; Branch if A = sprite 0F (Goomba); else, treat the sprite as thrown.
    BEQ CODE_01A534                           ; /
    BRA CODE_01A506

CODE_01A4F2:
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status == Normal; Sprite A is carryable and on the ground.
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
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status == Normal; Sprite A is in thrown status (0A), or carryable and in the air (and not a Goomba).
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
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status == Normal; Sprite A is in carried status (0B).
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
; And here are the actual jumps all those branches above are leading to.
; Sprite A is thrown (0A) and sprite B is normal (08).
    JMP CODE_01A625                           ; Generally, kills sprite B.

CODE_01A531:
; Sprite A is thrown (0A) and sprite B is carryable (09).
; Kills either sprite B or both sprites, depending on whether B is on the ground.
; Either sprite A or B are being carried (0B), both are thrown (0A), or sprite A is a carryable Goomba (09).
    JMP CODE_01A642                           ; Generally, kills both sprites.

CODE_01A534:
    JMP CODE_01A685

CODE_01A537:
; Sprite A is normal (08) and sprite B is thrown (0A).
    JMP CODE_01A5C4                           ; Generally, kills sprite A.

ADDR_01A53A:
    JMP CODE_01A5C4                           ; Unused. Does the same as above.

CODE_01A53D:
; Both sprites are in normal status (08).
    JMP CODE_01A56D                           ; Bumps the two sprites off each other.

CODE_01A540:
    JSR CODE_01A6D9                           ; Sprite collision: Either sprite is in normal status (08) and the other sprite is carryable (09).
    PHX
    PHY
    TYA
    TXY
    TAX                                       ; Handle Koopas kicking/hopping into the sprite, if applicable.
    JSR CODE_01A6D9                           ; Return if they're already in the process of doing so.
    PLY
    PLX
    LDA.W SpriteMisc1558,X
    ORA.W SpriteMisc1558,Y
    BNE Return01A5C3
CODE_01A555:
    LDA.W SpriteStatus,X
    CMP.B #$09
    BNE CODE_01A56D                           ; If sprite A is the carryable sprite or sprite B is on the ground, just have the two bump off each other.
    JSR IsOnGround
    BNE CODE_01A56D
    LDA.B SpriteNumber,X                      ; \ Branch if not Goomba
    CMP.B #$0F                                ; |
    BNE +                                     ; /; If sprite 0F (Goomba), kill both sprites.
    JMP CODE_01A685                           ; Else, jump to kill just sprite A.

  + JMP CODE_01A5C4

CODE_01A56D:
    LDA.B SpriteXPosLow,X                     ; Just have the two sprites bump off each other.
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
    LDA.B _0                                  ; Turn sprite A around if:
    STA.W SpriteMisc157C,Y                    ; set to change direction when touched ($1686)
    PLA                                       ; it's currently facing toward sprite B
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
    EOR.B #$01                                ; Turn sprite B around if:
    STA.W SpriteMisc157C,X                    ; set to change direction when touched ($1686)
    PLA                                       ; it's currently facing toward sprite A
    CMP.W SpriteMisc157C,X
    BEQ Return01A5C3
    LDA.W SpriteMisc15AC,X
    BNE Return01A5C3
    LDA.B #$08                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
Return01A5C3:
    RTS

CODE_01A5C4:
    LDA.W SpriteNumber,Y                      ; Sprite collision: sprite B thrown into sprite A (kills sprite A in most cases).
    SEC
    SBC.B #$83
    CMP.B #$02
    BCS +
    JSR FlipSpriteDir
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; If sprite A is the flying ? blocks, set misc RAM to mark as hit and clear sprite B's Y speed.
CODE_01A5D3:
    PHX
    TYX
    JSR CODE_01B4E2
    PLX
    RTS

  + LDX.W CurSpriteProcess                    ; X = Sprite index
    LDY.W SpriteInterIndex                    ; Handle blue Koopas catching shells and throwblocks.
    JSR CODE_01A77C
    LDA.B #$02                                ; \ Sprite status = Killed; Kill sprite A.
    STA.W SpriteStatus,Y                      ; /
    PHX
    TYX
    JSL CODE_01AB72                           ; Display a contact graphic.
    PLX
    LDA.B SpriteXSpeed,X
    ASL A
    LDA.B #$10
    BCC +
    LDA.B #$F0                                ; Send sprite B flying upwards and in the direction of sprite A.
  + STA.W SpriteXSpeed,Y
    LDA.B #$D0
    STA.W SpriteYSpeed,Y
    PHY
    INC.W SpriteMisc1626,X
    LDY.W SpriteMisc1626,X
    CPY.B #$08                                ; Get SFX for killing an enemy with a thrown sprite.
    BCS +
    LDA.W StompSFX-1,Y
    STA.W SPCIO0                              ; / Play sound effect
  + TYA
    CMP.B #$08
    BCC +
    LDA.B #$08                                ; Give corresponding points/1up.
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
; SFX for jumping on enemies in a row. Also for hits by a shell and by star power.
    LDA.B SpriteNumber,X                      ; Sprite collision: sprite A thrown into sprite B (kills sprite B in most cases).
    SEC
    SBC.B #$83
    CMP.B #$02
    BCS +
    PHX
    TYX                                       ; If sprite B is the flying ? blocks, set misc RAM to mark as hit and clear sprite A's Y speed.
    JSR FlipSpriteDir
    PLX
    LDA.B #$00
    STA.W SpriteYSpeed,Y
    JSR CODE_01B4E2
    RTS

; Not the flying ? blocks.
  + JSR CODE_01A77C                           ; Handle blue Koopas catching shells and throwblocks.
    BRA +

CODE_01A642:
    JSR IsOnGround                            ; Sprite collision: Sprite A is thrown into a carryable sprite B.
    BNE +                                     ; Kill sprite B if it's on the ground, and both sprites if not.
    JMP CODE_01A685

  + PHX
    LDA.W SpriteMisc1626,Y
    INC A
    STA.W SpriteMisc1626,Y
    LDX.W SpriteMisc1626,Y                    ; Get SFX for killing an enemy with a thrown sprite.
    CPX.B #$08
    BCS +
    %LorW_X(LDA,StompSFX-1)
    STA.W SPCIO0                              ; / Play sound effect
  + TXA
    CMP.B #$08
    BCC +
    LDA.B #$08                                ; Give corresponding points/1up.
  + PLX
    JSL GivePoints
    LDA.B #$02                                ; \ Sprite status = Killed; Kill sprite B.
    STA.W SpriteStatus,X                      ; /
    JSL CODE_01AB72                           ; Display a contact graphic.
    LDA.W SpriteXSpeed,Y
    ASL A
    LDA.B #$10
    BCC +
    LDA.B #$F0                                ; Send sprite B flying upwards and in the direction of sprite A.
  + STA.B SpriteXSpeed,X
    LDA.B #$D0
    STA.B SpriteYSpeed,X
    RTS

CODE_01A685:
; Sprite collision: Either sprite A or B are being carried, both are thrown, or sprite A is a carryable Goomba.
    LDA.B SpriteNumber,X                      ; \ Branch if Flying Question Block; Kills both sprites in most cases.
    CMP.B #$83                                ; |
    BEQ ADDR_01A69A                           ; |
    CMP.B #$84                                ; |
    BEQ ADDR_01A69A                           ; /
    LDA.B #$02                                ; \ Sprite status = Killed; If sprite B is the flying ? blocks, set misc RAM to mark as hit.
    STA.W SpriteStatus,X                      ; /; Else, kill sprite B.
    LDA.B #$D0
    STA.B SpriteYSpeed,X
    BRA +

ADDR_01A69A:
    JSR CODE_01B4E2
  + LDA.W SpriteNumber,Y                      ; \ Branch if Flying Question Block or Key
    CMP.B #$80                                ; |
    BEQ CODE_01A6BB                           ; |
    CMP.B #$83                                ; |
    BEQ ADDR_01A6B8                           ; |; If sprite A is:
    CMP.B #$84                                ; |; sprite 80 (key), do nothing.
    BEQ ADDR_01A6B8                           ; /; sprite 83/84 (flying ? block), set misc RAM to mark as hit.
    LDA.B #$02                                ; \ Sprite status = Killed; anything else: kill sprite A.
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$D0
    STA.W SpriteYSpeed,Y
    BRA CODE_01A6BB

ADDR_01A6B8:
    JSR CODE_01A5D3                           ; Set misc RAM for sprite 83/84.
CODE_01A6BB:
    JSL CODE_01AB6F
    LDA.B #$04                                ; Points to give for killing a sprite with a carryable one.
    JSL GivePoints
    LDA.B SpriteXSpeed,X
    ASL A
    LDA.B #$10
    BCS +
    LDA.B #$F0                                ; Send the two sprites flying away from each other.
  + STA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.W SpriteXSpeed,Y
    RTS


DATA_01A6D7:
    db $30,$D0

CODE_01A6D9:
; X speeds for shells/Goombas/Bob-ombs/etc. after a blue Koopa kicks it. Right, left.
    STY.B _0                                  ; Subroutine to handle one sprite hopping into or kicking the other (Koopas).
    JSR IsOnGround
    BEQ Return01A72D
    LDA.W SpriteBlockedDirs,Y                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Return if:
    BEQ Return01A72D                          ; /; either sprite is not on the ground
    LDA.W SpriteTweakerA,X                    ; \ Return if doesn't kick/hop into shells; the sprite is not set to hop in/kick shells
    AND.B #$40                                ; |; either sprite is already hopping into/kicking a shell
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
; Return if the sprites aren't within half a tile of each other,
  + CLC                                       ; or if the Koopa is walking away from the shell.
    ADC.B #$08
    CMP.B #$10
    BCC Return01A72D
    LDA.W SpriteMisc157C,X
    CMP.B _2
    BNE Return01A72D
    LDA.B SpriteNumber,X                      ; \ Branch if not Blue Shelless
    CMP.B #$02                                ; |; If not sprite 02 (blue Koopa), hop into the shell. Else, kick the shell.
    BNE +                                     ; /
    LDA.B #$20
    STA.W SpriteMisc163E,X
    STA.W SpriteMisc1558,X
    LDA.B #$23                                ; Prepare to kick the sprite; set timers and lock sprite slot for interaction.
    STA.W SpriteMisc1564,X
    TYA
    STA.W SpriteMisc160E,X
    RTS

PlayKickSfx:
; Play kick sound. Exactly what it says on the tin. Also used for sliding into enemies.
    LDA.B #!SFX_KICK                          ; \ Play sound effect; Kick SFX (for shells, footballs, etc.)
    STA.W SPCIO0                              ; /
Return01A72D:
    RTS

  + LDA.W SpriteMisc1540,Y                    ; \ Return if timer is set; Subroutine for a sprite to jump inside a shell (Koopas).
    BNE Return01A777                          ; /
    LDA.W SpriteNumber,Y                      ; \ Return if sprite >= #$0F; Return if:
    CMP.B #$0F                                ; |; The sprite is not a shell.
    BCS Return01A777                          ; /; The shell was killed.
    LDA.W SpriteBlockedDirs,Y                 ; \ Return if not on ground; The shell is no longer on the ground.
    AND.B #$04                                ; |
    BEQ Return01A777                          ; /
    LDA.W SpriteOBJAttribute,Y                ; \ Branch if $15F6,y positive...; Branch if the shell is rightside-up.
    BPL +                                     ; /
    AND.B #$7F                                ; \ ...otherwise make it positive; Turn the shell rightside-up.
    STA.W SpriteOBJAttribute,Y                ; /
    LDA.B #$E0                                ; \ Set upward speed; Y speed to give a shell when flipped rightside-up.
    STA.W SpriteYSpeed,Y                      ; /
    LDA.B #$20                                ; \ $1564,y = #$20; Disable contact for the shell.
    STA.W SpriteMisc1564,Y                    ; /
CODE_01A755:
; Temporarily freeze a Koopa.
    LDA.B #$20                                ; \ C2,x and 1558,x = #$20; How many frames Koopas freeze for after kicking a shell or flipping one over.
    STA.B SpriteTableC2,X                     ; | (These are for the shell sprite)
    STA.W SpriteMisc1558,X                    ; /
    RTS

; Shell is rightside-up; hop inside.
  + LDA.B #$E0                                ; \ Set upward speed; Y speed to give the Koopa when it jumps.
    STA.B SpriteYSpeed,X                      ; /
    LDA.W SpriteInLiquid,X
    CMP.B #$01
    LDA.B #$18
    BCC +                                     ; Set how long to wait before erasing the Koopa. Account for water physics.
    LDA.B #$2C
  + STA.W SpriteMisc1558,X
    TXA
    STA.W SpriteMisc1594,Y                    ; Track sprite slots.
    TYA
    STA.W SpriteMisc1594,X
Return01A777:
    RTS


DATA_01A778:
    db $10,$F0

DATA_01A77A:
    db $00,$FF

CODE_01A77C:
; Low X position distances to shift a shell from a blue Koopa when it's catching one.
; High X position distances to shift a shell from a blue Koopa when it's catching one.
    LDA.B SpriteNumber,X                      ; Subroutine to handle blue Koopas catching shells and throwblocks (and some other sprites, though glitchily).
    CMP.B #$02
    BNE CODE_01A7C2                           ; Return if...
    LDA.W SpriteMisc187B,Y                    ; Sprite A is not a blue Koopa.
    BNE CODE_01A7C2                           ; Sprite B is a disco shell.
    LDA.W SpriteMisc157C,X                    ; The sprites are not moving in opposite directions (or at the very least, facing opposite directions).
    CMP.W SpriteMisc157C,Y
    BEQ CODE_01A7C2
    STY.B _1
    LDY.W SpriteMisc1534,X                    ; Return the sprite interaction routine if the blue Koopa is already being pushed by the shell.
    BNE +
    STZ.W SpriteMisc1528,X
    STZ.W SpriteMisc163E,X
    TAY
    STY.B _0
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_01A778,Y
    LDY.B _1
    STA.W SpriteXPosLow,Y                     ; Move the shell in front of the Koopa.
    LDA.W SpriteXPosHigh,X
    LDY.B _0
    ADC.W DATA_01A77A,Y
    LDY.B _1
    STA.W SpriteXPosHigh,Y
    TYA
    STA.W SpriteMisc160E,X
    LDA.B #$01
    STA.W SpriteMisc1534,X
  + PLA                                       ; Return sprite interaction.
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
; What sprites are spawned when various sprites are bounced off of by Mario, hit by a block, or eaten by Yoshi.
; Unused x8
; 08, 09, 0A, 0B, 0C, unused x3
; 10, 3F, 40
; Scratch RAM usage:
; $00, $01, $0B, $0E, $0F
; Misc RAM input:
; $154C - Disable interaction.
; $187B - If non-zero, gives Mario an X speed when bouncing off the sprite and doesn't kill it (like a Disco Shell).
; Misc RAM output (when using default interaction):
; $1540 - If $1656 bit 6 is set (die when jumped on), timer for a squish animation. Set to #$20 when squished.
; $154C - Set to #$08 if it wasn't already set.
; $157C - If $1686 bit 4 is set (change direction when touched), horizontal direction of the sprite.
; Subroutine to handle interaction between Mario and the sprite in X.
    PHB                                       ; With default interaction disabled, returns carry set if in contact and clear if not.
    PHK                                       ; With default interaction, all routines are handled internally.
    PLB                                       ; (star power, slide-killing, Mario damage, bouncing, carrying, etc.)
    JSR MarioSprInteractRt
    PLB
    RTL                                       ; Also sets $0F/$0E with values from SubHorzPos/SubVertPos.

MarioSprInteractRt:
    LDA.W SpriteTweakerD,X                    ; \ Branch if "Process interaction every frame" is set
    AND.B #$20                                ; |
    BNE ProcessInteract                       ; /
    TXA                                       ; \ Otherwise, return every other frame
    EOR.B TrueFrame                           ; |
    AND.B #$01                                ; |; Return if not a frame in which interaction is processed for the sprite, or the sprite is horizontally offscreen.
    ORA.W SpriteOffscreenX,X                  ; |
    BEQ ProcessInteract                       ; |
  - CLC                                       ; |
    RTS                                       ; /

ProcessInteract:
    JSR SubHorizPos                           ; The actual Mario-sprite interaction routine.
    LDA.B _F
    CLC
    ADC.B #$50
    CMP.B #$A0                                ; Return if Mario is not within a 10x12 space around the sprite.
    BCS -                                     ; No contact, return; (i.e. not within any hitbox whatsoever)
    JSR CODE_01AD42
    LDA.B _E                                  ; That said, this is a single-byte compare, so this space loops each screen anyway.
    CLC                                       ; (thankfully, the CheckForContact makes sure of that anyway).
    ADC.B #$60
    CMP.B #$C0
    BCS -                                     ; No contact, return
CODE_01A80F:
    LDA.B PlayerAnimation                     ; \ If animation sequence activated...
    CMP.B #$01                                ; |; Return if Mario is performing a special animation.
    BCS -                                     ; / ...no contact, return
    LDA.B #$00                                ; \ Branch if bit 6 of $0D9B set?
    BIT.W IRQNMICommand                       ; |
    BVS +                                     ; /
    LDA.W PlayerBehindNet                     ; \ If Mario and Sprite not on same side of scenery...; Return if Mario and the sprite are on different layers.
    EOR.W SpriteBehindScene,X                 ; |
  + BNE ReturnNoContact2                      ; / ...no contact, return
    JSL GetMarioClipping
    JSL GetSpriteClippingA                    ; Return if Mario is not in contact with the sprite.
    JSL CheckForContact
    BCC ReturnNoContact2                      ; No contact, return
    LDA.W SpriteTweakerD,X                    ; \ Branch if sprite uses default Mario interaction
    BPL +                                     ; /; Handle default interaction. Else, return carry set.
    SEC                                       ; Contact, return
    RTS


DATA_01A839:
    db $F0,$10

; X speeds to gives sprites when killed by a star.
  + LDA.W InvinsibilityTimer                  ; \ Branch if Mario doesn't have star; Subroutine to handle default interaction when Mario is actually touching a sprite.
    BEQ CODE_01A87E                           ; /
    LDA.W SpriteTweakerD,X                    ; \ Branch if "Process interaction every frame" is set; Branch if Mario doesn't have star power or the sprite can't be killed by a star.
    AND.B #$02                                ; |
    BNE CODE_01A87E                           ; /
CODE_01A847:
    JSL CODE_01AB6F                           ; Mario is touching a sprite with either star power or sliding into it.
    INC.W StarKillCounter
    LDA.W StarKillCounter
    CMP.B #$08
    BCC +                                     ; Increase kill count and give corresponding points.
    LDA.B #$08
    STA.W StarKillCounter
  + JSL GivePoints
    LDY.W StarKillCounter
    CPY.B #$08
    BCS +                                     ; Get SFX for being hit with star power.
    LDA.W StompSFX-1,Y
    STA.W SPCIO0                              ; / Play sound effect
  + LDA.B #$02                                ; \ Sprite status = Killed; Kill the sprite.
    STA.W SpriteStatus,X                      ; /
    LDA.B #$D0
    STA.B SpriteYSpeed,X
    JSR SubHorizPos                           ; Send flying away from Mario.
    LDA.W DATA_01A839,Y
    STA.B SpriteXSpeed,X
ReturnNoContact2:
    CLC
    RTS

CODE_01A87E:
    STZ.W StarKillCounter                     ; Mario doesn't have star power.
    LDA.W SpriteMisc154C,X
    BNE CODE_01A895                           ; Return if the sprite has player contact disabled.
    LDA.B #$08                                ; Otherwise, prevent extra contact from occuring.
    STA.W SpriteMisc154C,X
    LDA.W SpriteStatus,X
    CMP.B #$09                                ; Branch if not a carryable sprite.
    BNE +
    JSR CODE_01AA42                           ; Handle touching a carryable sprite.
CODE_01A895:
    CLC
    RTS

; Non-carryable sprite.
  + LDA.B #$14                                ; Distance above the sprite that Mario's position must be to be considered on "top" of it.
    STA.B _1                                  ; (increasing this value = smaller safe space)
    LDA.B _5
    SEC
    SBC.B _1
    ROL.B _0
    CMP.B PlayerYPosNow
    PHP
    LSR.B _0
    LDA.B _B
    SBC.B #$00                                ; Branch to CODE_01A8E6 if:
    PLP                                       ; Too low to bounce off the sprite (Y position greater than the sprite's).
    SBC.B PlayerYPosNow+1                     ; Moving upward, the sprite can't be hit while moving upwards,
    BMI CODE_01A8E6                           ; and Mario hasn't hit any other enemies.
    LDA.B PlayerYSpeed+1                      ; Both Mario and the sprite are on the ground.
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
    AND.B #$10                                ; |; If the sprite can be bounced on, branch.
    BNE CODE_01A91C                           ; /
    LDA.W SpinJumpFlag
    ORA.W PlayerRidingYoshi                   ; If not spinjumping or riding Yoshi, branch.
    BEQ CODE_01A8E6
CODE_01A8D8:
    LDA.B #!SFX_SPLAT                         ; SFX for spinjumping off an enemy that can't be bounced on.
    STA.W SPCIO0                              ; / Play sound effect; Also used for bouncing off of disco shells.
    JSL BoostMarioSpeed                       ; Make Mario bounce upwards.
    JSL DisplayContactGfx
    RTS

CODE_01A8E6:
    LDA.W PlayerSlopePose                     ; Hitting an enemy without bouncing off of it.
    BEQ +
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Takes 5 fireballs to kill"...
    AND.B #$04                                ; | ...is set; If sliding and the sprite can be killed by sliding, then kill it and return.
    BNE +                                     ; /
    JSR PlayKickSfx
    JSR CODE_01A847
    RTS

  + LDA.W IFrameTimer                         ; \ Return if Mario is invincible
    BNE Return01A91B                          ; /; If Mario is invulnerable or riding Yoshi, return.
    LDA.W PlayerRidingYoshi
    BNE Return01A91B
    LDA.W SpriteTweakerE,X
    AND.B #$10
    BNE +                                     ; If it changes direction when touched, turn it around.
    JSR SubHorizPos
    TYA
    STA.W SpriteMisc157C,X
  + LDA.B SpriteNumber,X
    CMP.B #$53                                ; If sprite 53 (throwblock), return.
    BEQ Return01A91B
    JSL HurtMario                             ; For everything else, hurt Mario.
Return01A91B:
    RTS

CODE_01A91C:
    LDA.W SpinJumpFlag                        ; Hitting an enemy on top, handle bouncing off.
    ORA.W PlayerRidingYoshi                   ; If not spinjumping or riding Yoshi, branch.
    BEQ CODE_01A947
CODE_01A924:
    JSL DisplayContactGfx
    LDA.B #$F8                                ; Y speed of Mario when stomping an enemy while spinjumping.
    STA.B PlayerYSpeed+1
    LDA.W PlayerRidingYoshi                   ; Get bounce speed based on whether Mario is spinjumping or riding Yoshi.
    BEQ +
    JSL BoostMarioSpeed
  + JSR CODE_019ACB                           ; Turn the sprite into a smoke cloud.
    JSL CODE_07FC3B                           ; Generate the stars from the spinjump.
    JSR CODE_01AB46                           ; Increase bounce counter/give points.
    LDA.B #!SFX_SPINKILL                      ; SFX for spinjumping or Yoshi-stomping an enemy.
    STA.W SPCIO0                              ; / Play sound effect
    JMP CODE_01A9F2                           ; Return, handling Lakitu's cloud if applicable.

CODE_01A947:
; Bouncing off an enemy without spinjumping/riding Yoshi.
    JSR CODE_01A8D8                           ; Set Y speed, display a contact graphic, and set default sound effect (for disco shell).
    LDA.W SpriteMisc187B,X
    BEQ CODE_01A95D                           ; If bouncing on a disco shell (or chuck/etc.), just give Mario some X speed and return.
    JSR SubHorizPos
    LDA.B #$18                                ; X speed to give Mario to the right of a disco shell/Chuck.
    CPY.B #$00
    BEQ +
    LDA.B #$E8                                ; X speed to give Mario to the left of a disco shell/Chuck.
  + STA.B PlayerXSpeed+1
    RTS

CODE_01A95D:
    JSR CODE_01AB46                           ; Increase bounce counter/play SFX/give points.
    LDY.B SpriteNumber,X
    LDA.W SpriteTweakerE,X                    ; Branch if the sprite doesn't spawn a new sprite when bounced on.
    AND.B #$40
    BEQ CODE_01A9BE
    CPY.B #$72
    BCC CODE_01A979
    PHX
    PHY                                       ; Sprite 73 (cape super Koopa): spawn a feather, turn into a normal Koopa.
    JSL CODE_02EAF2                           ; (also sprites 72+)
    PLY
    PLX
    LDA.B #$02                                ; Sprite that the cape super Koopa becomes when bounced on.
    BRA CODE_01A99B

CODE_01A979:
    CPY.B #$6E
    BNE CODE_01A98A
    LDA.B #$02
    STA.B SpriteTableC2,X                     ; Sprite 6E (Dino Rhino): turn into Dino Torch, prepare flame.
    LDA.B #$FF
    STA.W SpriteMisc1540,X
    LDA.B #$6F                                ;DINO TORCH SPRITE NUM; Sprite that Dino Rhino becomes when bounced on.
    BRA CODE_01A99B

CODE_01A98A:
    CPY.B #$3F
    BCC CODE_01A998
    LDA.B #$80                                ; Sprite 3F (para-Goomba) and sprite 40 (para-Bomb): turn into a Goomba/Bob-omb and set stun timer.
    STA.W SpriteMisc1540,X
    LDA.W SpriteToSpawn2-$40,Y                ; Hey, this label might be wrong!
    BRA CODE_01A99B

CODE_01A998:
    LDA.W SpriteToSpawn,Y                     ; Sprites 08-0C (Koopas) and sprite 10 (winged Goomba): turn into respective sprites.
CODE_01A99B:
    STA.B SpriteNumber,X
    LDA.W SpriteOBJAttribute,X
    AND.B #$0E
    STA.B _F
    JSL LoadSpriteTables                      ; Respawn the sprite.
    LDA.W SpriteOBJAttribute,X
    AND.B #$F1
    ORA.B _F
    STA.W SpriteOBJAttribute,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.B SpriteNumber,X
    CMP.B #$02                                ; Unused?
    BNE +                                     ; Sets the "walked off ledge" flag for the Blue Koopa.
    INC.W SpriteMisc151C,X
  + RTS

CODE_01A9BE:
    LDA.B SpriteNumber,X                      ; Does not spawn a new sprite when bounced on.
    SEC
    SBC.B #$04
    CMP.B #$0D
    BCS CODE_01A9CC
    LDA.W FlightPhase
    BNE CODE_01A9D3
CODE_01A9CC:
; If the sprite is set to die when jumped on,
    LDA.W SpriteTweakerA,X                    ; \ Branch if doesn't die when jumped on; or if sprite 04-10 and Mario flies into it,
    AND.B #$20                                ; |; then squish the sprite.
    BEQ +                                     ; /; Else, branch.
CODE_01A9D3:
    LDA.B #$03                                ; \ Sprite status = Smushed
    STA.W SpriteStatus,X                      ; /
    LDA.B #$20
    STA.W SpriteMisc1540,X
    STZ.B SpriteXSpeed,X                      ; \ Sprite Speed = 0
    STZ.B SpriteYSpeed,X                      ; /
    RTS

  + LDA.W SpriteTweakerB,X                    ; \ Branch if Tweaker bit...; Sprite is not set to squish when killed.
    AND.B #$80                                ; | ..."Falls straight down when killed"...
    BEQ CODE_01AA01                           ; / ...is NOT set.; If set to fall down when killed, set the sprite status. Else, branch.
    LDA.B #$02                                ; \ Sprite status = Falling off screen
    STA.W SpriteStatus,X                      ; /
    STZ.B SpriteXSpeed,X                      ; \ Sprite Speed = 0
    STZ.B SpriteYSpeed,X                      ; /
CODE_01A9F2:
    LDA.B SpriteNumber,X                      ; \ Return if NOT Lakitu
    CMP.B #$1E                                ; |
    BNE +                                     ; /; If killing sprite 1E (Lakitu), erase its cloud too.
    LDY.W LakituCloudSlot
    LDA.B #$1F
    STA.W SpriteMisc1540,Y
  + RTS

CODE_01AA01:
    LDY.W SpriteStatus,X                      ; Sprite is not set to fall straight down when killed.
    STZ.W SpriteMisc1626,X
    CPY.B #$08
    BEQ SetStunnedTimer                       ; Set the sprite as stationary/carryable.
CODE_01AA0B:
    LDA.B SpriteTableC2,X                     ; If $C2 is non-zero or the sprite is coming from status 08, then also set the stun timer.
    BNE SetStunnedTimer
    STZ.W SpriteMisc1540,X
    BRA SetAsStunned

SetStunnedTimer:
    LDA.B #$02                                ; \
    LDY.B SpriteNumber,X                      ; |
    CPY.B #$0F                                ; | Set stunnned timer with:; Set the stun timer to #$FF if...
    BEQ CODE_01AA28                           ; |; sprite 0D (Bob-omb)
    CPY.B #$11                                ; | #$FF for Goomba, Buzzy Beetle, Mechakoopa, or Bob-omb...; sprite 0F (Goomba)
    BEQ CODE_01AA28                           ; | #$02 for others; sprite 11 (Buzzy Beetle)
    CPY.B #$A2                                ; |; sprite A2 (MechaKoopa)
    BEQ CODE_01AA28                           ; |; For any other sprites, set it to #$02.
    CPY.B #$0D                                ; |
    BNE +                                     ; |
CODE_01AA28:
    LDA.B #$FF                                ; |; How long to stun the four above sprites for when kicked/hit.
  + STA.W SpriteMisc1540,X                    ; /
SetAsStunned:
    LDA.B #$09                                ; \ Status = stunned; Change to stationary/carryable status.
    STA.W SpriteStatus,X                      ; /
    RTS

BoostMarioSpeed:
; Routine to handle Mario's speed from bouncing off of an enemy.
    LDA.B PlayerIsClimbing                    ; \ Return if climbing; If climbing, don't bounce.
    BNE Return01AA41                          ; /
    LDA.B #$D0                                ; Speed Mario bounces off of an enemy without A being pressed.
    BIT.B byetudlrHold
    BPL +
    LDA.B #$A8                                ; Speed Mario bounces off of an enemy with A pressed.
  + STA.B PlayerYSpeed+1
Return01AA41:
    RTL

CODE_01AA42:
    LDA.W SpinJumpFlag                        ; Subroutine to handle Mario touching a carryable sprite.
    ORA.W PlayerRidingYoshi
    BEQ +                                     ; If...
    LDA.B PlayerYSpeed+1                      ; Mario is spinjumping or on Yoshi
    BMI +                                     ; Mario is moving downwards
    LDA.W SpriteTweakerA,X                    ; \ Branch if can't be jumped on; the sprite can be jumped on
    AND.B #$10                                ; |; Then kill the sprite in a cloud of smoke and return. (i.e, shells, goombas, etc.)
    BEQ +                                     ; /
    JMP CODE_01A924

  + %WorB(LDA,byetudlrHold)
    AND.B #$40
    BEQ +
    LDA.W CarryingFlag                        ; \ Branch if carrying an enemy...; If...
    ORA.W PlayerRidingYoshi                   ; | ...or on Yoshi; X and Y are held
    BNE +                                     ; /; Mario is not carrying something or riding Yoshi
    LDA.B #$0B                                ; \ Sprite status = Being carried; Then have Mario pick up the sprite and return.
    STA.W SpriteStatus,X                      ; /
    INC.W CarryingFlag                        ; Set carrying enemy flag
    LDA.B #$08
    STA.W PickUpItemTimer
    RTS

  + LDA.B SpriteNumber,X                      ; \ Branch if Key
    CMP.B #$80                                ; |; What do do when carryable sprites are touched by Mario.
    BEQ CODE_01AAB7                           ; /
    CMP.B #$3E                                ; \ Branch if P Switch; If:
    BEQ CODE_01AAB2                           ; /; sprite 0D (Bob-Omb): kick it
    CMP.B #$0D                                ; \ Branch if Bobomb; sprite 0F (Goomba): kick it, upwards slightly.
    BEQ CODE_01AA97                           ; /; sprite 2D (baby Yoshi): kick it
    CMP.B #$2D                                ; \ Branch if Baby Yoshi; sprite 3E (P-switch): make solid, handle pressing
    BEQ CODE_01AA97                           ; /; sprite 80 (key): make solid
    CMP.B #$A2                                ; \ Branch if MechaKoopa; sprite A2 (MechaKoopa): kick it
    BEQ CODE_01AA97                           ; /; others (shells): kick it and give points
    CMP.B #$0F                                ; \ Branch if not Goomba
    BNE CODE_01AA94                           ; /
    LDA.B #$F0
    STA.B SpriteYSpeed,X
    BRA CODE_01AA97

CODE_01AA94:
; Touching any other sprites (i.e. shells).
    JSR CODE_01AB46                           ; Give points.
CODE_01AA97:
    JSR PlayKickSfx                           ; Touching a Bob-Omb, Baby Yoshi, Goomba, or MechaKoopa.
    LDA.W SpriteMisc1540,X
    STA.B SpriteTableC2,X
    LDA.B #$0A                                ; \ Sprite status = Kicked; Set kicked status.
    STA.W SpriteStatus,X                      ; /
    LDA.B #$10                                ; Disable contact with Mario for 16 frames.
    STA.W SpriteMisc154C,X
    JSR SubHorizPos
    LDA.W ShellSpeedX,Y                       ; Set the sprite's X speed.
    STA.B SpriteXSpeed,X
    RTS

CODE_01AAB2:
; Touching a P-switch.
    LDA.W SpriteMisc163E,X                    ; Return no contact if pressed.
    BNE Return01AB2C
CODE_01AAB7:
; Touching a key.
    STZ.W SpriteMisc154C,X                    ; (useless)
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B PlayerYPosNow                       ; If Mario's touching the bottom 8 pixels of the key, then he's hitting the side and should be pushed out (branch).
    CLC                                       ; If he's any higher, then he's hitting the top and should be pushed up (branch).
    ADC.B #$08                                ; Otherwise, just his head is inside and he should be pushed down.
    CMP.B #$20
    BCC CODE_01AB31
    BPL +
    LDA.B #$10                                ; Y speed to give Mario if his head is inside.
    STA.B PlayerYSpeed+1
    RTS

; Hitting the top of the key/P-switch.
  + LDA.B PlayerYSpeed+1                      ; Return if moving upwards.
    BMI Return01AB2C
    STZ.B PlayerYSpeed+1
    STZ.B PlayerInAir                         ; Set Mario to be standing on top of a solid sprite.
    INC.W StandOnSolidSprite
    LDA.B #$1F
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$2F
  + STA.B _0                                  ; Push Mario on top of the sprite.
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _0
    STA.B PlayerYPosNext
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B PlayerYPosNext+1
    LDA.B SpriteNumber,X
    CMP.B #$3E                                ; Return the key. Below code is for pressing P-switches only.
    BNE Return01AB2C
    ASL.W SpriteTweakerD,X                    ; Disable default Mario interaction for the switch.
    LSR.W SpriteTweakerD,X
    LDA.B #!SFX_SWITCH                        ; SFX for pressing a P-switch.
    STA.W SPCIO0                              ; / Play sound effect
    LDA.W MusicBackup                         ; Don't change the music if it's already changed.
    BMI +
    LDA.B #!BGM_PSWITCH                       ; SFX for the P-switch music.
    STA.W SPCIO2                              ; / Change music
  + LDA.B #$20                                ; Set the P-switch to erase itself.
    STA.W SpriteMisc163E,X
    LSR.W SpriteOBJAttribute,X                ; Useless, unless you move the switch to GFX page 1.
    ASL.W SpriteOBJAttribute,X
    LDY.W SpriteMisc151C,X
    LDA.B #$B0                                ; How long the blue/silver P-switches last.
    STA.W BluePSwitchTimer,Y
    LDA.B #$20                                ; \ Set ground shake timer; How long Layer 1 shakes after hitting the switch.
    STA.W ScreenShakeTimer                    ; /
    CPY.B #$01
    BNE Return01AB2C                          ; If hitting a silver P-switch, turn all sprites into coins too.
    JSL CODE_02B9BD
Return01AB2C:
    RTS


DATA_01AB2D:
    db $01,$00,$FF,$FF

CODE_01AB31:
; How quickly to push Mario to either side of the key/P-switch.
; Hitting the side of the key/P-switch.
    STZ.B PlayerXSpeed+1                      ; Clear Mario's X speed.
    JSR SubHorizPos
    TYA
    ASL A
    TAY
    REP #$20                                  ; A->16; Push Mario to the side of the sprite.
    LDA.B PlayerXPosNext
    CLC
    ADC.W DATA_01AB2D,Y
    STA.B PlayerXPosNext
    SEP #$20                                  ; A->8
    RTS

CODE_01AB46:
    PHY                                       ; Subroutine to get bounce sound effect and give points. Also used when bump-kicking shells.
    LDA.W SpriteStompCounter
    CLC
    ADC.W SpriteMisc1626,X
    INC.W SpriteStompCounter
    TAY                                       ; Increase Mario's bounce counter and get bounce SFX.
    INY
    CPY.B #$08
    BCS +
    LDA.W StompSFX-1,Y
    STA.W SPCIO0                              ; / Play sound effect
  + TYA
    CMP.B #$08
    BCC +
    LDA.B #$08                                ; Give points.
  + JSL GivePoints
    PLY
    RTS


    db $0C,$FC,$EC,$DC,$CC

CODE_01AB6F:
; Unused?
    JSR PlayKickSfx                           ; Subroutine to display the "hit" graphic at a sprite's position.
CODE_01AB72:
    JSR IsSprOffScreen                        ; Return if offscreen.
    BNE Return01AB98
    PHY
    LDY.B #$03
CODE_01AB7A:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_01AB83                           ; Find an empty smoke sprite slot.
    DEY
    BPL CODE_01AB7A
    INY
CODE_01AB83:
    LDA.B #$02                                ; Smoke sprite to display (contact graphic).
    STA.W SmokeSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SmokeSpriteXPos,Y                   ; Spawn the smoke at the sprite's position.
    LDA.B SpriteYPosLow,X
    STA.W SmokeSpriteYPos,Y
    LDA.B #$08                                ; How many frames the graphics lasts.
    STA.W SmokeSpriteTimer,Y
    PLY
Return01AB98:
    RTL

DisplayContactGfx:
    JSR IsSprOffScreen                        ; Subroutine to display the "hit" graphic at Mario's position.
    BNE Return01ABCB
    PHY
    LDY.B #$03
CODE_01ABA1:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_01ABAA                           ; Find an empty smoke sprite slot.
    DEY
    BPL CODE_01ABA1
    INY
CODE_01ABAA:
    LDA.B #$02                                ; Smoke sprite to display (contact graphic).
    STA.W SmokeSpriteNumber,Y
    LDA.B PlayerXPosNext                      ; Store player x position to the smoke sprite's.
    STA.W SmokeSpriteXPos,Y
    LDA.W PlayerRidingYoshi
    CMP.B #$01
    LDA.B #$14                                ; Distance to offset the contact graphic from Mario when riding Yoshi.
    BCC +
    LDA.B #$1E                                ; Distance to offset the contact graphic from Mario normally.
  + CLC
    ADC.B PlayerYPosNext
    STA.W SmokeSpriteYPos,Y
    LDA.B #$08                                ; How many frames the graphic lasts.
    STA.W SmokeSpriteTimer,Y
    PLY
Return01ABCB:
    RTL

SubSprXPosNoGrvty:
    TXA                                       ; Routine to update a sprite's X position using its current speed. JSL at $018022.
    CLC
    ADC.B #$0C                                ; All this really does is run the routine below with a modified index.
    TAX
    JSR SubSprYPosNoGrvty
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

SubSprYPosNoGrvty:
; Routine to update a sprite's Y position using its current speed (also used for X). JSL at $01801A.
    LDA.B SpriteYSpeed,X                      ; Load current sprite's Y speed; Return if speed is 0.
    BEQ CODE_01AC09                           ; If speed is 0, branch to $AC09
    ASL A                                     ; \
    ASL A                                     ; |Multiply speed by 16
    ASL A                                     ; |
    ASL A                                     ; /; Update fraction bits.
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
    ORA.B #$F0                                ; Update the actual position.
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
    STA.W SpriteXMovement                     ; Keep track of how far the sprite has moved.
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
; Low bytes of the vertical offscreen processing distances.
; High bytes of the vertical offscreen processing distances.
; Low bytes of the horizontal offscreen processing distances.
; High bytes of the horizontal offscreen processing distances.
    LDA.B #$06                                ; \ Entry point of routine determines value of $03; SubOffscreenX3 routine. Processes sprites offscreen from -$70 to +$60 ($0160,$FF90).
    STA.B _3                                  ; |
    BRA +                                     ; |

SubOffscreen2Bnk1:
    LDA.B #$04                                ; |; SubOffscreenX2 routine. Processes sprites offscreen from -$10 to +$A0 ($01A0,$FFF0).
    BRA +                                     ; |

SubOffscreen1Bnk1:
    LDA.B #$02                                ; |; SubOffscreenX1 routine. Processes sprites offscreen from -$40 to +$A0 ($01A0,$FFC0).
  + STA.B _3                                  ; |
    BRA +                                     ; |

SubOffscreen0Bnk1:
    STZ.B _3                                  ; /; SubOffscreenX0 routine. Processes sprites offscreen from -$40 to +$30 ($0130,$FFC0).
  + JSR IsSprOffScreen                        ; \ if sprite is not off screen, return; Return if not offscreen.
    BEQ Return01ACA4                          ; /
    LDA.B ScreenMode                          ; \  vertical level
    AND.B #!ScrMode_Layer1Vert                ; |; Branch if in a vertical level.
    BNE VerticalLevel                         ; /
    LDA.B SpriteYPosLow,X                     ; \
    CLC                                       ; |
    ADC.B #$50                                ; | if the sprite has gone off the bottom of the level...; Erase the sprite if below the level.
    LDA.W SpriteYPosHigh,X                    ; | (if adding 0x50 to the sprite y position would make the high byte >= 2)
    ADC.B #$00                                ; |
    CMP.B #$02                                ; |
    BPL OffScrEraseSprite                     ; /    ...erase the sprite
    LDA.W SpriteTweakerD,X                    ; \ if "process offscreen" flag is set, return
    AND.B #$04                                ; |; Return if set to process offscreen.
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
    CMP.B SpriteXPosLow,X                     ; Check if within the horizontal bounds specified by the routine call. Alternates sides each frame.
    PHP                                       ; If it is within the bounds (i.e. onscreen), return.
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
    LDA.B SpriteNumber,X                      ; \ If MagiKoopa...; Subroutine to erase a sprite when offscreen.
    CMP.B #$1F                                ; |
    BNE +                                     ; | Sprite to respawn = MagiKoopa; If sprite 1F (MagiKoopa), just make
    STA.W SpriteRespawnNumber                 ; |; it look for a new position again.
    LDA.B #$FF                                ; | Set timer until respawn
    STA.W SpriteRespawnTimer                  ; /
  + LDA.W SpriteStatus,X                      ; \ If sprite status < 8, permanently erase sprite
    CMP.B #$08                                ; |
    BCC +                                     ; /
    LDY.W SpriteLoadIndex,X                   ; \ Branch if should permanently erase sprite
    CPY.B #$FF                                ; |; Erase the sprite.
    BEQ +                                     ; /; If it wasn't killed, set it to respawn.
    LDA.B #$00                                ; \ Allow sprite to be reloaded by level loading routine
    STA.W SpriteLoadStatus,Y                  ; /
  + STZ.W SpriteStatus,X                      ; Erase sprite
Return01ACA4:
    RTS

VerticalLevel:
    LDA.W SpriteTweakerD,X                    ; \ If "process offscreen" flag is set, return; Offscreen routine for a vertical level.
    AND.B #$04                                ; |; Return if set to process offscreen.
    BNE Return01ACA4                          ; /
    LDA.B TrueFrame                           ; \ Return every other frame
    LSR A                                     ; |; Process every other frame.
    BCS Return01ACA4                          ; /
    LDA.B SpriteXPosLow,X                     ; \
    CMP.B #$00                                ; | If the sprite has gone off the side of the level...
    LDA.W SpriteXPosHigh,X                    ; |; Erase the sprite if off either side of the level.
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
    LDA.B Layer1YPos                          ; Check if within the vertical bounds of the screen. Alternates sides each frame.
    CLC                                       ; If it is within the bounds (i.e. onscreen), return.
    ADC.W SpriteOffScreen1,Y
    ROL.B _0                                  ; Sprite 22 and sprite 24 (green net Koopas) will not despawn off the top of the screen.
    CMP.B SpriteYPosLow,X                     ; (was probably intended to sprite 23 instead of 24)
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
    PHY                                       ; Random number generation routine. Outputs in $148C/$148D (returns $148C)
    LDY.B #$01
    JSL CODE_01AD07                           ; Run RNG for high byte.
    DEY
    JSL CODE_01AD07                           ; Run RNG for low byte.
    PLY
    RTL

CODE_01AD07:
    LDA.W RNGCalc
    ASL A
    ASL A                                     ; With a = $148B:
    SEC                                       ; a = 5a + 1;
    ADC.W RNGCalc
    STA.W RNGCalc
    ASL.W RNGCalc+1
    LDA.B #$20
    BIT.W RNGCalc+1                           ; With b = $148C:
    BCC CODE_01AD21                           ; if (b.4 == b.7) {
    BEQ CODE_01AD26                           ; b = 2b + 1;
    BNE CODE_01AD23                           ; } else {
CODE_01AD21:
; b = 2b;
    BNE CODE_01AD26                           ; }
CODE_01AD23:
    INC.W RNGCalc+1
CODE_01AD26:
    LDA.W RNGCalc+1
    EOR.W RNGCalc                             ; Invert byte b with byte a and output the result.
    STA.W RandomNumber,Y
    RTL

SubHorizPos:
; Equivalent routine in bank 2 at $02848D, bank 3 at $03B817.
; Curiously, this one uses $D1, while the others use $94.
; Subroutine to check horizontal proximity of Mario to a sprite.
    LDY.B #$00                                ; Returns the side in Y (0 = right) and distance in $0F.
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
; Equivalent routine in bank 2 at $02D50C, and bank 3 at $03B829.
; Subroutine to check vertical proximity of Mario to a sprite.
    LDY.B #$00                                ; Returns the side in Y (0 = below) and distance in $0E.
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
    LSR A                                     ; Flying question block INIT
    LSR A                                     ; Preserve spawn X position %4 for deciding what sprite to contain.
    LSR A
    AND.B #$03
    STA.W SpriteMisc151C,X
    INC.W SpriteMisc157C,X                    ; Set the sprite to face left.
    RTS


DATA_01AD68:
    db $FF,$01

DATA_01AD6A:
    db $F4,$0C

DATA_01AD6C:
    db $F0,$10

Flying_Block:
; X/Y speed accelerations for the flying ? block.
; Maximum Y speeds for the flying ? block.
; Maximum X speeds for the flying ? block.
; Flying Question Block misc RAM:
; $C2   - Indicator that the block has been hit. When 1, it bounces up, and when 2, it comes back down.
; $151C - Which item to spawn when hit (coin, fireflower, feather, 1up). When small, an additional 4 gets added to this.
; $1528 - How many pixels the sprite has moved horizontally in the frame.
; $1534 - Direction of horizontal acceleration. Even = left, odd = right
; $1558 - Set to #$10 when hit for the first time. (bounce animation timer)
; $1564 - Set to #$10 when hit.
; $1570 - Frame counter for animation.
; $157C - Horizontal direction the sprite is facing. Always set to 1.
; $1594 - Direction of acceleration. Even = up, odd = down.
; $163E - Timer for a sprite rising out of the block. Set to #$50 when the sprite is spawned.
    LDA.W SpriteMisc163E,X                    ; Flying question block MAIN
    BEQ +                                     ; Change OAM index if necessary.
    STZ.W SpriteOAMIndex,X                    ; While spawning something, it becomes either #$04 (no Yoshi) or #$00 (with Yoshi).
    LDA.W PlayerRidingYoshi                   ; (because Yoshi uses #$04 while turning)
    BNE +                                     ; However, this causes glitches with multiple blocks, or turning with an item.
    LDA.B #$04
    STA.W SpriteOAMIndex,X
  + JSR SubSprGfx2Entry1                      ; Draw a 16x16 sprite.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileYPos+$100,Y
    DEC A                                     ; Shift the sprite one tile up.
    STA.W OAMTileYPos+$100,Y
    STZ.W SpriteMisc1528,X
    LDA.B SpriteTableC2,X                     ; Don't move or draw wings if the block has been hit.
    BNE CODE_01ADF8
    JSR CODE_019E95                           ; Draw wings.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Don't move if the game is frozen.
    BNE CODE_01ADF8                           ; /
    LDA.B TrueFrame
    AND.B #$01                                ; Only change Y speed every other frame.
    BNE +
    LDA.W SpriteMisc1594,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC                                       ; Handle Y speed acceleration.
    ADC.W DATA_01AD68,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_01AD6A,Y
    BNE +
    INC.W SpriteMisc1594,X
  + JSR SubSprYPosNoGrvty                     ; Update Y position.
    LDA.B SpriteNumber,X
    CMP.B #$83                                ; Branch if not sprite 84.
    BEQ CODE_01ADE8
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B TrueFrame                           ; Only change X speed every frame frame, and don't update for a brief time at max speed.
    AND.B #$03
    BNE +
    LDA.W SpriteMisc1534,X
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CLC                                       ; Handle X speed acceleration.
    ADC.W DATA_01AD68,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_01AD6C,Y
    BNE +
    INC.W SpriteMisc1534,X
    LDA.B #$20                                ; How long to fly at max speed for.
    STA.W SpriteMisc1540,X
  + BRA +

CODE_01ADE8:
    LDA.B #$F4                                ; Sprite 83: move left at a constant rate.
    STA.B SpriteXSpeed,X
  + JSR SubSprXPosNoGrvty                     ; Update X position.
    LDA.W SpriteXMovement                     ; Preserve how many pixels the block has moved.
    STA.W SpriteMisc1528,X
    INC.W SpriteMisc1570,X                    ; Handle animation timer.
CODE_01ADF8:
    JSR SubSprSprInteract                     ; Process interaciton with other sprites.
    JSR CODE_01B457                           ; Make the block solid.
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LDA.W SpriteMisc1558,X
    CMP.B #$08
    BNE CODE_01AE5E                           ; Branch if the block is not exactly halfway through the hit animation.
    LDY.B SpriteTableC2,X
    CPY.B #$02
    BEQ CODE_01AE5E
    PHA
    INC.B SpriteTableC2,X
    LDA.B #$50                                ; Set the sprite spawn timer.
    STA.W SpriteMisc163E,X
    LDA.B SpriteXPosLow,X
    STA.B TouchBlockXPos
    LDA.W SpriteXPosHigh,X
    STA.B TouchBlockXPos+1                    ; Set the sprite to spawn at the ? block's position.
    LDA.B SpriteYPosLow,X
    STA.B TouchBlockYPos
    LDA.W SpriteYPosHigh,X
    STA.B TouchBlockYPos+1
    LDA.B #$FF                                ; \ Set to permanently erase sprite; Prevent the ? block from respawning.
    STA.W SpriteLoadIndex,X                   ; /
    LDY.W SpriteMisc151C,X
    LDA.B Powerup
    BNE +
    INY                                       ; If Mario doesn't have a powerup, increase index by 4.
    INY
    INY
    INY
  + LDA.W DATA_01AE88,Y                       ; Get index for the sprite to spawn from the block.
    STA.B _5
    PHB
    LDA.B #$02
    PHA
    PLB                                       ; Spawn the sprite.
    PHX
    JSL CODE_02887D
    PLX
    LDY.W TileGenerateTrackA                  ; Prevent the powerup from appearing behind FG objects while rising.
    LDA.B #$01                                ; Note: if the block is spawning a coin, this causes glitches because $185E is uninitialized!
    STA.W SpriteMisc1528,Y
    LDA.W SpriteNumber,Y
    CMP.B #$75
    BNE +                                     ; If spawning the fireflower, set it to stay still on top of the sprite.
    LDA.B #$FF
    STA.W SpriteTableC2,Y
  + PLB
    PLA
CODE_01AE5E:
    LSR A
    TAY
    LDA.W DATA_01AE7F,Y
    STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM; Handle the bounce animation for the block when hit.
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B _0
    STA.W OAMTileYPos+$100,Y
    LDA.B SpriteTableC2,X
    CMP.B #$01
    LDA.B #$2A                                ; Tile to use for the block normally (? block).
    BCC +
    LDA.B #$2E                                ; Tile to use when the block is hit (brown block).
  + STA.W OAMTileNo+$100,Y
    RTS


DATA_01AE7F:
    db $00,$03,$05,$07,$08,$08,$07,$05
    db $03

DATA_01AE88:
    db $06,$02,$04,$05,$06,$01,$01,$05

Return01AE90:
; How much to shift the flying ? block each frame of its bounce animation.
; Sprites for the flying ? block to spawn, corresponding to $0288A3.
; If Mario is big
; If Mario is small
    RTS                                       ; Flat switch palace switch INIT

PalaceSwitch:
    JSL CODE_02CD2D                           ; Flat switch palace switch redirect
    RTS

InitThwomp:
; Thwomp INIT
    LDA.B SpriteYPosLow,X                     ; Preserve spawn Y position.
    STA.W SpriteMisc151C,X
    LDA.B SpriteXPosLow,X
    CLC                                       ; Offset X position.
    ADC.B #$08
    STA.B SpriteXPosLow,X
Return01AEA2:
    RTS

Thwomp:
; Thwomp misc RAM:
; $C2   - Current phase. 00 = waiting, 01 = falling, 02 = on ground/rising
; $151C - Height to rise up until. No high byte exists.
; $1528 - Animation frame for the Thwomp's face.
; 0 = normal, 1 = glaring, 2 = angry
; $1540 - Timer after smashing the ground to wait before rising up again.
; $154C - Timer for disabling contact with Mario. Set to #$08 when touched.
; $157C - Which side of the Thwomp that Mario is on. Only set while waiting for Mario to come close.
; Thwomp MAIN
    JSR ThwompGfx                             ; Draw graphics.
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return01AEA2                          ; Return if dying or the game is frozen.
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01AEA2                          ; /
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR MarioSprInteractRt
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_01AEC3
    dw CODE_01AEFA
    dw CODE_01AF24

CODE_01AEC3:
; Pointers to the different phases of the Thwomp.
; 00 - Waiting for Mario
; 01 - Falling
; 02 - On ground/rising
; Thwomp phase 0 - waiting for Mario
    LDA.W SpriteOffscreenVert,X               ; Make the Thwomp always fall if vertically offscreen.
    BNE CODE_01AEEE
    LDA.W SpriteOffscreenX,X                  ; Never fall if offscreen horizontally.
    BNE Return01AEF9
    JSR SubHorizPos
    TYA                                       ; Keep track of which side Mario is on.
    STA.W SpriteMisc157C,X
    STZ.W SpriteMisc1528,X
    LDA.B _F                                  ; Handle the animation frame.
    CLC
    ADC.B #$40                                ; Range around the sprite that Mario has to be for the Thwomp to glare at him.
    CMP.B #$80
    BCS +
    LDA.B #$01                                ; Animation frame to use when Mario is close to the Thwomp.
    STA.W SpriteMisc1528,X
  + LDA.B _F                                  ; Check if Mario is close enough to drop.
    CLC
    ADC.B #$24                                ; Range around the Thwomp that Mario has to be for it to fall.
    CMP.B #$50
    BCS Return01AEF9
CODE_01AEEE:
    LDA.B #$02                                ; Animation frame to use when the Thwomp is falling.
    STA.W SpriteMisc1528,X
    INC.B SpriteTableC2,X                     ; Set the sprite to start falling.
    LDA.B #$00
    STA.B SpriteYSpeed,X
Return01AEF9:
    RTS

CODE_01AEFA:
    JSR SubSprYPosNoGrvty                     ; Thwomp phase 1 - falling
    LDA.B SpriteYSpeed,X
    CMP.B #$3E                                ; Max falling speed for the Thwomp.
    BCS +
    ADC.B #$04                                ; Acceleration of the Thwomp.
    STA.B SpriteYSpeed,X
  + JSR CODE_019140
    JSR IsOnGround                            ; If the thwomp hasn't hit a block, return.
    BEQ +
    JSR SetSomeYSpeed__                       ; Set ground Y speed.
    LDA.B #$18                                ; \ Set ground shake timer; Time to shake the screen.
    STA.W ScreenShakeTimer                    ; /
    LDA.B #!SFX_KAPOW                         ; SFX for the Thwomp hitting the ground.
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B #$40                                ; How long to wait on the ground.
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + RTS

CODE_01AF24:
; Thwomp phase 2 - on ground/rising
    LDA.W SpriteMisc1540,X                    ; Return if waiting on the ground.
    BNE Return01AF3F
    STZ.W SpriteMisc1528,X
    LDA.B SpriteYPosLow,X
    CMP.W SpriteMisc151C,X
    BNE +                                     ; If the Thwomp reaches its spawn height, return to phase 0.
    LDA.B #$00
    STA.B SpriteTableC2,X
    RTS

  + LDA.B #$F0                                ; Speed to rise up at.
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
; X position offsets for each of the Thwomp's tiles.
; Fifth byte is used only when the Thwomp isn't using its normal expression. Same for the below.
; Y position offsets for each of the Thwomp's tiles.
; Tile numbers for the Thwomp.
; YXPPCCCT for each of the Thwomp's tiles.
    JSR GetDrawInfoBnk1                       ; GFX subroutine for the Thwomp.
    LDA.W SpriteMisc1528,X
    STA.B _2
    PHX
    LDX.B #$03
    CMP.B #$00                                ; Upload 4 tiles. If not using the default facial expression, upload a fifth one.
    BEQ CODE_01AF64
    INX
CODE_01AF64:
    LDA.B _0
    CLC
    ADC.W ThwompDispX,X
    STA.W OAMTileXPos+$100,Y                  ; Upload X and Y position.
    LDA.B _1
    CLC
    ADC.W ThwompDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W ThwompGfxProp,X
    ORA.B SpriteProperties                    ; Upload YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    LDA.W ThwompTiles,X
    CPX.B #$04
    BNE CODE_01AF8F
    PHX
    LDX.B _2                                  ; Upload the tile number.
    CPX.B #$02
    BNE +
    LDA.B #$CA                                ; Tile number to use for the angry Thwomp's face.
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
    LDA.B #$04                                ; Draw 5 16x16 tiles.
    JMP CODE_01B37E

Thwimp:
; Thwimp misc RAM:
; $C2   - Which way to jump. Even = right, odd = left.
; $1540 - Timer for waitiing to jump.
; $154C - Timer for disabling contact with Mario. Set to #$08 when touched.
; $157C - Horizontal direction the sprite is facing. Not actually updated by the sprite; instead, only when Mario takes damage from it.
    LDA.W SpriteStatus,X                      ; Thwimp MAIN
    CMP.B #$08
    BNE CODE_01B006                           ; If dying or the game is frozen, just draw graphics.
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01B006                           ; /
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR MarioSprInteractRt
    JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
    JSR CODE_019140                           ; Interact with blocks.
    LDA.B SpriteYSpeed,X                      ; Apply gravity.
    BMI CODE_01AFC3
    CMP.B #$40                                ; Max falling Y speed.
    BCS CODE_01AFC8
    ADC.B #$05                                ; Additional acceleration while falling.
CODE_01AFC3:
    CLC
    ADC.B #$03                                ; Base acceleration. Used throughout the jump.
    BRA +

CODE_01AFC8:
    LDA.B #$40                                ; Y speed to give when at max falling speed.
  + STA.B SpriteYSpeed,X
    JSR IsTouchingCeiling                     ; \ If touching ceiling,
    BEQ +                                     ; |; If it hits a ceiling, knock it back down.
    LDA.B #$10                                ; | Y speed = #$10
    STA.B SpriteYSpeed,X                      ; /
  + JSR IsOnGround                            ; If the Thwimp is on the ground, return to draw graphics.
    BEQ CODE_01B006
    JSR SetSomeYSpeed__
    STZ.B SpriteXSpeed,X                      ; \ Sprite Speed = 0; Clear X and Y speed.
    STZ.B SpriteYSpeed,X                      ; /
    LDA.W SpriteMisc1540,X
    BEQ CODE_01AFFC                           ; Branch if the wait timer is zero, as it has just hit the ground.
    DEC A                                     ; If the wait timer is one, then it's time to jump. Else, branch to just draw graphics.
    BNE CODE_01B006
    LDA.B #$A0                                ; Y speed to give at the start of the Thwimp's jump.
    STA.B SpriteYSpeed,X
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    LSR A                                     ; Set X speed.
    LDA.B #$10                                ; X speed when jumping right.
    BCC +
    LDA.B #$F0                                ; X speed when jumping left.
  + STA.B SpriteXSpeed,X
    BRA CODE_01B006

CODE_01AFFC:
    LDA.B #!SFX_BONK                          ; SFX for hitting the ground.
    STA.W SPCIO0                              ; / Play sound effect
    LDA.B #$40                                ; How long to wait before jumping.
    STA.W SpriteMisc1540,X
CODE_01B006:
    LDA.B #$01                                ; Draw 4 16x16 tiles.
    JMP SubSprGfx0Entry0

InitVerticalFish:
; Vertical fish INIT
    JSR FaceMario                             ; Face Mario and tell it to move vertically.
    INC.W SpriteMisc151C,X
Return01B011:
    RTS


DATA_01B012:
    db $10,$F0

InitFish:
; Initial X speeds for the horizontal fish.
    JSR SubHorizPos                           ; Fish INIT (also generated and jumping fish)
    LDA.W DATA_01B012,Y                       ; Set initial X speed based on which side Mario is on.
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
; X speeds for the horizontal fish.
; X/Y speeds for both fish not in the direction of their movement.
; Y speeds for the vertical fish.
; X speeds for how fast sprites fly away when kick-killed.
; Y speeds to randomly pick from for a flopping fish.
; X speeds to randomly pick from for a flopping fish.
; Directions to check for the fish's block status. Horizontal, vertical.
; Fish misc RAM:
; $C2   - Direction of movement, incremented at each turn. Even = +, odd = -.
; $151C - Which way the fish swims. 0 = horizontal, 1 = vertical.
; $1540 - Timer for making the fish automatically turn around. Sets to #$80 at each turn.
; $1570 - Frame counter for animation.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame to use.
; 0/1 = swimming, 2/3 = flopping
    LDA.W SpriteStatus,X                      ; Fish MAIN
    CMP.B #$08
    BNE CODE_01B03E
    LDA.B SpriteLock                          ; If the fish is dying or the game is frozen, just draw graphics.
    BEQ +
CODE_01B03E:
    JMP CODE_01B10A

  + JSR SetAnimationFrame
    LDA.W SpriteInLiquid,X                    ; Branch if in water.
    BNE CODE_01B0A7
; Fish is not in water.
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    JSR IsTouchingObjSide
    BEQ +                                     ; If touching a block, flip to the other direction.
    JSR FlipSpriteDir
  + JSR IsOnGround                            ; Make the fish flop on the ground.
    BEQ CODE_01B09C
    LDA.W SpriteBuoyancy
    BEQ +                                     ; If sprite buoyancy is enabled in the level, spawn water splashes as it bounces.
    JSL CODE_0284BC
  + JSL GetRand
    ADC.B TrueFrame
    AND.B #$07                                ; Give a random X speed.
    TAY
    LDA.W DATA_01B029,Y
    STA.B SpriteXSpeed,X
    JSL GetRand
    LDA.W RandomNumber+1
    AND.B #$03                                ; Give a random Y speed.
    TAY
    LDA.W DATA_01B025,Y
    STA.B SpriteYSpeed,X
    LDA.W RandomNumber
    AND.B #$40
    BNE +                                     ; Occasionally Y flip its graphics.
    LDA.W SpriteOBJAttribute,X
    EOR.B #$80
    STA.W SpriteOBJAttribute,X
  + JSL GetRand
    LDA.W RandomNumber
    AND.B #$80                                ; Occasionally update the direction it's facing.
    BNE CODE_01B09C
    JSR UpdateDirection
CODE_01B09C:
    LDA.W SpriteMisc1602,X
    CLC
    ADC.B #$02                                ; Set animation frame to be flopping.
    STA.W SpriteMisc1602,X
    BRA CODE_01B0EA

CODE_01B0A7:
; Fish is in water.
    JSR CODE_019140                           ; If the fish hits a block, change direction.
    JSR UpdateDirection
    ASL.W SpriteOBJAttribute,X                ; Clear Y flip (from flopping).
    LSR.W SpriteOBJAttribute,X
    LDA.W SpriteBlockedDirs,X
    LDY.W SpriteMisc151C,X
    AND.W DATA_01B031,Y
    BNE CODE_01B0C3
    LDA.W SpriteMisc1540,X                    ; If the fish hits a wall or its timer runs around, turn the other way.
    BNE +
CODE_01B0C3:
    LDA.B #$80                                ; How many frames to wait before turning the fish around automatically.
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.W SpriteMisc151C,X
    BEQ +
    INY                                       ; Set X and Y speed based on the direction of movement and type of fish.
    INY
  + LDA.W DATA_01B01D,Y
    STA.B SpriteXSpeed,X
    LDA.W DATA_01B01F,Y
    STA.B SpriteYSpeed,X
    JSR SubSprXPosNoGrvty
    AND.B #$0C                                ; Update the sprite's position.
    BNE CODE_01B0EA                           ; Oddly, don't update its Y position for the horizontal fish going left.
    JSR SubSprYPosNoGrvty
CODE_01B0EA:
; Fish code convenes here.
    JSR SubSprSprInteract                     ; Process interaction with Mario and other sprites.
    JSR MarioSprInteractRt
    BCC CODE_01B10A
    LDA.W SpriteInLiquid,X
    BEQ CODE_01B107                           ; Kick-kill the fish if:
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star; It's not in water
    BNE CODE_01B107                           ; /; Mario has star power
    LDA.W PlayerRidingYoshi
    BNE CODE_01B10A                           ; Else, hurt Mario unless he's on Yoshi.
    JSL HurtMario
    BRA CODE_01B10A

CODE_01B107:
    JSR CODE_01B12A
CODE_01B10A:
    LDA.W SpriteMisc1602,X                    ; GFX routine for fish sprites.
    LSR A
    EOR.B #$01                                ; Set GFX page based on whether it's flopping or not.
    STA.B _0                                  ; Flopping = page x0
    LDA.W SpriteOBJAttribute,X                ; Swimming = page x1
    AND.B #$FE
    ORA.B _0
    STA.W SpriteOBJAttribute,X
    JSR SubSprGfx2Entry1                      ; Draw a 16x16 sprite.
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LSR.W SpriteOBJAttribute,X
    SEC                                       ; Reset GFX page for next run.
    ROL.W SpriteOBJAttribute,X
    RTS

CODE_01B12A:
; Subroutine to handle kicking stunned Koopas/out-of-water fish.
    LDA.B #$10                                ; How long to show Mario's "kicked sprite" pose.
    STA.W KickingTimer
    LDA.B #!SFX_KICK                          ; SFX for kicking the sprite.
    STA.W SPCIO0                              ; / Play sound effect
    JSR SubHorizPos
    LDA.W DATA_01B023,Y                       ; Send the sprite flying away from Mario (does not apply to Koopas, which just drop straight down)
    STA.B SpriteXSpeed,X
    LDA.B #$E0                                ; Speed to send the fish flying
    STA.B SpriteYSpeed,X
    LDA.B #$02                                ; \ Sprite status = Killed; Kill the sprite.
    STA.W SpriteStatus,X                      ; /
    STY.B PlayerDirection                     ; Make Mario face the sprite he kicked.
    LDA.B #$01                                ; Number of points to give Mario for kicking a Koopa/Fish (200).
    JSL GivePoints
    RTS

CODE_01B14E:
; Sprite glitter subroutine.
    LDA.B TrueFrame                           ; Spawn once every 4 frames.
    AND.B #$03
CODE_01B152:
    ORA.W SpriteOffscreenVert,X
    ORA.B SpriteLock                          ; Return if game frozen or sprite offscreen.
    BNE Return01B191
    JSL GetRand
    AND.B #$0F
    CLC
    LDY.B #$00
    ADC.B #$FC
    BPL +
    DEY
  + CLC                                       ; Give a random X offset in the range #$FFFC-#$000B.
    ADC.B SpriteXPosLow,X                     ; Return if that would stick the sparkle offscreen.
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
    ADC.B SpriteYPosLow,X                     ; Give a random Y offset in the range #$00FE-#$010D.
    STA.B _0
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _1
    JSL CODE_0285BA                           ; Spawn the sparkle.
Return01B191:
    RTS

GeneratedFish:
; Generated Fish misc RAM:
; $154C - Timer for disabling contact with Mario. Set to #$08 when touched.
; $1570 - Frame counter for animation.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame to use.
; 0/1 = swimming
; Generated fish MAIN.
    JSR CODE_01B209                           ; Process interaction with Mario/sprites and draw GFX.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if game is frozen.
    BNE Return01B1B0                          ; /
    JSR SetAnimationFrame                     ; Set animation frame.
    JSR SubSprXPosNoGrvty                     ; Update X position.
    JSR SubSprYPosNoGrvty                     ; Update Y position.
    JSR CODE_019140                           ; Process interaction with blocks?...
    LDA.B SpriteYSpeed,X
    CMP.B #$20                                ; Max fall speed for the generated fish.
    BPL +
    CLC
    ADC.B #$01                                ; Gravity for the generated fish.
  + STA.B SpriteYSpeed,X
Return01B1B0:
    RTS


DATA_01B1B1:
    db $D0,$D0,$B0

JumpingFish:
; Y speeds for each of the jumping fish's jumps.
; Surface-jumping Fish misc RAM:
; $C2   - Bounce counter. On the third bounce, it does a big leap and briefly sinks into the water.
; $151C - Mirror of in-water flag for after the third bounce.
; $1540 - Timer set to #$10 when entering water. Not used otherwise.
; $154C - Timer for disabling contact with Mario. Set to #$08 when touched.
; $1570 - Frame counter for animation. Increases thrice as fast while in air.
; $157C - Horizontal direction the sprite is facing. (always 1)
; $1602 - Animation frame to use.
; 0/1 = swimming
; Surface-jumping fish MAIN.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Just draw graphics if the game is frozen.
    BNE CODE_01B209                           ; /
    LDA.W SpriteInLiquid,X
    STA.W SpriteMisc151C,X
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    LDA.W SpriteInLiquid,X                    ; Branch if not touching water.
    BEQ CODE_01B1EA
    LDA.B SpriteTableC2,X                     ; Branch in the phase to sink in water.
    CMP.B #$03                                ; Number of leaps to make before the big leap and sink.
    BEQ CODE_01B1DE
    INC.B SpriteTableC2,X
    TAY
    LDA.W DATA_01B1B1,Y                       ; Set Y speed and jump out of the water.
    STA.B SpriteYSpeed,X                      ; Also set the stun timer for no reason.
    LDA.B #$10
    STA.W SpriteMisc1540,X
    STZ.W SpriteInLiquid,X
    BRA CODE_01B206

CODE_01B1DE:
    DEC.B SpriteYSpeed,X                      ; Fish is sinking.
    LDA.B TrueFrame
    AND.B #$03                                ; Slowly accelerate upwards.
    BNE +
    DEC.B SpriteYSpeed,X
  + BRA CODE_01B206

CODE_01B1EA:
; Fish is in midair.
    INC.W SpriteMisc1570,X                    ; Animate thrice as fast in mid-air.
    INC.W SpriteMisc1570,X
    CMP.W SpriteMisc151C,X
    BEQ CODE_01B206
    LDA.B #$10
    STA.W SpriteMisc1540,X
    LDA.B SpriteTableC2,X
    CMP.B #$03
    BNE CODE_01B206                           ; If it just finished sinking, reset jump counter and send into the air.
    STZ.B SpriteTableC2,X
    LDA.B #$D0                                ; Y speed for the fish's first jump.
    STA.B SpriteYSpeed,X
CODE_01B206:
; All code re-convenes here for GFX.
    JSR SetAnimationFrame                     ; Set animation frame.
CODE_01B209:
    JSR SubSprSpr_MarioSpr                    ; Process interaction with Mario/sprites.
    JSR UpdateDirection                       ; Update direction based on X speed (although its X speed never changes...).
    JMP CODE_01B10A                           ; Draw GFX.


DATA_01B212:
    db $08,$F8,$10,$F0

InitFloatSpkBall:
; X speeds for the floating spike ball. First two are "slow", second two are "fast".
    JSR FaceMario                             ; Floating spike ball INIT
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXPosLow,X
    AND.B #$10
    BEQ +                                     ; Get X speed based on odd or even X position.
    INY
    INY
  + LDA.W DATA_01B212,Y
    STA.B SpriteXSpeed,X
    BRA InitFloatingPlat                      ; Find water  below and spawn in it.

InitFallingPlat:
; Floating checkerboard platform INIT
    INC.W SpriteMisc1602,X                    ; Make
InitOrangePlat:
; Flying orange platform INIT
    LDA.W SpriteBuoyancy                      ; If sprite buoyancy is enabled, find water to float in.
    BNE InitFloatingPlat                      ; If buoyancy is not enabled, just stay in midair instead.
    INC.B SpriteTableC2,X                     ; (in the case of the chekerboard platform, it will fall straight down).
    RTS

InitFloatingPlat:
    LDA.B #$03                                ; Floating platform INIT (also used by spike ball)
    STA.W SpriteMisc151C,X
CODE_01B23B:
    JSR CODE_019140
    LDA.W SpriteInLiquid,X
    BNE Return01B25D
    DEC.W SpriteMisc151C,X                    ; Look for water below the sprite and spawn it there.
    BMI CODE_01B262                           ; $151C is used as the number of tiles to look; if
    LDA.B SpriteYPosLow,X                     ; no water could be found in that range, re-initialize the sprite
    CLC                                       ; and check again next frame.
    ADC.B #$08                                ; Scans at most until its high Y position is greater than #$02, at
    STA.B SpriteYPosLow,X                     ; which point it gives up.
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    CMP.B #$02
    BCS Return01B25D
    BRA CODE_01B23B

Return01B25D:
    RTS

InitChckbrdPlat:
    INC.W SpriteMisc1602,X                    ; Checkerboard platform INIT.
    RTS

CODE_01B262:
    LDA.B #$01                                ; \ Sprite status = Initialization; Set the sprite to re-initialize on the next frame.
    STA.W SpriteStatus,X                      ; /
Return01B267:
    RTS


DATA_01B268:
    db $FF,$01

DATA_01B26A:
    db $F0,$10

Platforms:
; X/Y accerations for the platforms.
; Max X/Y speeds for the platforms.
; Flying platform misc RAM:
; $C2   - Frame counter for acceleration. Increments while accelerating; the platform's speed gets updated every 4th value.
; $151C - Next direction of acceleration. Even = -, odd = +.
; $1528 - Number of pixels moved per frame, for moving Mario. Only used for the horizontal platforms.
; $1540 - Timer for how long to wait before applying acceleration again.
; Set to #$30 each time $151C increments.
; $1602 - Set to #$01 for the checkerboard platforms. Makes them 5 tiles instead of 3.
; Flying platforms MAIN (this refers to both the checkerboard and flying rock platforms)
    JSR CODE_01B2D1                           ; Draw graphics.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if the game is frozen.
    BNE Return01B2C2                          ; /
    LDA.W SpriteMisc1540,X                    ; Branch if not accelerating.
    BNE CODE_01B2A5
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    AND.B #$03                                ; How often to update the platform's speed.
    BNE CODE_01B2A5
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X                      ; Accerate X/Y speed.
    CLC                                       ; If at the max, change acceration direction
    ADC.W DATA_01B268,Y                       ; and stall an appropriate amount of time.
    STA.B SpriteYSpeed,X
    STA.B SpriteXSpeed,X
    CMP.W DATA_01B26A,Y
    BNE CODE_01B2A5
    INC.W SpriteMisc151C,X
    LDA.B #$18                                ; How long the platforms stall at max speed.
    LDY.B SpriteNumber,X
    CPY.B #$55
    BNE +
    LDA.B #$08                                ; How long the horizontal checkerboard platform stalls at max speed.
  + STA.W SpriteMisc1540,X
CODE_01B2A5:
    LDA.B SpriteNumber,X
    CMP.B #$57
    BCS CODE_01B2B0
    JSR SubSprXPosNoGrvty                     ; If a horizontal platform, only update X position.
    BRA +                                     ; If a vertical platform, only update Y position.

CODE_01B2B0:
    JSR SubSprYPosNoGrvty
    STZ.W SpriteXMovement
  + LDA.W SpriteXMovement
    STA.W SpriteMisc1528,X                    ; Make solid and move Mario with the platform.
    JSR CODE_01B457
    JSR SubOffscreen1Bnk1                     ; Process offscreen from -$40 to +$A0.
Return01B2C2:
    RTS


DATA_01B2C3:
    db $00,$01,$00,$01,$00,$00,$00,$00
    db $01,$01,$00,$00,$00,$00

CODE_01B2D1:
; What kind of platform each sprite is. Indexed by sprite number from #$55.
; 00 = brown/checker, 01 = rock/orange
; The revolving platform is not handled by this.
    LDA.B SpriteNumber,X                      ; Graphics subroutine for almost all platform sprites.
    SEC
    SBC.B #$55                                ; If a rock/orange platform, jump down.
    TAY                                       ; If a brown/checker platform, continue code.
    LDA.W DATA_01B2C3,Y
    BEQ CODE_01B2DF
    JMP CODE_01B395

CODE_01B2DF:
    JSR GetDrawInfoBnk1                       ; Brown/checker platform GFX routine.
    LDA.W SpriteMisc1602,X
    STA.B _1
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y                  ; Set Y position for three tiles.
    STA.W OAMTileYPos+$108,Y                  ; If a checkerboard platform, set two more.
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
    ADC.B #$10                                ; Set X position for three tiles.
    STA.W OAMTileXPos+$108,Y                  ; If a checkerboard platform, set two more again.
    LDX.B _1
    BEQ +
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$10C,Y
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$110,Y
  + LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _1                                  ; Set tile numbers for checkerboard platforms.
    BEQ CODE_01B344
    LDA.B #$EA                                ; Leftmost tile.
    STA.W OAMTileNo+$100,Y
    LDA.B #$EB                                ; Middle tiles.
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$108,Y
    STA.W OAMTileNo+$10C,Y
    LDA.B #$EC                                ; Rightmost tile.
    STA.W OAMTileNo+$110,Y
    BRA +

CODE_01B344:
    LDA.B #$60                                ; Leftmost tile.
    STA.W OAMTileNo+$100,Y
    LDA.B #$61                                ; Middle tiles.
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$108,Y                    ; Set tile numbers for brown platforms.
    STA.W OAMTileNo+$10C,Y
    LDA.B #$62                                ; Rightmost tile.
    STA.W OAMTileNo+$110,Y
  + LDA.B SpriteProperties
    ORA.W SpriteOBJAttribute,X
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y                  ; Set YXPPCCCT for each tile.
    STA.W OAMTileAttr+$10C,Y                  ; If a brown platform, send the middle tile in front as the end of the platform?
    STA.W OAMTileAttr+$110,Y
    LDA.B _1
    BNE +
    LDA.B #$62
    STA.W OAMTileNo+$108,Y
  + LDA.B #$04
    LDY.B _1
    BNE CODE_01B37E
    LDA.B #$02                                ; Upload 3/5 16x16 tiles to OAM.
CODE_01B37E:
    LDY.B #$02
    JMP FinishOAMWriteRt


DiagPlatTiles:
    db $CB,$E4,$CC,$E5,$CC,$E5,$CC,$E4
    db $CB

    db $85,$88,$86,$89,$86,$89,$86,$88
    db $85

CODE_01B395:
; Tile numbers for the orange platforms.
    JSR GetDrawInfoBnk1                       ; Rock/orange platform GFX routine.
    PHY
    LDY.B #$00
    LDA.B SpriteNumber,X
    CMP.B #$5E
    BNE +                                     ; Set sprite 5E (the flying orange platform) to be bigger than normal.
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
    STA.W OAMTileYPos+$118,Y                  ; Set Y position for three tiles, plus two for the lower tiles.
    STA.W OAMTileYPos+$120,Y                  ; If the flying orange platform, set two (four) more.
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
    BNE +                                     ; Drawing nine tiles for the flying orange platform,
    LDA.B #$04                                ; Five for the others.
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
    STA.W OAMTileNo+$100,Y                    ; Set X position, tile numbers, and YXPPCCCT for all of the tiles.
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
    LDA.B SpriteNumber,X                      ; Set right edge of the flying rock platforms.
    CMP.B #$5B
    BCS CODE_01B43A
    LDA.B #$85                                ; Top tile.
    STA.W OAMTileNo+$110,Y
    LDA.B #$88                                ; Bottom tile.
    STA.W OAMTileNo+$10C,Y
    BRA CODE_01B444

CODE_01B43A:
    LDA.B #$CB                                ; Top tile.
    STA.W OAMTileNo+$110,Y                    ; Set right edge for the flying orange platforms.
    LDA.B #$E4                                ; Bottom tile.
    STA.W OAMTileNo+$10C,Y
CODE_01B444:
    LDA.B #$08
    LDY.B _0
    BNE +                                     ; Upload 5/9 16x16 tiles to OAM.
    LDA.B #$04
  + JMP CODE_01B37E

InvisBlkMainRt:
; Misc RAM input:
; $1528 - Number of pixels the sprite has moved horizontally that frame, for moving Mario. Note: not cleared post-routine.
; Misc RAM output:
; $C2   - If the sprite is solid from all sides: set to 1 if initially 0. Can be used as a flag for whether the sprite has been hit from below.
; $1558 - If the sprite is solid from all sides: set to #$10 if $C2 was initially 0 when hit from below. Can be used as a timer for a bouncing animation.
; $1564 - If the sprite is solid from all sides (with sprite number >= 83): set to #$0F when hit from below.
; Invisible solid block MAIN; JSL here to make a sprite solid.
    PHB                                       ; Returns carry set if Mario is on top of the sprite, and clear if not.
    PHK                                       ; If bit 0 of $190F is clear, the block is completely solid.
    PLB                                       ; If set, it's like passable like a ledge.
    JSR CODE_01B457
    PLB
    RTL

CODE_01B457:
    JSR ProcessInteract                       ; Return carry clear if Mario is not touching the sprite.
    BCC CODE_01B4B2
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos                          ; Branch if the sprite isn't at least 1.8 blocks below Mario (i.e. he's not on top).
    STA.B _0                                  ; Oddly, this uses on-screen position,
    LDA.B PlayerYPosScrRel                    ; hence the glitchiness if you touch a solid sprite offscreen.
    CLC                                       ; It's probably meant to save bytes on cross-screen interaction.
    ADC.B #$18
    CMP.B _0
    BPL CODE_01B4B4
    LDA.B PlayerYSpeed+1
    BMI CODE_01B4B2                           ; Return carry clear if Mario is moving up or is being pushed down by an object.
    LDA.B PlayerBlockedDir                    ; Else, he is standing on the top of the block.
    AND.B #$08
    BNE CODE_01B4B2
    LDA.B #$10                                ; Y speed to give Mario when sitting on top of the block.
    STA.B PlayerYSpeed+1
    LDA.B #$01                                ; Set Mario as standing on a solid sprite.
    STA.W StandOnSolidSprite
    LDA.B #$1F
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$2F
  + STA.B _1                                  ; Set Y position on top, accounting for Yoshi.
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
    DEY                                       ; If not blocked on the left/right,
  + CLC                                       ; slide Mario with the sprite.
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
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Make Platform Passable" is set; Not on top of the sprite; check inside it.
    LSR A                                     ; |; Return carry clear if passable from below.
    BCS CODE_01B4B2                           ; /
    LDA.B #$00
    LDY.B PlayerIsDucking
    BNE CODE_01B4C4
    LDY.B Powerup
    BNE +
CODE_01B4C4:
; Branch if Mario is vertically inside the sprite,
    LDA.B #$08                                ; accounting for powerup, ducking, and Yoshi.
  + LDY.W PlayerRidingYoshi                   ; Pushes Mario out of the sprite if so, and
    BEQ +                                     ; returns carry clear.
    ADC.B #$08
  + CLC
    ADC.B PlayerYPosScrRel
    CMP.B _0
    BCC CODE_01B505
    LDA.B PlayerYSpeed+1                      ; Return carry clear if Mario is moving downwards (not jumping up and hitting the bottom of it).
    BPL CODE_01B4F7
    LDA.B #$10                                ; Y speed to give Mario after hitting the sprite's bottom.
    STA.B PlayerYSpeed+1
    LDA.B SpriteNumber,X
    CMP.B #$83                                ; Handle "hittable" sprite blocks (83, 84, 9C, B9, C8).
    BCC +                                     ; This accidentally also applies to AF, B1, BB, and BC.
CODE_01B4E2:
    LDA.B #$0F                                ; Disable contact with other sprites.
    STA.W SpriteMisc1564,X
    LDA.B SpriteTableC2,X
    BNE +
    INC.B SpriteTableC2,X                     ; Set the bounce timer for the sprite if it hasn't already been hit.
    LDA.B #$10
    STA.W SpriteMisc1558,X
  + LDA.B #!SFX_BONK                          ; SFX for hitting a sprite block.
    STA.W SPCIO0                              ; / Play sound effect
CODE_01B4F7:
    CLC
    RTS


DATA_01B4F9:
    db $0E,$F1,$10,$E0,$1F,$F1

DATA_01B4FF:
    db $00,$FF,$00,$FF,$00,$FF

CODE_01B505:
; Low X offset from a sprite to push Mario if he ends up inside.
; 0/1 = one-tile sprites
; 2/3 = Reznor
; 4/5 = two-tile sprites
; High X offset from a sprite to push Mario if he ends up inside.
    JSR SubHorizPos                           ; Push Mario to the side of the sprite and returns carry clear.
    LDA.B SpriteNumber,X
    CMP.B #$A9
    BEQ CODE_01B520
    CMP.B #$9C
    BEQ CODE_01B51E                           ; If...
    CMP.B #$BB                                ; Sprite 49 (growing pipe):    Y = 4/5
    BEQ CODE_01B51E                           ; Sprite 60 (switch palace):   Y = 4/5
    CMP.B #$60                                ; Sprite 9C (Hammer Bro plat): Y = 4/5
    BEQ CODE_01B51E                           ; Sprite A9 (Reznor Platform): Y = 2/3
    CMP.B #$49                                ; Sprite BB (Castle block):    Y = 4/5
    BNE +                                     ; Other (one-tile sprites):    Y = 0/1
CODE_01B51E:
    INY
    INY
CODE_01B520:
    INY
    INY
  + LDA.W DATA_01B4F9,Y
    CLC
    ADC.B SpriteXPosLow,X
    STA.B PlayerXPosNext                      ; Push Mario out of the sprite and clear his speed.
    LDA.W DATA_01B4FF,Y
    ADC.W SpriteXPosHigh,X
    STA.B PlayerXPosNext+1
    STZ.B PlayerXSpeed+1
    CLC
    RTS

OrangePlatform:
; Orange platform misc RAM:
; $C2   - Flag for which platform it should be. 00 = floating, 01 = flying.
; $1528 - Number of pixels moved per frame, for moving Mario.
; See FloatingPlatMain for additional misc RAM when floating in water rather than flying.
; Flying orange platform MAIN
    LDA.B SpriteTableC2,X                     ; Change to a floating platform if sprite buoyancy is enabled.
    BEQ Platforms2
    JSR CODE_01B2D1                           ; Draw graphics.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if sprites are frozen.
    BNE +                                     ; /
    JSR SubSprXPosNoGrvty                     ; Update X position.
    LDA.W SpriteXMovement
    STA.W SpriteMisc1528,X
    JSR CODE_01B457                           ; Make the platform solid.
    BCC +
    LDA.B #$01                                ; Start moving if Mario is on top of the platform.
    STA.W BGFastScrollActive                  ; Also triggers the fast BG scroll sprite and flying turnblocks.
    LDA.B #$08
    STA.B SpriteXSpeed,X
  + RTS

FloatingSpikeBall:
; Floating platform/spike ball misc RAM:
; $151C - Flag for whether Mario is on the platform. #$01 if so.
; Also used during initialization to divide finding water tiles over multiple frames.
; $154C - Timer for disabling contact with Mario. Set to #$08 for the spike ball when touched.
; $1602 - Set to #$01 for the checkerboard platforms. Makes it 5 tiles instead of 3.
    LDA.W SpriteStatus,X                      ; Floating spike ball MAIN
    CMP.B #$08                                ; If dying, just draw graphics.
    BEQ Platforms2
    JMP CODE_01B666

Platforms2:
    LDA.B SpriteLock                          ; Floating platform MAIN. Also used by the floating spike ball.
    BEQ +                                     ; Skip to just draw graphics if the game is frozen.
    JMP CODE_01B64E

  + LDA.W SpriteBlockedDirs,X
    AND.B #$0C                                ; Update Y position, unless blocked by something.
    BNE +                                     ; ...though, none of the sprites interact with solid blocks.
    JSR SubSprYPosNoGrvty
  + STZ.W SpriteXMovement
    LDA.B SpriteNumber,X
    CMP.B #$A4                                ; Update X position (only for the spike ball).
    BNE +
    JSR SubSprXPosNoGrvty
  + LDA.B SpriteYSpeed,X
    CMP.B #$40                                ; Limit maximum falling Y speed when not in water.
    BPL +
    INC.B SpriteYSpeed,X
; Handle movement in water.
  + LDA.W SpriteInLiquid,X                    ; Branch if not in water.
    BEQ CODE_01B5A6
    LDY.B #$F8
    LDA.B SpriteNumber,X
    CMP.B #$5D
    BCC +
    LDY.B #$FC
  + STY.B _0                                  ; Make the platform float upwards in water.
    LDA.B SpriteYSpeed,X
    BPL CODE_01B5A1
    CMP.B _0
    BCC CODE_01B5A6
CODE_01B5A1:
    SEC
    SBC.B #$02
    STA.B SpriteYSpeed,X
CODE_01B5A6:
    LDA.B PlayerYSpeed+1                      ; Handle interaction with Mario.
    PHA
    LDA.B SpriteNumber,X
    CMP.B #$A4
    BNE CODE_01B5B5
    JSR MarioSprInteractRt
    CLC                                       ; Handle basic interaction.
    BRA +                                     ; For the spike ball, hurt mario and make spinjumpable.

CODE_01B5B5:
    JSR CODE_01B457                           ; For all others, make it a solid platform.
  + PLA                                       ; If they aren't in contact, branch down.
    STA.B _0
    STZ.W TileGenerateTrackA
    BCC CODE_01B5E7
    LDA.B SpriteNumber,X
    CMP.B #$5D
    BCC CODE_01B5DA
    LDY.B #$03
    LDA.B Powerup
    BNE +
    DEY                                       ; Make the orange platforms sink slowly while Mario is on them.
  + STY.B _0                                  ; Sinks slightly faster if Mario is big.
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
    BCC CODE_01B5E7                           ; If Mario lands on a platform with his Y speed greater than #$20,
    LSR A                                     ; divide that speed by 4 and transfer it to the platform.
    LSR A
    STA.B SpriteYSpeed,X
CODE_01B5E7:
    LDA.W TileGenerateTrackA
    CMP.W SpriteMisc151C,X
    STA.W SpriteMisc151C,X
    BEQ CODE_01B610                           ; If Mario has just jumped off the platform
    LDA.W TileGenerateTrackA                  ; and it's moving upwards, give it a small push downwards.
    BNE CODE_01B610
    LDA.B PlayerYSpeed+1
    BPL CODE_01B610
    LDY.B #$08                                ; Y speed to push with when Mario is big.
    LDA.B Powerup
    BNE +
    LDY.B #$06                                ; Y speed to push with when Mario is small.
  + STY.B _0
    LDA.B SpriteYSpeed,X
    CMP.B #$20
    BPL CODE_01B610
    CLC
    ADC.B _0
    STA.B SpriteYSpeed,X
CODE_01B610:
    LDA.B #$01
    AND.B TrueFrame                           ; Skip down to graphics every other frame.
    BNE CODE_01B64E
    LDA.B SpriteYSpeed,X
    BEQ CODE_01B624
    BPL +                                     ; Idle movements.
    CLC                                       ; If Y speed is:
    ADC.B #$02                                ; Zero: do nothing
; Upwards (-): accelerate downwards.
  + SEC                                       ; Downwards (+): accelerate upwards.
    SBC.B #$01
    STA.B SpriteYSpeed,X
CODE_01B624:
    LDY.W TileGenerateTrackA
    BEQ +
    LDY.B #$05                                ; Distance to push when Mario is big.
    LDA.B Powerup
    BNE +
    LDY.B #$02                                ; Distance to push when Mario is small.
  + STY.B _0
    LDA.B SpriteYPosLow,X                     ; If Mario is sitting on the platform, push it down slightly.
    PHA
    SEC
    SBC.B _0
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSR CODE_019140                           ; Process interaction with water.
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
CODE_01B64E:
; Handle graphics.
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteNumber,X
    CMP.B #$A4                                ; Draw graphics. Spike ball routine is below,
    BEQ CODE_01B666                           ; platform routine is back before this.
    JMP CODE_01B2D1


DATA_01B65A:
    db $F8,$08,$F8,$08

DATA_01B65E:
    db $F8,$F8,$08,$08

FloatMineGfxProp:
    db $31,$71,$A1,$F1

CODE_01B666:
; X offsets for the floating spike ball's tiles.
; Y offsets for the floating spike ball's tiles.
; YXPPCCCT for the floating spike ball's tiles.
    JSR GetDrawInfoBnk1                       ; GFX routine for the floating spike ball.
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
    LSR A                                     ; Loop for all four tiles of the spike ball.
    LSR A
    AND.B #$04
    LSR A
    ADC.B #$AA                                ; Baese tile. Second tile is to its right.
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
    LDA.B #$03                                ; Upload 4 16x16 tiles to OAM.
    JMP FinishOAMWriteRt


BlkBridgeLength:
    db $20,$00

TurnBlkBridgeSpeed:
    db $01,$FF

BlkBridgeTiming:
    db $40,$40

TurnBlockBridge:
; Maximum bridge lengths.
; Bridge expansion/retraction speeds.
; How long to wait at max/min lengths before moving again.
; Turnblock bridge misc RAM:
; $C2   - Direction of movement. H/V bridge uses this mod 4; H bridge just alternates 0 and 1.
; 0 = extend horz, 1 = retract horz, 2 = extend vert, 3 = retract vert
; $151C - Distance currently extended. Max is #$20.
; $1540 - Timer to wait before extending/retracting.
; Horizontal/vertical turnblock bridge MAIN.
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR CODE_01B710                           ; Draw GFX.
    JSR CODE_01B852                           ; Handle contact.
    JSR CODE_01B6B2
    RTS

CODE_01B6B2:
    LDA.B SpriteTableC2,X                     ; H/V bridge primary routine.
    AND.B #$01
    TAY                                       ; If at max/min length, branch to move to next phase.
    LDA.W SpriteMisc151C,X
    CMP.W BlkBridgeLength,Y
    BEQ CODE_01B6D1
    LDA.W SpriteMisc1540,X
    ORA.B SpriteLock                          ; Return if either the game of bridge is frozen.
    BNE +
    LDA.W SpriteMisc151C,X
    CLC                                       ; Expand/retract the bridge.
    ADC.W TurnBlkBridgeSpeed,Y
    STA.W SpriteMisc151C,X
  + RTS

CODE_01B6D1:
    LDA.W BlkBridgeTiming,Y
    STA.W SpriteMisc1540,X                    ; Move to next phase and temporarily freeze the bridge.
    INC.B SpriteTableC2,X
    RTS

HorzTurnBlkBridge:
; Horizontal turnblock bridge MAIN (see above for misc).
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR CODE_01B710                           ; Draw GFX.
    JSR CODE_01B852                           ; Handle contact.
    JSR CODE_01B6E7                           ; Run main routine.
    RTS

CODE_01B6E7:
    LDY.B SpriteTableC2,X                     ; H bridge primary routine.
    LDA.W SpriteMisc151C,X                    ; If at max/min length, branch to move to next phase.
    CMP.W BlkBridgeLength,Y
    BEQ CODE_01B703
    LDA.W SpriteMisc1540,X
    ORA.B SpriteLock                          ; Return if either the game of bridge is frozen.
    BNE +
    LDA.W SpriteMisc151C,X
    CLC                                       ; Expand/retract the bridge.
    ADC.W TurnBlkBridgeSpeed,Y
    STA.W SpriteMisc151C,X
  + RTS

CODE_01B703:
    LDA.W BlkBridgeTiming,Y
    STA.W SpriteMisc1540,X
    LDA.B SpriteTableC2,X                     ; Move to next phase.
    EOR.B #$01
    STA.B SpriteTableC2,X
    RTS

CODE_01B710:
; Scratch RAM usage and returns:
; $00 - Outer tile X offset from center.
; $01 - Inner tile X offset from center.
; $02 - Outer tile Y offset from center.
; $03 - Inner tile Y offset from center.
    JSR GetDrawInfoBnk1                       ; Turnblock bridge GFX routine.
    STZ.B _0
    STZ.B _1
    STZ.B _2
    STZ.B _3
    LDA.B SpriteTableC2,X                     ; Set up the addresses for offsets from
    AND.B #$02                                ; the center base tile.
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
    PLA                                       ; Set Y position for each tile.
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
    PLA                                       ; Set X position for each tile.
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
    LSR A                                     ; Useless?
    LSR A
    LDA.B #$40                                ; Tile number.
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$10C,Y                    ; Set tiles.
    STA.W OAMTileNo+$110,Y
    STA.W OAMTileNo+$108,Y
    STA.W OAMTileNo+$100,Y
    LDA.B SpriteProperties
    STA.W OAMTileAttr+$10C,Y
    STA.W OAMTileAttr+$104,Y                  ; Set YXPPCCCT.
    STA.W OAMTileAttr+$108,Y                  ; Rightmost tile takes priority, to prevent odd overlaps.
    STA.W OAMTileAttr+$110,Y                  ; It's also X flipped for whatever reason.
    ORA.B #$60
    STA.W OAMTileAttr+$100,Y
    LDA.B _0
    PHA
    LDA.B _2
    PHA
    LDA.B #$04                                ; Upload 5 16x16 tiles to OAM.
    JSR CODE_01B37E
    PLA
    STA.B _2
    PLA
    STA.B _0
    RTS

FinishOAMWrite:
; Scratch RAM usage: $00-$0B
; $00 - Sprite Y position (low)
; $01 - Sprite Y position (high)
; $02 - Sprite X position (low)
; $03 - Sprite X position (high)
; $04 - Current tile X position within the screen (low)
; $05 - Current tile X position within the screen (high)
; $06 - Sprite X position within the screen
; $07 - Sprite X position within the screen
; $08 - Number of tiles to draw (returns with #$FF)
; $09 - Current tile Y position within the screen (low)
; $0A - Current tile Y position within the screen (high)
; $0B - Tile size (00 = 8x8, 02 = 16x16, 80+ = manually set)
; Routine to make sure sprite tiles are on-screen and set their size.
    PHB                                       ; Wrapper; Usage:
    PHK                                       ; A = Number of tiles to draw, -1
    PLB                                       ; Y = Tile size (00 = 8x8, 02 = 16x16, 80+ = variable; set size manually)
    JSR FinishOAMWriteRt                      ; Jump to this after storing values to OAM to upload them.
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
    STA.B _1                                  ; Set up position data in scratch RAM.
    LDA.B SpriteXPosLow,X
    STA.B _2
    SEC
    SBC.B Layer1XPos
    STA.B _7
    LDA.W SpriteXPosHigh,X
    STA.B _3
CODE_01B7DE:
    TYA                                       ; Main tile loop.
    LSR A
    LSR A
    TAX
    LDA.B _B
    BPL CODE_01B7F0
    LDA.W OAMTileSize+$40,X
    AND.B #$02                                ; Set tile size.
    STA.W OAMTileSize+$40,X                   ; If Y was negative, don't change size.
    BRA +

CODE_01B7F0:
    STA.W OAMTileSize+$40,X
  + LDX.B #$00
    LDA.W OAMTileXPos+$100,Y
    SEC
    SBC.B _7
    BPL +
    DEX
  + CLC                                       ; Get 16-bit X position of the tile within the screen.
    ADC.B _2
    STA.B _4
    TXA
    ADC.B _3
    STA.B _5
    JSR CODE_01B844
    BCC +
    TYA
    LSR A
    LSR A                                     ; Set OAM high X bit if applicable.
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
  + CLC                                       ; Get 16-bit Y position of the tile within the screen.
    ADC.B _0
    STA.B _9
    TXA
    ADC.B _1
    STA.B _A
    JSR CODE_01C9BF
    BCC +                                     ; Hide offscreen if applicable.
    LDA.B #$F0
    STA.W OAMTileYPos+$100,Y
  + INY
    INY
    INY                                       ; Loop for all the tiles.
    INY
    DEC.B _8
    BPL CODE_01B7DE
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_01B844:
; Returns carry set if the tile is offscreen horizontally, clear if not.
    REP #$20                                  ; A->16; Store X position in $04 first.
    LDA.B _4
    SEC
    SBC.B Layer1XPos
    CMP.W #$0100
    SEP #$20                                  ; A->8
    RTS

    RTS                                       ; rest in peace little buddy

CODE_01B852:
    LDA.W SpriteWayOffscreenX,X               ; Contact routine for the turnblock bridge.
    BNE Return01B8B1                          ; Return if:
    LDA.B PlayerAnimation                     ; Sprite is offscreen.
    CMP.B #$01                                ; Mario is in a special animation phase.
    BCS Return01B8B1                          ; Mario isn't in contact.
    JSR CODE_01B8FF
    BCC Return01B8B1
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _2
    SEC                                       ; Branch if Mario is below a 1.8 pixel range on top of the sprite.
    SBC.B _D                                  ; As with the normal solid routine, it uses on-screen position,
    STA.B _9                                  ; so glitches occur when offscreen.
    LDA.B PlayerYPosScrRel
    CLC
    ADC.B #$18
    CMP.B _9
    BCS ADDR_01B8B2
    LDA.B PlayerYSpeed+1                      ; Return if Mario is moving up. Else, he's on top of the bridge.
    BMI Return01B8B1
    STZ.B PlayerYSpeed+1                      ; Clear Mario's Y speed.
    LDA.B #$01                                ; Set Mario as standing on a solid sprite.
    STA.W StandOnSolidSprite
    LDA.B _D
    CLC
    ADC.B #$1F
    LDY.W PlayerRidingYoshi
    BEQ +
    CLC
    ADC.B #$10
  + STA.B _0                                  ; Set Y position on top, accounting for Yoshi.
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
  + CLC                                       ; Move Mario with the bridge.
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    TYA
    ADC.B PlayerXPosNext+1
    STA.B PlayerXPosNext+1
Return01B8B1:
    RTS

ADDR_01B8B2:
    LDA.B _2                                  ; Touching bottom of the bridge.
    CLC
    ADC.B _D
    STA.B _2
    LDA.B #$FF
    LDY.B PlayerIsDucking
    BNE ADDR_01B8C3
    LDY.B Powerup                             ; Branch if Mario is not touching the bottom of the bridge.
    BNE +                                     ; (i.e. touching sides).
ADDR_01B8C3:
    LDA.B #$08
  + CLC
    ADC.B PlayerYPosScrRel
    CMP.B _2
    BCC ADDR_01B8D5
    LDA.B PlayerYSpeed+1                      ; Return if Mario is moving down.
    BPL +
    LDA.B #$10                                ; Y speed to give Mario after hitting the bottom.
    STA.B PlayerYSpeed+1
  + RTS

ADDR_01B8D5:
    LDA.B _E                                  ; Touching sides of the block.
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
    EOR.B #$FF                                ; Shove Mario to the side and clear his X speed.
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
    LDA.B _0                                  ; Check for contact between Mario and the turnblock bridge.
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
    CLC                                       ; Set up all the addresses and
    ADC.B #$10                                ; check for contact.
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
; Intial X speeds for the horizontal net Koopa.
    JSR SubHorizPos                           ; Horizontal climbing net Koopa INIT.
    LDA.W HorzNetKoopaSpeed,Y                 ; Move towards Mario.
    STA.B SpriteXSpeed,X
    BRA +

InitVertNetKoopa:
    INC.B SpriteTableC2,X                     ; Vertical climbing net Koopa INIT.
    INC.B SpriteXSpeed,X
    LDA.B #$F8                                ; Initial Y speed.
    STA.B SpriteYSpeed,X
  + LDA.B SpriteXPosLow,X
    LDY.B #$00
    AND.B #$10
    BNE +                                     ; Start in front/behind scenery depending on X position.
    INY
  + TYA
    STA.W SpriteBehindScene,X
    LDA.W SpriteOBJAttribute,X
    AND.B #$02
    BNE +                                     ; Double X/Y speed if red.
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
; Animation frames during the turning animation.
; Horz A - Horz B - Vert A - Vert B - Vert C
; Special-World-Passed alternatives to the above five.
; GFX pages for the above frames.
; Directions to check for blocks for each type.
; Net Koopa misc RAM:
; $C2   - Whether the sprite is horizontal (00) or vertical (01).
; $1540 - Timer for the turning animation. Set to #$50 at the start.
; $1570 - Frame counter for animation.
; $157C - Direction of movement. 0 = right/up, 1 = left/down
; $15AC - Timer for turning around.
; $1602 - Animation frame to use for the Koopa.
; 0 = in front of net, 1 = behind net
; 2 = turning (horz), 3/4 = turning (vert)
; Climbing net Koopa MAIN
    LDA.W SpriteMisc1540,X                    ; Branch if the stun timer is 0.
    BEQ CODE_01B9FB
    CMP.B #$30                                ; Branch if the stun timer is 1-2F.
    BCC CODE_01B9A0
    CMP.B #$40                                ; Branch if the stun timer is 30-3F.
    BCC CODE_01B9A3
    BNE CODE_01B9A0
    LDY.B SpriteLock                          ; Branch if the stun timer is 41+ or sprites are locked.
    BNE CODE_01B9A0
    LDA.W SpriteBehindScene,X
    EOR.B #$01                                ; Stun timer is 40; flip its direction,
    STA.W SpriteBehindScene,X                 ; invert its Y speed, and
    JSR FlipSpriteDir                         ; invert the side of the fence the Koopa is on,
    JSR CODE_01BA7F
CODE_01B9A0:
    JMP CODE_01BA37

CODE_01B9A3:
    LDY.B SpriteYPosLow,X                     ; Koopa is in the process of turning; handle animation.
    PHY
    LDY.W SpriteYPosHigh,X
    PHY
    LDY.B #$00
    CMP.B #$38                                ; Get base index (0/1) based on stun timer.
    BCC +
    INY
  + LDA.B SpriteTableC2,X
    BEQ +
    INY
    INY
    LDA.B SpriteYPosLow,X
    SEC                                       ; If vertical, switch to next set (2/3).
    SBC.B #$0C                                ; If coming from behind the net, use 3/4 instead, to reverse the animation.
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X                    ; Also, shift its position up 12 pixels too, to push it on top of the net.
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.W SpriteBehindScene,X
    BEQ +
    INY
  + LDA.W OWLevelTileSettings+$49
    BPL +
    INY                                       ; If the special world is passed, switch from 0-4 to 5-7.
    INY                                       ; Likely meant to prevent conflict from the modified Koopa graphics.
    INY
    INY
    INY
  + LDA.W DATA_01B969,Y
    STA.W SpriteMisc1602,X
    LDA.W DATA_01B973,Y
    STA.B _0
    LDA.W SpriteOBJAttribute,X                ; Use all of the above to get the proper animation frame and graphics page.
    PHA
    AND.B #$FE
    ORA.B _0
    STA.W SpriteOBJAttribute,X
    JSR SubSprGfx1                            ; Draw the sprite.
    PLA
    STA.W SpriteOBJAttribute,X
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    RTS

CODE_01B9FB:
; Koopa is not turning.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Branch if the game is frozen.
    BNE CODE_01BA53                           ; /
    JSR CODE_019140
    LDY.B SpriteTableC2,X
    LDA.W SpriteBlockedDirs,X
    AND.W DATA_01B97D,Y
    BEQ CODE_01BA14                           ; If it hits a block, reverse its direction of movement.
CODE_01BA0C:
    JSR FlipSpriteDir
    JSR CODE_01BA7F
    BRA CODE_01BA37

CODE_01BA14:
    LDA.W SprMap16TouchVertLow                ; Normal movement.
    LDY.B SpriteYSpeed,X
    BEQ CODE_01BA27
    BPL CODE_01BA1F
    BMI CODE_01BA2A
CODE_01BA1F:
    CMP.B #$07
    BCC CODE_01BA0C
    CMP.B #$1D
    BCS CODE_01BA0C                           ; If no longer touching a fence tile, set the sprite to turn around.
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
; Handle general functions.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; If the game is frozen, just draw graphics.
    BNE CODE_01BA53                           ; /
    INC.W SpriteMisc1570,X
    JSR UpdateDirection
    LDA.B SpriteTableC2,X
    BNE CODE_01BA4A
    JSR SubSprXPosNoGrvty                     ; Update direction and position.
    BRA +

CODE_01BA4A:
    JSR SubSprYPosNoGrvty
  + JSR MarioSprInteractRt                    ; Interact with Mario.
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
CODE_01BA53:
    LDA.W SpriteMisc157C,X
    PHA
    LDA.W SpriteMisc1570,X
    AND.B #$08
    LSR A
    LSR A                                     ; Climbing animation.
    LSR A
    STA.W SpriteMisc157C,X
    LDA.B SpriteProperties
    PHA
    LDA.W SpriteBehindScene,X
    STA.W SpriteMisc1602,X
    LDA.W SpriteBehindScene,X
    BEQ +
    LDA.B #!OBJ_Priority1                     ; Draw graphics.
    STA.B SpriteProperties                    ; Send behind objects if applicable.
  + JSR SubSprGfx1
    PLA
    STA.B SpriteProperties
    PLA
    STA.W SpriteMisc157C,X
    RTS

CODE_01BA7F:
    LDA.B SpriteYSpeed,X                      ; Invert Y speed.
    EOR.B #$FF
    INC A
    STA.B SpriteYSpeed,X
    RTS

InitClimbingDoor:
    LDA.B SpriteXPosLow,X                     ; Climbing door INIT
    CLC
    ADC.B #$08
    STA.B SpriteXPosLow,X                     ; Offset X/Y position to line up with the object.
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
; Unused?
; Offsets from their normal position to draw the columns for each frame of the animation.
; Number of columns to not draw for each frame of the animation.
; Tile numbers to use based on the number of columns.
; Three columns
; Two columns
; (unused)
    RTS                                       ; One column

ClimbingDoor:
; Climbing door misc RAM:
; $1540 - Timer for the turning animation.
; $154C - Timer to wait briefly after being hit before turning. Set to #$07 on hit.
; Climbing door MAIN
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LDA.W SpriteMisc154C,X
    CMP.B #$01                                ; Handle Mario preparing the fence to turn shortly after being hit.
    BNE +
    LDA.B #!SFX_FLYHIT                        ; \ Play sound effect; SFX for the door turning.
    STA.W SPCIO0                              ; /
    LDA.B #$19                                ; Erase the net object below.
    JSL GenTileFromSpr2
    LDA.B #$1F
    STA.W SpriteMisc1540,X                    ; Start the turn.
    STA.W NetDoorTimer
    LDA.B PlayerXPosNext
    SEC
    SBC.B #$10                                ; Preserve Mario's distance from the center of the net.
    SEC                                       ; Routine that uses it is at $00DB17.
    SBC.B SpriteXPosLow,X
    STA.W NetDoorPlayerXOffset
  + LDA.W SpriteMisc1540,X
    ORA.W SpriteMisc154C,X
    BNE +
    JSL GetSpriteClippingA                    ; Mark the net as hit and ready to turn if:
    JSR CODE_01BC1D                           ; Not already turning/being hit.
    JSL CheckForContact                       ; Mario is in contact.
    BCC +                                     ; Mario has punched the net.
    LDA.W PunchNetTimer
    CMP.B #$01
    BNE +
    LDA.B #$06
    STA.W SpriteMisc154C,X
  + LDA.W SpriteMisc1540,X                    ; Return (and don't draw) if not in the process of turning.
    BEQ Return01BACC
    CMP.B #$01
    BNE +
    PHA                                       ; Restore the net object below the fence if finished turning.
    LDA.B #$1A
    JSL GenTileFromSpr2
    PLA
  + CMP.B #$10
    BNE +
    LDA.W PlayerBehindNet                     ; Invert Mario's layer when halfway turned.
    EOR.B #$01
    STA.W PlayerBehindNet
; Climbing door GFX routine.
  + LDA.B #$30                                ; OAM slot for the climbing door.
    STA.W SpriteOAMIndex,X
    STA.B _3
    TAY
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X                     ; Set up some scratch RAM.
    SEC                                       ; $00 - X position
    SBC.B Layer1YPos                          ; $01 - Y position
    STA.B _1                                  ; $02 - Turn timer, divided by 2
    LDA.W SpriteMisc1540,X                    ; $06 - Number of columns to not draw.
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
    SEC                                       ; Set X positions.
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
    STA.W OAMTileYPos+$110,Y                  ; Set Y positions.
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
    STA.W OAMTileNo+$100,Y                    ; Set tile numbers.
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
    ORA.B #$09                                ; CCCT bits.
    CPX.B #$06
    BCS +
    ORA.B #$40
  + CPX.B #$00
    BEQ CODE_01BBE6                           ; Set YXPPCCCT.
    CPX.B #$03                                ; Set X bit for right column,
    BEQ CODE_01BBE6                           ; and Y bit for bottom row.
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
    LDA.B #$08                                ; Draw 9 16x16 tiles.
    JSR CODE_01B37E
    LDY.B #$0C
    PLA
    BEQ Return01BC1C
    CMP.B #$02
    BNE +
    LDA.B #$03
    STA.W OAMTileSize+$43,Y                   ; Send unused columns offscreen.
    STA.W OAMTileSize+$44,Y
    STA.W OAMTileSize+$45,Y
  + LDA.B #$03
    STA.W OAMTileSize+$46,Y
    STA.W OAMTileSize+$47,Y
    STA.W OAMTileSize+$48,Y
Return01BC1C:
    RTS

CODE_01BC1D:
; Set clipping values for Mario. Used for the rotating fence sprite.
    LDA.B PlayerXPosNext                      ; \ $00 = Mario X Low; Why they didn't just change the sprite's hitbox, who knows.
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
; Palettes for the magic to cycle through.
    LDA.B SpriteLock                          ; Magikoopa magic MAIN
    BEQ +                                     ; If the game is frozen, just draw graphics.
    JMP CODE_01BCBD

  + JSR CODE_01B14E                           ; Draw glitter.
    JSR SubSprYPosNoGrvty                     ; Update X/Y position.
    JSR SubSprXPosNoGrvty
    LDA.B SpriteYSpeed,X
    PHA
    LDA.B #$FF
    STA.B SpriteYSpeed,X                      ; Interact with blocks.
    JSR CODE_019140
    PLA
    STA.B SpriteYSpeed,X
    JSR IsTouchingCeiling
    BEQ CODE_01BCBD                           ; If offscreen or not touching a ceiling, branch to interact with sprites and draw graphics.
    LDA.W SpriteOffscreenX,X
    BNE CODE_01BCBD
    LDA.B #!SFX_BONK                          ; \ Play sound effect; SFX for the Magikoopa's magic hitting a block.
    STA.W SPCIO0                              ; /
    STZ.W SpriteStatus,X
    LDA.W SprMap16TouchVertLow
    SEC
    SBC.B #$11                                ; If not hitting tiles 111-12D, just erase it in a cloud of smoke.
    CMP.B #$1D
    BCS CODE_01BCB9
    JSL GetRand
    ADC.W RandomNumber+1
    ADC.B PlayerXSpeed+1
    ADC.B TrueFrame
    LDY.B #$78                                ; Magikoopa magic sprite spawn A (1up)
    CMP.B #$35
    BEQ +
    LDY.B #$21                                ; Magikoopa magic sprite spawn B (coin)
    CMP.B #$08
    BCC +
    LDY.B #$27                                ; Magikoopa magic sprite spawn C (Thwimp)
    CMP.B #$F7
    BCS +
    LDY.B #$07                                ; Magikoopa magic sprite spawn D (yellow Koopa)
  + STY.B SpriteNumber,X
    LDA.B #$08                                ; \ Sprite status = Normal; Turn the block into a random sprite Their chances are:
    STA.W SpriteStatus,X                      ; /; 1up: 1/256
    JSL InitSpriteTables                      ; Coin: 8/256
    LDA.B TouchBlockXPos+1                    ; \ Sprite X position = block X position; Thwimp: 9/256
    STA.W SpriteXPosHigh,X                    ; |; Koopa: 238/256
    LDA.B TouchBlockXPos                      ; |
    AND.B #$F0                                ; |
    STA.B SpriteXPosLow,X                     ; |
    LDA.B TouchBlockYPos+1                    ; /
    STA.W SpriteYPosHigh,X                    ; \ Sprite Y position = block Y position
    LDA.B TouchBlockYPos                      ; |
    AND.B #$F0                                ; |
    STA.B SpriteYPosLow,X                     ; /
    LDA.B #$02                                ; \ Block to generate = #$02
    STA.B Map16TileGenerate                   ; /; Erase the block.
    JSL GenerateTile
CODE_01BCB9:
    JSR CODE_01BD98                           ; Spawn a smoke sprite.
    RTS

CODE_01BCBD:
    JSR SubSprSpr_MarioSpr                    ; Interact with sprites/Mario.
    LDA.B TrueFrame
    LSR A
    LSR A
    AND.B #$03                                ; Get palette.
    TAY
    LDA.W MagiKoopasMagicPals,Y
    STA.W SpriteOBJAttribute,X
    JSR MagiKoopasMagicGfx                    ; Draw graphics.
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos                          ; Erase if it goes off the bottom of the screen.
    CMP.B #$E0
    BCC +
    STZ.W SpriteStatus,X
  + RTS


MagiKoopasMagicDisp:
    db $00,$01,$02,$05,$08,$0B,$0E,$0F
    db $10,$0F,$0E,$0B,$08,$05,$02,$01

MagiKoopasMagicGfx:
; X/Y offsets for the magic's tiles during the animation.
    JSR GetDrawInfoBnk1                       ; Magikoopa magic GFX routine.
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
    CLC                                       ; Set Y position for the circle.
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileYPos+$100,Y
    LDX.B _3
    LDA.B _0
    CLC                                       ; Set X position for the circle.
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileXPos+$100,Y
    LDA.B _2
    CLC
    ADC.B #$05
    AND.B #$0F
    STA.B _2                                  ; Set Y position for the square.
    TAX
    LDA.B _1
    CLC
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileYPos+$104,Y
    LDA.B _3
    CLC
    ADC.B #$05
    AND.B #$0F
    STA.B _3                                  ; Set X position for the square.
    TAX
    LDA.B _0
    CLC
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileXPos+$104,Y
    LDA.B _2
    CLC
    ADC.B #$05
    AND.B #$0F
    STA.B _2                                  ; Set Y position for the triangle.
    TAX
    LDA.B _1
    CLC
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileYPos+$108,Y
    LDA.B _3
    CLC
    ADC.B #$05
    AND.B #$0F
    STA.B _3                                  ; Set X position for the triangle.
    TAX
    LDA.B _0
    CLC
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileXPos+$108,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties                    ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    LDA.B #$88                                ; Tile number for the circle.
    STA.W OAMTileNo+$100,Y
    LDA.B #$89                                ; Tile number for the square.
    STA.W OAMTileNo+$104,Y
    LDA.B #$98                                ; Tile number for the triangle.
    STA.W OAMTileNo+$108,Y
    LDY.B #$00                                ; \ 3 8x8 tiles
    LDA.B #$02                                ; |
    JMP FinishOAMWriteRt

CODE_01BD98:
    LDY.B #$03                                ; Subroutine to spawn a smoke sprite. Used by the Magikoopa's magic.
CODE_01BD9A:
    LDA.W SmokeSpriteNumber,Y                 ; Find an empty slot.
    BEQ CODE_01BDA3
    DEY
    BPL CODE_01BD9A
    RTS

CODE_01BDA3:
    LDA.B #$01
    STA.W SmokeSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SmokeSpriteXPos,Y                   ; Spawn smoke at the sprite's position.
    LDA.B SpriteYPosLow,X
    STA.W SmokeSpriteYPos,Y
    LDA.B #$1B
    STA.W SmokeSpriteTimer,Y
    RTS

InitMagikoopa:
    LDY.B #$09                                ; Magikoopa INIT
CODE_01BDBA:
    CPY.W CurSpriteProcess
    BEQ +
    LDA.W SpriteStatus,Y                      ; Erase if another Magikoopa already exists.
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
; Magikoopa misc RAM:
; $C2   - Current phase.
; 0 = find tile, 1 = fade in, 2 = shoot magic, 3 = fade out.
; $1540 - Timer for animation.
; Set to #$04 for timing each palette change during fade-in.
; Set to #$70 for shooting the magic.
; Set to #$02 for timing each palette change during fade-out.
; $1570 - Pointer to current palette to use.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame.
; 0 = fading in, 1 = unused?, 2/3 = wand raised, 4/5 = shooting
; Magikoopa MAIN
    LDA.B #$01                                ; Disable interaction with Mario/sprites.
    STA.W SpriteOnYoshiTongue,X
    LDA.W SpriteOffscreenX,X
    BEQ +                                     ; If offscreen, search for a new spot.
    STZ.B SpriteTableC2,X
  + LDA.B SpriteTableC2,X
    AND.B #$03
    JSL ExecutePtr

    dw CODE_01BDF2
    dw CODE_01BE5F
    dw CODE_01BE6E
    dw CODE_01BF16

CODE_01BDF2:
; Magikoopa pointers.
; 0 - Find spot
; 1 - Fade in
; 2 - Shoot magic
; 3 - Fade out
    LDA.W SpriteWillAppear                    ; Magikoopa phase 0 - Find spot.
    BEQ +                                     ; Erase the sprite if sprite D2 is present.
    STZ.W SpriteStatus,X
    RTS

  + LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    LDY.B #$24                                ; Return if:
    STY.B ColorSettings                       ; Game frozen.
    LDA.W SpriteMisc1540,X                    ; Stun timer is set?
    BNE +                                     ; RNG would put it offscreen.
    JSL GetRand
    CMP.B #$D1
    BCS +
    CLC
    ADC.B Layer1YPos
    AND.B #$F0
    STA.B SpriteYPosLow,X                     ; Give a random Y position.
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    JSL GetRand
    CLC
    ADC.B Layer1XPos
    AND.B #$F0                                ; Give a random X position.
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    JSR SubHorizPos
    LDA.B _F
    CLC
    ADC.B #$20
    CMP.B #$40                                ; Return if:
    BCC +                                     ; Within two tiles of Mario.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Not on the ground.
    LDA.B #$01                                ; Inside a block.
    STA.B SpriteXSpeed,X
    JSR CODE_019140
    JSR IsOnGround
    BEQ +
    LDA.W SprMap16TouchHorizHigh
    BNE +
    INC.B SpriteTableC2,X
    STZ.W SpriteMisc1570,X                    ; Move to next phase.
    JSR CODE_01BE82
    JSR SubHorizPos
    TYA                                       ; Face Mario.
    STA.W SpriteMisc157C,X
  + RTS

CODE_01BE5F:
; Magikoopa phase 1 - Fade in.
    JSR CODE_01C004                           ; Fade palette in.
    STZ.W SpriteMisc1602,X                    ; Draw graphics.
    JSR SubSprGfx1
    RTS


DATA_01BE69:
    db $04,$02,$00

DATA_01BE6C:
    db $10,$F8

CODE_01BE6E:
; Frames for the Magikoopa's shooting animation. Third byte is unused.
; Also includes the following frame (i.e. 4/5, 2/3).
; X offsets for positioning the Magikoopa's wand.
; Magikoopa phase 2 - Shoot magic.
    STZ.W SpriteOnYoshiTongue,X               ; Reenable Mario/sprite interaction.
    JSR SubSprSpr_MarioSpr
    JSR SubHorizPos
    TYA                                       ; Face Mario.
    STA.W SpriteMisc157C,X
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X                     ; If the stun timer has run out, move to next phase and make sprites transparent.
CODE_01BE82:
    LDY.B #$34
    STY.B ColorSettings
  + CMP.B #$40
    BNE CODE_01BE96
    PHA                                       ; If:
    LDA.B SpriteLock                          ; The stun timer reaches #$40
    ORA.W SpriteOffscreenX,X                  ; The game is not frozen
    BNE +                                     ; The Magikoopa is onscreen
    JSR CODE_01BF1D                           ;JUMP TO GENERATE MAGIC; Then spawn magic.
  + PLA
CODE_01BE96:
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    TAY                                       ; Set animation frame.
    PHY
    LDA.W SpriteMisc1540,X
    LSR A
    LSR A
    LSR A
    AND.B #$01
    ORA.W DATA_01BE69,Y
    STA.W SpriteMisc1602,X
    JSR SubSprGfx1                            ; Draw graphics.
    LDA.W SpriteMisc1602,X
    SEC
    SBC.B #$02
    CMP.B #$02
    BCC +
    LSR A                                     ; Make the Magikoopa "laugh" after shooting by shifting up and down.
    BCC +
    LDA.W SpriteOAMIndex,X
    TAX
    INC.W OAMTileYPos+$100,X
    LDX.W CurSpriteProcess                    ; X = Sprite index
  + PLY
    CPY.B #$01                                ; Draw glitter on the Magikoopa while his wand is raised.
    BNE +
    JSR CODE_01B14E
  + LDA.W SpriteMisc1602,X
    CMP.B #$04                                ; Return if the Magikoopa hasn't shot yet.
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
    CLC                                       ; If in frame 04/05, add the Magikoopa's wand.
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
    LDA.B #$99                                ; Tile to use for the Magikoopa's wand.
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
; Magikoopa phase 3 - Fade out.
    JSR CODE_01BFE3                           ; Fade palette out.
    JSR SubSprGfx1                            ; Draw graphics.
    RTS

CODE_01BF1D:
    LDY.B #$09                                ; Routine to aim and spawn magic.
CODE_01BF1F:
    LDA.W SpriteStatus,Y                      ; Find an empty sprite slot, and return if none found.
    BEQ CODE_01BF28
    DEY
    BPL CODE_01BF1F
    RTS

CODE_01BF28:
    LDA.B #!SFX_MAGIC                         ; \ Play sound effect; SFX for shooting magic.
    STA.W SPCIO0                              ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$20                                ;GENERATES MAGIC HERE!   !@#; Sprite to spawn (magic).
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    CLC                                       ; Spawn at the Magikoopa's position.
    ADC.B #$0A
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    TYX
    JSL InitSpriteTables
    LDA.B #$20                                ; Speed to give the magic.
    JSR CODE_01BF6A
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _0                                  ;PULLS SPEED FROM RAM HERE?; Set X and Y speed.
    STA.W SpriteYSpeed,Y
    LDA.B _1
    STA.W SpriteXSpeed,Y
    RTS

CODE_01BF6A:
; Aiming routine for the Magikooa's magic.
    STA.B _1                                  ;FILLS OUT RAM TO USE FOR SPEED?; Input: A = desired magnitude of the final speed vector, X = sprite slot to aim from.
    PHX                                       ; Output: $00 = X speed, $01 = Y speed
    PHY
    JSR CODE_01AD42
    STY.B _2
    LDA.B _E
    BPL +
    EOR.B #$FF
    CLC
    ADC.B #$01
; $02 = Vertical direction
  + STA.B _C                                  ; $03 = Horizontal direction
    JSR SubHorizPos                           ; $0C = Absolute vertical distance
    STY.B _3                                  ; $0D = Absolute horizontal distance.
    LDA.B _F
    BPL +
    EOR.B #$FF
    CLC
    ADC.B #$01
  + STA.B _D
    LDY.B #$00
    LDA.B _D
    CMP.B _C
    BCS +                                     ; If further away horizontally than vertically, swap $0C/$0D
    INY                                       ; (so that the shorter distance is in $0C).
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
    ADC.B _C                                  ; $00 = ($0C * $01) / $0D
    CMP.B _D                                  ; $0B = ($0C * $01) % $0D
    BCC +
    SBC.B _D                                  ; Essentially, this does a ratio of the vertical and horizontal distances,
    INC.B _0                                  ; then scales the base speed using that ratio.
  + STA.B _B
    DEX
    BNE CODE_01BFA7
    TYA
    BEQ +
    LDA.B _0
    PHA                                       ; If $0C/$0D were swapped before,
    LDA.B _1                                  ; swap $00/$01.
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
  + LDA.B _1                                  ; Invert $00/$01 if Mario is to the left/above.
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
    LDA.W SpriteMisc1540,X                    ; Fade the Magikoopa's palette out.
    BNE Return01C000                          ; Only update the palette every 2 frames.
    LDA.B #$02
    STA.W SpriteMisc1540,X
    DEC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$00
    BNE +                                     ; Decrease palette.
    INC.B SpriteTableC2,X                     ; If at 0, move to next phase.
    LDA.B #$10
    STA.W SpriteMisc1540,X
    PLA
    PLA
Return01C000:
    RTS

  + JMP CODE_01C028                           ; ...kinda a pointless jump.

CODE_01C004:
    LDA.W SpriteMisc1540,X                    ; Fade the Magikoopa's palette in.
    BNE CODE_01C05E                           ; Only update every 4 frames.
    LDA.B #$04
    STA.W SpriteMisc1540,X
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$09
    BNE +
    LDY.B #$24                                ; Increase palette.
    STY.B ColorSettings                       ; If at max (09), move to next phase. (the branches are a bit weird here...)
  + CMP.B #$09
    BNE CODE_01C028
    INC.B SpriteTableC2,X
    LDA.B #$70                                ; Timer for shooting magic.
    STA.W SpriteMisc1540,X
    RTS

CODE_01C028:
    LDA.W SpriteMisc1570,X                    ; Actually update the Magikoopa's palette.
    DEC A
    ASL A
    ASL A
    ASL A
    ASL A
    TAX
    STZ.B _0
    LDY.W DynPaletteIndex                     ; Store color values to the upload table.
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
    STA.W DynPaletteTable,X                   ; Set location and size: x10 colors starting at F0.
    LDA.B #$F0
    STA.W DynPaletteTable+1,X
    STZ.W DynPaletteTable+$12,X
    TXA
    CLC                                       ; Update dynamic palettes index.
    ADC.B #$12
    STA.W DynPaletteIndex
CODE_01C05E:
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

    JSR InitGoalTape                          ; \ Unreachable; Unused. Some kind of raised goal tape?
    LDA.B SpriteYPosLow,X                     ; | Call Goal Tape INIT, then
    SEC                                       ; | Sprite Y position -= #$4C
    SBC.B #$4C                                ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    SBC.B #$00                                ; |
    STA.W SpriteYPosHigh,X                    ; |
    RTS                                       ; /

InitGoalTape:
    LDA.B SpriteXPosLow,X                     ; Goal tape INIT.
    SEC
    SBC.B #$08                                ; X offset of the goal tape's hitbox.
    STA.B SpriteTableC2,X
    LDA.W SpriteXPosHigh,X
    SBC.B #$00
    STA.W SpriteMisc151C,X                    ; Set the position of the goal tape's hitbox.
    LDA.B SpriteYPosLow,X                     ; Also preserve whether the tape is a normal or secret exit.
    STA.W SpriteMisc1528,X
    LDA.W SpriteYPosHigh,X                    ; \ Save extra bits into $187B,x
    STA.W SpriteMisc187B,X                    ; /
    AND.B #$01                                ; \ Clear extra bits out of position
    STA.W SpriteYPosHigh,X                    ; /
    STA.W SpriteMisc1534,X
    RTS

GoalTape:
; Goal tape misc RAM:
; $C2   - X position of the tape's hitbox (low)
; $151C - X position of the tape's hitbox (high)
; $1528 - Y position of the tape's hitbox (low)
; $1534 - Y position of the tape's hitbox (high)
; $1540 - Timer for changing directions. Set to #$7C at each turn.
; Also used as a timer (#$80) for the stars after hitting the goal tape.
; $1594 - Relative Y position the tape was hit at.
; $1602 - Set to 01 when the goal is crossed.
; $160E - Set to 01 when the actual tape is hit.
; $187B - Goal type. #$00-#$03 = normal, #$04-#$07 = secret, #$08-#$0B = submap warp, #$0C+ = glitched
; Goal tape MAIN.
    JSR CODE_01C12D                           ; Draw the goal tape.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; If the game is frozen, return.
    BNE Return01C0A4                          ; /
    LDA.W SpriteMisc1602,X                    ; If the goal tape hasn't been hit already, branch.
    BEQ +
Return01C0A4:
    RTS


DATA_01C0A5:
    db $10,$F0

; Movement speeds for the goal tape.
  + LDA.W SpriteMisc1540,X                    ; Goal tape hasn't been hit yet.
    BNE +
    LDA.B #$7C                                ; How long before the goal tape changes direction.
    STA.W SpriteMisc1540,X
    INC.W SpriteBlockedDirs,X
  + LDA.W SpriteBlockedDirs,X
    AND.B #$01
    TAY                                       ; Update Y speed.
    LDA.W DATA_01C0A5,Y
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty                     ; Update position.
    LDA.B SpriteTableC2,X
    STA.B _0
    LDA.W SpriteMisc151C,X
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    SEC                                       ; If Mario is not touching the tape horizontally, return.
    SBC.B _0
    CMP.W #$0010                              ; Width of the tape's hitbox.
    SEP #$20                                  ; A->8
    BCS Return01C12C
    LDA.W SpriteMisc1528,X
    CMP.B PlayerYPosNext
    LDA.W SpriteMisc1534,X                    ; If Mario is below the goal tape, return.
    AND.B #$01
    SBC.B PlayerYPosNext+1
    BCC Return01C12C
    LDA.W SpriteMisc187B,X                    ; \ $141C = #01 if Goal Tape triggers secret exit
    LSR A                                     ; |; Set secret exit flag for the goal tape if applicable.
    LSR A                                     ; |
    STA.W SecretGoalTape                      ; /
    LDA.B #!BGM_LEVELCLEAR                    ; SFX for the goal tape/level end music.
    STA.W SPCIO2                              ; / Change music
    LDA.B #$FF
    STA.W MusicBackup
    LDA.B #$FF                                ; Set the end level timer.
    STA.W EndLevelTimer
    STZ.W InvinsibilityTimer                  ; Zero out star timer; Clear the star timer.
    INC.W SpriteMisc1602,X
    JSR MarioSprInteractRt                    ; Branch if the actual tape was not touched (and thus no bonus stars given).
    BCC CODE_01C125
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect; SFX for breaking the goal tape.
    STA.W SPCIO3                              ; /
    INC.W SpriteMisc160E,X
    LDA.W SpriteMisc1528,X
    SEC                                       ; Keep track of how high the tape was when hit.
    SBC.B SpriteYPosLow,X
    STA.W SpriteMisc1594,X
    LDA.B #$80                                ; How many frames the bonus star counter stays on screen.
    STA.W SpriteMisc1540,X
    JSL CODE_07F252                           ; Count bonus stars to give Mario (and 3up if giving 50).
    BRA +                                     ; Trigger the tape.

CODE_01C125:
; No bonus stars given.
    STZ.W SpriteTweakerE,X                    ; Let the tape turn into a coin.
  + JSL TriggerGoalTape                       ; Trigger goal tape.
Return01C12C:
    RTS

CODE_01C12D:
; Goal tape GFX routine.
    LDA.W SpriteMisc160E,X                    ; Branch if the goal tape has been hit.
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
    LDA.B _1                                  ; Upload three 8x8s to OAM.
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    STA.W OAMTileYPos+$108,Y
    LDA.B #$D4                                ; 16x8 tile to use for the goal tape.
    STA.W OAMTileNo+$100,Y
    INC A
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$108,Y
    LDA.B #$32                                ; YXPPCCCT for the goal tape.
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    LDY.B #$00
    LDA.B #$02
    JMP FinishOAMWriteRt

; Goal tape has been hit.
  + LDA.W SpriteMisc1540,X                    ; If done drawing bonus star digits, erase the sprite.
    BEQ +
    JSL CODE_07F1CA                           ; Draw the bonus star digits.
    RTS

  + STZ.W SpriteStatus,X
    RTS

GrowingVine:
; Growing vine misc RAM:
; $1540 - Timer for going behind objects after being spawned from a block. Set to #$3E when spawned from a block.
; $154C - Set to #$2C when spawned from a block.
    LDA.B SpriteProperties                    ; Growing vine MAIN.
    PHA
    LDA.W SpriteMisc1540,X
    CMP.B #$20
    BCC +                                     ; If spawned from a block, send behind objects.
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + JSR SubSprGfx2Entry1                      ; Set up OAM.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A                                     ; Set tile based on frame.
    LSR A
    LDA.B #$AC                                ; Vine frame A.
    BCC +
    LDA.B #$AE                                ; Vine frame B.
  + STA.W OAMTileNo+$100,Y
    PLA
    STA.B SpriteProperties
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if game frozen.
    BNE Return01C1ED                          ; /
    LDA.B #$F0                                ; Vine's Y speed.
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty                     ; Update position.
    LDA.W SpriteMisc1540,X
    CMP.B #$20                                ; Don't interact with objects while being spawned from a block.
    BCS CODE_01C1CB
    JSR CODE_019140                           ; Interact with blocks.
    LDA.W SpriteBlockedDirs,X
    BNE CODE_01C1C8
    LDA.W SpriteYPosHigh,X                    ; Erase the vine if it hit a block or it's off the top of the level.
    BPL CODE_01C1CB
CODE_01C1C8:
    JMP OffScrEraseSprite

CODE_01C1CB:
    LDA.B SpriteYPosLow,X                     ; Spawn a vine tile beneath the sprite.
    AND.B #$0F                                ; Return if not centered on a tile.
    CMP.B #$00
    BNE Return01C1ED
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position
    STA.B TouchBlockXPos                      ; | for block creation
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position
    STA.B TouchBlockYPos                      ; | for block creation; Spawn the tile.
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
; Accelerations for the flying sprites.
; Max speeds for the flying sprites.
; Flying sprite misc RAM:
; $C2   - If non-zero, only shows wings. If specifically #$02, also makes it sparkle, and if sprite 7E, also send Yoshi to the bonus game.
; Only actually used for Yoshi wings, but works for all others too.
; $151C - Direction of vertical acceleration. Even = up, odd = down.
; $1540 - Never set, but code is implemented to use this as a timer for rising the P-balloon out of blocks.
; $1570 - Frame counter for the wings animation. Still updated in the P-balloon despite not being used.
; $157C - Indicates the sprite is a P-balloon.
    LDA.W SpriteStatus,X                      ; Flying sprite MAIN (P-balloon MAIN, wings MAIN, flying key/1up/red coin)
    CMP.B #$0C
    BEQ CODE_01C255                           ; Branch if in powerup state from the goal tape or sprites are locked.
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01C255                           ; /
    LDA.B SpriteNumber,X
    CMP.B #$7D
    BNE +
    LDA.W SpriteMisc1540,X
    BEQ +
    LDA.B SpriteProperties                    ; Unused code that just always branches to the next.
    PHA
    LDA.B #!OBJ_Priority1                     ; Would have been used for making the P-balloon rise out of blocks.
    STA.B SpriteProperties
    JSR CODE_01C61A
    PLA
    STA.B SpriteProperties
    LDA.B #$F8
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
    RTS

  + LDA.B TrueFrame
    AND.B #$01                                ; Change vertical acceleration every other frame.
    BNE +
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X                      ; Update acceleration.
    CLC
    ADC.W DATA_01C1EE,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_01C1F0,Y
    BNE +                                     ; If at max Y speed, change direction.
    INC.W SpriteMisc151C,X
  + LDA.B #$0C                                ; Flying sprites X speed.
    STA.B SpriteXSpeed,X
    JSR SubSprXPosNoGrvty                     ; Update X position.
    LDA.B SpriteYSpeed,X
    PHA
    CLC                                       ; Decrease Y speed, to make the balloon "rise" slightly.
    SEC
    SBC.B #$02
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty                     ; Update sprite Y position.
    PLA                                       ; ...And restore Y speed afterwards.
    STA.B SpriteYSpeed,X
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    INC.W SpriteMisc1570,X                    ; Increase frame counter.
CODE_01C255:
    LDA.B SpriteNumber,X
    CMP.B #$7D
    BNE CODE_01C262                           ; Don't draw wings if P-balloon.
    LDA.B #$01
    STA.W SpriteMisc157C,X
    BRA CODE_01C27F

CODE_01C262:
    LDA.B SpriteTableC2,X                     ; Handles winged sprites, including the Yoshi wings as part of sprite 7E.
    CMP.B #$02                                ; If Yoshi wings, make them sparkle.
    BNE CODE_01C27C
    LDA.B TrueFrame
    AND.B #$03                                ; Every 4th frame, display a glitter effect.
    BNE +                                     ; [note: branch is actually useless]
    JSR CODE_01B14E
  + LDA.B EffFrame
    LSR A                                     ; Would cause the sprite to flip through every palette, but since there
    AND.B #$0E                                ; isn't any actual sprite being drawn, it seems to be useless.
    EOR.W SpriteOBJAttribute,X
    STA.W SpriteOBJAttribute,X
CODE_01C27C:
    JSR CODE_019E95                           ; Draw wings.
CODE_01C27F:
    LDA.B SpriteTableC2,X                     ; If the sprite state is non-zero, then return with only the wings drawn.
    BEQ +
    JSR GetDrawInfoBnk1                       ; (useless?)
    RTS

; Other winged sprites/P-balloon continue here.
  + JSR CODE_01C61A                           ; Draw GFX.
    JSR MarioSprInteractRt                    ; Return if Mario isn't in contact.
    BCC Return01C2D2
    LDA.B SpriteNumber,X
    CMP.B #$7E                                ; Branch if not sprite 7E (flying red coin).
    BNE CODE_01C2A6
    JSR CODE_01C4F0                           ; Display glitter when collected.
    LDA.B #$05                                ; How many coins the flying red coin gives (5).
    JSL ADDR_05B329
    LDA.B #$03                                ; How many points the flying red coin gives (800).
    JSL GivePoints
    BRA ADDR_01C30F                           ; Erase the sprite.

CODE_01C2A6:
; Sprite 7F (flying 1up).
    CMP.B #$7F                                ; Branch if not sprite 7F.
    BNE CODE_01C2AF
    JSR GiveMario1Up                          ; Give Mario a 1up.
    BRA ADDR_01C30F                           ; Erase the sprite.

CODE_01C2AF:
; Sprite 80 (flying key).
    CMP.B #$80                                ; Branch if not sprite 80.
    BNE CODE_01C2CE
    LDA.B PlayerYSpeed+1                      ; Return if Mario is moving upward.
    BMI Return01C2D2
    LDA.B #$09                                ; \ Sprite status = Carryable; Make carryable.
    STA.W SpriteStatus,X                      ; /
    LDA.B #$D0                                ; Bounce Mario.
    STA.B PlayerYSpeed+1
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    STZ.W SpriteMisc1540,X                    ; Clear the key's Y speed and stun timer, then
    LDA.W SpriteTweakerD,X                    ; \ Use default interation with Mario; set to use default Mario interaction.
    AND.B #$7F                                ; |
    STA.W SpriteTweakerD,X                    ; /
    RTS

CODE_01C2CE:
    CMP.B #$7D
    BEQ +                                     ; If not sprite 7D, just return.
Return01C2D2:
    RTS                                       ; (not that anything else can get here)

  + LDY.B #$0B                                ; Sprite 7D (P-balloon)
CODE_01C2D5:
    LDA.W SpriteStatus,Y
    CMP.B #$0B
    BNE +                                     ; If Mario already has a P-balloon, reset that one?
    LDA.W SpriteNumber,Y                      ; (see $019560 for carryable routine)
    CMP.B #$7D                                ; Seems useless?
    BEQ +
    LDA.B #$09                                ; \ Sprite status = Carryable; Also see $019FA3 for carried routine.
    STA.W SpriteStatus,Y                      ; /
  + DEY
    BPL CODE_01C2D5
    LDA.B #$00
    LDY.W PBalloonInflating
    BNE +                                     ; Decide whether to erase this P-balloon or give it to Mario,
    LDA.B #$0B                                ; \ Sprite status = Being carried; depending on whether he already has one.
  + STA.W SpriteStatus,X                      ; /
    LDA.B PlayerYSpeed+1
    STA.B SpriteYSpeed,X                      ; Connect the sprite to Mario.
    LDA.B PlayerXSpeed+1
    STA.B SpriteXSpeed,X
    LDA.B #$09
    STA.W PBalloonInflating                   ; Start the inflation animation.
    LDA.B #$FF
    STA.W PBalloonTimer
    LDA.B #!SFX_PBALLOON                      ; \ Play sound effect; SFX for inflating.
    STA.W SPCIO0                              ; /
    RTS

ADDR_01C30F:
    STZ.W SpriteStatus,X
    RTS


ChangingItemSprite:
    db $74,$75,$77,$76

ChangingItem:
; Roulette block sprite table.
; Roulette sprite misc RAM:
; $C2   - Flag for whether the sprite is stationary in the block (#$01) or bouncing out of it (#$00).
; $151C - Used to indicate a powerup is from the roulette block. Always #$01.
; $154C - Set after being hit out of a block.
; $1558 - Timer to disable interaction with the sides of blocks. Set when hit out of a block.
; $1570 - Frame counter for the powerups' codes, not actually used by the roulette.
; $157C - Horizontal direction the sprite is facing. Always 0.
; $187B - Timer for changing the sprite. The sprite changes every #$40 ticks.
    LDA.B #$01                                ; Roulette block MAIN
    STA.W SpriteMisc151C,X
    LDA.W SpriteOnYoshiTongue,X
    BNE +                                     ; Don't change sprite if on Yoshi's tongue.
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
    LSR A                                     ; |; Turn into the appropriate sprite and run powerup codes.
    AND.B #$03                                ; |
    TAY                                       ; |
    LDA.W ChangingItemSprite,Y                ;  /
    STA.B SpriteNumber,X                      ; \ Change into the appropriate power up
    JSL LoadSpriteTables                      ; /
    JSR PowerUpRt                             ; Run the power up code
    LDA.B #$81                                ; \ Change it back to the turning item
    STA.B SpriteNumber,X                      ; |; Restore the sprite.
    JSL LoadSpriteTables                      ; /
    RTS


EatenBerryGfxProp:
    db $02,$02,$04,$06

FireFlower:
; YXPPCCCT properties for the different berries. First is unused.
; Powerup misc RAM:
; $C2   - Flag for whether the sprite is moving (0) or stationary (1). If the high bit is set, prevents the sprite from ever moving.
; $151C - Indicates the powerup is the roulette sprite.
; $1528 - Direction of the feather's acceleration. Even = left, odd = right.
; If set while rising from a ? block, prevents it from going behind objects (used by the flying ? block).
; $1534 - Flag for having been dropped from the item box. Set for all items, but not used in feathers.
; $1540 - Timer for rising out of the item box. Set to #$3E at the start.
; $154C - Timer for disabling contact with Mario. Set to #$2C when spawned from item boxes.
; $1558 - Timer to prevent interaction with the sides of blocks. Only ever used by the roulette sprite, after being hit out of the block.
; $1570 - Frame counter for the fire flower's animation.
; $157C - Horizontal direction the sprite is facing.
; $1594 - Unused, but can be used to change the number of lives a 1up gives (00 = 1, 01 = 2, 02 = 3, 03 = 5)
; $160E - If set, turns the sprite into a berry.
    LDA.B EffFrame                            ; \ Flip flower every 8 frames; Fireflower MAIN
    AND.B #$08                                ; |
    LSR A                                     ; |; X flip every 8 frames.
    LSR A                                     ; |
    LSR A                                     ; | ($157C,x = 0 or 1)
    STA.W SpriteMisc157C,X                    ; /
PowerUpRt:
; Generic powerup MAIN (fireflower, mushroom, 1up, star, roulette, coin)
    LDA.W SpriteMisc160E,X                    ; Turn into a berry if $160E is set.
    BEQ +
; Berry sprite.
    JSR SubSprGfx2Entry1                      ; Draw a 16x16.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$80                                ; \ Set berry tile to OAM; Tile to use for the berry.
    STA.W OAMTileNo+$100,Y                    ; /
    PHX                                       ; \ Set gfx properties of berry
    LDX.W EatenBerryType                      ; | X = type of berry being eaten
    %LorW_X(LDA,EatenBerryGfxProp)            ; |
    ORA.B SpriteProperties                    ; |; Set YXPPCCCT based on berry color.
    STA.W OAMTileAttr+$100,Y                  ; /
    PLX                                       ; X = sprite index
    RTS

  + LDA.B SpriteProperties                    ; Not a berry; check if dropped from item box.
    PHA
    JSR CODE_01C4AC                           ; Process interaction with Mario.
    LDA.W SpriteMisc1534,X                    ; Branch if not dropped from the item box.
    BEQ CODE_01C38F
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    LDA.B #$10                                ; Y speed to fall with.
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
  + LDA.B EffFrame
    AND.B #$0C                                ; Make the sprite flash.
    BNE CODE_01C3AB
    PLA
    RTS

CODE_01C38F:
; Not from item box; check if rising out of a ? block.
    LDA.W SpriteMisc1540,X                    ; Branch if not rising from a block.
    BEQ CODE_01C3AE
    JSR CODE_019140                           ; Process object interaction for some reason.
    LDA.W SpriteMisc1528,X
    BNE +                                     ; Send behind objects, unless spawned from a flying ? block.
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01C3AB                           ; /
    LDA.B #$FC                                ; Y speed to rise with.
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
CODE_01C3AB:
    JMP CODE_01C48D                           ; Draw graphics.

CODE_01C3AE:
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Not from block; normal sprite routine.
    BNE CODE_01C3AB                           ; /
    LDA.W SpriteStatus,X                      ; Just draw graphics if game frozen or spawned from goal tape.
    CMP.B #$0C
    BEQ CODE_01C3AB
    LDA.B SpriteNumber,X
    CMP.B #$76                                ; \ Useless code, branch nowhere if not a star; Useless.
    BNE +                                     ; /
  + INC.W SpriteMisc1570,X
    JSR CODE_018DBB                           ; Set X speed.
    LDA.B SpriteNumber,X
    CMP.B #$75                                ; flower
    BNE +                                     ; Clear X speed if fireflower and not from the roulette block.
    LDA.W SpriteMisc151C,X
    BNE +
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
  + CMP.B #$76                                ; star
    BEQ +
    CMP.B #$21                                ; sprite coin; Double X speed for mushrooms.
    BEQ +                                     ; (not for star/coin/roulette).
    LDA.W SpriteMisc151C,X
    BNE +
    ASL.B SpriteXSpeed,X
  + LDA.B SpriteTableC2,X                     ; Branch if moving.
    BEQ CODE_01C3F3
    BMI +
    JSR CODE_019140
    LDA.W SpriteBlockedDirs,X                 ; If not locked in place (from flying ? block) and no longer on the ground, start moving.
    BNE +
    STZ.B SpriteTableC2,X
  + BRA CODE_01C437                           ; Skip movement code.

CODE_01C3F3:
    LDA.W IRQNMICommand                       ; Sprite is not stationary.
    CMP.B #$C1                                ; Branch unless in level mode #$C0?
    BEQ CODE_01C42C                           ; i.e.  Reznor/Morton/Roy boss rooms? which don't have powerups?
    BIT.W IRQNMICommand
    BVC CODE_01C42C
    STZ.W SpriteBlockedDirs,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.W SpriteYPosHigh,X
    BNE +
    LDA.B SpriteYPosLow,X
    CMP.B #$A0
    BCC +                                     ; Move horizontally if on the floor of the boss room.
    AND.B #$F0                                ; Else, clear X speed.
    STA.B SpriteYPosLow,X
    LDA.W SpriteBlockedDirs,X
    ORA.B #$04
    STA.W SpriteBlockedDirs,X
    JSR CODE_018DBB
  + JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
    INC.B SpriteYSpeed,X                      ; ...apply gravity?
    INC.B SpriteYSpeed,X
    INC.B SpriteYSpeed,X
    BRA +

CODE_01C42C:
; Not in Reznor/Morton/Roy's boss room.
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
  + LDA.B TrueFrame
    AND.B #$03                                ; Adjust fall speed slightly.
    BEQ CODE_01C437
    DEC.B SpriteYSpeed,X
CODE_01C437:
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR IsTouchingCeiling
    BEQ +                                     ; Clear Y speed if hitting a ceiling.
    LDA.B #$00
    STA.B SpriteYSpeed,X
  + JSR IsOnGround
    BNE CODE_01C44A                           ; Skip Y speed handler if in air.
    BRA CODE_01C47E

CODE_01C44A:
    LDA.B SpriteNumber,X                      ; Set Y speed on the ground.
    CMP.B #$21                                ; sprite coin; Branch if not a coin.
    BNE CODE_01C46C
    JSR CODE_018DBB                           ; Set X speed.
    LDA.B SpriteYSpeed,X
    INC A
    PHA
    JSR SetSomeYSpeed__
    PLA
    LSR A                                     ; Give coin standard Y speed.
    JSR CODE_01CCEC                           ; (adjust it a bit weirdly when on Layer 2...)
    CMP.B #$FC
    BCS +
    LDY.W SpriteBlockedDirs,X
    BMI +
    STA.B SpriteYSpeed,X
  + BRA CODE_01C47E

CODE_01C46C:
    JSR SetSomeYSpeed__                       ; Set ground Y speed for non-coin powerups.
    LDA.W SpriteMisc151C,X
    BNE CODE_01C47A
    LDA.B SpriteNumber,X
    CMP.B #$76                                ; star; Give standard Y speed if not star/roulette, else make it bounce.
    BNE CODE_01C47E
CODE_01C47A:
    LDA.B #$C8                                ; Bounce Y speed for star/roulette sprite.
    STA.B SpriteYSpeed,X
CODE_01C47E:
    LDA.W SpriteMisc1558,X                    ; All powerups meet back up.
    ORA.B SpriteTableC2,X                     ; If moving and touching the side of an object,
    BNE CODE_01C48D                           ; or if the roulette sprite after first coming out of its block,
    JSR IsTouchingObjSide                     ; flip the sprite's direction.
    BEQ CODE_01C48D
    JSR FlipSpriteDir
CODE_01C48D:
    LDA.W SpriteMisc1540,X
    CMP.B #$36                                ; Don't draw for a few frames after spawning from a block.
    BCS CODE_01C4A8
    LDA.B SpriteTableC2,X
    BEQ CODE_01C49C
    CMP.B #$FF
    BNE CODE_01C4A1
CODE_01C49C:
    LDA.W SpriteBehindScene,X                 ; If stationary or set to go behind scenery, draw behind objects.
    BEQ +
CODE_01C4A1:
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + JSR CODE_01C61A                           ; Draw GFX.
CODE_01C4A8:
    PLA
    STA.B SpriteProperties
  - RTS

CODE_01C4AC:
    JSR CODE_01A80F                           ; Generic powerup interaction routine (including coin).
    BCC -
    LDA.W SpriteMisc151C,X
    BEQ CODE_01C4BA                           ; Return if:
    LDA.B SpriteTableC2,X                     ; Mario isn't in contact with the powerup.
    BNE Return01C4FA                          ; It's a roulette sprite still in the block.
CODE_01C4BA:
; Contact is disabled with Mario.
    LDA.W SpriteMisc154C,X                    ; Powerup is rising out of a block.
    BNE Return01C4FA
CODE_01C4BF:
    LDA.W SpriteMisc1540,X                    ; Else, interact with the powerup.
    CMP.B #$18
    BCS Return01C4FA
    STZ.W SpriteStatus,X                      ; Erase sprite.
    LDA.B SpriteNumber,X
    CMP.B #$21                                ; Branch if not a moving coin.
    BNE TouchedPowerUp
    JSL CODE_05B34A                           ; Give a coin.
    LDA.W SpriteOBJAttribute,X
    AND.B #$0E
    CMP.B #$02                                ; Give an appropriate amount of points.
    BEQ CODE_01C4E0
    LDA.B #$01                                ; Points to give for a normal coin.
    BRA +

CODE_01C4E0:
    LDA.W SilverCoinsCollected
    INC.W SilverCoinsCollected
    CMP.B #$0A                                ; Maximum points to give for a silver coin.
    BCC +
    LDA.B #$0A
  + JSL GivePoints
CODE_01C4F0:
    LDY.B #$03
CODE_01C4F2:
    LDA.W SmokeSpriteNumber,Y                 ; Find an empty smoke sprite slot to put glitter in.
    BEQ CODE_01C4FB
    DEY
    BPL CODE_01C4F2
Return01C4FA:
    RTS

CODE_01C4FB:
    LDA.B #$05
    STA.W SmokeSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SmokeSpriteXPos,Y                   ; Spawn glitter at the sprite's position.
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
; Items to put in the item box when Mario collects a powerup, indexed by his status and the sprite ID.
; Mushroom
; Flower
; Star
; Feather
; 1up
; Pointers to powerup transformations for each powerup collected.
; Mushroom
; Flower
; Star
; Feather
; 1up
    SEC                                       ; \ Index created from...; Routine to decide what to do when a powerup is touched or eaten. Usage: sprite ID in A.
    SBC.B #$74                                ; | ... powerup touched (upper 2 bits)
    ASL A                                     ; |
    ASL A                                     ; |
    ORA.B Powerup                             ; | ... Mario's status (lower 3 bits); Get the sprite to put in the item box, if applicable.
    TAY                                       ; /
    LDA.W ItemBoxSprite,Y                     ; \ Put appropriate item in item box
    BEQ +                                     ; |
    STA.W PlayerItembox                       ; /
    LDA.B #!SFX_ITEMRESERVED                  ; \; SFX to play when Mario receives a powerup in the item box.
    STA.W SPCIO3                              ; / Play sound effect
  + LDA.W GivePowerPtrIndex,Y                 ; \ Call routine to change Mario's status
    JSL ExecutePtr                            ; /

    dw GiveMarioMushroom                      ; 0 - Big
    dw CODE_01C56F                            ; 1 - No change
    dw GiveMarioStar                          ; 2 - Star
    dw GiveMarioCape                          ; 3 - Cape
    dw GiveMarioFire                          ; 4 - Fire
    dw GiveMario1Up                           ; 5 - 1Up 13

; Powerup routine pointers (specifically, the "give powerup" part).
; 00 - Big
; 01 - Do nothing (give points)
; 02 - Star
; 03 - Cape
; 04 - Fireflower
    RTS                                       ; 05 - 1up

GiveMarioMushroom:
    LDA.B #$02                                ; \ Set growing action; Routine to handle giving Mario a mushroom.
    STA.B PlayerAnimation                     ; /
    LDA.B #$2F                                ; \; How many frames the mushroom powerup animation lasts.
if ver_is_japanese(!_VER)                     ;\======================== J ====================
    STA.W PlayerAniTimer                      ;! | Set animation timer
else                                          ;<================ U, SS, E0, & E1 ==============
    STA.W PlayerAniTimer,Y                    ;! | Set animation timer; (sidenote: the ,Y here is probably a typo?)
endif                                         ;/===============================================
    STA.B SpriteLock                          ; / Set lock sprites timer
    JMP CODE_01C56F                           ; JMP to next instruction?

CODE_01C56F:
; Routine for giving points after collecting most powerups (except capes/1ups). Also serves as a general 'do nothing'.
    LDA.B #$04                                ; How many points to give Mario for collecting a powerup (1000).
    LDY.W SpriteMisc1534,X                    ; Give points, unless it's from the item box.
    BNE +
    JSL GivePoints
  + LDA.B #!SFX_MUSHROOM                      ; \; SFX for collecting a powerup.
    STA.W SPCIO0                              ; /
    RTS

CODE_01C580:
    LDA.B #$FF                                ; \ Set star timer; How long star power lasts.
    STA.W InvinsibilityTimer                  ; /
    LDA.B #!BGM_STARPOWER                     ; SFX for the star power music.
    STA.W SPCIO2                              ; / Change music
    ASL.W MusicBackup
    SEC
    ROR.W MusicBackup
    RTL

GiveMarioStar:
; Routine to handle giving Mario a star.
    JSL CODE_01C580                           ; Run above routine.
    BRA CODE_01C56F                           ; Give points.

GiveMarioCape:
; Routine to handle giving Mario a cape.
    LDA.B #$02                                ; Set cape status.
    STA.B Powerup
    LDA.B #!SFX_FEATHER                       ; \ Play sound effect; SFX for grabbing a feather.
    STA.W SPCIO0                              ; /
    LDA.B #$04                                ; How many points grabbing a feather gives (1000).
    JSL GivePoints
    JSL CODE_01C5AE                           ; Make a cloud of smoke at Mario's position.
    INC.B SpriteLock
    RTS

CODE_01C5AE:
    LDA.B PlayerYPosScrRel+1                  ; Routine (JSL) to make a cloud of smoke at Mario's position and temporarily freeze the game.
    ORA.B PlayerXPosScrRel+1                  ; Return if Mario is offscreen.
    BNE Return01C5EB
    LDA.B #$03
    STA.B PlayerAnimation
    LDA.B #$18                                ; How many frames the cape animation lasts.
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
  + LDY.W SmokeSpriteSlotIdx                  ; Spawn a cloud of smoke at Mario's position.
CODE_01C5D4:
    LDA.B #$81
    STA.W SmokeSpriteNumber,Y
    LDA.B #$1B                                ; How long the smoke lasts.
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
; Routine to handle giving Mario a fireflower.
    LDA.B #$20                                ; How many frames the animation lasts.
    STA.W CyclePaletteTimer
    STA.B SpriteLock
    LDA.B #$04
    STA.B PlayerAnimation
    LDA.B #$03                                ; Set fire status.
    STA.B Powerup
    JMP CODE_01C56F

GiveMario1Up:
    LDA.B #$08                                ; Routine to handle giving Mario a 1up.
    CLC                                       ; Give Mario a 1up. Seems to be able to give 2/3ups as well.
    ADC.W SpriteMisc1594,X
    JSL GivePoints
    RTS


PowerUpTiles:
    db $24,$26,$48,$0E,$24,$00,$00,$00
    db $00,$E4,$E8,$24,$EC

StarPalValues:
    db $00,$04,$08,$04

CODE_01C61A:
; Tiles used by various powerup sprites. Order:
; Mushroom, flower, star, feather, 1up, -, -, -
; , P-balloon, flying red coin, flying 1-up, flying key
; Palettes that star power flashes through.
    JSR GetDrawInfoBnk1                       ; Subroutine to draw graphics for powerups and coin sprites.
    STZ.B _A
    LDA.W ReznorOAMIndex
    BNE +
    LDA.W IRQNMICommand
    CMP.B #$C1                                ; If in a Mode 7 room (except Reznor's/Bowser's), change the OAM index.
    BEQ +
    BIT.W IRQNMICommand
    BVC +
    LDA.B #$D8                                ; OAM index for a powerup in Mode 7 rooms.
    STA.W SpriteOAMIndex,X
    TAY
  + LDA.B SpriteNumber,X
    CMP.B #$21                                ; sprite coin
    BNE PowerUpGfxRt                          ; Jump to the graphics routine corresponding to the sprite.
    JSL CoinSprGfx
    RTS

CoinSprGfx:
    JSR CoinSprGfxSub                         ; Subroutine to draw graphics for sprite 21 (coin).
    RTL

CoinSprGfxSub:
    JSR GetDrawInfoBnk1
    LDA.B _0
    STA.W OAMTileXPos+$100,Y                  ; Set X/Y position.
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B #$E8                                ; Base tile to use for the coin.
    STA.W OAMTileNo+$100,Y
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties                    ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    TXA
    CLC
    ADC.B EffFrame
    LSR A                                     ; Animate spinning.
    LSR A
    AND.B #$03
    BNE CODE_01C670
    LDY.B #$02                                ; Draw 16x16.
    BRA +


MovingCoinTiles:
    db $EA,$FA,$EA

CODE_01C670:
; 8x8 tiles to use for the coin in its turning frame.
    PHX                                       ; Draws the coin in its turning frame (2 8x8s).
    TAX
    LDA.B _0
    CLC
    ADC.B #$04                                ; Offset horizontally.
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    CLC                                       ; Offset bottom 8x8.
    ADC.B #$08
    STA.W OAMTileYPos+$104,Y
    LDA.L MovingCoinTiles-1,X
    STA.W OAMTileNo+$100,Y                    ; Set tile number.
    STA.W OAMTileNo+$104,Y
    LDA.W OAMTileAttr+$100,Y
    ORA.B #$80                                ; Flip bottom tile vertically.
    STA.W OAMTileAttr+$104,Y
    PLX
    LDY.B #$00                                ; Draw 8x8s.
  + LDA.B #$01                                ; Draw two tiles.
    JSL FinishOAMWrite
    RTS

PowerUpGfxRt:
; Routine to draw graphics for powerup sprites.
    CMP.B #$76                                ; \ Setup flashing palette for star; If not the star, don't animate palette.
    BNE +                                     ; |
    LDA.B TrueFrame                           ; |
    LSR A                                     ; |
    AND.B #$03                                ; |
    PHY                                       ; |; Get current palette for the star.
    TAY                                       ; |
    LDA.W StarPalValues,Y                     ; |
    PLY                                       ; |
    STA.B _A                                  ; / $0A contains palette info, will be applied later
  + LDA.B _0                                  ; \ Set tile x position
    STA.W OAMTileXPos+$100,Y                  ; /
    LDA.B _1                                  ; \ Set tile y position; Set X/Y position.
    DEC A                                     ; |
    STA.W OAMTileYPos+$100,Y                  ; /
    LDA.W SpriteMisc157C,X                    ; \ Flip flower/cape if 157C,x is set
    LSR A                                     ; |
    LDA.B #$00                                ; |
    BCS +                                     ; |
    ORA.B #!OBJ_XFlip                         ; /; Set YXPPCCCT.
  + ORA.B SpriteProperties                    ; \ Add in level priority information
    ORA.W SpriteOBJAttribute,X                ; | Add in palette/gfx page
    EOR.B _A                                  ; | Adjust palette for star
    STA.W OAMTileAttr+$100,Y                  ; / Set property byte
    LDA.B SpriteNumber,X                      ; \ Set powerup tile
    SEC                                       ; |
    SBC.B #$74                                ; |; Set tile number.
    TAX                                       ; | X = Sprite number - #$74
    LDA.W PowerUpTiles,X                      ; |
    STA.W OAMTileNo+$100,Y                    ; /
    LDX.W CurSpriteProcess                    ; X = sprite index
    LDA.B #$00                                ; Draw one 16x16 tile.
    JSR CODE_01B37E
    RTS


DATA_01C6E6:
    db $02,$FE

DATA_01C6E8:
    db $20,$E0

DATA_01C6EA:
    db $0A,$F6,$08

Feather:
; X speed accelerations for the feather.
; Maximum X speeds for the feather.
; Y speeds for the feather's "swing". Actual speed is this + #$06.
; 0 = down (left); 1 = up; 2 = down (right)
; Feather MAIN.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; If game frozen, just handle touched routine and graphics.
    BNE CODE_01C744                           ; /
    LDA.B SpriteTableC2,X                     ; Branch if not stationary.
    BEQ CODE_01C701
    JSR CODE_019140
    LDA.W SpriteBlockedDirs,X                 ; If no longer on the ground, set to fall.
    BNE +
    STZ.B SpriteTableC2,X
  + BRA CODE_01C741                           ; Interact with Mario and draw.

CODE_01C701:
    LDA.W SpriteStatus,X                      ; Feather is in air.
    CMP.B #$0C                                ; Just draw graphics if spawned by the goal tape.
    BEQ CODE_01C744
    LDA.W SpriteMisc154C,X
    BEQ +                                     ; If knocked out of a block, only update Y position and decelerate,
    JSR SubSprYPosNoGrvty                     ; then process interaction with Mario and draw.
    INC.B SpriteYSpeed,X
    JMP CODE_01C741

  + LDA.W SpriteMisc1528,X                    ; Feather is falling.
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CLC                                       ; Accerate horizontally.
    ADC.W DATA_01C6E6,Y                       ; If at max speed, invert direction.
    STA.B SpriteXSpeed,X
    CMP.W DATA_01C6E8,Y
    BNE +
    INC.W SpriteMisc1528,X
  + LDA.B SpriteXSpeed,X
    BPL +
    INY
  + LDA.W DATA_01C6EA,Y                       ; Set Y speed based on where in the swing the feather is.
    CLC
    ADC.B #$06
    STA.B SpriteYSpeed,X
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR SubSprXPosNoGrvty                     ; Update X/Y position.
    JSR SubSprYPosNoGrvty
CODE_01C741:
    JSR UpdateDirection                       ; Update directon based on X speed.
CODE_01C744:
    JSR CODE_01C4AC                           ; Process interaction with Mario.
    JMP CODE_01C61A                           ; Draw graphics.

InitBrwnChainPlat:
    LDA.B #$80                                ; Revolving platform INIT
    STA.W SpriteMisc151C,X                    ; Set initial angle (#$0180 = 270deg)
    LDA.B #$01
    STA.W SpriteMisc1528,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$78
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,X                    ; Shift center position from spawn location.
    LDA.B SpriteYPosLow,X                     ; (7.8 blocks right, 6.8 blocks down)
    CLC
    ADC.B #$68
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    RTS

BrownChainedPlat:
; Revolving platform misc RAM:
; $C2   - X position (low) of the platform, previous frame, Used to determine how far it's moved in the frame.
; $1504 - Speed of rotation. Max #$40.
; $1510 - Accumulating fraction bits for the angle.
; $151C - Angle, low.
; $1528 - Angle, high. Odd = upper half, even = lower half.
; $1602 - Flag for being on the platform. Set to #$03 if true.
; $160E - Flag for simply touching the platform. Set to #$01 if true.
    JSR SubOffscreen2Bnk1                     ; Revolving platform MAIN
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01C795                           ; /
    LDA.B TrueFrame                           ; Every 4th frame while the game is not frozen,
    AND.B #$03                                ; if Mario is not on the platform, slow it down.
    ORA.W SpriteMisc1602,X
    BNE CODE_01C795
    LDA.B #$01                                ; Deceleration speed (counterclockwise)
    LDY.W SpriteMisc1504,X
    BEQ CODE_01C795
    BMI +
    LDA.B #$FF                                ; Deceleration speed (clockwise)
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
    SBC.W SpriteMisc1528,X                    ; Update rotation.
    AND.B #$01                                ; Output is in $14B8 (X) and $14BA (Y).
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
    SBC.B SpriteTableC2,X                     ; Register how much the platform moved horizontally.
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
    SEC                                       ; Store OAM for the outermost chain link.
    SBC.B Layer1XPos
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$100,Y
    LDA.B #$A2                                ; Tile
    STA.W OAMTileNo+$100,Y
    LDA.B #$31                                ; YXPPCCCT
    STA.W OAMTileAttr+$100,Y
    LDY.B #$00
    LDA.W BrSwingPlatYPos
    SEC
    SBC.W BrSwingCenterYPos
    BPL +                                     ; Adjust for whether the platform is left or right of the center.
    EOR.B #$FF                                ; $00 - 00 if left, 01 if right.
    INC A
    INY
  + STY.B _0
    STA.W HW_WRDIV+1
    STZ.W HW_WRDIV
    LDA.B #$05
    STA.W HW_WRDIV+2
    JSR DoNothing                             ; Calculate tile X position.
    LDA.W HW_RDDIV                            ; $02/$03 = X offset between each tile.
    STA.B _2                                  ; $06/$07 = X position of the current tile.
    STA.B _6
    LDA.W HW_RDDIV+1
    STA.B _3
    STA.B _7
    LDY.B #$00
    LDA.W BrSwingPlatXPos
    SEC
    SBC.W BrSwingCenterXPos
    BPL +                                     ; Adjust for whether the platform is above or below the center.
    EOR.B #$FF                                ; $01 - 00 if above, 01 if below.
    INC A
    INY
  + STY.B _1
    STA.W HW_WRDIV+1
    STZ.W HW_WRDIV
    LDA.B #$05
    STA.W HW_WRDIV+2
    JSR DoNothing                             ; Calculate tile Y position.
    LDA.W HW_RDDIV                            ; $04/$05 - Y offset between each tile.
    STA.B _4                                  ; $08/$09 - Y position of the current tile.
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
    SEC                                       ; Dummy OAM tile for the center of the chain.
    SBC.B Layer1YPos
    SEC
    SBC.B #$08                                ; Y offset of the center of the chain.
    STA.B _A
    STA.W OAMTileYPos+$100,Y
    LDA.W BrSwingCenterXPos
    SEC
    SBC.B Layer1XPos
    SEC
    SBC.B #$08                                ; X offset of the center of the chain.
    STA.B _B
    STA.W OAMTileXPos+$100,Y
    LDA.B #$A2
    STA.W OAMTileNo+$100,Y                    ; Useless, as the tile gets sent offscreen later.
    LDA.B #$31
    STA.W OAMTileAttr+$100,Y
    LDX.B #$03                                ; Number of additional chain links to draw (excluding outermost).
CODE_01C87C:
    INY                                       ; Chain link GFX loop.
    INY
    INY
    INY
    LDA.B _0
    BNE CODE_01C88E
    LDA.B _A
    CLC
    ADC.B _7
    STA.W OAMTileYPos+$100,Y                  ; Store Y position for the tile.
    BRA +

CODE_01C88E:
    LDA.B _A
    SEC
    SBC.B _7
    STA.W OAMTileYPos+$100,Y
  + LDA.B _6
    CLC
    ADC.B _2
    STA.B _6                                  ; Update Y position for the next tile.
    LDA.B _7
    ADC.B _3
    STA.B _7
    LDA.B _1
    BNE CODE_01C8B1
    LDA.B _B
    CLC
    ADC.B _9
    STA.W OAMTileXPos+$100,Y                  ; Store X position for the tile.
    BRA +

CODE_01C8B1:
    LDA.B _B
    SEC
    SBC.B _9
    STA.W OAMTileXPos+$100,Y
  + LDA.B _8
    CLC
    ADC.B _4
    STA.B _8                                  ; Update X position for the next tile.
    LDA.B _9
    ADC.B _5
    STA.B _9
    LDA.B #$A2
    STA.W OAMTileNo+$100,Y                    ; Store tile number and YXPPCCCT for the chain link.
    LDA.B #$31
    STA.W OAMTileAttr+$100,Y
    DEX
    BPL CODE_01C87C
    LDX.B #$03                                ; Number of tiles to draw for the platform.
  - STX.B _2                                  ; Platform GFX loop.
    INY
    INY
    INY
    INY
    LDA.W BrSwingPlatYPos
    SEC
    SBC.B Layer1YPos                          ; Set Y position.
    SEC
    SBC.B #$10                                ; Y offset from outermost chain tile for the platform.
    STA.W OAMTileYPos+$100,Y
    LDA.W BrSwingPlatXPos
    SEC
    SBC.B Layer1XPos                          ; Set X position.
    CLC
    ADC.W DATA_01C9B7,X
    STA.W OAMTileXPos+$100,Y
    LDA.W BrwnChainPlatTiles,X
    STA.W OAMTileNo+$100,Y                    ; Set tile and YXPPCCCT.
    LDA.B #$31
    STA.W OAMTileAttr+$100,Y
    DEX
    BPL -
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$09                                ; Number of tiles total in the platform.
    STA.B _8
    LDA.W BrSwingCenterYPos
    SEC
    SBC.B #$08
    STA.B _0
    LDA.W BrSwingCenterYPos+1
    SBC.B #$00
    STA.B _1                                  ; Store some information.
    LDA.W BrSwingCenterXPos                   ; $00 - 16-bit Xpos of the platform's center.
    SEC                                       ; $02 - 16-bit Ypos of the platform's center.
    SBC.B #$08                                ; $06 - On-screen Y position of the platform's center.
    STA.B _2                                  ; $07 - On-screen X position of the platform's center.
    LDA.W BrSwingCenterXPos+1
    SBC.B #$00
    STA.B _3
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileYPos+$104,Y
    STA.B _6
    LDA.W OAMTileXPos+$104,Y
    STA.B _7
CODE_01C934:
    TYA                                       ; Tile size OAM loop.
    LSR A
    LSR A
    TAX
    LDA.B #$02                                ; Set as 16x16.
    STA.W OAMTileSize+$40,X
    LDX.B #$00
    LDA.W OAMTileXPos+$100,Y
    SEC
    SBC.B _7
    BPL +
    DEX
  + CLC
    ADC.B _2
    STA.B _4                                  ; If the tile is offscreen on the right, set high X bit of OAM.
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
    ADC.B _0                                  ; If the tile is offscreen vertically, keep it offscreen.
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
    STA.W BrSwingPlatXPos                     ; Preserve onscreen X/Y position of th outermost chainlink tile.
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
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM; Send the dummy center tile offscreen.
    LDA.B #$F0
    STA.W OAMTileYPos+$104,Y
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if the game is frozen.
    BNE +                                     ; /
    JSR CODE_01CCF0                           ; Update the platform's angle.
    JMP CODE_01C9EC                           ; Process interaction with the platform.

  + RTS


DATA_01C9B7:
    db $E0,$F0,$00,$10

BrwnChainPlatTiles:
    db $60,$61,$61,$62

CODE_01C9BF:
; X offsets for each tile of the platform part of the revolving brown platform.
; Returns carry set if the tile is below the screen, clear if not.
    REP #$20                                  ; A->16; Store Y position in $09 first.
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
; Accel/decel speeds for the revolving brown platform.
; Max speeds for the revolving brown platform.
    LDA.W SpriteMisc160E,X                    ; Not touching the platform at all.
    BEQ +                                     ; If Mario just stopped touching the platform, clear the flag.
    STZ.W SpriteMisc160E,X                    ; Then for no real reason reason redraw his graphics.
CODE_01C9E2:
    PHX
    JSL DrawMarioAndYoshi                     ; Redraw Mario. This is done to have Mario line up with the platform's movement.
    PLX
    STX.W CurSpriteProcess
  + RTS

CODE_01C9EC:
    LDA.W BrSwingPlatXPos+1                   ; Process interaction with the platform.
    XBA
    LDA.W BrSwingPlatXPos
    REP #$20                                  ; A->16
    SEC
    SBC.B Layer1XPos
    CLC                                       ; Set horizontally offscreen flag...?
    ADC.W #$0010                              ; Plus sprite frozen flag.
    CMP.W #$0120                              ; Return if set.
    SEP #$20                                  ; A->8
    ROL A
    AND.B #$01
    ORA.B SpriteLock
    STA.W SpriteWayOffscreenX,X
    BNE Return01C9D5
    JSR CODE_01CA9C
    STZ.W SpriteMisc1602,X                    ; Return if not in contact.
    BCC CODE_01C9DA
    LDA.B #$01                                ; Set flag for touching the platform.
    STA.W SpriteMisc160E,X
    LDA.W BrSwingPlatYPos
    SEC
    SBC.B Layer1YPos
    STA.B _3
    SEC
    SBC.B #$08                                ; Return if not touching the top of the platform.
    STA.B _E
    LDA.B PlayerYPosScrRel
    CLC
    ADC.B #$18
    CMP.B _E
    BCS Return01CA9B
    LDA.B PlayerYSpeed+1                      ; Restore Mario and return if moving upwards.
    BMI CODE_01C9E2
    STZ.B PlayerYSpeed+1
    LDA.B #$03                                ; Make Mario stand on top of the platform.
    STA.W StandOnSolidSprite
    STA.W SpriteMisc1602,X
    LDA.B #$28
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$38
  + STA.B _F
    LDA.W BrSwingPlatYPos                     ; Offset Mario's Y position from the platform.
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
    DEY                                       ; Move Mario horizontally with the platform.
  + CLC
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    TYA
    ADC.B PlayerXPosNext+1
    STA.B PlayerXPosNext+1
CODE_01CA6E:
    JSR CODE_01C9E2                           ; Redraw Mario.
    LDA.B byetudlrFrame
    BMI +                                     ; Hide Mario from the future draws,
    LDA.B #$FF                                ; unless jumping off. (yes, this causes him to be drawn twice)
    STA.B PlayerHiddenTiles
if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
  + LDA.B TrueFrame                           ;!
    LSR A                                     ;!
    BCC Return01CA9B                          ;!
    LDA.W SpriteMisc151C,X                    ;!
    CLC                                       ;!
    ADC.B #$80                                ;!
    LDA.W SpriteMisc1528,X                    ;!
    ADC.B #$00                                ;!; Every other frame, if not at the max speed, accelerate/decelerate
    AND.B #$01                                ;!; the platform according to which side of the center it is on.
    TAY                                       ;!; (Y = 0 for right side, Y = 1 for left)
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
    LDA.W BrSwingPlatXPos                     ; Subroutine to check for contact with the platform. Carry set if so.
    SEC
    SBC.B #$18                                ; X displacement (low)
    STA.B _4
    LDA.W BrSwingPlatXPos+1
    SBC.B #$00                                ; X displacement (high)
    STA.B _A
    LDA.B #$40                                ; Width
    STA.B _6
    LDA.W BrSwingPlatYPos
    SEC
    SBC.B #$0C                                ; Y displacement (low)
    STA.B _5
    LDA.W BrSwingPlatYPos+1
    SBC.B #$00                                ; Y displacement (high)
    STA.B _B
    LDA.B #$13                                ; Height
    STA.B _7
    JSL GetMarioClipping
    JSL CheckForContact
    RTS

CODE_01CACB:
; Usage:
; $151C - Angle (low)
; $1528 - Angle (high)
; Output:
; $36   - 16-bit angle
; $14BC - 16-bit horizontal radius (#$0050)
; $14BF - 16-bit vertical radius   (#$0000)
; $14B4 - 16-bit X position of the platform at 0 deg
; $14B6 - 16-bit Y position of the platform at 0 deg
; $14B0 - 16-bit X position of the center of the platform
; $14B2 - 16-bit Y position of the center of the platform
; Sprite rotation preparation routine.
    LDA.B #$50                                ; Radius.
    STA.W BrSwingRadiusX                      ; Set up $14BC as the 16-bit radius.
    STZ.W BrSwingRadiusY                      ; Also sets up $14BF as a vertical radius, though it's always zero.
    STZ.W BrSwingRadiusX+1
    STZ.W BrSwingRadiusY+1
    LDA.B SpriteXPosLow,X
    STA.W BrSwingXDist
    LDA.W SpriteXPosHigh,X
    STA.W BrSwingXDist+1
    LDA.W BrSwingXDist
    SEC                                       ; Store the horizontal center of the platform.
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
    SEC                                       ; Store the vertical center of the platform.
    SBC.W BrSwingRadiusY
    STA.W BrSwingCenterYPos
    LDA.W BrSwingYDist+1
    SBC.W BrSwingRadiusY+1
    STA.W BrSwingCenterYPos+1
    LDA.W SpriteMisc151C,X
    STA.B Mode7Angle                          ; Store the angle.
    LDA.W SpriteMisc1528,X
    STA.B Mode7Angle+1
    RTS

CODE_01CB20:
; Usage:
; $36 - 16-bit angle of rotation
; Run $01CACB (sprites) or $01CCC7 (Mode 7) first to set up additional information.
; Output:
; $14C2 - 16-bit sin value
; $14C5 - 16-bit cos value
; $1866 - Signage of the sin value (1 = negative).
; $1867 - Signage of the cos value (1 = negative).
    LDA.B Mode7Angle+1                        ; Routine to prepare the game's global rotation routine.
    STA.W BrSwingAngleParity
    PHX
    REP #$30                                  ; AXY->16
    LDA.B Mode7Angle                          ; Get the sin value for the angle.
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
    AND.W #$01FF                              ; Get the cos value for the angle.
    TAX
    LDA.L CircleCoords,X
    STA.W BrSwingCosine
    SEP #$30                                  ; AXY->8
    LDA.B _1
    STA.W BrSwingAngleParity+1
    PLX
    RTS

CODE_01CB53:
; Usage:
; Run $01CB20 first.
; Output:
; $14B8 - 16-bit X position along the perimeter of the circle.
; $14BA - 16-bit Y position along the perimeter of the circle.
    REP #$20                                  ; A->16; Global rotation routine.
    LDA.W BrSwingCosine
    STA.B _2                                  ; Calculate X position.
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
    STA.B _2                                  ; Calculate Y position.
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
    LDA.B _0                                  ; Subroutine to do 16-bit cos/sin multiplication. Stores a radius in $00 and cos/sin value in $02.
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
    NOP                                       ; \ Do nothing at all; Subroutine to wait 16 cycles for registers to finish multiplication.
    NOP                                       ; |
    NOP                                       ; |
    NOP                                       ; |
    NOP                                       ; |
    NOP                                       ; |
    NOP                                       ; |
    NOP                                       ; |
    RTS                                       ; /

CODE_01CC9D:
; Set up before running below routine:
; $14B4 - 16-bit X position to check.
; $14B6 - 16-bit Y position to check.
; Returns carry set if contact is made, as well as:
; $14B8 - 16-bit X position, rotated with the platform.
; $14BA - 16-bit Y position, rotated with the platform.
    LDA.W IggyLarryPlatIntXPos+1              ; Routine to handle interaction between a sprite and Iggy/Larry's platform.
    ORA.W IggyLarryPlatIntYPos+1              ; Return no interaction if high X/Y bytes are non-zero (pretty much never).
    BNE +
    JSR CODE_01CCC7
    JSR CODE_01CB20                           ; Get rotation information.
    JSR CODE_01CB53
    LDA.W IggyLarryTempYPos
    AND.B #$F0
    STA.B _0
    LDA.W IggyLarryTempXPos
    LSR A
    LSR A                                     ; Check if the sprite is in contact with a solid tile.
    LSR A                                     ; Returns carry set if so.
    LSR A
    ORA.B _0
    TAY
    LDA.W IggyLarryPlatInteract,Y
    CMP.B #$15
    RTL

  + CLC
    RTL

CODE_01CCC7:
; Usage:
; $14B4 - 16-bit X position of point to check.
; $14B6 - 16-bit Y position of point to check.
; Output:
; $14B0 - 16-bit horizontal center of rotation.
; $14B2 - 16-bit vertical center of rotation.
; $14BC - 16-bit horizontal distance from the center for the point.
; $14BF - 16-bit vertical distance from the center for the point.
    REP #$20                                  ; A->16; Iggy/Larry Mode 7 interaction prep routine. Stores necessary information for various things.
    LDA.B Mode7CenterX
    STA.W IggyLarryRotCenterX                 ; Store center of rotation.
    LDA.B Mode7CenterY
    STA.W IggyLarryRotCenterY
    LDA.W IggyLarryPlatIntXPos
    SEC                                       ; Store horizontal radius of the position from center.
    SBC.W IggyLarryRotCenterX
    STA.W BrSwingRadiusX
    LDA.W IggyLarryPlatIntYPos
    SEC                                       ; Store vertical radius of interaction point from center.
    SBC.W IggyLarryRotCenterY
    STA.W BrSwingRadiusY
    SEP #$20                                  ; A->8
    RTS

    RTS

    RTS

CODE_01CCEC:
    EOR.B #$FF                                ; Subroutine to invert the accumulator.
    INC A
    RTS

CODE_01CCF0:
    LDA.W SpriteMisc1504,X                    ; Subroutine to update the revolving platform's angle.
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
    LSR A                                     ; Update the platform's angle.
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
    JSL CODE_03CC09                           ; Wendy/Lemmy redirect
    RTS

InitKoopaKid:
    LDA.B SpriteYPosLow,X                     ; Koopa Kid INIT
    LSR A
    LSR A                                     ; Store Y position as boss type.
    LSR A
    LSR A
    STA.B SpriteTableC2,X
    CMP.B #$05                                ; Wendy/Lemmy only.
    BCC +
    LDA.B #$78                                ; Initial X position.
    STA.B SpriteXPosLow,X
    LDA.B #$40
    STA.B SpriteYPosLow,X                     ; Initial Y position.
    LDA.B #$01
    STA.W SpriteYPosHigh,X
    LDA.B #$80                                ; How long before the boss rises out of the pipe for the first time.
    STA.W SpriteMisc1540,X
    RTS

; Not Wendy/Lemmy.
  + LDY.B #$90                                ; Y low byte of starting position for Morton/Ludwig/Roy/Iggy/Larry.
    STY.B SpriteYPosLow,X
    CMP.B #$03                                ; Iggy/Larry only.
    BCC +
    JSL CODE_00FCF5                           ; Set initial position and face Mario.
    JSR FaceMario
    RTS

; Morton/Roy/Ludwig.
  + LDA.B #$01                                ; Set to face left initially.
    STA.W SpriteMisc157C,X
    LDA.B #$20
    STA.B Mode7XScale                         ; Set initial scaling.
    STA.B Mode7YScale
    JSL CODE_03DD7D                           ; Load palette/GFX files.
    LDY.B SpriteTableC2,X
    LDA.W DATA_01CD92,Y                       ; Set boss room to load.
    STA.W SpriteMisc187B,X
    CMP.B #$01                                ; Branch if loading Morton/Roy.
    BEQ CODE_01CD87
    CMP.B #$00
    BNE +
    LDA.B #$70                                ; X low byte of starting position for Ludwig.
    STA.B SpriteXPosLow,X
  + LDA.B #$01                                ; X high byte of starting position for Ludwig.
    STA.W SpriteXPosHigh,X
    RTS

CODE_01CD87:
; Morton/Roy.
    LDA.B #$26                                ; Initial X position of the left wall.
    STA.W SpriteMisc1534,X
    LDA.B #$D8                                ; Initial X position of the right wall.
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
; Mode 7 room to load. Only actually use for Ludwig/Morton/Roy?
; 0 = Lud, 1 = Mor/Roy, 2 = Igg/Lar, 3 = Lem/Wen
; Mode 7 animation base indices for Morton, Roy, and Ludwig respectively.
; Additional Mode 7 animation values for the frames of Ludwig/Morton/Roy (indexed by $1602).
; Though they could have just directly added the index...
; X flip values for Morton/Roy/Ludwig's direction.
; Morton/Roy/Ludwig misc RAM:
; $C2   - Which boss the sprite is running.
; 0 = Morton, 1 = Roy, 2 = Ludwig
; $151C - Main routine pointer.
; 0 = stationary (spawn / Ludwig waiting for Mario), 1 = stationary (walls dropping / starting Ludwig)
; 2 = normal movement, 3 = hurt, 4 = dying, 5 = dead (wait for level end)
; $1528 - Morton/Roy: Attack routine pointer. 0 = walking, 1 = dropping.
; Ludwig: Attack routine pointer. 0 = fire, 1 = shell, 2 = jump.
; $1534 - X position of the left wall in Morton/Roy's. Starts at #$26.
; $1540 - Various phase timers. Set to #$80 for the hurt animation, to #$14 when dying (for the part where the boss grows in size),
; and to #$30 after the boss has died (to wait for level end).
; Morton/Roy: Set to #$26 when hitting the ground after dropping, to wait before starting to move.
; Ludwig: Set to #$FF when starting fire/shell phases, and #$30 for waiting before jumping.
; $1558 - Timer set to #$60 when jumping, for starting Ludwig's rotation. This value only actually has to be greater than $1540.
; $157C - Morton/Roy: Rotational direction the boss is moving. 0 = counterclockwise, 1 = clockwise.
; Ludwig: Direction of movement. 0 = right, 1 = left
; $1594 - Relative direction Morton/Roy is moving. 0 = left, 1 = up, 2 = right, 3 = down.
; $15AC - Turn timer. Set to #$0A whenever turning; Morton/Roy set after dropping from the ceiling.
; $1602 - Animation frame.
; 0/1/2 = walking, 3/4 = fireballs, 5 = turning, 6 = falling/jumping, 6/7 = hurt, 8 = unused hurt frame, 1B-1D = spinning shell (ludwig)
; $160E - Roy/Morton: X position of the right wall. Starts at #$D8.
; Ludwig: Jump X speed; #$14 when jumping right, #$EC when jumping left.
; $1626 - Number of hits the boss has taken. Dies if jumped on at 3+, or fireballed at 12+.
; $163E - Timer for shooting Ludwig's fireball. Set to #$30 when the fireball is spawned.
; $164A - Timer used to move the walls inwards in Roy's. Only decrements when the walls actually move.
; $187B - Mode 7 room to load. 0 = Ludwig, 1 = Morton/Roy
; $1FE2 - Disable contact with Mario. Set to 8 when touched.
    JSR GetDrawInfoBnk1                       ; Container for GetDrawInfo (for the offscreen forced return).
    RTS

WallKoopaKids:
; Ludwig/Morton/Roy MAIN
    STZ.W PlayerIsFrozen                      ; Clear player frozen timer by default.
    LDA.W SpriteMisc1602,X
    CMP.B #$1B                                ; If spinning in a shell, don't X flip.
    BCS CODE_01CDD5
    LDA.W SpriteMisc15AC,X
    CMP.B #$08
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01CDA5,Y                       ; Get X flip.
    BCS +
    EOR.B #$80
  + STA.B _0
    LDY.B SpriteTableC2,X
    LDA.W DATA_01CD99,Y
    LDY.W SpriteMisc1602,X
    CLC                                       ; Get Mode 7 animation index and add X flip to it.
    ADC.W DATA_01CD9C,Y                       ; End result is stored to $1BA2.
    CLC
    ADC.B _0
CODE_01CDD5:
    STA.W Mode7TileIndex
    JSL CODE_03DEDF                           ; Handle the Mode 7 tilemap.
    JSR CODE_01CDA7                           ; Run GetDrawInfo.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if game frozen.
    BNE Return01CE3D                          ; /
    JSR CODE_01D2A8                           ; Handle player interaction.
    JSR CODE_01D3B1                           ; Handle fireball interaction.
    LDA.W SpriteMisc187B,X
    CMP.B #$01
    BEQ +
    LDA.W SpriteMisc163E,X
    BNE +
    LDA.W SpriteMisc157C,X
    PHA                                       ; If running Ludwig and not currently shooting a fireball,
    JSR SubHorizPos                           ; turn towards Mario.
    TYA
    STA.W SpriteMisc157C,X
    PLA
    CMP.W SpriteMisc157C,X
    BEQ +
    LDA.B #$10                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
  + LDA.W SpriteMisc151C,X                    ; Execute boss phases.
    JSL ExecutePtr

    dw CODE_01CE1E
    dw CODE_01CE3E
    dw CODE_01CE5F
    dw CODE_01CF7D
    dw CODE_01CFE0
    dw CODE_01D043

CODE_01CE1E:
; Phases for Morton/Roy/Ludwig's movements.
; 0 - Stationary (spawn / ludwig waiting for Mario)
; 1 - Stationary (walls dropping / starting ludwig)
; 2 - Moving
; 3 - Hurt
; 4 - Dying
; 5 - Dead (end level)
    LDA.W SpriteMisc187B,X                    ; Stationary (spawn / Ludwig waiting for Mario).
    CMP.B #$01                                ; Branch if in Ludwig's room.
    BNE +
    STZ.W HorizLayer1Setting                  ; Disable horizontal scroll.
    INC.W BossPillarFalling                   ; Make pillars fall.
    STZ.W BossPillarYPos
    INC.B SpriteLock                          ; Freeze sprites.
    INC.W SpriteMisc151C,X                    ; Move to next phase (walls falling).
    RTS

  + LDA.B Layer1XPos                          ; Ludwig waiting.
    CMP.B #$7E                                ; Wait until the screen is all the way to the right,
    BCC Return01CE3D                          ; then move to next phase.
    INC.W SpriteMisc151C,X
Return01CE3D:
    RTS

CODE_01CE3E:
; Phase 1 - Stationary (walls dropping / starting Ludwig)
    STZ.B PlayerXSpeed+1                      ; Freeze Mario.
    JSR SubSprYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +                                     ; Handle ground interaction.
    CLC                                       ; Also apply gravity...?
    ADC.B #$03
  + STA.B SpriteYSpeed,X
    JSR CODE_01D0C0
    BCC Return01CE3D
    INC.W SpriteMisc151C,X                    ; Move to next phase.
    LDA.B SpriteTableC2,X
    CMP.B #$02                                ; Return if not running Ludwig.
    BCC Return01CE3D
    JMP CODE_01CEA8                           ; Set timer for fireball attack.

CODE_01CE5F:
    LDA.B SpriteTableC2,X                     ; Phase 2 - Boss is moving/attacking.
    JSL ExecutePtr

    dw CODE_01D116
    dw CODE_01D116
    dw CODE_01CE6B

CODE_01CE6B:
; Morton/Roy/Ludwig routine pointers.
; 0 - Morton
; 1 - Roy
; 2 - Ludwig
    LDA.W SpriteMisc1528,X                    ; Ludwig's main routine.
    JSL ExecutePtr

    dw CODE_01CE78
    dw CODE_01CEB6
    dw CODE_01CEFD

CODE_01CE78:
; Ludwig's movement/attack pointers.
; 0 - Shooting fireballs.
; 1 - Shell
; 2 - Jumping
; Ludwig attack phase 0 - Shooting fireballs.
    STZ.B Mode7Angle                          ; Clear rotation.
    STZ.B Mode7Angle+1
    LDA.W SpriteMisc1540,X                    ; Branch if done phase.
    BEQ CODE_01CEA5
    LDY.B #$03
    AND.B #$30
    BNE +
    INY
; Set animation frame.
  + TYA                                       ; 3/4 for firing animation, 5 for turning.
    LDY.W SpriteMisc15AC,X
    BEQ +
    LDA.B #$05
  + STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    AND.B #$3F                                ; Return if not time to spawn a fireball.
    CMP.B #$2E
    BNE +
    LDA.B #$30                                ; Set timer for shooting.
    STA.W SpriteMisc163E,X
    JSR CODE_01D059                           ; Spawn the fireball.
  + RTS

CODE_01CEA5:
; Done with fireballs.
    INC.W SpriteMisc1528,X                    ; Move to next phase.
CODE_01CEA8:
    LDA.B #$FF                                ; Set phase timer.
    STA.W SpriteMisc1540,X
    RTS


DATA_01CEAE:
    db $30,$D0

DATA_01CEB0:
    db $1B,$1C,$1D,$1B

DATA_01CEB4:
    db $14,$EC

CODE_01CEB6:
; Maximum X speeds for Ludwig in his shell state.
; Animation frames for Ludwig while spinning in his shell.
; Ludwig's horizontal jump X speeds.
; Ludwig attack phase 1 - Spinning in his shell.
    LDA.W SpriteMisc1540,X                    ; Branch if not done with the phase.
    BNE +
    JSR SubHorizPos
    TYA                                       ; Prevent Ludwig from jumping left when on screen 0, for some reason.
    CMP.W SpriteXPosHigh,X
    BNE +
    INC.W SpriteMisc1528,X                    ; Increment attack phase (jumping).
    LDA.W DATA_01CEB4,Y                       ; Set Ludwig's jump X speed.
    STA.W SpriteMisc160E,X
    LDA.B #$30                                ; Set timer for waiting to jump.
    STA.W SpriteMisc1540,X
    LDA.B #$60                                ; Set timer for starting rotation during the jump.
    STA.W SpriteMisc1558,X
    LDA.B #$D8                                ; Ludwig's jump Y speed.
    STA.B SpriteYSpeed,X
    RTS

  + JSR SubHorizPos                           ; Continue shell phase.
    LDA.B SpriteXSpeed,X
    CMP.W DATA_01CEAE,Y
    BEQ +
    CLC                                       ; Accelerate towards Mario.
    ADC.W DATA_01D4E7,Y
    STA.B SpriteXSpeed,X
  + JSR SubSprXPosNoGrvty
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03                                ; Animate the shell's spin.
    TAY
    LDA.W DATA_01CEB0,Y
    STA.W SpriteMisc1602,X
    RTS

CODE_01CEFD:
; Ludwig's attack phase 2 - Jumping.
    LDA.W SpriteMisc1540,X                    ; Branch if already jumping.
    BEQ CODE_01CF1C
    DEC A                                     ; Branch if not time to actually jump.
    BNE +
    LDA.W SpriteMisc160E,X                    ; Set X speed.
    STA.B SpriteXSpeed,X
    LDA.B #!SFX_SPRING                        ; \ Play sound effect; SFX for Ludwig jumping.
    STA.W SPCIO3                              ; /
  + LDA.B SpriteXSpeed,X
    BEQ Return01CF1B
    BPL +
    INC.B SpriteXSpeed,X                      ; Decrease X speed? Pretty much unused since position is not updated.
    INC.B SpriteXSpeed,X
  + DEC.B SpriteXSpeed,X
Return01CF1B:
    RTS

CODE_01CF1C:
; Ludwig is jumping (i.e. in air).
    JSR CODE_01D0C0                           ; Branch if not touching the ground.
    BCC +
    LDA.B SpriteYSpeed,X                      ; Branch if moving upward (is already checked though, so unused).
    BMI +
    STZ.B SpriteXSpeed,X                      ; \ Sprite Speed = 0
    STZ.B SpriteYSpeed,X                      ; /; Clear X/Y speed, and return to attack phase 0 (firing).
    STZ.W SpriteMisc1528,X
    JMP CODE_01CEA8                           ; Set fireball phase timer.

; Hasn't hit the ground.
  + JSR SubSprXPosNoGrvty                     ; Update position.
    JSR SubSprYPosNoGrvty
    LDA.B TrueFrame
    LSR A
    BCS CODE_01CF44
    LDA.B SpriteYSpeed,X
    BMI CODE_01CF42                           ; Apply gravity, and cap Y speed at #$70.
    CMP.B #$70
    BCS CODE_01CF44
CODE_01CF42:
    INC.B SpriteYSpeed,X
CODE_01CF44:
    LDA.W SpriteMisc1558,X
    BNE CODE_01CF4F
    LDA.B Mode7Angle                          ; Branch if Ludwig hasn't completed one full rotation yet.
    ORA.B Mode7Angle+1
    BEQ CODE_01CF67
CODE_01CF4F:
    LDA.B SpriteXSpeed,X
    ASL A
    LDA.B #$04
    LDY.B #$00
    BCC +
    LDA.B #$FC
    DEY                                       ; Rotate in the direction that Ludwig is moving.
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
    BCC +                                     ; Set animation frame.
    LDA.B #$05                                ; 6 if moving upwards or just starting to fall (Y speed < #$08)
    CPY.B #$10                                ; 5 for a little bit after starting to fall (Y speed < #$10).
    BCC +                                     ; 2 after falling for a while (Y speed >= #$10).
    LDA.B #$02
  + STA.W SpriteMisc1602,X
    RTS

CODE_01CF7D:
    JSR SubSprYPosNoGrvty                     ; Morton/Roy/Ludwig phase 3 - Hurt.
    INC.B SpriteYSpeed,X                      ; Handle Y speed; fall towards the ground, stop when the boss hits it.
    JSR CODE_01D0C0
    LDA.W SpriteMisc1540,X
    BEQ CODE_01CFB7                           ; Branch A if done with hurt animation.
    CMP.B #$40                                ; Branch B if scaling back to normal.
    BCC CODE_01CF9E                           ; Branch C if starting to scale (register damage, check if dead).
    BEQ CODE_01CFC6
    LDY.B #$06
    LDA.B EffFrame
    AND.B #$04
    BEQ +                                     ; Set animation frame for the damage animation.
    INY                                       ; Both frames (6/7) are identical, though, so most of this code is unnecessary.
  + TYA
    STA.W SpriteMisc1602,X
    RTS

CODE_01CF9E:
; Scale the boss back to normal.
    LDY.W Empty18A6                           ; Unused.
    LDA.B Mode7XScale
    CMP.B #$20
    BEQ +
    INC.B Mode7XScale
  + LDA.B Mode7YScale                         ; Increment X and Y scales until they're back to normal (#$20).
    CMP.B #$20
    BEQ +
    DEC.B Mode7YScale
  + LDA.B #$07                                ; Set animation frame (7).
    STA.W SpriteMisc1602,X
    RTS

CODE_01CFB7:
; Done with hurt animation.
    LDA.B #$02                                ; Return to normal movement.
    STA.W SpriteMisc151C,X
    LDA.B SpriteTableC2,X
    BEQ +                                     ; Set timer for moving Roy's walls inward.
    LDA.B #$20                                ; Also gets set for Ludwig's battle, but is never used.
    STA.W SpriteInLiquid,X
  + RTS

CODE_01CFC6:
    INC.W SpriteMisc1626,X                    ; Increase Morton/Roy/Ludwig's damage count, and check if time to kill the boss.
    LDA.W SpriteMisc1626,X
    CMP.B #$03                                ; Ludwig, Morton, and Roy's HP, when being hit by Mario.
    BCC +
CODE_01CFD0:
; Kill Morton/Roy/Ludwig.
    LDA.B #!SFX_BOSSDEAD                      ; \ Play sound effect; Ludwig, Morton, and Roy's death SFX.
    STA.W SPCIO0                              ; /
    LDA.B #$04                                ; Change boss phase to 4 (dying).
    STA.W SpriteMisc151C,X
    LDA.B #$13                                ; Set timer for the death animation (specifically, the "boss is growing" part).
    STA.W SpriteMisc1540,X
  + RTS

CODE_01CFE0:
; Morton/Roy/Ludwig phase 4 - Dying.
    LDY.W SpriteMisc1540,X                    ; Branch if shrinking the boss (not growing).
    BEQ CODE_01CFFC
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$01                                ; Move the boss upwards (so he doesn't rotate into the ground).
    STA.B SpriteYPosLow,X
    BCS +
    DEC.W SpriteYPosHigh,X
  + DEC.B Mode7YScale
    TYA                                       ; Increase the boss's scaling.
    AND.B #$03                                ; Horizontal scaling occurs only 3 out of 4 frames, for some reason.
    BEQ +
    DEC.B Mode7XScale
  + BRA +

CODE_01CFFC:
    LDA.B Mode7Angle                          ; Shrink and spin the boss.
    CLC
    ADC.B #$06                                ; Morton/Roy/Ludwig death animation rotation speed.
    STA.B Mode7Angle
    LDA.B Mode7Angle+1
    ADC.B #$00
    AND.B #$01
    STA.B Mode7Angle+1
    INC.B Mode7XScale                         ; Shrink the boss.
    INC.B Mode7YScale
  + LDA.B Mode7YScale
    CMP.B #con($A0,$A0,$A0,$80,$80)           ; Return if the boss hasn't shrunk enough yet.
    BCC Return01D042
    LDA.W SpriteOffscreenX,X
    BNE +
    LDA.B #$01
    STA.W SmokeSpriteNumber
    LDA.B SpriteXPosLow,X
    SBC.B #$08                                ; Spawn a cloud of smoke, unless the boss is offscreen (for Ludwig).
    STA.W SmokeSpriteXPos
    LDA.B SpriteYPosLow,X
    ADC.B #$08
    STA.W SmokeSpriteYPos
    LDA.B #$1B
    STA.W SmokeSpriteTimer
  + LDA.B #$D0                                ; Hide the boss offscreen.
    STA.B SpriteYPosLow,X
    JSL CODE_03DEDF                           ; Handle the Mode 7 tilemap.
    INC.W SpriteMisc151C,X                    ; Increase boss pointer (death cloud).
    LDA.B #$30                                ; Set timer for waiting to end the level.
    STA.W SpriteMisc1540,X
Return01D042:
    RTS

CODE_01D043:
; Morton/Roy/Ludwig phase 5 - Dead (end level).
    LDA.W SpriteMisc1540,X                    ; Return if not time to end the level.
    BNE +
    INC.W CutsceneID                          ; Set cutscene flag.
    DEC.W EndLevelTimer                       ; Set end level timer.
    LDA.B #!BGM_BOSSCLEAR                     ; Song played after defeating Morton/Ludwig/Roy.
    STA.W SPCIO2                              ; / Change music
    STZ.W SpriteStatus,X                      ; Erase the boss.
  + RTS


DATA_01D057:
    db $FF,$F1

CODE_01D059:
; X position offsets for Ludwig's fireballs.
; Spawn Ludwig's fireball.
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect; Ludwig's fireball SFX.
    STA.W SPCIO3                              ; /
    LDY.B #$04
CODE_01D060:
    LDA.W SpriteStatus,Y                      ; Find an empty sprite slot; return if none found.
    BEQ CODE_01D069
    DEY
    BPL CODE_01D060
    RTS

CODE_01D069:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$34                                ; Sprite spawned by Ludwig (fireball).
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    LDA.B SpriteYPosLow,X
    CLC                                       ; Set Y position.
    ADC.B #$03                                ; Height of Ludwig's fireball relative to him.
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.W SpriteMisc157C,X
    PHX
    TAX
    LDA.B _0
    CLC                                       ; Set X position, accounting for direction.
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
    LDA.W SpriteMisc157C,X                    ; Set direction to be the same as Ludwig's.
    STA.W SpriteMisc157C,Y
    TAX
    LDA.W DATA_01D0BE,X                       ; Set X speed.
    STA.W SpriteXSpeed,Y
    LDA.B #$30                                ; How long fireballs stay in Ludwig's mouth before being fired.
    STA.W SpriteMisc1540,Y
    PLX
    RTS


DATA_01D0BE:
    db $20,$E0

CODE_01D0C0:
; Speed of Ludwig's fireballs.
    LDA.B SpriteYSpeed,X                      ; Subroutine to handle Morton/Roy/Ludwig touching the ground. Returns carry set if so, clear if not.
    BMI +
    LDA.W SpriteYPosHigh,X
    BNE +                                     ; Return carry clear if the boss is:
    LDA.B Mode7YScale                         ; Not on the ground.
    LSR A                                     ; Moving upwards.
    TAY                                       ; Y position too low (non-zero high byte).
    LDA.B SpriteYPosLow,X
    CMP.W DATA_01D0DE-8,Y
    BCC +
    LDA.W DATA_01D0DE-8,Y                     ; Adjust Y position to account for scaling.
    STA.B SpriteYPosLow,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Stop the boss from falling.
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
; Y position of the ground for Morton/Roy/Ludwig, accounting for vertical stretch.
; Indexed by the current Y scaling ($39) divided by 2, minus 8.
    LDA.W SpriteMisc1528,X                    ; Morton/Roy's main routine.
    JSL ExecutePtr

    dw CODE_01D146
    dw CODE_01D23F

; Morton/Roy movement/attack pointers.
; 0 - Walking
; 1 - Dropping from ceiling.
    RTS                                       ; Rip.


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
; Morton and Roy X speeds. Indexed by number of hits received and direction. Second bytes are up/down.
; 0 - left
; 0 - right
; 1 - left
; 1 - right
; 2 - left
; 2 - right
; Morton and Roy Y speeds. Indexed by number of hits received and direction. First bytes are left/right.
; 0 - up
; 0 - down
; 1 - up
; 1 - down
; 2 - up
; 2 - down
; Unused values.
; Positions of the ceiling and floor for Morton/Roy.
; Only the second (ceiling) and third (floor) bytes are used.
; Frames for Morton/Roy's walking animations.
    LDA.B EffFrame                            ; Morton/Roy movement phase 0 - Walking.
    LSR A
    LDY.W SpriteMisc1626,X
    CPY.B #$02                                ; Double walking speed after two hits.
    BCS +
    LSR A
  + AND.B #$03
    TAY
    LDA.W DATA_01D142,Y
    LDY.W SpriteMisc15AC,X                    ; Handle walking and turning animations.
    BEQ +                                     ; 0/1/2 - walking, 5 = turning.
    LDA.B #$05
  + STA.W SpriteMisc1602,X
    LDA.W SpriteInLiquid,X
    BEQ +
    LDY.B SpriteXPosLow,X
    CPY.B #$50                                ; Move walls inwards if:
    BCC +                                     ; The timer is set, with an even frame.
    CPY.B #$80                                ; Roy is near the center of the room (tiles 5-7).
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
    STA.B _C                                  ; Store the X positions for the wall's tiles.
    LDA.W SpriteMisc160E,X                    ; Uses $05-0A.
    STA.B _7
    STA.B _8
    STA.B _9
    STA.B _A
    LDA.B Mode7Angle
    ASL A                                     ; Jump if the boss is in the process of turning on a corner.
    BEQ +
    JMP CODE_01D224

  + LDY.W SpriteMisc1594,X                    ; Morton/Roy is not turning on a corner.
    TYA                                       ; Branch if walking vertically.
    LSR A
    BCS CODE_01D1B5
    LDA.B SpriteXPosLow,X
    CPY.B #$00
    BNE CODE_01D1AE
    CMP.W SpriteMisc1534,X
    BCC CODE_01D215                           ; Branch down if walking into one of the walls, to start turning.
    BRA CODE_01D1D8                           ; Else branch for walking forwards.

CODE_01D1AE:
    CMP.W SpriteMisc160E,X
    BCS CODE_01D215
    BRA CODE_01D1D8

CODE_01D1B5:
    LDA.W SpriteMisc157C,X                    ; Walking vertically.
    BNE +
    INY
    INY
    INY                                       ; Keep the boss on the wall they're walking on.
    INY
  + LDA.W _5,Y
    STA.B SpriteXPosLow,X
    LDY.W SpriteMisc1594,X
    LDA.B SpriteYPosLow,X
    CPY.B #$03
    BEQ ADDR_01D1D3
    CMP.W DATA_01D13E,Y                       ; Branch down if walking into the ceiling/floor, to start turning.
    BCC CODE_01D215                           ; Else continue below for walking forwards.
    BRA CODE_01D1D8

ADDR_01D1D3:
    CMP.W DATA_01D13E,Y
    BCS CODE_01D215
CODE_01D1D8:
    LDA.W SpriteMisc1626,X                    ; Not time to start turning - walk forwards.
    CMP.B #$02
    BCC +
    LDA.B #$02
  + ASL A
    ASL A                                     ; Set X/Y speed for the boss.
    ADC.W SpriteMisc1594,X
    TAY
    LDA.W DATA_01D122,Y
    STA.B SpriteXSpeed,X
    LDA.W DATA_01D12E,Y
    STA.B SpriteYSpeed,X
    JSR SubSprXPosNoGrvty                     ; Update position.
    JSR SubSprYPosNoGrvty
    LDA.W SpriteMisc1594,X
    LDY.W SpriteMisc157C,X
    BNE +
    EOR.B #$02                                ; Return if not walking on the ceiling.
  + CMP.B #$02
    BNE +
    JSR SubHorizPos
    LDA.B _F
    CLC
    ADC.B #$10                                ; If Mario is within a tile of the boss, increase phase pointer (falling).
    CMP.B #$20
    BCS +
    INC.W SpriteMisc1528,X
  + RTS

CODE_01D215:
    LDY.W SpriteMisc157C,X                    ; Walking into a corner - start turning.
    LDA.W SpriteMisc1594,X
    CLC                                       ; Increase/decrease relative movement direction.
    ADC.W DATA_01D23D,Y
    AND.B #$03
    STA.W SpriteMisc1594,X
CODE_01D224:
    LDY.W SpriteMisc157C,X                    ; Boss is turning a corner.
    LDA.B Mode7Angle
    CLC
    ADC.W DATA_01D239,Y
    STA.B Mode7Angle                          ; Rotate the boss, based on direction of movement.
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
; Rotation speeds (lo) when Roy and Morton are turning a corner.
; Rotation speeds (hi) when Roy and Morton are turning a corner.
; Values to increase/decrease relative movement direction, indexed by the boss's rotational direction.
; Morton/Roy movement phase 1 - Dropping from the ceiling.
    LDA.W SpriteMisc1540,X                    ; Branch if the ground hasn't been hit yet.
    BEQ CODE_01D25E
    CMP.B #$01                                ; Return if not time to resume normal movement.
    BNE Return01D2A7
    STZ.W SpriteMisc1528,X                    ; Return to normal movement routine.
    JSR SubHorizPos
    TYA
    STA.W SpriteMisc157C,X                    ; Move towards Mario.
    ASL A
    EOR.B #$02
    STA.W SpriteMisc1594,X
    LDA.B #$0A                                ; \ Set turning timer; Set turn timer.
    STA.W SpriteMisc15AC,X                    ; /
    RTS

CODE_01D25E:
; Haven't hit the ground.
    LDA.B #$06                                ; Set falling animation frame (6).
    STA.W SpriteMisc1602,X
    JSR SubSprYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$70
    BCS +                                     ; Update Y position and apply gravity, cap Y speed at #$70.
    CLC
    ADC.B #$04
    STA.B SpriteYSpeed,X
  + LDA.B Mode7Angle
    ORA.B Mode7Angle+1
    BEQ +
    LDA.B Mode7Angle                          ; Rotate clockwise until the boss faces upright again.
    CLC
    ADC.B #$08                                ; Falling rotation speed.
    STA.B Mode7Angle
    LDA.B Mode7Angle+1
    ADC.B #$00
    AND.B #$01
    STA.B Mode7Angle+1
  + JSR CODE_01D0C0                           ; Return if it hasn't hit the ground.
    BCC Return01D2A7
    LDA.B #$20                                ; \ Set ground shake timer; Time to shake the screen after Morton/Roy hit the ground.
    STA.W ScreenShakeTimer                    ; /
    LDA.B PlayerInAir
    BNE +
    LDA.B #$28                                ; \ Lock Mario in place; Time to freeze Mario if he's on the ground when Morton/Roy hit it.
    STA.W PlayerStunnedTimer                  ; /
  + LDA.B #!SFX_KAPOW                         ; \ Play sound effect; SFX for Morton/Roy smashing the ground/
    STA.W SPCIO3                              ; /
    LDA.B #$28                                ; Time until the boss waits before returning to normal movement.
    STA.W SpriteMisc1540,X
    STZ.B Mode7Angle                          ; Reset rotation if not zero already.
    STZ.B Mode7Angle+1
Return01D2A7:
    RTS

CODE_01D2A8:
    LDA.W SpriteMisc151C,X                    ; Morton/Roy/Ludwig interaction routine.
    CMP.B #$03                                ; Return if the boss is in its hurt state.
    BCS Return01D318
    LDA.W SpriteMisc187B,X
    CMP.B #$03
    BNE CODE_01D2BD                           ; Unused?
    LDA.W SpriteMisc1528,X
    CMP.B #$03
    BCS Return01D318
CODE_01D2BD:
    JSL GetMarioClipping
    JSR CODE_01D40B                           ; Return if player not in contact.
    JSL CheckForContact
    BCC Return01D318
    LDA.W SpriteMisc1FE2,X                    ; Return if player contact is disabled.
    BNE Return01D318
    LDA.B #$08                                ; Disable contact for 8 frames.
    STA.W SpriteMisc1FE2,X
    LDA.B PlayerInAir                         ; Branch to just hurt Mario if he's on the ground.
    BEQ CODE_01D319
    LDA.W SpriteMisc1602,X
    CMP.B #$10
    BCS CODE_01D2E3                           ; Branch if falling from the ceiling.
    CMP.B #$06
    BCS ADDR_01D31E
CODE_01D2E3:
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$08                                ; Branch to just bump Mario off if not hitting the top of the boss.
    CMP.B SpriteYPosLow,X
    BCS ADDR_01D31E
    LDA.W SpriteMisc1594,X
    LSR A                                     ; Branch if the boss is currently moving vertically, not horizontally.
    BCS CODE_01D334
    LDA.B PlayerYSpeed+1                      ; Return if Mario is moving upwards.
    BMI Return01D31D
    JSR CODE_01D351                           ; Display a contact sprite.
    LDA.B #$D0                                ; Y speed to give Mario after bouncing on Morton/Roy/Ludwig.
    STA.B PlayerYSpeed+1
    LDA.B #!SFX_SPLAT                         ; \ Play sound effect; SFX for bouncing on Morton/Roy/Ludwig.
    STA.W SPCIO0                              ; /
    LDA.W SpriteMisc1602,X
    CMP.B #$1B                                ; Branch if not Ludwig in his spinning form (i.e. the boss should be hurt).
    BCC CODE_01D379
ADDR_01D309:
; Bouncing on Ludwig in his shell, or downwards onto any boss when falling.
    LDY.B #$20                                ; X speed to give when hitting the right side of Ludwig's shell.
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B #$08
    CMP.B PlayerXPosNext
    BMI +
    LDY.B #$E0                                ; X speed to give when hitting the left side of Ludwig's shell.
  + STY.B PlayerXSpeed+1
Return01D318:
    RTS

CODE_01D319:
    JSL HurtMario                             ; Touching the boss while on the ground; hurt Mario.
Return01D31D:
    RTS

ADDR_01D31E:
; Boss is falling or Mario is touching the lower half of the boss (e.g. while it's falling).
    LDA.B #!SFX_BONK                          ; \ Play sound effect; SFX for the "bump".
    STA.W SPCIO0                              ; /
    LDA.B PlayerYSpeed+1
    BPL +
    LDA.B #$10                                ; Y speed to give when moving upwards and hitting the boss.
    STA.B PlayerYSpeed+1
    RTS

  + JSR ADDR_01D309
    LDA.B #$D0                                ; Y speed to give when moving downwards and hitting the boss.
    STA.B PlayerYSpeed+1
    RTS

CODE_01D334:
; Boss is moving vertically up/down the wall.
    LDA.B #!SFX_BONK                          ; \ Play sound effect; SFX for the "bump".
    STA.W SPCIO0                              ; /
    LDA.B PlayerYSpeed+1
    BPL +
    LDA.B #$20                                ; Y speed to give when hitting the boss while moving upwards.
    STA.B PlayerYSpeed+1
    RTS

  + LDY.B #$20                                ; X speed to give when hitting the right side of the boss while moving downwards.
    LDA.B SpriteXPosLow,X
    BPL +
    LDY.B #$E0                                ; X speed to give when hitting the left side of the boss while moving downwards.
  + STY.B PlayerXSpeed+1
    LDA.B #$B0                                ; Y speed to give when hitting the boss while moving downwards.
    STA.B PlayerYSpeed+1
    RTS

CODE_01D351:
    LDA.B SpriteXPosLow,X                     ; Subroutine to display a contact sprite for hitting Morton/Roy/Ludwig.
    PHA
    SEC
    SBC.B #$08
    STA.B SpriteXPosLow,X                     ; Shift 8 pixels left.
    LDA.W SpriteXPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B SpriteYPosLow,X
    PHA
    CLC                                       ; Shift 8 pixels down.
    ADC.B #$08
    STA.B SpriteYPosLow,X
    JSL DisplayContactGfx                     ; Display the sprite.
    PLA
    STA.B SpriteYPosLow,X
    PLA                                       ; Restore position.
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    RTS

CODE_01D379:
    LDA.B #$18                                ; Subroutine to hurt Morton/Roy/Ludwig.
    STA.B Mode7XScale
    PHX
    LDA.B Mode7YScale                         ; Stretch the boss.
    LSR A
    TAX
    LDA.B #$28
    STA.B Mode7YScale
    LSR A
    TAY
    LDA.W DATA_01D0DE-8,Y
    SEC
    SBC.W DATA_01D0DE-8,X
    PLX                                       ; Shift the boss's position to account for the vertical scaling.
    CLC
    ADC.B SpriteYPosLow,X
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    STZ.B SpriteXSpeed,X                      ; \ Sprite Speed = 0; Clear X/Y speed.
    STZ.B SpriteYSpeed,X                      ; /
    LDA.B #$80                                ; Set timer for the hit animation.
    STA.W SpriteMisc1540,X
    LDA.B #$03                                ; Set phase to hurt.
    STA.W SpriteMisc151C,X
    LDA.B #!SFX_ENEMYHURT                     ; \ Play sound effect; SFX for hurting Morton/Roy/Ludwig.
    STA.W SPCIO3                              ; /
    RTS

CODE_01D3B1:
    LDA.W SpriteMisc151C,X                    ; Subroutine to handle fireball interaction for Morton/Roy/Ludwig.
    CMP.B #$03                                ; Return if already hurt or dying.
    BCS Return01D40A
    LDY.B #$0A
CODE_01D3BA:
    STY.W SpriteInterIndex                    ; Look for Mario's fireballs.
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
    STA.B _9                                  ; Check if it's in contact with the boss.
    LDA.B #$08
    STA.B _2
    STA.B _3
    PHY
    JSR CODE_01D40B
    PLY
    JSL CheckForContact
    BCC +
    LDA.B #$01                                ; \ Extended sprite = Smoke puff
    STA.W ExtSpriteNumber,Y                   ; /; Turn fireball into a puff of smoke.
    LDA.B #$0F
    STA.W ExtSpriteMisc176F,Y
    LDA.B #!SFX_BONK                          ; \ Play sound effect; SFX for hurting Morton/Roy/Ludwig with a fireball.
    STA.W SPCIO0                              ; /
    INC.W SpriteMisc1626,X
    LDA.W SpriteMisc1626,X
    CMP.B #$0C                                ; How many fireballs it takes to kill Morton/Ludwig/Roy.
    BCC +
    JSR CODE_01CFD0
  + DEY
    CPY.B #$07                                ; Continue to next extended sprite. Only check slots 07-0A.
    BNE CODE_01D3BA
Return01D40A:
    RTS

CODE_01D40B:
    LDA.B SpriteXPosLow,X                     ; Subroutine to get clipping data for Morton/Ludwig/Roy, in place of GetSpriteClippingA.
    SEC
    SBC.B #$08
    STA.B _4                                  ; X position
    LDA.W SpriteXPosHigh,X
    SBC.B #$00
    STA.B _A
    LDA.B #$10                                ; Width
    STA.B _6
    LDA.B #$10                                ; Height
    STA.B _7
    LDA.W SpriteMisc1602,X
    CMP.B #$69
    LDA.B #$08
    BCC +
    ADC.B #$0A
; Y position
  + CLC                                       ; (branch unused?...)
    ADC.B SpriteYPosLow,X
    STA.B _5
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _B
    RTS


DATA_01D439:
    db $A8,$B0,$B8,$C0,$C8

; Fireball sprite indexes; hardcoded because of the sprite BG in boss rooms.
    STZ.W SpriteStatus,X                      ; \ Unreachable; Unused erase routine.
    RTS                                       ; / Erase sprite


DATA_01D442:
    db $00,$F0,$00,$10

LudwigFireTiles:
    db $4A,$4C,$6A,$6C

DATA_01D44A:
    db $45,$45,$05,$05

BossFireball:
; X offsets for Ludwig's fireballs. First two are facing right, second are left.
; Tiles for Ludwig's fireball animation. Two tiles per frame.
; YXPPCCCT for Ludwig's fileball animation.
; Boss fireball misc RAM:
; $1540 - Timer for preparing to fire from Ludwig's mouth. Set to #$30 initially.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame. 00 = round fireball, 01 = thin fireball
    LDA.B SpriteLock                          ; Boss fireball MAIN.
    ORA.W PlayerIsFrozen                      ; Skip to graphics if:
    BNE CODE_01D487                           ; Sprites frozen
    LDA.W SpriteMisc1540,X                    ; Player frozen
    CMP.B #$10                                ; Waiting inside Ludwig's mouth.
    BCS CODE_01D487
    TAY
    BNE +                                     ; If done firing from Ludwig's mouth,
    JSR SetAnimationFrame                     ; process interaction with Mario and animate.
    JSR SetAnimationFrame
    JSR MarioSprInteractRt
  + JSR SubSprXPosNoGrvty
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$20
    STA.B _0
    LDA.W SpriteXPosHigh,X                    ; Update X position.
    ADC.B #$00                                ; Erase if off the side of Ludwig's room.
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
    LDA.W SpriteMisc157C,X                    ; Get various OAM-related data.
    ASL A
    STA.B _2
    %LorW_X(LDA,DATA_01D439)
    STA.W SpriteOAMIndex,X
    TAY
    PHX
    LDA.W SpriteMisc1540,X
    LDX.B #$01
    CMP.B #$08                                ; Draw two tiles, or only one tile if waiting in Ludwig's mouth.
    BCC CODE_01D4A8
    DEX
CODE_01D4A8:
    PHX
    PHX
    TXA
    CLC
    ADC.B _2
    TAX                                       ; Set X position, accounting for direction.
    LDA.B _0
    CLC
    ADC.W DATA_01D442,X
    STA.W OAMTileXPos+$100,Y
    LDA.B EffFrame
    LSR A
    LSR A
    ROR A                                     ; Set YXPPCCCT. Flip vertically every 4 frames.
    AND.B #$80
    ORA.W DATA_01D44A,X
    STA.W OAMTileAttr+$100,Y
    LDA.B _1
    INC A                                     ; Set Y position.
    INC A
    STA.W OAMTileYPos+$100,Y
    PLA
    CLC
    ADC.B _3                                  ; Set tile number.
    TAX
    LDA.W LudwigFireTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    INY
    INY
    INY                                       ; Repeat for the second tile, if applicable.
    INY
    DEX
    BPL CODE_01D4A8
    PLX
    LDY.B #$02
    LDA.B #$01                                ; Draw 2 16x16s.
    JMP FinishOAMWriteRt


DATA_01D4E7:
    db $01,$FF

DATA_01D4E9:
    db $0F,$00

DATA_01D4EB:
    db $00,$02,$04,$06,$08,$0A,$0C,$0E
    db $0E,$0C,$0A,$08,$06,$04,$02,$00

ParachuteSprites:
; Increment/decrement values, used for the parachute sprite's angles and Ludwig's shell speed.
; Max/min angle values for the parachute sprite.
; X speeds for each angular value (00-0F). Inverted when moving left.
; Para-Goomba/Bomb misc RAM:
; $C2   - Swing direction (odd = left, even = right)
; $151C - Flag for having hit the side of a block. When set, the sprite locks its animation and sinks straight down.
; $1540 - Timer after landing for the parachute to decend.
; $1570 - Current "angle" (max #$0F)
; $157C - Horizontal direction the sprite is facing.
; $1602 - Current animation frame for the parachute. 0 = normal, 1 = tilt left, 2 = tilt right
; For the parachute's subroutine, values are C (normal) and D (tilted).
    LDA.W SpriteStatus,X                      ; Para-Goomba MAIN / Para-Bomb MAIN
    CMP.B #$08                                ; Skip to graphics if dead.
    BEQ +
    JMP CODE_01D671

  + LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01D558                           ; /; Skip movement if game frozen or landing on the ground.
    LDA.W SpriteMisc1540,X
    BNE CODE_01D558
    LDA.B TrueFrame
    LSR A
    BCC +                                     ; Move downwards one pixel every two frames.
    INC.B SpriteYPosLow,X
    BNE +
    INC.W SpriteYPosHigh,X
  + LDA.W SpriteMisc151C,X                    ; Skip horizontal movement if the sprite hit a wall.
    BNE CODE_01D558
    LDA.B TrueFrame
    LSR A
    BCC +
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY                                       ; Every two frames, increase/decrease the current angle.
    LDA.W SpriteMisc1570,X                    ; If at the maximum, invert direction of movement.
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
    EOR.B #$FF                                ; Update X position, using the angle and current direction to find the X speed.
    INC A
  + CLC
    ADC.B SpriteXSpeed,X
    STA.B SpriteXSpeed,X
    JSR SubSprXPosNoGrvty
    PLA
    STA.B SpriteXSpeed,X
    BRA CODE_01D558

CODE_01D558:
; Handle the parachute's graphics.
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JMP CODE_01D5B3                           ; Draw GFX and interact with Mario.


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
; Animation frames for the parachute, indexed by the sprite's angle ($1570).
; Horizontal directions for the frames designated above.
; X offsets (low) for the Goomba/Bob-omb.
; X offsets (high) for the Goomba/Bob-omb.
; Y offsets for the Goomba/Bob-omb from the parachute.
; Sprite numbers for the parachute sprites to turn into.
; YXPPCCCT data indexes of each frame for the Goomba/Bob-omb's draw call.
    STZ.W TileGenerateTrackA                  ; Parachute sprite GFX routine.
    LDY.B #$F0
    LDA.W SpriteMisc1540,X
    BEQ +
    LSR A
    EOR.B #$0F
    STA.W TileGenerateTrackA
    CLC
    ADC.B #$F0                                ; Get vertical position for the parachute.
    TAY                                       ; Normally one tile above the sprite;
  + STY.B _0                                  ; when landing, sinks into it instead.
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
    PHA                                       ; Set the parachute's palette.
    AND.B #$F1
    ORA.B #$06                                ; Palette to use.
    STA.W SpriteOBJAttribute,X
    LDY.W SpriteMisc1570,X
    LDA.W DATA_01D55E,Y                       ; Get animation frame/direction for the parachute.
    STA.W SpriteMisc1602,X                    ; 0C = normal, 0D = tilted.
    LDA.W DATA_01D56E,Y
    STA.W SpriteMisc157C,X
    JSR SubSprGfx2Entry1                      ; Draw a 16x16 tile.
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
    STA.B SpriteXPosLow,X                     ; Get horizontal position for the Goomba/Bob-omb.
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
  + CLC                                       ; Get vertical position for the Goomba/Bob-omb, offset from the parachute.
    ADC.B SpriteYPosLow,X
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    ADC.B _0
    STA.W SpriteYPosHigh,X
    LDA.W SpriteMisc1602,X
    SEC
    SBC.B #$0C
    CMP.B #$01
    BNE +                                     ; Get animation frame for the Goomba/Bob-omb.
    CLC                                       ; 00 = normal, 01 = tilted left, 02 = tilted right.
    ADC.W SpriteMisc157C,X
  + STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    BEQ +                                     ; If it landed on the ground, clear the animation frame.
    STZ.W SpriteMisc1602,X
  + LDY.W SpriteMisc1602,X
    LDA.W DATA_01D5B0,Y                       ; Draw four 8x8s.
    JSR SubSprGfx0Entry0
    JSR SubSprSpr_MarioSpr                    ; Process interaction with Mario and other sprites.
    LDA.W SpriteMisc1540,X
    BEQ CODE_01D693                           ; Branch depending on whether the sprite has landed or in the process of landing.
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
    STA.W SpriteMisc1540,X                    ; Turn the sprite into a Bob-omb/Goomba, and set its stun timer.
CODE_01D671:
    LDA.B SpriteNumber,X
    SEC
    SBC.B #$3F
    TAY
    LDA.W DATA_01D5AE,Y
    STA.B SpriteNumber,X
    JSL LoadSpriteTables
    RTS

  + JSR CODE_019140                           ; Landed on the ground, waiting for parachute to fall.
    JSR IsOnGround
    BEQ +
    JSR SetSomeYSpeed__                       ; Useless. (likely leftover from an older version)
  + JSR SubSprYPosNoGrvty
    INC.B SpriteYSpeed,X
    BRA CODE_01D6B5                           ; Restore position values.

CODE_01D693:
    TXA                                       ; Hasn't landed.
    EOR.B TrueFrame
    LSR A                                     ; Process object interaction every other frame.
    BCC CODE_01D6B5
    JSR CODE_019140
    JSR IsTouchingObjSide
    BEQ +
    LDA.B #$01                                ; If it hits the side of a block, lock its angle at #$07.
    STA.W SpriteMisc151C,X
    LDA.B #$07
    STA.W SpriteMisc1570,X
  + JSR IsOnGround
    BEQ CODE_01D6B5                           ; If it hits the ground, start the "falling parachute" timer.
    LDA.B #$20
    STA.W SpriteMisc1540,X
CODE_01D6B5:
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X                     ; Restore position values.
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
Return01D6C3:
    RTS

InitLineRope:
    CPX.B #$06                                ; Line-guided rope INIT
    BCC +                                     ; If in slot 06+
    LDA.W SpriteMemorySetting                 ; and the sprite memory setting is 01,
    BEQ +                                     ; make the rope long.
    INC.W SpriteTweakerB,X
    BRA +

InitLinePlat:
    LDA.B SpriteXPosLow,X                     ; Brown/checkered line-guided platform INIT
    AND.B #$10
    EOR.B #$10                                ; Change type depending on X position.
    STA.W SpriteMisc1602,X
    BEQ +
    INC.W SpriteTweakerB,X
  + INC.W SpriteMisc1540,X
    JSR LineFuzzy_Plats                       ; Run MAIN routine, twice for some reason.
    JSR LineFuzzy_Plats
    INC.W SpriteMisc1626,X                    ; Make stationary.
Return01D6EC:
    RTS

InitLineGuidedSpr:
; Chainsaw, Grinder, and Fuzzy INIT
    INC.W SpriteMisc187B,X                    ; Make move 1.5 times as fast.
    LDA.B SpriteXPosLow,X
    AND.B #$10
    BNE CODE_01D707
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B #$40
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X                    ; If in an even X position,
    SBC.B #$01                                ; spawn 20 tiles to the left, and set it to go right/down.
    STA.W SpriteXPosHigh,X                    ; Else,
    BRA InitLineBrwnPlat                      ; spawn one tile to the right, and set to go left/up.

CODE_01D707:
    INC.W SpriteMisc157C,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$0F
    STA.B SpriteXPosLow,X
InitLineBrwnPlat:
    LDA.B #$02                                ; Line-guided brown platform INIT
    STA.W SpriteMisc1540,X
    RTS


DATA_01D717:
    db $F8,$00

LineRope_Chainsaw:
; X offsets of the smoke spawned by the rope/saw mechanisms.
; Line-guided sprite misc RAM:
; $C2   - State of the sprite.
; 0 = end of tile, 1 = on rope, 2 = falling
; $151C - Base index to the current line guide's offset table at $07F9DB, low.
; $1528 - Base index to the current line guide's offset table at $07F9DB, high.
; $1534 - "Left" offset from the base index to $07F9DB. When moving D/R, increments each frame.
; $1540 - Timer to briefly prevent latching onto a rope after falling off one. Set to #$10 when starting to fall.
; Also briefly set to #$01/#$02 during initialization.
; $154C - Disable interaction with Mario.
; Set to #$08 for contact with enemies.
; Set to #$10 when jumping off a rope.
; $1570 - "Right" offset from the base index to $07F9DB. When moving U/L, decrements each frame.
; $157C - Direction of movement. 0 = down/right, 1 = up/left.
; $1602 - Checker/brown platform: type of platform. 00 = brown, 10 = checkerboard.
; $160E - Current rope tile the sprite is touching, minus 76.
; $1626 - Stationary flag. When 0, the sprite is moving.
; $163E - In contact with Mario flag. Set to #$03 when true.
; $187B - When set, increases the sprite's speed by 1.5 times.
    TXA                                       ; Line-guided rope MAIN / Chainsaw MAIN
    ASL A
    ASL A
    EOR.B EffFrame
    STA.B _2
    AND.B #$07
    ORA.B SpriteLock
    BNE LineGrinder
    LDA.B _2                                  ; Draw smoke at the sprite's position every 8 frames.
    LSR A
    LSR A
    LSR A
    AND.B #$01
    TAY
    LDA.W DATA_01D717,Y
    STA.B _0
    LDA.B #$F2                                ; Y offset of the smoke.
    STA.B _1
    JSR CODE_018063
LineGrinder:
    LDA.B TrueFrame                           ; Grinder MAIN
    AND.B #$07
    ORA.W SpriteMisc1626,X
    ORA.B SpriteLock                          ; Play sound effect every 8 frames.
    BNE LineFuzzy_Plats
    LDA.B #!SFX_BLOCKSNAKE                    ; \ Play sound effect; SFX for line-guided sprites.
    STA.W SPCIO1                              ; /
LineFuzzy_Plats:
    JMP CODE_01D9A7                           ; Fuzzy MAIN / line-guided platform MAIN

CODE_01D74D:
; Generic line-guidance routine.
    JSR SubOffscreen1Bnk1                     ; Process offscreen from -$40 to +$A0.
    LDA.W SpriteMisc1540,X
    BNE CODE_01D75C                           ; Return if the sprite did not just fall off a rope
    LDA.B SpriteLock                          ; and either the game is frozen or the sprite is stationary.
    ORA.W SpriteMisc1626,X
    BNE Return01D6EC
CODE_01D75C:
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_01D7F4
    dw CODE_01D768
    dw CODE_01DB44

CODE_01D768:
; Line-guided sprite state pointers.
; 0 - Reached end of tile
; 1 - On rope.
; 2 - Falling
; State 1: On rope.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if the game is frozen.
    BNE Return01D791                          ; /
    LDA.W SpriteMisc157C,X                    ; Branch if moving up/left.
    BNE CODE_01D792
    LDY.W SpriteMisc1534,X
    JSR CODE_01D7B0                           ; Update position (D/R).
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc187B,X
    BEQ +
    LDA.B TrueFrame                           ; Make fuzzies/grinders/chainsaws move 1.5 times faster.
    LSR A
    BCC +
    INC.W SpriteMisc1534,X
  + LDA.W SpriteMisc1534,X
    CMP.W SpriteMisc1570,X                    ; If at the end of the current tile, switch to state 0.
    BCC Return01D791
    STZ.B SpriteTableC2,X
Return01D791:
    RTS

CODE_01D792:
    LDY.W SpriteMisc1570,X                    ; Moving up/left.
    DEY                                       ; Update position (U/L).
    JSR CODE_01D7B0
    DEC.W SpriteMisc1570,X
    BEQ CODE_01D7AD
    LDA.W SpriteMisc187B,X
    BEQ +
    LDA.B TrueFrame
    LSR A                                     ; Make fuzzies/grinders/chainsaws move 1.5 times faster.
    BCC +                                     ; If at the end of the current tile, switch to state 0.
    DEC.W SpriteMisc1570,X
    BNE +
CODE_01D7AD:
    STZ.B SpriteTableC2,X
  + RTS

CODE_01D7B0:
; Subroutine to update a line-guided sprite's position.
    PHB                                       ; Sprites calling this routine must be modified; ; Load pointer offset to Y before running.
    LDA.B #$07                                ; to set $151C,x and $1528,x to a location in
    PHA                                       ; LineTable instead of $07/F9DB+something
    PLB
    LDA.W SpriteMisc151C,X                    ; Get base pointer to $07F9DB.
    STA.B _4
    LDA.W SpriteMisc1528,X
    STA.B _5
    LDA.B (_4),Y
    AND.B #$0F
    STA.B _6
    LDA.B (_4),Y
    PLB                                       ; Get new X and Y offset for the current tile.
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _7
    LDA.B SpriteYPosLow,X
    AND.B #$F0
    CLC                                       ; Update Y position.
    ADC.B _7
    STA.B SpriteYPosLow,X
    LDA.B SpriteXPosLow,X
    AND.B #$F0
    CLC                                       ; Update X position.
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
; Search X offsets for finding a line guide.
; Default order (backwards): v>, ^>, v<, ^<
; Search X offsets, high byte.
; Search Y offsets for finding a line guide.
    JMP CODE_01D89F                           ; Search Y offsets, high byte.

CODE_01D7F4:
    LDY.B #$03                                ; State 0: Reached the end of tile. Search for next rope tile.
CODE_01D7F6:
    STY.W SpriteInterIndex                    ; Check if touching a line guide.
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_01D7E1,Y
    STA.B _2                                  ; Get position to check for a rope tile.
    LDA.W SpriteXPosHigh,X                    ; $00 = Tile Y pos (lo)
    ADC.W DATA_01D7E5,Y                       ; $01 = Tile Y pos (hi)
    STA.B _3                                  ; $02 = Tile X pos (lo)
    LDA.B SpriteYPosLow,X                     ; $03 = Tile X pos (hi)
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
    AND.B #$F0                                ; Check whether an actual new block is being looked at.
    CMP.B _4                                  ; $04 = Y position of block being looked at.
    BNE CODE_01D83A                           ; $05 = X position of block being locked at, if not looking at a new row.
    LDA.B _2                                  ; If not looking at a new block, skip to the next search offset.
    AND.B #$F0
    STA.B _5
    LDA.B SpriteXPosLow,X
    AND.B #$F0
    CMP.B _5
    BEQ CODE_01D861
CODE_01D83A:
    JSR CODE_01D94D                           ;WIERD ROUTINE INVOLVING POSITIONS.  ALL VARIABLES SET ABOVE...; Branch if the tile being touched is not on page 0.
    BNE CODE_01D7F1                           ; (broken?)
    LDA.W Map16TileNumber                     ;"# OF CUSTOM BLOCK???"
    CMP.B #$94
    BEQ CODE_01D851
    CMP.B #$95
    BNE CODE_01D856
    LDA.W OnOffSwitch                         ; Decide whether the tile is a rope tile, and branch if so.
    BEQ CODE_01D861                           ; 094: Rope tile if ON/OFF switch is on.
    BNE CODE_01D856                           ; 095: Rope tile if ON/OFF switch is off.
CODE_01D851:
; 076-093, 096-099: Rope tiles.
    LDA.W OnOffSwitch                         ; Anything else: Not a rope tile.
    BNE CODE_01D861
CODE_01D856:
    LDA.W Map16TileNumber
    CMP.B #$76
    BCC CODE_01D861
    CMP.B #$9A
    BCC CODE_01D895
CODE_01D861:
    LDY.W SpriteInterIndex                    ; Tile is not a rope tile.
    DEY                                       ; Repeat for all the search offsets.
    BPL CODE_01D7F6
    LDA.B SpriteTableC2,X
    CMP.B #$02                                ; ?? #00 - platforms stop at end rather than fall off; If already falling, return.
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
  + LDA.W DATA_01DD11,Y                       ; Set X/Y speed for the sprite and set to falling.
    BPL +
    ASL A
  + PHY
    ASL A
    STA.B SpriteYSpeed,X                      ;SPEED SETTINGS!
    PLY
    LDA.W DATA_01DD51,Y
    ASL A
    STA.B SpriteXSpeed,X
    LDA.B #$10                                ; How long to prevent grabbing onto a rope again.
    STA.W SpriteMisc1540,X
Return01D894:
    RTS

CODE_01D895:
    PHA                                       ; Tile is a rope tile (076-099).
    SEC
    SBC.B #$76                                ; Normalize index.
    TAY
    PLA
    CMP.B #$96
    BCC CODE_01D8A4
CODE_01D89F:
    LDY.W SpriteMisc160E,X                    ; Don't move the sprite if running into tiles 096-099.
    BRA +

CODE_01D8A4:
    LDA.B SpriteYPosLow,X
    STA.B _8
    LDA.W SpriteYPosHigh,X
    STA.B _9
    LDA.B SpriteXPosLow,X
    STA.B _A                                  ; Move the sprite onto the rope, and track some free RAM:
    LDA.W SpriteXPosHigh,X                    ; $08 - Original Y pos (lo)
    STA.B _B                                  ; $09 - Original Y pos (hi)
    LDA.B _0                                  ; $0A - Original X pos (lo)
    STA.B SpriteYPosLow,X                     ; $0B - Original X pos (hi)
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
    LDA.W DATA_07FBF3,Y                       ; Set base index to $07F9DB for the tile.
    STA.W SpriteMisc151C,X
    LDA.W DATA_07FC13,Y
    STA.W SpriteMisc1528,X
    PLB
    LDA.W DATA_01DCD1,Y
    STA.W SpriteMisc1570,X                    ; Set start and end offsets.
    STZ.W SpriteMisc1534,X
    TYA                                       ; Track the current tile number.
    STA.W SpriteMisc160E,X
    LDA.W SpriteMisc1540,X                    ; Unused? I don't think this code can run with this set.
    BNE CODE_01D933
    STZ.W SpriteMisc157C,X
    LDA.W DATA_01DCF1,Y
    BEQ CODE_01D8FF
    TAY
    LDA.B SpriteYPosLow,X
    CPY.B #$01
    BNE +
    EOR.B #$0F
; Decide whether to make the sprite move right or left on the rope.
  + BRA +                                     ; Only moves left if:

CODE_01D8FF:
; Meets condition decided by $01DCF1
    LDA.B SpriteXPosLow,X                     ; Not coming from falling state (i.e. already on the rope).
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
    ADC.B #$08                                ; If not in range of the rope's "start" position, skip it.
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
; Rope tile successfully found.
    LDA.B #$01                                ; Switch to on-rope state.
    STA.B SpriteTableC2,X
    RTS

  + LDA.B _8                                  ; Not touching the start of the rope.
    STA.B SpriteYPosLow,X
    LDA.B _9
    STA.W SpriteYPosHigh,X                    ; Restore original position.
    LDA.B _A
    STA.B SpriteXPosLow,X
    LDA.B _B
    STA.W SpriteXPosHigh,X
    JMP CODE_01D861

CODE_01D94D:
    LDA.B _0                                  ; Line-guided sprite routine to find the tile the sprite is about to touch.
    AND.B #$F0
    STA.B _6
    LDA.B _2
    LSR A                                     ; First push: $0X
    LSR A                                     ; Second push: $YX
    LSR A                                     ; (where Y/X are the tile's position)
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
    STA.B _5                                  ; Get tile pointer (vertical level).
    LDA.L DATA_00BABC,X
    ADC.B _3
    STA.B _6
    BRA +

CODE_01D977:
    PLA
    LDX.B _3
    CLC
    ADC.L DATA_00BA60,X                       ; Get tile pointer (horizontal level).
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
    LDA.B [_5]                                ; Get tile number in $1693, high byte in A?
    PLY                                       ; Seems to only work in certain X positions...?
    STY.B _5
    PHA
    LDA.B _5
    AND.B #$07
    TAY
    PLA
    AND.W DATA_018000,Y
    RTS

CODE_01D9A7:
    LDA.B SpriteNumber,X                      ;LINE GUIDE PLATFORM FUZZY; Various line-guided sprite routines.
    CMP.B #$64                                ;DETERMINE SPRITE ITS DEALING WITH; Branch if the rope mechanism.
    BEQ CODE_01D9D3
    CMP.B #$65                                ; Branch if a line-guided platform.
    BCC CODE_01D9D0                           ;PLATFORM!
    CMP.B #$68                                ; Branch if not a fuzzy (grinder, chainsaw).
    BNE CODE_01D9BA
    JSR CODE_01DBD4                           ; Fuzzy.
    BRA CODE_01D9C1

CODE_01D9BA:
    CMP.B #$67                                ; Branch if not a grinder.
    BNE CODE_01D9C6
; Grinder.
    JSR CODE_01DC0B                           ; Draw GFX.
CODE_01D9C1:
    JSR MarioSprInteractRt                    ; Interact with Mario.
    BRA +                                     ; Run line-guided routines.

CODE_01D9C6:
; Chainsaw.
    JSR MarioSprInteractRt                    ; Interact with Mario.
    JSL CODE_03C263                           ; Draw GFX.
  + JMP CODE_01D74D                           ; Run line-guided routines.

CODE_01D9D0:
; Platform.
    JMP CODE_01DAA2                           ; Jump to MAIN.

CODE_01D9D3:
; Actual rope mechanism MAIN.
    JSR CODE_01DC54                           ; Draw GFX.
    LDA.B SpriteXPosLow,X
    PHA
    LDA.B SpriteYPosLow,X
    PHA
    JSR CODE_01D74D                           ; Run line-guided routines.
    PLA
    SEC
    SBC.B SpriteYPosLow,X
    EOR.B #$FF                                ; Track number of pixels the rope moved vertically and horizontally.
    INC A
    STA.W TileGenerateTrackA
    PLA
    SEC
    SBC.B SpriteXPosLow,X
    EOR.B #$FF
    INC A
    STA.W TileGenerateTrackB
    LDA.B PlayerBlockedDir
    AND.B #$03                                ; Return if Mario is blocked on either side.
    BNE Return01DA09
    JSR CODE_01A80F                           ; Branch if Mario and the rope are in contact.
    BCS CODE_01DA0A
CODE_01D9FE:
    LDA.W SpriteMisc163E,X                    ; Not in contact with Mario.
    BEQ Return01DA09                          ; Clear flag for being able to grab the rope.
    STZ.W SpriteMisc163E,X
    STZ.W PlayerClimbingRope
Return01DA09:
    RTS

CODE_01DA0A:
; In contact with Mario.
    LDA.W SpriteStatus,X                      ; Clear climbing flag if the rope is despawning...?
    BEQ CODE_01DA37
    LDA.W CarryingFlag                        ; \ Branch if carrying an enemy...
    ORA.W PlayerRidingYoshi                   ; | ...or if on Yoshi; Return not in contact if Mario is carrying something.
    BNE CODE_01D9FE                           ; /
    LDA.B #$03                                ; Set flag for being in contact with the rope.
    STA.W SpriteMisc163E,X
    LDA.W SpriteMisc154C,X
    BNE Return01DA8F
    LDA.W PlayerClimbingRope                  ; Return if:
    BNE CODE_01DA2F                           ; "Prevent climbing" flag set.
    LDA.B byetudlrHold                        ; Not already on the rope and up isn't being pressed.
    AND.B #$08
    BEQ Return01DA8F
    STA.W PlayerClimbingRope
CODE_01DA2F:
; Rope is being climbed.
    BIT.B byetudlrFrame                       ; Check if B is pressed.
    BPL +
    LDA.B #$B0                                ; Y speed given when jumping off a rope mechanism.
    STA.B PlayerYSpeed+1
CODE_01DA37:
    STZ.W PlayerClimbingRope                  ; Clear climbing flag.
    LDA.B #$10                                ; Briefly prevent regrabbing the rope.
    STA.W SpriteMisc154C,X
  + LDY.B #$00                                ; Not jumping off.
    LDA.W TileGenerateTrackA
    BPL +
    DEY
  + CLC
    ADC.B PlayerYPosNext
    STA.B PlayerYPosNext
    TYA
    ADC.B PlayerYPosNext+1
    STA.B PlayerYPosNext+1                    ; Move Mario's Y position with the rope.
    LDA.B SpriteYPosLow,X                     ; Also, if he's too high up on the rope, move him downwards.
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
    BEQ CODE_01DA84                           ; Move Mario's X position with the rope.
    BPL CODE_01DA7F                           ; Also, center him onto the rope.
    LDA.B #$FF
    BRA +

CODE_01DA7F:
    LDA.B #$01
  + JSR CODE_01DA90
CODE_01DA84:
    LDA.W SpriteMisc1626,X
    BEQ Return01DA8F                          ; Make the rope start moving if not already.
    STZ.W SpriteMisc1626,X
    STZ.W SpriteMisc1540,X
Return01DA8F:
    RTS

CODE_01DA90:
    LDY.B #$00                                ; Subroutine to shift Mario's X position along the rope. A contains the number of pixels to move.
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
    LDY.B #$18                                ;LINE GUIDED PLATFORM CODE; Actual line-guided platform MAIN.
    LDA.W SpriteMisc1602,X                    ; Get platform size.
    BEQ +                                     ; Brown: 3 tiles
    LDY.B #$28                                ;CONDITIONAL DEPENDING ON PLATFORM TYPE?; Checkered: 5 tiles.
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
    PHA                                       ; Center the platform's graphics and move up half a tile.
    SEC
    SBC.B #$08
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSR CODE_01B2DF                           ;DRAW GFX  .  RELIES ON NEW POSITIONS MADE UP THERE.; Draw GFX.
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
    JSR CODE_01D74D                           ;LINE GUIDE HANDLER???; Run line-guided routines.
    PLA
    SEC
    SBC.B SpriteXPosLow,X                     ; Track number of pixels moved horizontally and temporarily store over $1528.
    LDY.W SpriteMisc1528,X
    PHY
    EOR.B #$FF
    INC A
    STA.W SpriteMisc1528,X
    LDY.B #$18
    LDA.W SpriteMisc1602,X                    ; Get platform size (again).
    BEQ +                                     ; Brown: 3 tiles
    LDY.B #$28                                ; Checkered: 5 tiles.
  + STY.B _0
    LDA.B SpriteXPosLow,X
    PHA
    SEC
    SBC.B _0
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteXPosHigh,X                    ; Center the platform and shift up half a tile **again**,
    LDA.B SpriteYPosLow,X                     ; this time for interaction.
    PHA
    SEC
    SBC.B #$08
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSR CODE_01B457                           ;CUSTOM INTERACTION HANDLER; Make platform solid.
    BCC +
    LDA.W SpriteMisc1626,X
    BEQ +                                     ; If Mario is on the platform and it isn't already moving, make it start.
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
    PLA                                       ; Restore original value for $1528.
    STA.W SpriteMisc1528,X
    RTS

CODE_01DB44:
; Line-guided state 2: Falling.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if frozen.
    BNE +                                     ; /
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    LDA.W SpriteMisc1540,X
    BNE +                                     ; Check for other line guides if:
    LDA.B SpriteYSpeed,X                      ; Just fell off a rope and relatching temporarily disabled.
    CMP.B #$20                                ; Falling downward faster than #$20 (i.e. not moving upward or at peak of jump)
    BMI +
    JSR CODE_01D7F4
  + RTS


DATA_01DB5A:
    db $18,$E8

Grinder:
; Ground grinder misc RAM:
; $157C - Direction the sprite is moving. 0 = right, 1 = left.
; X speeds for the ground grinder.
; Ground Grinder MAIN
    JSR CODE_01DBA2                           ; Draw GFX.
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return01DB95                          ; Return if dead or sprites frozen.
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01DB95                          ; /
    LDA.B TrueFrame
    AND.B #$03                                ; Play grinder sound every 4 frames.
    BNE +
    LDA.B #!SFX_BLOCKSNAKE                    ; \ Play sound effect; SFX for the ground grinder.
    STA.W SPCIO1                              ; /
  + JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR MarioSprInteractRt                    ; Process interaction with Mario.
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01DB5A,Y                       ; Set X speed.
    STA.B SpriteXSpeed,X
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    JSR IsOnGround
    BEQ +                                     ; Clear Y speed if on the ground.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + JSR IsTouchingObjSide
    BEQ Return01DB95                          ; Turn around if it hits something.
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
; X position offsets for the ground grinder's tiles.
; Y position offsets for the ground grinder's tiles.
; YXPPCCCT for the ground grinder's tiles.
    JSR GetDrawInfoBnk1                       ; Ground Grinder GFX routine.
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC                                       ; Set X position.
    ADC.W DATA_01DB96,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Set Y position.
    ADC.W DATA_01DB9A,X
    STA.W OAMTileYPos+$100,Y
    LDA.B EffFrame
    AND.B #$02                                ; Set tile (6C/6E).
    ORA.B #$6C
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_01DB9E,X                       ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for 4 tiles.
    INY
    DEX
    BPL -
CODE_01DBD0:
    LDA.B #$03                                ; Draw 4 16x16s.
    BRA +

CODE_01DBD4:
; Fuzzy GFX routine.
    JSR SubSprGfx2Entry1                      ; Create a 16x16 tile.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileXPos+$100,Y
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$100,Y                  ; Shift half a tile left and up.
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B #$08
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$01                                ; Animate by X flipping every four frames.
    TAX
    LDA.B #$C8                                ; Tile to use for the Fuzzy.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_01DC09,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.B #$00
  + PLX                                       ; Draw a 16x16.
CODE_01DC04:
    LDY.B #$02
    JMP FinishOAMWriteRt


DATA_01DC09:
    db $05,$45

CODE_01DC0B:
; YXPPCCCT to use for the Fuzzy's animation.
    JSR GetDrawInfoBnk1                       ; Line-guided Grinder GFX routine.
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC                                       ; Set X position.
    ADC.W DATA_01DC3B,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Set Y position.
    ADC.W DATA_01DC3F,X
    STA.W OAMTileYPos+$100,Y
    LDA.B EffFrame
    AND.B #$02                                ; Set tile (6C/6E).
    ORA.B #$6C
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_01DC43,X                       ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for 4 tiles.
    INY
    DEX
    BPL -
    BRA CODE_01DBD0                           ; Draw 4 16x16s.


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
; X position offsets for the line-guided grinder's tiles.
; Y position offsets for the line-guided grinder's tiles.
; YXPPCCCT for the line-guided grinder's tiles.
; Tile numbers for the rope mechanism's motor's animation.
; Tile numbers for the rope part of the rope mechanism.
    JSR GetDrawInfoBnk1                       ; Rope mechanism GFX routine.
    LDA.B _0
    SEC
    SBC.B #$08
    STA.B _0                                  ; Shift half a tile left and up.
    LDA.B _1
    SEC
    SBC.B #$08
    STA.B _1
    TXA
    ASL A
    ASL A
    EOR.B EffFrame                            ; $02 = Animation index for the motor,
    LSR A                                     ; using the sprite's slot so that multiple
    LSR A                                     ; ropes onscreen at a time don't look identical.
    LSR A
    AND.B #$03
    STA.B _2
    LDA.B #$05
    CPX.B #$06                                ; $03 = Length of the rope.
    BCC +
    LDY.W SpriteMemorySetting                 ; Will by default have a length of 5 tiles, unless:
    BEQ +                                     ; Sprite memory setting is 0.
    LDA.B #$09                                ; Sprite is in slot 6+.
  + STA.B _3                                  ; In which case the length will be 9 tiles.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDX.B #$00
CODE_01DC85:
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y                  ; Set X/Y position for the current tile.
    CLC
    ADC.B #$10
    STA.B _1
    %LorW_X(LDA,LineGuideRopeTiles)
    CPX.B #$00
    BNE +
    PHX
    LDX.B _2                                  ; Set tile number.
    %LorW_X(LDA,RopeMotorTiles)
    PLX
  + STA.W OAMTileNo+$100,Y
    LDA.B #$37                                ; YXPPCCCT for the motor.
    CPX.B #$01
    BCC +
    LDA.B #$31                                ; YXPPCCCT for the rope.
  + STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY                                       ; Loop for all tiles.
    INX
    CPX.B _3
    BNE CODE_01DC85
    LDA.B #$DE                                ; Tile number for the last tile of the rope.
    STA.W OAMTileNo+$FC,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$04
    CPX.B #$06
    BCC +
    LDY.W SpriteMemorySetting                 ; Draw 5 or 9 16x16 tiles.
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
; Number of frames (and offsets) each lineguide takes to move across.
; Used as the "right index" for the movement.
; Used to determine how to direct an incoming line-guided sprite on a line guide.
; #$00 = Horizontal; moves left if in X range of 0A-0F (right) of the rope.
; #$01 = Vertical; moves left if in Y range 01-05 (bottom) of the rope.
; #$02 = Vertical; moves left if in Y range 0A-0F (top) of the rope.
; Y speeds to give a line-guided sprite when falling off the end.
; First x20: R/D, second: U/L
; X speeds to give a line-guided sprite when falling off the end.
; First x20: R/D, second: U/L
; X positions for each bonus game box.
; Y positions for each bonus game box.
; Initial movement directions for each bonus game box.
    LDA.W DisableBonusSprite                  ; Bonus Game INIT
    BEQ +                                     ; Erase sprite if all the boxes are already spawned.
    STZ.W SpriteStatus,X
    RTS

  + LDX.B #$09                                ; Create 8 more boxes.
CODE_01DDB7:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /; Spawn another bonus game box.
    LDA.B #$82
    STA.W SpriteNumber,X
    %LorW_X(LDA,DATA_01DD90)
    STA.B SpriteXPosLow,X
    LDA.B #$00
    STA.W SpriteXPosHigh,X
    %LorW_X(LDA,DATA_01DD99)
    STA.B SpriteYPosLow,X                     ; Set X/Y position for the box.
    ASL A
    LDA.B #$00
    BCS +
    INC A
  + STA.W SpriteYPosHigh,X
    JSL InitSpriteTables
    %LorW_X(LDA,DATA_01DDA2)
    STA.W SpriteMisc157C,X                    ; Set initial movement direction.
    TXA
    CLC
    ADC.B TrueFrame                           ; Set initial item for the box.
    AND.B #$07
    STA.W SpriteMisc1570,X
    DEX                                       ; Loop for 8 boxes.
    BNE CODE_01DDB7
    STZ.W BonusGameComplete                   ; Clear bonus game beat flag and bonus 1up counter.
    STZ.W BonusGame1UpCount
    JSL GetRand
    EOR.B TrueFrame
    ADC.B EffFrame
    AND.B #$07                                ; Stick a random sprite in the central box.
    TAY
    LDA.W DATA_01DE21,Y
    STA.W SpriteMisc1570+9
    LDA.B #$01                                ; Stop the central box from animating.
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
; X speeds to give the box for each movement direction.
; Y speeds to give the box for each movement direction.
; X positions where the box should stop and change movement direction (the "corners").
; Y positions where the box should stop and change movement direction (the "corners").
; Contents to display in the box when the box is hit.
; Star
; Mushroom
; Fireflower
; Bonus game misc RAM:
; $C2   - Flag for whether the box is animating (0) or stopped (1).
; $1540 - Timer for the block's hit animation.
; $154C - Timer for flashing complete lines after the game ends.
; $1570 - Current animation frame. 0/1/2 = star, 3/4/5 = mushroom, 6/7/8 = fireflower.
; $157C - Direction of movement.
; 0 = right, 1 = down, 2 = left, 3 = up, FF = No movement (center item).
; Bonus Game MAIN
    STZ.W SpriteOffscreenX,X                  ; Clear offscreen flag?...
    CPX.B #$01
    BNE +                                     ; Handle spawning 1ups at the end of the game.
    JSR CODE_01E26A
  + JSR CODE_01DF19                           ; Draw GFX.
    LDA.B SpriteLock                          ; \ Return if sprites locked
    BNE Return01DE40                          ; /
    LDA.W BonusGameComplete                   ; Return if sprites frozen
    BEQ +                                     ; or the game is over.
Return01DE40:
    RTS

; Bonus game isn't over.
  + LDA.B SpriteTableC2,X                     ; Branch if the box isn't animating its contents.
    BNE CODE_01DE8C
    LDA.B EffFrame
    AND.B #$03
    BNE +
    INC.W SpriteMisc1570,X                    ; Increase animation index every 4 frames.
    LDA.W SpriteMisc1570,X
    CMP.B #$09
    BNE +
    STZ.W SpriteMisc1570,X
  + JSR MarioSprInteractRt
    BCC CODE_01DE8C
    LDA.B PlayerYSpeed+1
    BPL CODE_01DE8C
    LDA.B #$F4
    LDY.B Powerup                             ; Branch if:
    BEQ +                                     ; Not in contact with Mario.
    LDA.B #con($00,$00,$00,$FC,$FC)           ; Mario isn't moving upwards.
  + CLC                                       ; Not being touched specifically by Mario's head.
    ADC.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B PlayerYPosScrRel
    BCS CODE_01DE8C
    LDA.B #$10                                ; Y speed to give Mario when hitting the bottom of a bonus game box.
    STA.B PlayerYSpeed+1
    LDA.B #!SFX_SWITCH                        ; \ Play sound effect; SFX for hitting a bonus game box.
    STA.W SPCIO0                              ; /
    INC.B SpriteTableC2,X                     ; Stop the box from animating.
    LDY.W SpriteMisc1570,X
    LDA.W DATA_01DE21,Y                       ; "Round" the box's contents to a full item.
    STA.W SpriteMisc1570,X
    LDA.B #$10                                ; Set timer for the box's hit animation.
    STA.W SpriteMisc1540,X
CODE_01DE8C:
; Move the box around the circle.
    LDY.W SpriteMisc157C,X                    ; Return if the box shouldn't move (center box).
    BMI Return01DEAF
    LDA.B SpriteXPosLow,X
    CMP.W DATA_01DE19,Y
    BNE CODE_01DE9F                           ; Branch if the box has hit a "corner" of the game.
    LDA.B SpriteYPosLow,X
    CMP.W DATA_01DE1D,Y
    BEQ +
CODE_01DE9F:
    LDA.W DATA_01DE11,Y
    STA.B SpriteXSpeed,X                      ; Update X/Y speed.
    LDA.W DATA_01DE15,Y
    STA.B SpriteYSpeed,X
    JSR SubSprXPosNoGrvty                     ; Update position.
    JSR SubSprYPosNoGrvty
Return01DEAF:
    RTS

  + LDY.B #$09                                ; Time to change the box's direction at a corner.
CODE_01DEB2:
    LDA.W SpriteTableC2,Y
    BEQ CODE_01DED7
    LDA.W SpriteYPosLow,Y
    CLC
    ADC.B #$04                                ; Check if all the boxes have been hit.
    AND.B #$F8                                ; Clip their positions while at it.
    STA.W SpriteYPosLow,Y
    LDA.W SpriteXPosLow,Y
    CLC
    ADC.B #$04
    AND.B #$F8
    STA.W SpriteXPosLow,Y
    DEY
    BNE CODE_01DEB2
    INC.W BonusGameComplete                   ; If all boxes have been hit, end the game.
    JSR CODE_01DFD9
    RTS

CODE_01DED7:
    LDA.W SpriteMisc157C,X                    ; Not all boxes have been hit.
    INC A
    AND.B #$03                                ; Increase movement direction.
    TAY
    STA.W SpriteMisc157C,X
    BRA CODE_01DE9F                           ; Update speed and position, then return.


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
; Tiles for the Bonus Game item box animation.
; 0 - Star (bottom)
; 1 - Star
; 2 - Star (top)
; 3 - Mushroom (bottom)
; 4 - Mushroom
; 5 - Mushroom (top)
; 6 - Fireflower (bottom)
; 7 - Fireflower
; 8 - Fireflower (top)
; YXPPCCCT for the items inside the Bonus Game's item box.
; Star
; Mushroom
; Fireflower
; Y position offsets for the block's hit animation.
    LDA.W SpriteMisc1540,X                    ; Bonus game item box GFX routine
    LSR A
    TAY                                       ; Get vertical offset for the block's hit animation, if applicable.
    LDA.W DATA_01DF10,Y
    STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$110,Y
    STA.W OAMTileXPos+$100,Y                  ; Set the X positions for all 5 tiles.
    STA.W OAMTileXPos+$108,Y                  ; (16x16 white box + 4 8x8s for the item).
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$104,Y
    STA.W OAMTileXPos+$10C,Y
    LDA.W SpriteMisc154C,X
    CLC
    BEQ CODE_01DF4E
    LSR A                                     ; Handle flashing the item in the box
    LSR A                                     ; after the game ends.
    LSR A
    LSR A
    BRA +

    CLC                                       ; \ Unreachable instructions; Unused code; would make items alternate flashing.
    ADC.W CurSpriteProcess                    ; /
  + LSR A
CODE_01DF4E:
    PHP
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _0
    SEC                                       ; Set Y position for the box.
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$110,Y
    PLP
    BCS +
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y                  ; If not currently flashing the item,
    CLC                                       ; set its Y position too.
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
    STA.W OAMTileNo+$100,Y                    ; Set tiles for the item inside the box.
    %LorW_X(LDA,DATA_01DEE4)
    STA.W OAMTileNo+$104,Y
    %LorW_X(LDA,DATA_01DEE5)
    STA.W OAMTileNo+$108,Y
    %LorW_X(LDA,DATA_01DEE6)
    STA.W OAMTileNo+$10C,Y
    LDA.B #$E4                                ; Tile for the white box.
    STA.W OAMTileNo+$110,Y
    PLX
    LDA.B SpriteProperties
    %LorW_X(ORA,DATA_01DF07)
    STA.W OAMTileAttr+$100,Y                  ; Set YXPPCCCT for the item inside the box.
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    STA.W OAMTileAttr+$10C,Y
    ORA.B #$01                                ; YXPPCCCT for the white box.
    STA.W OAMTileAttr+$110,Y
    PLX
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    STA.W OAMTileSize+$42,Y                   ; Set sizes for all five tiles.
    STA.W OAMTileSize+$43,Y                   ; (4 8x8s, 1 16x16)
    LDA.B #$02
    STA.W OAMTileSize+$44,Y
    RTS


DATA_01DFC1:
    db $00,$01,$02,$02,$03,$04,$04,$05
    db $06,$06,$07,$00,$00,$08,$04,$02
    db $08,$06,$03,$08,$07,$01,$08,$05

CODE_01DFD9:
; Indices for the block position tables in each row/column.
; 0 - Top row
; 1 - Right column
; 2 - Bottom row
; 3 - Left column
; 4 - \ diagonal
; 5 - / diagonal
; 6 - Middle row
; 7 - Middle column
    LDA.B #$07                                ; Routine to end the bonus game.
    STA.B _0
CODE_01DFDD:
    LDX.B #$02                                ; Outer loop ($00); loop for each line (8 lines).
CODE_01DFDF:
    STX.B _1                                  ; Inner loop ($01); loop for each block in the row (3 blocks).
    LDA.B _0
    ASL A
    ADC.B _0
    CLC
    ADC.B _1
    TAY                                       ; Get the X/Y position of the box to check.
    LDA.W DATA_01DFC1,Y                       ; Store them in $02/$03.
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
    LDA.W SpriteXPosLow,Y                     ; Loop through the boxes until the one in question is found.
    CMP.B _3
    BEQ CODE_01E00D
CODE_01E008:
    DEY
    CPY.B #$01
    BNE CODE_01DFFA
CODE_01E00D:
    LDA.W SpriteMisc1570,Y                    ; Store the box's contents to $04-$06
    STA.B _4,X                                ; and its sprite index to $07-$09.
    STY.B _7,X
    DEX                                       ; Loop for all boxes in the line.
    BPL CODE_01DFDF
    LDA.B _4
    CMP.B _5
    BNE +                                     ; Move to next line if all three box's contents aren't the same.
    CMP.B _6
    BNE +
    INC.W BonusGame1UpCount                   ; Count a life.
    LDA.B #$70
    LDY.B _7
    STA.W SpriteMisc154C,Y
    LDY.B _8                                  ; Set the flashing timer for all three boxes.
    STA.W SpriteMisc154C,Y
    LDY.B _9
    STA.W SpriteMisc154C,Y
  + DEC.B _0                                  ; Loop for all the lines.
    BPL CODE_01DFDD
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDY.B #!SFX_CORRECT                       ; SFX for getting at least one line. SFX for none is this +1.
    LDA.W BonusGame1UpCount
    STA.W BonusOneUpsRemain
    BNE +                                     ; If no 1ups were gotten, set game end timer.
    LDA.B #$58
    STA.W BonusFinishTimer
    INY
  + STY.W SPCIO3                              ; / Play sound effect
    RTS

InitFireball:
    LDA.B SpriteYPosLow,X                     ; Podoboo INIT
    STA.W SpriteMisc1528,X                    ; Track the spawn Y position.
    LDA.W SpriteYPosHigh,X
    STA.W SpriteMisc151C,X
  - LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$10
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X                    ; Scan below the Podoboo for water/lava.
    ADC.B #$00                                ; Loop never terminates if there is none, hence the buoyancy crash bug.
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
; Y speeds to give the Podoboo when jumping, in order to reach its spawn position.
; If the value is positive (#$00-#$7F), the game instead gives the Podoboo the max of #$80
; and stores that value to $1564. However, this doesn't work correctly,
; and essentially has no effect.
; Maximum downwards Y speeds for the Podoboo.
; Second value is used when acting as Bowser's flame.
; Podoboo misc RAM:
; $C2   - Flag for whether the sprite is a podoboo (0) or Bowser fireball (1).
; $151C - Spawn Y position (high); used for maximum jump distance.
; $1528 - Spawn Y position (low); used for maximum jump distance.
; $1540 - Timer for waiting in the lava. Set to a random value between #$60 and #$9F.
; $1558 - Timer for the Bowser fireballs, for when to disappear.
; $1564 - Timer to retain Y speed if the jump distance is too far to reach with the normal max speed of #$80.
; However, doesn't work correctly, and as a result has no effect on the sprite.
; (unless the vertical distance is so great that a value greater than $1540 gets accidentally stored)
; $1570 - Frame counter for animation.
; $15D0 - Mirror of $1540. Seems unused, though?
; $1602 - Animation frame.
; 0/1 = facing upwards, 2/3 = facing downwards
    STZ.W SpriteOnYoshiTongue,X               ; Podoboo MAIN (and also Bowser fireball)
    LDA.W SpriteMisc1540,X                    ; Branch if lava timer is 0 (time to jump / already in air).
    BEQ CODE_01E0A7
    STA.W SpriteOnYoshiTongue,X
    DEC A
    BNE +                                     ; If about to jump, play the sound effect for doing so.
    LDA.B #!SFX_PODOBOO                       ; \ Play sound effect; SFX for the podoboo leaping out of the lava.
    STA.W SPCIO3                              ; /
  + RTS

CODE_01E0A7:
    LDA.B SpriteLock                          ; Time to jump / Podoboo is in midair.
    BEQ +                                     ; Skip down to just draw graphics if the game is frozen.
    JMP CODE_01E12D

  + JSR MarioSprInteractRt                    ; Interact with Mario.
    JSR SetAnimationFrame                     ; Change animation every 4 frames.
    JSR SetAnimationFrame
    LDA.W SpriteOBJAttribute,X
    AND.B #$7F
    LDY.B SpriteYSpeed,X
    BMI +                                     ; If moving downwards,
    INC.W SpriteMisc1602,X                    ; increase animation frame by 2
    INC.W SpriteMisc1602,X                    ; and vertically flip the sprite.
    ORA.B #$80
  + STA.W SpriteOBJAttribute,X
    JSR CODE_019140
    LDA.W SpriteInLiquid,X
    BEQ CODE_01E106                           ; Branch if not in contact with water or if moving upwards.
    LDA.B SpriteYSpeed,X
    BMI CODE_01E106
    JSL GetRand
    AND.B #$3F                                ; Set time to wait within the lava.
    ADC.B #$60                                ; Time is a random value between #$60 and #$9F.
    STA.W SpriteMisc1540,X
CODE_01E0E2:
    LDA.B SpriteYPosLow,X
    SEC
    SBC.W SpriteMisc1528,X
    STA.B _0
    LDA.W SpriteYPosHigh,X
    SBC.W SpriteMisc151C,X
    LSR A                                     ; Determine the number of blocks between the Podoboo and
    ROR.B _0                                  ; its spawn position, then use that to get the Y speed
    LDA.B _0                                  ; necessary to reach it.
    LSR A
    LSR A                                     ; If the distance is too far to reach even with max speed,
    LSR A                                     ; this will instead set a timer to disable gravity temporarily.
    TAY                                       ; ...Or it would, but that function doesn't work.
    LDA.W DATA_01E07B,Y                       ; (the timer is only set once, so it runs out before jumping)
    BMI +
    STA.W SpriteMisc1564,X
    LDA.B #$80
  + STA.B SpriteYSpeed,X
    RTS

CODE_01E106:
; Podoboo is in the process of jumping.
    JSR SubSprYPosNoGrvty                     ; Update Y position.
    LDA.B EffFrame
    AND.B #$07
    ORA.B SpriteTableC2,X                     ; If the sprite is specifically a Podoboo (not a Bowser fireball),
    BNE +                                     ; spawn lava particles every 8 frames.
    JSL CODE_0285DF
  + LDA.W SpriteMisc1564,X
    BNE CODE_01E12A
    LDA.B SpriteYSpeed,X                      ; Apply downwards acceleration,
    BMI CODE_01E125                           ; and limit Y speed based on whether the sprite
    LDY.B SpriteTableC2,X                     ; is acting as a Podoboo or Bowser's flame.
    CMP.W DATA_01E091,Y
    BCS CODE_01E12A                           ; $1564 is used here, but it ends up
CODE_01E125:
; being #$00 by the time this gets run,
    CLC                                       ; so it has no effect.
    ADC.B #$02
    STA.B SpriteYSpeed,X
CODE_01E12A:
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
CODE_01E12D:
; Physics routines end.
    LDA.B SpriteTableC2,X                     ; Branch for the Podoboo's graphics; if running Bowser's fire, continue below.
    BEQ CODE_01E198
    LDY.B SpriteLock                          ; Branch to just do the fire's graphics if the game is frozen.
    BNE CODE_01E164
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Branch if not on the ground.
    BEQ CODE_01E151                           ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Clear Y speed.
    LDA.W SpriteMisc1558,X
    BEQ CODE_01E14A
    CMP.B #$01                                ; If the timer hasn't been set yet, set it.
    BNE +                                     ; If it's about to run out, erase the fire in a cloud of smoke.
    JMP CODE_019ACB

CODE_01E14A:
    LDA.B #$80                                ; How long the Bowser fireballs sit on the floor of Bowser's battle before disappearing.
    STA.W SpriteMisc1558,X
  + BRA CODE_01E164

CODE_01E151:
    TXA                                       ; Fire is still falling.
    ASL A
    ASL A                                     ; Wiggle the sprite left and right.
    CLC
    ADC.B TrueFrame
    LDY.B #$F0                                ; Leftwards X speed.
    AND.B #$04
    BEQ +
    LDY.B #$10                                ; Rightwards X speed.
  + STY.B SpriteXSpeed,X
    JSR SubSprXPosNoGrvty
CODE_01E164:
    LDA.B SpriteYPosLow,X                     ; Game is frozen; draw the Bowser fire's graphics.
    CMP.B #$F0                                ; Erase if it manages to fall offscreen.
    BCC +
    STZ.W SpriteStatus,X
  + JSR SubSprGfx2Entry1                      ; Draw a 16x16.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDA.B EffFrame
    AND.B #$0C
    LSR A
    ADC.W CurSpriteProcess
    LSR A                                     ; Change the tile used.
    AND.B #$03
    TAX
    LDA.W BowserFlameTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_01E194,X
    ORA.B SpriteProperties                    ; Change YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    PLX
    RTS


BowserFlameTiles:
    db $2A,$2C,$2A,$2C

DATA_01E194:
    db $05,$05,$45,$45

CODE_01E198:
; Tile numbers for the Bowser fire's animation.
; YXPPCCCT for the Bowser fire's animation.
; Podoboo GFX routine.
    LDA.B #$01                                ; Draw a 16x16.
    JSR SubSprGfx0Entry0
    REP #$20                                  ; A->16
    LDA.W #$0008
    ASL A
    ASL A
    ASL A
    ASL A                                     ; Store the pointer for the Podoboo's graphics for DMA upload.
    ASL A                                     ; ($7E8600; tile 0x548)
    CLC                                       ; All the math on A here is kinda pointless, can just directly load #$8600.
    ADC.W #$8500
    STA.W DynGfxTilePtr+6
    CLC
    ADC.W #$0200
    STA.W DynGfxTilePtr+$10
    SEP #$20                                  ; A->8
    RTS

InitKeyHole:
    LDA.B SpriteXPosLow,X                     ; Keyhole INIT
    CLC
    ADC.B #$08
    STA.B SpriteXPosLow,X                     ; Shift 8 pixels right.
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,X
; Keyhole misc RAM:
; $151C - Highest sprite slot with a key.
; $154C - Flag for the keyhole animation having already been activated.
    RTS                                       ; Keyhole MAIN

Keyhole:
    LDY.B #$0B
CODE_01E1CA:
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BCC CODE_01E1D8
    LDA.W SpriteNumber,Y                      ; Find the highest sprite slot with a key in it.
    CMP.B #$80
    BEQ CODE_01E1DB
CODE_01E1D8:
    DEY
    BPL CODE_01E1CA
CODE_01E1DB:
    LDA.W PlayerRidingYoshi
    BEQ CODE_01E1E5                           ; If Yoshi has a key in his mouth, use that instead.
    LDA.W YoshiHasKey
    BNE CODE_01E1ED
CODE_01E1E5:
    TYA
    STA.W SpriteMisc151C,X                    ; If no key is found, branch to just do GFX.
    BMI CODE_01E23A                           ; Else, track that slot.
    BRA CODE_01E1F3

CODE_01E1ED:
    JSL GetMarioClipping                      ; Key in Yoshi's mouth.
    BRA CODE_01E201

CODE_01E1F3:
    LDA.W SpriteStatus,Y                      ; There is a key free in the level.
    CMP.B #$0B                                ; Skip to just draw graphics if not held by Mario.
    BNE CODE_01E23A
    PHX
    TYX
    JSL GetSpriteClippingB
    PLX
CODE_01E201:
    JSL GetSpriteClippingA                    ; Check if key is touching the keyhole.
    JSL CheckForContact                       ; Skip to just draw graphics if not in contact
    BCC CODE_01E23A                           ; or if the keyhole animation was already activated.
    LDA.W SpriteMisc154C,X
    BNE CODE_01E23A
    LDA.B #$30                                ; Set keyhole timer.
    STA.W KeyholeTimer
    LDA.B #!BGM_KEYHOLE2                      ; SFX for the keyhole animation.
    STA.W SPCIO2                              ; / Change music
    INC.W PlayerIsFrozen                      ; Freeze player.
    INC.B SpriteLock                          ; Freeze sprites.
    LDA.W SpriteXPosHigh,X
    STA.W KeyholeXPos+1
    LDA.B SpriteXPosLow,X
    STA.W KeyholeXPos                         ; Track position for the keyhole window.
    LDA.W SpriteYPosHigh,X
    STA.W KeyholeYPos+1
    LDA.B SpriteYPosLow,X
    STA.W KeyholeYPos
    LDA.B #$30                                ; Set flag to not restart the animation.
    STA.W SpriteMisc154C,X
CODE_01E23A:
    JSR GetDrawInfoBnk1                       ; Keyhole GFX routine.
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.B _1                                  ; Set X/Y position.
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+$104,Y
    LDA.B #$EB
    STA.W OAMTileNo+$100,Y                    ; Set tiles.
    LDA.B #$FB
    STA.W OAMTileNo+$104,Y
    LDA.B #$30
    STA.W OAMTileAttr+$100,Y                  ; Set YXPPCCCT.
    STA.W OAMTileAttr+$104,Y
    LDY.B #$00
    LDA.B #$01                                ; Upload 2 8x8 tiles.
    JSR FinishOAMWriteRt
    RTS

CODE_01E26A:
    LDA.B TrueFrame                           ; Subroutine to handle spawning 1ups at the end of the bonus game.
    AND.B #$3F                                ; How often to spawn 1ups after the bonus game.
    BNE +
    LDA.W BonusGame1UpCount
    BEQ +                                     ; If there are still 1ups to spawn, spawn one.
    DEC.W BonusGame1UpCount
    JSR CODE_01E281
  + LDA.B #$01                                ; Activate the cluster sprite routines.
    STA.W ActivateClusterSprite
    RTS

CODE_01E281:
    LDY.B #$07                                ; Spawn a bonus game 1up.
CODE_01E283:
    LDA.W ClusterSpriteNumber,Y
    BEQ CODE_01E28C                           ; Search for an empty cluster sprite slot.
    DEY
    BPL CODE_01E283
    RTS

CODE_01E28C:
    LDA.B #$01                                ; Cluster sprite number (1up).
    STA.W ClusterSpriteNumber,Y
    LDA.B #$00                                ; Y position (low)
    STA.W ClusterSpriteYPosLow,Y
    LDA.B #$01                                ; Y position (high)
    STA.W ClusterSpriteYPosHigh,Y
    LDA.B #$18                                ; X position (low)
    STA.W ClusterSpriteXPosLow,Y
    LDA.B #$00                                ; X position (high)
    STA.W ClusterSpriteXPosHigh,Y
    LDA.B #$01                                ; Initial X speed.
    STA.W ClusterSpriteMisc1E66,Y
    LDA.B #$10                                ; Initial Y speed.
    STA.W ClusterSpriteMisc1E52,Y
    RTS

    %insert_empty($0D,$18,$18,$11,$0A)

    db $13,$14,$15,$16,$17,$18,$19

MontyMole:
; Abandoned data? Not used by anything.
; Monty Mole misc RAM:
; $C2   - Current phase.
; 0 = invisible, 1 = dirt animation, 2 = jumping out, 3 = walking
; $151C - Flag for whether the mole follows Mario (00) or walks straight and hops (10).
; $1540 - Timer for waiting in the ground before jumping out.
; $1558 - Timer for the hopping mole's hops.
; $1570 - Frame counter for animation.
; $157C - Direction the sprite is moving. 0 = right, 1 = left.
; $15D0 - Prevents the dirt from animating if set.
; $1602 - Animation frame.
; Mole form: 0/1 = walking, 2 = jumping out.
; In dirt: 0 = invisible, 1/2 = ground dirt, 3 = ledge dirt
; Monty Mole MAIN
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_01E2E0
    dw CODE_01E309
    dw CODE_01E37F
    dw CODE_01E393

CODE_01E2E0:
; Phase pointers for the Monty Mole.
; 0 - Invisible (Mario isn't close)
; 1 - Dirt animation, waiting to jump out
; 2 - Jumping out
; 3 - Walking
    JSR SubHorizPos                           ; Monty Mole phase 0 - Invisible (Mario isn't close)
    LDA.B _F
    CLC
    ADC.B #$60                                ; Return if Mario isn't within 6 tiles of the sprite on either side,
    CMP.B #$C0                                ; or if the sprite is horizontally offscreen.
    BCS CODE_01E305
    LDA.W SpriteOffscreenX,X
    BNE CODE_01E305
    INC.B SpriteTableC2,X                     ; Move to next phase (dirt animation).
    LDY.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,Y                    ; Set timer for the dirt animation, based on the current submap.
    TAY
    LDA.B #$68                                ; How many frames the Monty Moles wait before jumping out in Yoshi's Island.
    CPY.B #$01                                ; Map in which the Moles jump out slower on (Yoshi's Island).
    BEQ +
    LDA.B #$20                                ; How many frames the Monty Moles wait before jumping out elsewhere.
  + STA.W SpriteMisc1540,X
CODE_01E305:
    JSR GetDrawInfoBnk1                       ; Set up offscreen flags for the next run.
    RTS

CODE_01E309:
    LDA.W SpriteMisc1540,X                    ; Monty Mole phase 1 - Dirt animation (waiting to jump out)
    ORA.W SpriteOnYoshiTongue,X               ; Branch if not time to jump out, or on Yoshi's tongue.
    BNE CODE_01E343
    INC.B SpriteTableC2,X                     ; Move to next phase (jumping out)
    LDA.B #$B0                                ; Y speed for the Monty mole jumping out of the ground.
    STA.B SpriteYSpeed,X
    JSR IsSprOffScreen
    BNE +                                     ; If not offscreen, spawn dirt particles.
    TAY                                       ; (can actually just run the routine directly, no branch necessary)
    JSR CODE_0199E1
  + JSR FaceMario
    LDA.B SpriteNumber,X
    CMP.B #$4E
    BNE CODE_01E343
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position
    STA.B TouchBlockXPos                      ; | for block creation
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /; Spawn the Monty Mole's hole tile if the sprite is the ledge-dwelling mole.
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position
    STA.B TouchBlockYPos                      ; | for block creation
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    LDA.B #$08                                ; \ Block to generate = Mole hole
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
CODE_01E343:
    LDA.B SpriteNumber,X                      ; Not time to jump out.
    CMP.B #$4D                                ; Branch if running the ledge-dwelling mole.
    BNE +
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    LSR A                                     ; Set animation frame (1/2) for the ground-dwelling mole's dirt.
    AND.B #$01
    TAY
    LDA.W DATA_01E35F,Y
    STA.W SpriteMisc1602,X
    LDA.W DATA_01E361,Y                       ; Draw 4 8x8s.
    JSR SubSprGfx0Entry0
    RTS


DATA_01E35F:
    db $01,$02

DATA_01E361:
    db $00,$05

; Animation frames for the ground-dwelling mole while in the dirt.
; 8x8 YXPPCCCT indices for the ground-dwelling mole's animation.
  + LDA.B EffFrame                            ; Ledge-dwelling mole animation.
    ASL A
    ASL A                                     ; Set X/Y flip for the tile.
    AND.B #$C0
    ORA.B #$31
    STA.W SpriteOBJAttribute,X
    LDA.B #$03                                ; Set animation frame (3) for the ledge-dwelling mole's dirt.
    STA.W SpriteMisc1602,X
    JSR SubSprGfx2Entry1                      ; Draw a 16x16.
    LDA.W SpriteOBJAttribute,X
    AND.B #$3F                                ; Restore original X/Y flip.
    STA.W SpriteOBJAttribute,X
    RTS

CODE_01E37F:
; Monty Mole phase 2 - Jumping out.
    JSR CODE_01E3EF                           ; Run general routines (GFX, interaction, etc).
    LDA.B #$02                                ; Set aniamtion frame (2).
    STA.W SpriteMisc1602,X
    JSR IsOnGround
    BEQ +                                     ; If the mole has hit the ground, imove to next phase (normal movement).
    INC.B SpriteTableC2,X
  + RTS


DATA_01E38F:
    db $10,$F0

DATA_01E391:
    db $18,$E8

CODE_01E393:
; X speeds for the Monty Mole that walks straight.
; Maximum X speeds for the Mario-following Monty Mole.
; Monty Mole phase 3 - Walking.
    JSR CODE_01E3EF                           ; Run general routines (GFX, interaction, etc).
    LDA.W SpriteMisc151C,X                    ; Branch if the mole walks straight and hops (as opposed to following Mario).
    BNE CODE_01E3C7
    JSR SetAnimationFrame                     ; Set animation frame (0/1); change every 4 frames.
    JSR SetAnimationFrame
    JSL GetRand
    AND.B #$01                                ; Return if not time to check direction.
    BNE +
    JSR FaceMario                             ; Face Mario.
    LDA.B SpriteXSpeed,X
    CMP.W DATA_01E391,Y                       ; Return if already at the max speed for that direction.
    BEQ +
    CLC
    ADC.W DATA_01EBB4,Y                       ; Else, accelerate horizontally.
    STA.B SpriteXSpeed,X
    TYA
    LSR A
    ROR A
    EOR.B SpriteXSpeed,X                      ; If reversing direction, spawn smoke clouds and animate twice as fast.
    BPL +
    JSR CODE_01804E
    JSR SetAnimationFrame
  + RTS

CODE_01E3C7:
; Mole that moves straight and hops.
    JSR IsOnGround                            ; Freeze animation frame and speed if falling.
    BEQ CODE_01E3E9
    JSR SetAnimationFrame                     ; Set animation frame (0/1); change every 4 frames.
    JSR SetAnimationFrame
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01E38F,Y                       ; Set X speed based on direction.
    STA.B SpriteXSpeed,X
    LDA.W SpriteMisc1558,X
    BNE +                                     ; Handle hopping.
    LDA.B #$50                                ; Frames between hops.
    STA.W SpriteMisc1558,X
    LDA.B #$D8                                ; Y speed to hop with.
    STA.B SpriteYSpeed,X
  + RTS

CODE_01E3E9:
; Mole is falling.
    LDA.B #$01                                ; Freeze animation frame (1).
    STA.W SpriteMisc1602,X
    RTS

CODE_01E3EF:
    LDA.B SpriteProperties                    ; General Monty Mole subroutine (GFX, Mario/sprite/object interaction).
    PHA
    LDA.W SpriteMisc1540,X                    ; Send behind other sprites if currently in the ground.
    BEQ +
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + JSR SubSprGfx2Entry1                      ; Draw a 16x16 sprite.
    PLA
    STA.B SpriteProperties
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if game frozen.
    BNE CODE_01E41C                           ; /
    JSR SubSprSpr_MarioSpr                    ; Process Mario and sprite interaction.
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    JSR IsOnGround
    BEQ +                                     ; If on the ground, clear Y speed.
    JSR SetSomeYSpeed__
  + JSR IsTouchingObjSide
    BEQ +                                     ; If hitting the side of a block, change direction.
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
; X speeds for the Dry Bones / Bony Beetle.
; Unused?
; Dry Bones and Bony Beetle misc RAM:
; $C2   - Used as a flag by the ledge Dry Bones to indicate it just walked off a ledge.
; $1528 - Timer for the Bony Beetle, to hide in its shell. Increments constantly.
; $1534 - Flag for the sprite being collapsed.
; $1540 - Timer for pausing the sprite at various times.
; Dry Bones: Set to #$3F when throwing a bone.
; Bony Beetle: Set to #$A0 when hiding in its shell.
; Collapsed: Set to #$FF for waiting to repair itself.
; $1570 - Frame counter for animation.
; $157C - Direction the sprite is facing. 0 = right, 1 = left.
; $15AC - Turn timer, only used by the ledge Dry Bones. Set to #$08 when turning at the edge of a ledge.
; $1602 - Animation frame. 0/1 = walking, 2 = dry bones throwing, 2/3 bony beetle hiding
; $163E - Freezes the sprite in place and prevents it from attacking, but interaction with Mario is unaffected. Seems to be unused.
    LDA.W SpriteStatus,X                      ; Dry Bones MAIN and Bony Beetle MAIN
    CMP.B #$08
    BEQ +                                     ; If dying, skip down to handle graphics.
    ASL.W SpriteOBJAttribute,X                ; And flip the Bony Beetle upside down, too.
    SEC
    ROR.W SpriteOBJAttribute,X
    JMP CODE_01E5BF


DATA_01E43C:
    db $08,$F8

; X offsets for the second (head) tile of the Dry Bones / Bony Beetle's collapsed graphic.
  + LDA.W SpriteMisc1534,X                    ; Branch if the sprite is not collapsed.
    BEQ CODE_01E4C0
    JSR SubSprGfx2Entry1                      ; Draw a 16x16.
    LDY.W SpriteMisc1540,X
    BNE +
    STZ.W SpriteMisc1534,X                    ; If the timer has run out, return to normal movement and face Mario.
    PHY
    JSR FaceMario
    PLY
  + LDA.B #$48                                ; Tile to use mid-collpase tile.
    CPY.B #$10
    BCC +
    CPY.B #$F0                                ; Change tile.
    BCS +
    LDA.B #$2E                                ; Tile to use when fully collapsed.
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
    STA.W OAMTileXPos+$104,Y                  ; Draw the second 16x16 tile,
    LDA.W OAMTileYPos+$100,Y                  ; located one tile to the left of the 16x16 tile from before.
    STA.W OAMTileYPos+$104,Y
    LDA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    LDA.W OAMTileNo+$100,Y
    DEC A
    STA.W OAMTileNo+$104,Y
    LDA.W SpriteMisc1540,X
    BEQ +
    CMP.B #$40                                ; Time at which to start shaking.
    BCS +
    LSR A
    LSR A
    PHP                                       ; Shake the sprite side to side when about to fix itself.
    LDA.W OAMTileXPos+$100,Y
    ADC.B #$00
    STA.W OAMTileXPos+$100,Y
    PLP
    LDA.W OAMTileXPos+$104,Y
    ADC.B #$00
    STA.W OAMTileXPos+$104,Y
  + LDY.B #$02
    LDA.B #$01                                ; Draw two 16x16s.
    JSR FinishOAMWriteRt
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    JSR IsOnGround
    BEQ +                                     ; If on the ground, clear X/Y speed.
    STZ.B SpriteYSpeed,X                      ; \ Sprite Speed = 0
    STZ.B SpriteXSpeed,X                      ; /
  + RTS

CODE_01E4C0:
    LDA.B SpriteLock                          ; Dry Bones / Bony Beetle is not collapsed.
    ORA.W SpriteMisc163E,X                    ; Skip down to graphics/interaction if game is frozen. (or an unused condition?)
    BEQ +
    JMP CODE_01E5B6

  + LDY.W SpriteMisc157C,X                    ; Game isn't frozen.
    LDA.W DATA_01E41F,Y
    EOR.W SpriteSlope,X
    ASL A
    LDA.W DATA_01E41F,Y                       ; Set walking X speed.
    BCC +                                     ; Decelerate depending on the slope it's on.
    CLC
    ADC.W SpriteSlope,X
  + STA.B SpriteXSpeed,X
    LDA.W SpriteMisc1540,X
    BNE CODE_01E4ED
    TYA
    INC A                                     ; Clear X speed if collapsed
    AND.W SpriteBlockedDirs,X                 ; \ Branch if not touching object; or trying to walk up/down a conveyor
    AND.B #$03                                ; |; moving the opposite direction.
    BEQ +                                     ; /
CODE_01E4ED:
    STZ.B SpriteXSpeed,X
  + JSR IsTouchingCeiling
    BEQ +                                     ; Clear Y speed if it touches a ceiling.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    LDA.B SpriteNumber,X
    CMP.B #$31                                ; Branch if not the Bony Beetle.
    BNE CODE_01E51E
    LDA.W SpriteMisc1540,X                    ; Branch if not hiding in its shell.
    BEQ CODE_01E542
    LDY.B #$00
    CMP.B #$70
    BCS +
    INY
    INY
    CMP.B #$08
    BCC +                                     ; Handle the animation for hiding the beetle in its shell.
    CMP.B #$68
    BCS +
    INY
  + TYA
    STA.W SpriteMisc1602,X
    BRA CODE_01E563                           ; Skip down.

CODE_01E51E:
    CMP.B #$30                                ; Dry Bones (not Bony Beetle).
    BEQ CODE_01E52D
    CMP.B #$32
    BNE CODE_01E542
    LDA.W TranslevelNo
    CMP.B #$31                                ; Translevel that sprite 32 throws bones in. (modify $01E5A3 too)
    BNE CODE_01E542
CODE_01E52D:
; If sprite 30 (dry bones, throws), make it throw bones.
    LDA.W SpriteMisc1540,X                    ; If sprite 32 (dry bones, ledges) and in level 10D, make it also throw bones.
    BEQ CODE_01E542
    CMP.B #$01
    BNE +
    JSL CODE_03C44E
  + LDA.B #$02
    STA.W SpriteMisc1602,X
    JMP CODE_01E5B6

CODE_01E542:
; Not throwing a bone / hiding in the beetle's shell.
    JSR IsOnGround                            ; Branch if in midair.
    BEQ CODE_01E563
    JSR SetSomeYSpeed__                       ; Clear Y speed.
    JSR SetAnimationFrame                     ; Animate walking (0/1).
    LDA.B SpriteNumber,X
    CMP.B #$32
    BNE CODE_01E557                           ; Clear the ledge Dry Bones' turn flag.
    STZ.B SpriteTableC2,X
    BRA +

CODE_01E557:
    LDA.W SpriteMisc1570,X
    AND.B #$7F                                ; Turn the throwing Dry Bones and Bony Beetle towards Mario every so often.
    BNE +
    JSR FaceMario
  + BRA +

CODE_01E563:
    STZ.W SpriteMisc1570,X                    ; Sprite is not walking (i.e. in midair or bony beetle hiding)
    LDA.B SpriteNumber,X
    CMP.B #$32
    BNE +
    LDA.B SpriteTableC2,X
    BNE +                                     ; Stay on ledges if sprite 32 (dry bones, ledges).
    INC.B SpriteTableC2,X
    JSR FlipSpriteDir
    JSR SubSprXPosNoGrvty
    JSR SubSprXPosNoGrvty
  + LDA.B SpriteNumber,X                      ; Code reconvenes.
    CMP.B #$31
    BNE CODE_01E598
    LDA.B TrueFrame
    LSR A
    BCC +                                     ; Handle the Bony Beetle's "waiting to hide" timer.
    INC.W SpriteMisc1528,X
  + LDA.W SpriteMisc1528,X
    BNE CODE_01E5B6
    INC.W SpriteMisc1528,X
    LDA.B #$A0                                ; How many frames the beetle hides in its shell for.
    STA.W SpriteMisc1540,X
    BRA CODE_01E5B6

CODE_01E598:
    CMP.B #$30                                ; Dry Bones only again; handle throwing bones (the second part of the routine from earlier).
    BEQ CODE_01E5A7
    CMP.B #$32
    BNE CODE_01E5B6
    LDA.W TranslevelNo
    CMP.B #$31                                ; Translevel that sprite 32 throws bones in. (modify $01E529 too)
    BNE CODE_01E5B6
CODE_01E5A7:
; If sprite 30 (dry bones, throws), make it throw bones.
    LDA.W SpriteMisc1570,X                    ; If sprite 32 (dry bones, ledges) and in level 10D, make it also throw bones
    CLC
    ADC.B #$40
    AND.B #$7F
    BNE CODE_01E5B6
    LDA.B #$3F
    STA.W SpriteMisc1540,X
CODE_01E5B6:
    JSR CODE_01E5C4                           ; Process Mario interaction.
    JSR SubSprSprInteract                     ; Process sprite interaction.
    JSR FlipIfTouchingObj                     ; Flip if touching a block.
CODE_01E5BF:
    JSL CODE_03C390                           ; Draw GFX.
    RTS

CODE_01E5C4:
; Subroutine to process Dry Bones / Bony Beetle interaction with Mario.
    JSR MarioSprInteractRt                    ; Return if not in contact with Mario.
    BCC Return01E610
    LDA.B PlayerYPosNow
    CLC
    ADC.B #$14
    CMP.B SpriteYPosLow,X                     ; Branch to hurt Mario if not touching the top of the sprite,
    BPL CODE_01E604                           ; or moving upwards without having hit any other enemies yet.
    LDA.W SpriteStompCounter
    BNE CODE_01E5DB
    LDA.B PlayerYSpeed+1
    BMI CODE_01E604
CODE_01E5DB:
    LDA.B SpriteNumber,X                      ; Hitting the top of the sprite.
    CMP.B #$31
    BNE CODE_01E5EB
    LDA.W SpriteMisc1540,X                    ; Hurt Mario if he hits the Bony Beetle while it's hiding.
    SEC
    SBC.B #$08
    CMP.B #$60
    BCC CODE_01E604
CODE_01E5EB:
    JSR CODE_01AB46                           ; Give points and increase bounce counter.
    JSL DisplayContactGfx                     ; Display a contact sprite.
    LDA.B #!SFX_BONES                         ; \ Play sound effect; SFX for the Dry Bones / Bony Beetle collapsing.
    STA.W SPCIO0                              ; /
    JSL BoostMarioSpeed                       ; Boost Mario upwards.
    INC.W SpriteMisc1534,X
    LDA.B #$FF                                ; Set collapsed flag and timer for the sprite.
    STA.W SpriteMisc1540,X
    RTS

CODE_01E604:
; Didn't bounce off.
    JSL HurtMario                             ; Hurt Mario.
    LDA.W IFrameTimer                         ; \ Return if Mario is invincible
    BNE Return01E610                          ; /; Face the sprite towards Mario if he's not invulnerable.
    JSR FaceMario
Return01E610:
    RTS                                       ; Frames for the springboard animation. Indexed by $1540 divided by 2.


DATA_01E611:
    db $00,$01,$02,$02,$02,$01,$01,$00
    db $00

DATA_01E61A:
    db $1E,$1B,$18,$18,$18,$1A,$1C,$1D
    db $1E

SpringBoard:
; Y offsets for Mario from the springboard during the spring animation.
; Springboard misc RAM:
; $1540 - Timer for the springboard's animation. Set to #$11 when Mario lands on it.
; $154C - Timer for disabling interaction with Mario. Set to #$10 when dropping, throwing, or kicking. But, uh, cleared when Mario touches it.
; $157C - Direction the sprite is facing. 00 = right, 01 = left
; $1602 - Animation frame to use.
; 0 = normal, 1/2 = pressing animation
    LDA.B SpriteLock                          ; Springboard MAIN
    BEQ +                                     ; If sprites are frozen, just draw graphics.
    JMP CODE_01E6F0

  + JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    JSR IsOnGround
    BEQ +                                     ; If it's on the ground, do make it bounce.
    JSR CODE_0197D5
  + JSR IsTouchingObjSide
    BEQ +
    JSR FlipSpriteDir
    LDA.B SpriteXSpeed,X
    ASL A                                     ; If it hits the side of a block, bounce it back at 1/4th speed.
    PHP
    ROR.B SpriteXSpeed,X
    PLP
    ROR.B SpriteXSpeed,X
  + JSR IsTouchingCeiling
    BEQ +                                     ; If it hits a ceiling, clear Y speed.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteMisc1540,X                    ; Branch if Mario is not being sprung by the springboard.
    BEQ CODE_01E6B0
    LSR A
    TAY
    LDA.W PlayerRidingYoshi
    CMP.B #$01
    LDA.W DATA_01E61A,Y
    BCC +                                     ; Get a Y position offset for Mario.
    CLC
    ADC.B #$12
  + STA.B _0
    LDA.W DATA_01E611,Y                       ; Get the animation frame to use.
    STA.W SpriteMisc1602,X
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _0
    STA.B PlayerYPosNext                      ; Offset Mario vertically from the spring.
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B PlayerYPosNext+1
    STZ.B PlayerInAir                         ; Mario is not in the air.
    STZ.B PlayerXSpeed+1                      ; Clear Mario's X speed.
    LDA.B #$02                                ; Mario is standing on a springboard.
    STA.W StandOnSolidSprite
    LDA.W SpriteMisc1540,X
    CMP.B #$07                                ; If the spring timer is not in its last frame of animation, branch.
    BCS CODE_01E6AE
    STZ.W StandOnSolidSprite
    LDY.B #$B0                                ; Y speed to give Mario if A or B are not held on a springboard.
    LDA.B axlr0000Hold
    BPL CODE_01E69A                           ; If A is held, make Mario spinjump.
    LDA.B #$01
    STA.W SpinJumpFlag
    BRA CODE_01E69E

CODE_01E69A:
    LDA.B byetudlrHold
    BPL +
CODE_01E69E:
    LDA.B #$0B
    STA.B PlayerInAir
    LDY.B #$80                                ; Y speed to give Mario if A or B are held on a springboard.
    STY.W BouncingOnBoard
  + STY.B PlayerYSpeed+1
    LDA.B #!SFX_SPRING                        ; \ Play sound effect; SFX for bouncing off a springboard.
    STA.W SPCIO3                              ; /
CODE_01E6AE:
    BRA CODE_01E6F0

CODE_01E6B0:
; Mario is not landing on the springboard.
    JSR ProcessInteract                       ; If Mario isn't touching the spring, just draw its graphics.
    BCC CODE_01E6F0
    STZ.W SpriteMisc154C,X                    ; Enable interaction immediately.
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B PlayerYPosNext                      ; Check vertical proximity to the springboard.
    CLC                                       ; If Mario is inside the sprite, branch down.
    ADC.B #$04                                ; If he's above, branch further.
    CMP.B #$1C                                ; Else if he's below it, continue.
    BCC CODE_01E6CE
    BPL CODE_01E6E7
    LDA.B PlayerYSpeed+1
    BPL CODE_01E6F0                           ; If Mario is going downward, clear his speed.
    STZ.B PlayerYSpeed+1                      ; Then draw graphics either way.
    BRA CODE_01E6F0

CODE_01E6CE:
    BIT.B byetudlrHold                        ; Mario is vertically inside the springboard.
    BVC +
    LDA.W CarryingFlag                        ; \ Branch if carrying an enemy...; Branch if: Y/X aren't pressed, Mario is already carrying something, or Mario is riding Yoshi.
    ORA.W PlayerRidingYoshi                   ; | ...or if on Yoshi
    BNE +                                     ; /
    LDA.B #$0B                                ; \ Sprite status = carried; Set the springboard to carried status.
    STA.W SpriteStatus,X                      ; /
    STZ.W SpriteMisc1602,X
  + JSR CODE_01AB31
    BRA CODE_01E6F0

CODE_01E6E7:
    LDA.B PlayerYSpeed+1                      ; Mario is above the springboard.
    BMI CODE_01E6F0                           ; If Mario is falling onto the spring, set the spring timer.
    LDA.B #$11
    STA.W SpriteMisc1540,X
CODE_01E6F0:
    LDY.W SpriteMisc1602,X                    ; Draw springboard graphics.
    LDA.W DATA_01E6FD,Y
    TAY
    LDA.B #$02                                ; Draw 4 8x8s, X and Y flipped in a square.
    JSR SubSprGfx0Entry1
    RTS


DATA_01E6FD:
    db $00,$02,$00

SmushedGfxRt:
; Y position shifts for the springboard animation.
    JSR GetDrawInfoBnk1                       ; Subroutine to draw squished graphics for sprites. Draws two mirrored 8x8s.
    JSR IsSprOffScreen                        ; Don't draw if offscreen.
    BNE Return01E75A
    LDA.B _0                                  ; \ Set X displacement for both tiles
    STA.W OAMTileXPos+$100,Y                  ; | (Sprite position + #$00/#$08)
    CLC                                       ; |
    ADC.B #$08                                ; |
    STA.W OAMTileXPos+$104,Y                  ; /; Draw at the sprite's position.
    LDA.B _1                                  ; \ Set Y displacement for both tiles
    CLC                                       ; | (Sprite position + #$08)
    ADC.B #$08                                ; |
    STA.W OAMTileYPos+$100,Y                  ; |
    STA.W OAMTileYPos+$104,Y                  ; /
    PHX
    LDA.B SpriteNumber,X
    TAX
    LDA.B #$FE                                ; \ If P Switch, tile = #$FE
    CPX.B #$3E                                ; |; Use tile FE if sprite 3E (P-switch)
    BEQ +                                     ; /
    LDA.B #$EE                                ; \ If Sliding Koopa...
    CPX.B #$BD                                ; |
    BEQ +                                     ; |; Use tile EE if sprite BD (sliding blue Koopa) or 00-03 (shell-less Koopas)
    CPX.B #$04                                ; | ...or a shelless, tile = #$EE
    BCC +                                     ; /
    LDA.B #$C7                                ; \ If sprite num >= #$0F, tile = #$C7 (is this used?)
    CPX.B #$0F                                ; |; Use tile C7 if sprite 0F (Goomba)
    BCS +                                     ; /
    LDA.B #$4D                                ; If #$04 <= sprite num < #$0F, tile = #$4D (Koopas); Use tile 4D if anything else (glitchy...)
  + STA.W OAMTileNo+$100,Y                    ; \ Same value for both tiles
    STA.W OAMTileNo+$104,Y                    ; /
    PLX
    LDA.B SpriteProperties                    ; \ Store the first tile's properties
    ORA.W SpriteOBJAttribute,X                ; |
    STA.W OAMTileAttr+$100,Y                  ; /; X flip the second tile.
    ORA.B #!OBJ_XFlip                         ; \ Horizontally flip the second tile and store it
    STA.W OAMTileAttr+$104,Y                  ; /
    TYA                                       ; \ Y = index to size table
    LSR A                                     ; |
    LSR A                                     ; |
    TAY                                       ; /
    LDA.B #$00                                ; \ Two 8x8 tiles
    STA.W OAMTileSize+$40,Y                   ; |; Make them 8x8 size.
    STA.W OAMTileSize+$41,Y                   ; /
Return01E75A:
    RTS

PSwitch:
; Display Level Message 1 misc RAM:
; $1564 - Timer to wait before actually showing the message. Set to #$28 on spawn.
    LDA.W SpriteMisc1564,X                    ; Display Level Message 1 MAIN (also kinda P-switch MAIN, but its actual MAIN is at $01A1FD)
    CMP.B #$01                                ; Return if not time to show the message.
    BNE +
    STA.W OWPlayerSubmap                      ; Move Mario to the YI submap. [hijacked by LM, goes to $03BCA0]
    STA.W SaveDataBufferSubmap
    STZ.W SpriteStatus,X                      ; Erase the sprite.
    INC.W MessageBoxTrigger                   ; Show message 1.
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
; X positions for tiles in each frame of the Lakitu cloud's animation. 4 tiles per frame.
; Y positions for tiles in each frame of the Lakitu cloud's animation. 4 tiles per frame.
; These four seem unused.
; Y position offsets for the Lakitu cloud's 'floating' animation while Mario or a Lakitu is inside.
; 00-07 are for Mario/Lakitu.
; 08-0F are for Mario with a Yoshi.
; This byte seems unused.
; Lakitu Cloud misc RAM:
; $C2   - Flag for Mario being in the cloud.
; $151C - Flag to update the X/Y position of the cloud after the Lakitu is killed. Set to #$10 after Mario enters it for the first time.
; $1534 - Direction of vertical acceleration when a Lakitu is inside. Even = down, odd = up.
; $1540 - Timer for evaporating the cloud once its timer runs out.
; $154C - Timer for disabling Mario interaction. Always set to #$10 while a Lakitu is inside, and set to #$10 after jumping out of the cloud.
; $160E - Sprite slot containing the cloud's Lakitu. Uses the highest slot it can find at any given time.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Lakitu Cloud MAIN
    BEQ +                                     ; /; Skip down to just do graphics if game frozen.
CODE_01E7A8:
    JMP LakituCloudGfx

  + LDY.W LakituCloudTimer                    ; Game not frozen.
    BEQ +
    LDA.B EffFrame
    AND.B #$03
    BNE +
    LDA.W LakituCloudTimer                    ; Set the cloud to evaporate if its timer has run out.
    BEQ +
    DEC.W LakituCloudTimer
    BNE +
    LDA.B #$1F
    STA.W SpriteMisc1540,X
  + LDA.W SpriteMisc1540,X
    BEQ CODE_01E7DB
    DEC A                                     ; Erase the sprite once its evaporation timer runs out, and set the time for spawning the next Lakitu.
    BNE CODE_01E7A8
    STZ.W SpriteStatus,X
    LDA.B #$FF                                ; \ Set time until respawn; How long before the next Lakitu appears.
    STA.W SpriteRespawnTimer                  ; |
    LDA.B #$1E                                ; | Sprite to respawn = Lakitu; Which sprite spawns after the timer runs out (1E - Lakitu)
    STA.W SpriteRespawnNumber                 ; /
    RTS

CODE_01E7DB:
    LDY.B #$09                                ; Cloud isn't evaporating.
CODE_01E7DD:
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BNE +
    LDA.W SpriteNumber,Y                      ; Find a living Lakitu and track its slot.
    CMP.B #$1E                                ; If one is found, jump down a ways.
    BNE +                                     ; If none are found, continue below.
    TYA
    STA.W SpriteMisc160E,X
    JMP CODE_01E898

  + DEY
    BPL CODE_01E7DD
    LDA.B SpriteTableC2,X                     ; Branch if Mario is in the cloud.
    BNE CODE_01E840
    LDA.W SpriteMisc151C,X
    BEQ +                                     ; Update X/Y position.
    JSR SubSprXPosNoGrvty                     ; Unless the Lakitu was just killed and Mario hasn't entered the cloud yet.
    JSR SubSprYPosNoGrvty
  + LDA.W SpriteMisc154C,X                    ; Skip to just draw graphics if interaction is disabled (e.g. Mario just jumped out).
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
; If Mario touches the cloud while moving downwards,
  + CLC                                       ; put him inside and offset the cloud from his position (accounting for Yoshi).
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
    JSR LakituCloudGfx                        ; Mario is in the cloud.
    PHB
    LDA.B #$02
    PHA
    PLB                                       ; Handle control and speeds.
    JSL CODE_02D214
    PLB
    LDA.B SpriteYSpeed,X
    CLC                                       ; Sink the cloud slowly downwards.
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
    TAY                                       ; Adjust the Lakitu cloud's position for its "floating" animation.
  + LDA.B PlayerXPosNow                       ; Account for Yoshi's size, too.
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
    INC.W StandOnSolidSprite                  ; Set as standing on top of a solid sprite.
    INC.W PlayerInCloud                       ; Set flag for being inside the cloud.
    LDA.B byetudlrFrame
    AND.B #$80                                ; If B is pressed, make Mario jump out of the cloud.
    BEQ Return01E897
    LDA.B #$C0                                ; Y speed to give Mario when jumping out of a Lakitu cloud.
    STA.B PlayerYSpeed+1
    LDA.B #$10                                ; Disable contact with the cloud for 16 frames.
    STA.W SpriteMisc154C,X
    STZ.B SpriteTableC2,X
Return01E897:
    RTS

CODE_01E898:
    PHY                                       ; Lakitu is found, so cloud contains a Lakitu.
    JSR CODE_01E98D                           ; Handle movement and spiny attacks.
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    AND.B #$07
    TAY
    LDA.W DATA_01E793,Y
    STA.B _0
    PLY
    LDA.B SpriteXPosLow,X                     ; Move the Lakitu with the cloud.
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
    LDA.B #$10                                ; Disable Mario interaction with the cloud part.
    STA.W SpriteMisc154C,X
LakituCloudGfx:
    JSR GetDrawInfoBnk1                       ; Lakitu cloud GFX routine.
    LDA.W SpriteOffscreenVert,X               ; Return if vertically offscreen.
    BNE Return01E897
    LDA.B #$F8
    STA.B _C
    LDA.B #$FC
    STA.B _D
    LDA.B #$00
    LDY.B SpriteTableC2,X                     ; $0C-$0F: OAM offsets for each of the cloud's tiles (excluding face). Set to F8, FC, 00/30, 04/34.
    BNE +                                     ; $0E and $0F specifically are set to a low OAM index in order to hide Mario/Lakitu behind it.
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
    LSR A                                     ; Get tiles for the cloud's current frame of animation.
    AND.B #$0C
    STA.B _2
    LDA.B #$03                                ; Number of tiles to draw.
    STA.B _3
CODE_01E901:
    LDA.B _3
    TAX
    LDY.B _C,X                                ; Get index for the current tile's position.
    CLC
    ADC.B _2
    TAX
    %LorW_X(LDA,DATA_01E76F)
    CLC                                       ; Set X position for the tile.
    ADC.W LakituCloudTempXPos
    STA.W OAMTileXPos+$100,Y
    %LorW_X(LDA,DATA_01E77F)
    CLC                                       ; Set Y position for the tile.
    ADC.W LakituCloudTempYPos
    STA.W OAMTileYPos+$100,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$60                                ; Tile to use for the cloud when not being erased.
    STA.W OAMTileNo+$100,Y
    LDA.W SpriteMisc1540,X
    BEQ +
    LSR A                                     ; Set tile for the cloud.
    LSR A
    LSR A
    TAX
    LDA.W CloudTiles,X
    STA.W OAMTileNo+$100,Y
  + LDA.B SpriteProperties                    ; Set YXPPCCCT for the tile.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEC.B _3
    BPL CODE_01E901
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$F8                                ; OAM index for the Lakitu cloud's face.
    STA.W SpriteOAMIndex,X
    LDY.B #$02
    LDA.B #$01
    JSR FinishOAMWriteRt                      ; Draw four 16x16 tiles.
    LDA.W TileGenerateTrackB
    STA.W SpriteOAMIndex,X
    LDY.B #$02
    LDA.B #$01
    JSR FinishOAMWriteRt
    LDA.W SpriteOffscreenX,X                  ; Return and don't draw the cloud's face if horizontally offscreen.
    BNE Return01E984
    LDA.W LakituCloudTempXPos
    CLC                                       ; Set X position for the face.
    ADC.B #$04
    STA.W OAMTileXPos+8
    LDA.W LakituCloudTempYPos
    CLC                                       ; Set Y position for the face.
    ADC.B #$07
    STA.W OAMTileYPos+8
    LDA.B #$4D                                ; Tile for the Lakitu cloud's face.
    STA.W OAMTileNo+8
    LDA.B #$39                                ; YXPPCCCT for the Lakitu cloud's face.
    STA.W OAMTileAttr+8
    LDA.B #$00                                ; Set as an 8x8 tile.
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
; Tile numbers for the Lakitu cloud when being erased.
; Max X speeds for the Lakitu.
; Max Y speeds for the Lakitu before vertical acceleration is switched.
; Lakitu cloud's movement/attack routine.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if game frozen.
    BNE Return01E984                          ; /
    JSR SubHorizPos
    TYA                                       ; Face the Lakitu towards Mario.
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
    LDA.W SpriteStatus,X                      ; If sprite D2 is active and the Lakitu despawned offscreen,
    PLX                                       ; despawn the cloud too.
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
    CMP.W DATA_01E989,Y                       ; Accelerate horizontally towards Mario.
    BEQ +
    CLC
    ADC.W DATA_01EBB4,Y
    STA.B SpriteXSpeed,X
  + LDA.W SpriteMisc1534,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC                                       ; Alternate vertical acceleration, to create a wave motion.
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
    ASL A                                     ; If sprite D2 is active, send the Lakitu off the side of the screen.
    ASL A
    ASL A
    CLC
    ADC.B SpriteXSpeed,X
    STA.B SpriteXSpeed,X
  + JSR SubSprXPosNoGrvty
    PLA                                       ; Update X/Y position.
    STA.B SpriteXSpeed,X
    JSR SubSprYPosNoGrvty
    LDY.W SpriteMisc160E,X
    LDA.B TrueFrame
    AND.B #$7F
    ORA.W SpriteMisc151C,Y                    ; Throw a spiny if it's time to.
    BNE +                                     ; If the Lakitu is fishing, though, don't.
    LDA.B #$20
    STA.W SpriteMisc1558,Y
    JSR CODE_01EA21
  + RTS


DATA_01EA17:
    db $10,$F0

CODE_01EA19:
; Initial X speeds for the Lakitu's spinies.
    PHB                                       ; Wrapper; Lakitu throw routine. Used by both the cloud and pipe Lakitus.
    PHK
    PLB
    JSR CODE_01EA21
    PLB
    RTL

CODE_01EA21:
    JSL FindFreeSprSlot                       ; \ Return if no free slots; Return if no free sprite slots are found.
    BMI Return01EA6F                          ; /
    LDA.B #$08                                ; \ Sprite status = Normal; Set sprite state.
    STA.W SpriteStatus,Y                      ; /
    LDA.W SilverPSwitchTimer
    CMP.B #$01
    LDA.B #$14                                ; Sprite Lakitu throws (Spiny).
    BCC +
    LDA.B #$21                                ; Sprite Lakitu throws with the silver P-switch active (coin).
  + STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y                    ; Spawn at the Lakitu's position.
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    LDA.B #$D8                                ; Initial Y speed for the spiny/coin.
    STA.B SpriteYSpeed,X
    JSR SubHorizPos
    LDA.W DATA_01EA17,Y                       ; Set initial X speed for the spiny/coin.
    STA.B SpriteXSpeed,X
    LDA.B SpriteNumber,X
    CMP.B #$21
    BNE +                                     ; Change YXPPCCCT if spawning a coin, to make it silver.
    LDA.B #$02
    STA.W SpriteOBJAttribute,X
  + TXY
    PLX
Return01EA6F:
    RTS

CODE_01EA70:
; Routine to handle Yoshi's graphics, riding Yoshi, and tongue interaction.
    LDX.W YoshiIsLoose                        ; Return if there are no Yoshis in the level.
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
    ORA.W CutsceneID                          ; Skip animation if Yoshi is growing or the cutscene flag is set.
    BEQ +                                     ; (question: why cutscene flag?)
    JMP CODE_01EB48

  + STZ.W PlayerDuckingOnYoshi
    LDA.B SpriteTableC2,X
    CMP.B #$02
    BCC CODE_01EAA7                           ; If Yoshi is loose, make him perform the running animation.
    LDA.B #$30
    BRA CODE_01EAB2

CODE_01EAA7:
    LDY.B #$00                                ; Animation frame to give when standing still.
    LDA.B PlayerXSpeed+1                      ; \ Branch if Mario X speed == 0
    BEQ CODE_01EADF                           ; /; Branch if Mario is not moving horizontally.
    BPL CODE_01EAB2                           ; \ If Mario X speed is positive,; Else, make his X speed positive.
    EOR.B #$FF                                ; | invert it
    INC A                                     ; /
CODE_01EAB2:
    LSR A                                     ; \ Y = Upper 4 bits of X speed; Running animation.
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    TAY                                       ; /
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /; Branch if the game is frozen or it isn't time to change Yoshi's animation frame yet.
    DEC.W SpriteMisc1570,X                    ; \ If time to change frame...
    BPL +                                     ; |
    LDA.W DATA_01EDF5,Y                       ; | Set time to display new frame (based on Mario's X speed); Set timer (based on X speed) for how long until Yoshi changes frames again.
    STA.W SpriteMisc1570,X                    ; |
    DEC.W YoshiWalkingTimer                   ; | Set index to new frame, $18AD = ($18AD-1) % 3
    BPL +                                     ; |
    LDA.B #$02                                ; |
    STA.W YoshiWalkingTimer                   ; /; Get walking animation frame.
  + LDY.W YoshiWalkingTimer                   ; \ Y = frame to show
    LDA.W YoshiWalkFrames,Y                   ; |
    TAY                                       ; /
    LDA.B SpriteTableC2,X
    CMP.B #$02                                ; Branch if Yoshi is loose.
    BCS CODE_01EB2E
    BRA +

CODE_01EADF:
    STZ.W SpriteMisc1570,X                    ; Check if jumping.
  + LDA.B PlayerInAir                         ; Change animation frame if in air.
    BEQ +
    LDY.B #$02                                ; Animation frame to give when falling.
    LDA.B PlayerYSpeed+1
    BPL +
    LDY.B #$05                                ; Animation frame to give when jumping.
    BRA +

  + LDA.W SpriteMisc15AC,X                    ; Check if turning.
    BEQ +                                     ; Change animation frame if turning.
    LDY.B #$03                                ; Animation frame to give when turning.
; Check if sticking out tongue.
  + LDA.B PlayerInAir                         ; Skip if in the air.
    BNE CODE_01EB21
    LDA.W SpriteMisc151C,X                    ; Branch if not sticking out Yoshi's tongue.
    BEQ CODE_01EB0C
    LDY.B #$07                                ; Animation frame to use when sticking out Yoshi's tongue.
    LDA.B byetudlrHold
    AND.B #$08                                ; Change animation frame if sticking out Yoshi's tongue.
    BEQ +
    LDY.B #$06                                ; Animation frame to use when sticking out Yoshi's tongue while crouching.
  + BRA CODE_01EB21

CODE_01EB0C:
    LDA.W YoshiDuckTimer                      ; Not sticking out tongue.
    BEQ CODE_01EB16                           ; Decrease Yoshi's squatting timer if active.
    DEC.W YoshiDuckTimer
    BRA CODE_01EB1C

CODE_01EB16:
    LDA.B byetudlrHold                        ; Check if ducking.
    AND.B #$04                                ; If holding down, make Yoshi duck.
    BEQ CODE_01EB21
CODE_01EB1C:
    LDY.B #$04                                ; Animation frame to use when crouching.
    INC.W PlayerDuckingOnYoshi                ; Mark player as ducking.
CODE_01EB21:
    LDA.B SpriteTableC2,X                     ; Check if idle.
    CMP.B #$01
    BEQ CODE_01EB2E                           ; Change animation frame if idle.
    LDA.W SpriteMisc151C,X
    BNE CODE_01EB2E
    LDY.B #$04                                ; Animation frame to give when idle.
CODE_01EB2E:
    LDA.W PlayerRidingYoshi                   ; Check if entering a pipe.
    BEQ +
    LDA.W YoshiInPipeSetting
    CMP.B #$01
    BNE +
    LDA.B TrueFrame                           ; Change animation frame if riding Yoshi into a horizontal pipe.
    AND.B #$08                                ; (uses 8 or 9)
    LSR A
    LSR A
    LSR A
    ADC.B #$08
    TAY
; Done with animation frame.
  + TYA                                       ; Store animation frame.
    STA.W SpriteMisc1602,X
CODE_01EB48:
    LDA.B SpriteTableC2,X                     ; Offset from Mario.
    CMP.B #$01                                ; Branch if in a ridden state.
    BNE CODE_01EB97
    LDY.W SpriteMisc157C,X
    LDA.B PlayerXPosNext
    CLC
    ADC.W YoshiPositionX,Y                    ; Set X position based on direction.
    STA.B SpriteXPosLow,X
    LDA.B PlayerXPosNext+1
    ADC.W DATA_01EDF3,Y
    STA.W SpriteXPosHigh,X
    LDY.W SpriteMisc1602,X
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$10                                ; Set Y position based on frame.
    STA.B SpriteYPosLow,X
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.W DATA_01EDE4,Y                       ; Shift Mario's image based on frame.
    STA.W ScrShakePlayerYOffset
    LDA.B #$01
    LDY.W SpriteMisc1602,X
    CPY.B #$03
    BNE +                                     ; Set "riding Yoshi" flag (or turning, if applicable).
    INC A
  + STA.W PlayerRidingYoshi
    LDA.B #$01                                ; Allow the player to carry Yoshi between levels.
    STA.W CarryYoshiThruLvls
    LDA.W SpriteOBJAttribute,X                ; \ $13C7 = Yoshi palette; Track Yoshi's color.
    STA.W YoshiColor                          ; /
    LDA.W SpriteMisc157C,X
    EOR.B #$01                                ; Face Mario in the same direction as Yoshi.
    STA.B PlayerDirection
CODE_01EB97:
    LDA.B SpriteProperties                    ; Finish routine.
    PHA
    LDA.W PlayerRidingYoshi
    BEQ CODE_01EBAD
    LDA.W YoshiInPipeSetting
    BEQ CODE_01EBAD
    LDA.W DrawYoshiInPipe                     ; Run GFX routine and basic interactions.
    BNE +                                     ; Send Yoshi behind layers if entering a pipe, too.
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
; Acceleration values for a couple of sprites (Monty Mole, Eerie, Lakitu, Boo/Boo Block/Big Boo).
; Only the first two values are actually used...?
; X speeds to make Yoshi run away with.
; X speeds to give Mario when dismounting Yoshi on the ground.
; Sequence of frames for Yoshi's growing animation.
; Yoshi misc RAM:
; $C2   - Yoshi's current status. 00 = normal, 01 = being ridden, 02 = running.
; $151C - Distance Yoshi's tongue is from his mouth. Increments by #$03 when extending and decrements by #$04 when retracting. Caps at #$33.
; $1558 - Used as a couple timers.
; Set to #$08 when Yoshi's tongue is fully extended, to decide when to retract.
; Set to #$10 when Yoshi spits something out, to prevent him from sticking out his tongue.
; $1564 - Timer for the swallowing animation (when he actually swallows).
; Set to #$1A when swallowing, or #$21 when eating a berry.
; $1570 - Timer for how long each of Yoshi's animation frames last. Used to adjust how fast he animates in relation to his speed.
; $157C - Direction the sprite is facing. 00 = right, 01 = left
; $1594 - Pointer for a few different routines.
; 0 = normal, 1 = extending tongue, 2 = retracting tongue, 3 = spitting out
; $15AC - Timer for turning around. Set to #$10 at the start of a turn.
; $1602 - Animation frame to use.
; 0/1/2 = walking, 2 = falling, 3 = turning, 4 = crouching/unridden
; 5 = jumping, 6 = tongue out (up), 7 = tongue out (down), A/B/C = growing animation
; $160E - Sprite slot in Yoshi's mouth. Set to #$FF when empty.
; $163E - Timer to disable contact with sprites. Set to #$20 when mounted, and #$10 when Mario is knocked off.
; $1FE2 - Set when dismounting Yoshi, probably to prevent water splashes from showing if in water.
; Yoshi MAIN
    STZ.W PlayerIsFrozen                      ; Unfreeze the player (from berries).
    LDA.W YoshiHasWingsEvt                    ; \ $1410 = winged Yoshi flag
    STA.W YoshiHasWingsGfx                    ; /
    STZ.W YoshiHasWingsEvt                    ; Clear real winged Yoshi flag
    STZ.W YoshiCanStomp                       ; Clear stomp Yoshi flag
    STZ.W Empty191B
    LDA.W SpriteStatus,X                      ; \ Branch if normal Yoshi status
    CMP.B #$08                                ; |; If Yoshi is dying, don't let Mario bring him to the next level,
    BEQ +                                     ; /; and just draw graphics. (and handle tongue interaction, for some reason)
    STZ.W CarryYoshiThruLvls                  ; Mario won't have Yoshi when returning to OW
    JMP HandleOffYoshi

  + TXA
    INC A
    STA.W CurrentYoshiSlot
    LDA.W PlayerRidingYoshi
    BNE CODE_01EC04
    JSR SubOffscreen0Bnk1                     ; Branch if riding Yoshi or not offscreen.
    LDA.W SpriteStatus,X
    BNE CODE_01EC04
    LDA.W YoshiHeavenFlag
    BNE +                                     ; Unless in Yoshi Wings, prevent player from bringing Yoshi to the next level.
    STZ.W CarryYoshiThruLvls
  + RTS

CODE_01EC04:
    LDA.W PlayerRidingYoshi                   ; Check whether to hatch a Yoshi.
    BEQ CODE_01EC0E
    LDA.W YoshiInPipeSetting                  ; Skip if:
    BNE CODE_01EC61                           ; Entering a pipe while not on Yoshi.
CODE_01EC0E:
; Yoshi is laying an egg.
    LDA.W EggLaidTimer                        ; Not growing and game not frozen.
    BNE CODE_01EC61
    LDA.W YoshiGrowingTimer
    BEQ CODE_01EC4C
    DEC.W YoshiGrowingTimer
    STA.B SpriteLock                          ; Freeze game.
    STA.W PlayerIsFrozen
    CMP.B #$01                                ; If Yoshi isn't done hatching yet, skip to continue running the animation.
    BNE +
    STZ.B SpriteLock                          ; Unfreeze game.
    STZ.W PlayerIsFrozen
    LDY.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,Y
    DEC A
    ORA.W YoshiSavedFlag                      ; Decide whether to show Yoshi's spawn message.
    ORA.W OverworldOverride                   ; Conditions are: in Yoshi's Island, first time, and not title screen.
    BNE +
    INC.W YoshiSavedFlag
    LDA.B #$03                                ; Display Yoshi's spawn message.
    STA.W MessageBoxTrigger
  + DEC A
    LSR A
    LSR A
    LSR A                                     ; Set growing animation frame.
    TAY
    LDA.W GrowingAniSequence,Y                ; \ Set image to appropriate frame
    STA.W SpriteMisc1602,X                    ; /
    RTS

CODE_01EC4C:
; Not growing.
    LDA.B SpriteLock                          ; If the game isn't frozen, skip to next code.
    BEQ CODE_01EC61
CODE_01EC50:
    LDY.W PlayerRidingYoshi
    BEQ +                                     ; Offset the player's relative image on top of Yoshi.
    LDY.B #$06                                ; Normal offset distance while riding Yoshi.
    STY.W ScrShakePlayerYOffset
  + RTS


DATA_01EC5B:
    db $F0,$10

DATA_01EC5D:
    db $FA,$06

DATA_01EC5F:
    db $FF,$00

CODE_01EC61:
; X speeds to spawn an egg with.
; X lo position offsets for the egg spawn position from Yoshi.
; X hi position offsets for the egg spawn position from Yoshi.
    LDA.B PlayerInAir                         ; Not hatching; check whether to lay an egg.
    BNE CODE_01EC6A
    LDA.W EggLaidTimer
    BNE +                                     ; Skip if:
CODE_01EC6A:
; Not on ground.
    JMP CODE_01ECE1                           ; Timer to lay egg isn't set.

  + DEC.W EggLaidTimer                        ; Not in the process of laying.
    CMP.B #$01
    BNE CODE_01EC78
    STZ.B SpriteLock
    BRA CODE_01EC6A

CODE_01EC78:
    INC.W PlayerIsFrozen
    JSR CODE_01EC50                           ; Freeze game.
    STY.B SpriteLock
    CMP.B #$02                                ; Return if not ready to lay an egg.
    BNE Return01EC8A
    JSL FindFreeSprSlot                       ; \ Return if no free slots; Find a slot to spawn the egg in, then lay it.
    BPL +                                     ; |
Return01EC8A:
    RTS                                       ; /

  + LDA.B #$09                                ; \ Sprite status = Carryable; Lay an egg at Yoshi's position.
    STA.W SpriteStatus,Y                      ; /; Create the egg.
    LDA.B #$2C
    STA.W SpriteNumber,Y
    PHY
    PHY
    LDY.W SpriteMisc157C,X
    STY.B _F
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_01EC5D,Y
    PLY                                       ; Set X spawn position.
    STA.W SpriteXPosLow,Y
    LDY.W SpriteMisc157C,X
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_01EC5F,Y
    PLY
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$08                                ; Y offset from Yoshi.
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X                    ; Set Y spawn position.
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables                      ; Initialize the sprite.
    LDY.B _F
    LDA.W DATA_01EC5B,Y                       ; Set X speed.
    STA.B SpriteXSpeed,X
    LDA.B #$F0                                ; Initial Y speed of the egg.
    STA.B SpriteYSpeed,X
    LDA.B #$10                                ; Set the timer for the egg's hatching animation.
    STA.W SpriteMisc154C,X
    LDA.W YoshiEggSpriteHatch                 ; Set sprite for the egg to spawn.
    STA.W SpriteMisc151C,X
    PLX
    RTS

CODE_01ECE1:
    LDA.B SpriteTableC2,X                     ; Not laying an egg; handle movement.
    CMP.B #$01                                ; Skip if being ridden.
    BNE +
    JMP CODE_01ED70

; Not riding Yoshi.
  + JSR SubUpdateSprPos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    JSR IsOnGround
    BEQ +
    JSR SetSomeYSpeed__
    LDA.B SpriteTableC2,X                     ; If on the ground, give it a base Y speed (#$00 or #$24).
    CMP.B #$02                                ; If not loose, clear its X speed and make it bounce.
    BCS +
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.B #$F0                                ; Yoshi idle bouncing speed.
    STA.B SpriteYSpeed,X
  + JSR UpdateDirection                       ; Update direction being faced.
    JSR IsTouchingObjSide
    BEQ +                                     ; Invert X speed and direction if hitting a wall.
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
    LDA.W SpriteYPosHigh,X                    ; Mount Mario on Yoshi if:
    ADC.B #$00                                ; In contact with his saddle.
    STA.B _B                                  ; In air
    LDA.B #$08                                ; Not carrying something
    STA.B _7                                  ; Not already riding a Yoshi
    STA.B _6                                  ; Moving downwards
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
    LDY.B #$01                                ; Offset Mario from Yoshi.
    JSR CODE_01EDCE
    STZ.B PlayerXSpeed+1                      ; \ Mario's speed = 0; Clear Mario's X and Y speed.
    STZ.B PlayerYSpeed+1                      ; /
    LDA.B #$0C                                ; Make Yoshi squat briefly.
    STA.W YoshiDuckTimer
    LDA.B #$01                                ; Set Yoshi's state to being ridden.
    STA.B SpriteTableC2,X
    LDA.B #!SFX_YOSHIDRUMON                   ; \ Play sound effect; SFX: Turn on Yoshi drums.
    STA.W SPCIO1                              ; /
    LDA.B #!SFX_YOSHI                         ; \ Play sound effect; SFX for mounting Yoshi.
    STA.W SPCIO3                              ; /
    JSL DisabledAddSmokeRt                    ; Display smoke (disabled).
    LDA.B #$20                                ; Disable sprite contact briefly.
    STA.W SpriteMisc163E,X
    INC.W SpriteStompCounter                  ; Increase Mario's bounce counter.
CODE_01ED70:
    LDA.B SpriteTableC2,X                     ; Rejoin routines; handle Mario now riding Yoshi.
    CMP.B #$01                                ; Return if Mario is not riding Yoshi.
    BNE Return01EDCB
    JSR CODE_01F622                           ; Process sprite interaction.
    LDA.B byetudlrHold
    AND.B #$03
    BEQ +                                     ; Turn Yoshi around if:
    DEC A                                     ; Left/right pressed
    CMP.W SpriteMisc157C,X                    ; Not already facing that direction
    BEQ +                                     ; Not already turning
    LDA.W SpriteMisc15AC,X                    ; Not sticking out tongue
    ORA.W SpriteMisc151C,X                    ; Not ducking
    ORA.W PlayerDuckingOnYoshi
    BNE +
    LDA.B #$10                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
  + LDA.W PBalloonInflating
    BNE CODE_01ED9E                           ; Kick Mario off Yoshi if A is pressed or Mario gets a P-balloon.
    BIT.B axlr0000Frame                       ; Else, return.
    BPL Return01EDCB
CODE_01ED9E:
; Make Mario get off Yoshi (by spinjumping/p-balloon).
    LDA.B #$02                                ; Briefly disable water splashes.
    STA.W SpriteMisc1FE2,X
    STZ.B SpriteTableC2,X                     ; Set Yoshi to idle.
    LDA.B #!SFX_YOSHIDRUMOFF                  ; \ Play sound effect; SFX for dismounting Yoshi.
    STA.W SPCIO1                              ; /
    STZ.W CarryYoshiThruLvls                  ; Don't let Mario carry Yoshi to the next level.
    LDA.B PlayerXSpeed+1                      ; Give Yoshi Mario's X speed.
    STA.B SpriteXSpeed,X
    LDA.B #$A0                                ; Y speed to give Mario when jumping off Yoshi in mid-air.
    LDY.B PlayerInAir
    BNE +
    JSR SubHorizPos                           ; Decide how to jump off Yoshi based on whether he's in the air or not.
    LDA.W DATA_01EBC0,Y
    STA.B PlayerXSpeed+1
    LDA.B #$C0                                ; Y speed to give Mario when jumping off Yoshi on the ground.
  + STA.B PlayerYSpeed+1
    STZ.W PlayerRidingYoshi                   ; Mark as no longer riding.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Clear Yoshi's Y speed.
    JSR CODE_01EDCC                           ; Offset Mario vertically from Yoshi.
Return01EDCB:
    RTS

CODE_01EDCC:
    LDY.B #$00                                ; Subroutine to offset Mario from Yoshi's Y position when mounting/dismounting.
CODE_01EDCE:
    LDA.B SpriteYPosLow,X
    SEC
    SBC.W DATA_01EDE2,Y
    STA.B PlayerYPosNext
    STA.B PlayerYPosNow                       ; Offset player accordingly.
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
; Player offsets from Yoshi when mounting/dismounting. First is dismounting, second is mounting.
; Player image offsets while riding Yoshi, indexed by Yoshi's animation frame.
; Animation frames to cycle through for Yoshi's walking animation.
; Yoshi's X position offset from Mario while being ridden, low.
; Yoshi's X position offset from Mario while being ridden, high.
; Length of Yoshi's walking animation frames, indexed by Mario's X speed / 8.
; Tiles for Yoshi's head.
; Tiles for Yoshi's body.
; X offsets for Yoshi's head, low.
; Right
; Left
; X offsets for Yoshi's head, high.
; Base Y offsets for Yoshi.
; Y offsets for Yoshi's head.
    LDA.W SpriteMisc1602,X                    ; Yoshi's GFX routine. Also handles some other routines (most notably his tongue).
    PHA
    LDY.W SpriteMisc15AC,X
    CPY.B #$08
    BNE +
    LDA.W YoshiInPipeSetting
    ORA.B SpriteLock                          ; If turning, invert Mario and Yoshi's directions.
    BNE +
    LDA.W SpriteMisc157C,X
    STA.B PlayerDirection
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + LDA.W YoshiInPipeSetting
    BMI +
    CMP.B #$02                                ; Use the turning GFX frame if entering a vertical pipe.
    BNE +
    INC A
    STA.W SpriteMisc1602,X
  + JSR CODE_01EF18                           ; Set up OAM.
    LDY.B _E
    LDA.W OAMTileNo+$100,Y
    STA.B _0                                  ; Set actual tiles in SP1 for Yoshi.
    STZ.B _1
    LDA.B #$06                                ; Destination tile for Yoshi's head.
    STA.W OAMTileNo+$100,Y
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileNo+$100,Y
    STA.B _2
    STZ.B _3
    LDA.B #$08                                ; Destination tile for Yoshi's body.
    STA.W OAMTileNo+$100,Y
    REP #$20                                  ; A->16
    LDA.B _0
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A                                     ; Store the pointer to Yoshi's head tile for DMA upload.
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
    ASL A                                     ; Store the pointer to Yoshi's body tile for DMA upload.
    CLC
    ADC.W #$8500
    STA.W DynGfxTilePtr+8
    CLC
    ADC.W #$0200
    STA.W DynGfxTilePtr+$12
    SEP #$20                                  ; A->8
    PLA
    STA.W SpriteMisc1602,X
    JSR CODE_01F0A2                           ; Handle Yoshi's mouth routines.
    LDA.W YoshiHasWingsGfx                    ; \ Return if Yoshi doesn't have wings
    CMP.B #$02                                ; |; Return if Yoshi doesn't have wings.
    BCC Return01EF17                          ; /
    LDA.W PlayerRidingYoshi                   ; Just draw the wings if not on Yoshi.
    BEQ CODE_01EF13
    LDA.B PlayerInAir                         ; Branch if in air.
    BNE CODE_01EF00
    LDA.B PlayerXSpeed+1
    BPL +
    EOR.B #$FF
    INC A                                     ; If Mario's X speed is
; < 28: draw closed wings
  + CMP.B #$28                                ; => 28: draw open wings
    LDA.B #$01
    BCS CODE_01EF13
    LDA.B #$00
    BRA CODE_01EF13

CODE_01EF00:
    LDA.B EffFrame                            ; Yoshi has wings in air.
    LSR A
    LSR A
    LDY.B PlayerYSpeed+1
    BMI +
    LSR A                                     ; Animate Yoshi's wings and play flutter noises.
    LSR A                                     ; When rising upwards, animate 4 times faster.
  + AND.B #$01
    BNE CODE_01EF13
    LDY.B #!SFX_YOSHITONGUE                   ; \ Play sound effect; SFX for Yoshi's wing flutters.
    STY.W SPCIO3                              ; /
CODE_01EF13:
    JSL CODE_02BB23                           ; Draw Yoshi's wings.
Return01EF17:
    RTS

CODE_01EF18:
    LDY.W SpriteMisc1602,X                    ; Yoshi GFX routine (OAM portion)
    STY.W TileGenerateTrackA                  ; Set frame number for Yoshi's head.
    LDA.W YoshiHeadTiles,Y
    STA.W SpriteMisc1602,X
    STA.B _F
    LDA.B SpriteYPosLow,X
    PHA
    CLC
    ADC.W YoshiPositionY,Y
    STA.B SpriteYPosLow,X                     ; Get Y displacement for Yoshi's head.
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
    PHA                                       ; Get X displacement for Yoshi's head.
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
    ORA.W YoshiInPipeSetting                  ; If turning or entering a pipe, change OAM index for Yoshi's head to slot #$04.
    BEQ +                                     ; (to draw in front of Mario)
    LDA.B #$04
    STA.W SpriteOAMIndex,X
  + LDA.W SpriteOAMIndex,X
    STA.B _E
    JSR SubSprGfx2Entry1
    PHX
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDX.W TileGenerateTrackA                  ; Draw Yoshi's head and offset it vertically from the body.
    LDA.W OAMTileYPos+$100,Y
    CLC
    %LorW_X(ADC,YoshiHeadDispY)
    STA.W OAMTileYPos+$100,Y
    PLX
    PLA
    CLC                                       ; Increase OAM index.
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    LDY.W TileGenerateTrackA
    LDA.W YoshiBodyTiles,Y                    ; Set frame number for Yoshi's body.
    STA.W SpriteMisc1602,X
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$10                                ; Offset body horizontally from the head.
    STA.B SpriteYPosLow,X
    BCC +
    INC.W SpriteYPosHigh,X
  + JSR SubSprGfx2Entry1                      ; Draw Yoshi's body.
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    LDY.B _E
    LDA.B _F
    BPL +                                     ; If the frame for Yoshi's head was 80+, hide it offscreen.
    LDA.B #$F0                                ; (for growing animation frames)
    STA.W OAMTileYPos+$100,Y
  + LDA.B SpriteTableC2,X                     ; Figure out what to do with Yoshi's mouth.
    BNE CODE_01EFC6
    LDA.B EffFrame                            ; If not being ridden and not loose, handle Yoshi's idle animation.
    AND.B #$30
    BNE CODE_01EFDB
    LDA.B #$2A                                ; Tile to use for Yoshi's idle "mouth open" frame.
    BRA CODE_01EFFA

CODE_01EFC6:
    CMP.B #$02
    BNE CODE_01EFDB
    LDA.W SpriteMisc151C,X
    ORA.W CutsceneID                          ; If Yoshi is loose, does not have his tongue out, and is not in a custscene,
    BNE CODE_01EFDB                           ; animate his face; use the "hit" tile every 16 frames.
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
    LDA.W SpriteMisc151C,X                    ; If:
    BEQ +                                     ; Spitting
    LDA.W OAMTileNo+$100,Y                    ; Sticking out Yoshi's tongue
    CMP.B #$24                                ; Then make Yoshi open his mouth.
    BEQ +
CODE_01EFEE:
    LDA.B #$2A                                ; Tile for Yoshi's head when his mouth is open.
    STA.W OAMTileNo+$100,Y
  + LDA.W YoshiStartEatTimer
    BEQ CODE_01EFFD                           ; Change Yoshi's face if he's hit and about to stick out his tongue.
CODE_01EFF8:
    LDA.B #$0C                                ; Tile for Yoshi's head after being hit or while running loose.
CODE_01EFFA:
    STA.W OAMTileNo+$100,Y
CODE_01EFFD:
    LDA.W SpriteMisc1564,X
    LDY.W YoshiSwallowTimer
    BEQ CODE_01F00F                           ; If time to swallow, continue below to handle swallowing.
    CPY.B #$26                                ; If the wait timer is 26+, give Yoshi a full mouth.
    BCS CODE_01F038                           ; If the wait timer is 1-25, give him a full mouth for 24 out of every 32 frames.
    LDA.B EffFrame
    AND.B #$18
    BNE CODE_01F038
CODE_01F00F:
    LDA.W SpriteMisc1564,X
    CMP.B #$00                                ; Return if not swallowing.
    BEQ Return01EFDA
    LDY.B #$00                                ; Tile to use for Yoshi's head as the final part of the swallow animation (normal).
    CMP.B #$0F                                ; When swallow animation timer is:
    BCC CODE_01F03A                           ; < 0F: Only handle swallow animation, with empty mouth.
    CMP.B #$1C                                ; < 1C: Only handle swallow animation, with full mouth.
    BCC CODE_01F038                           ; = 1C: Erase tile and count berry if applicable. [only set this high by berries]
    BNE +                                     ; > 1C: Freeze Mario in place. [only set this high by berries]
    LDA.B _E
    PHA
    JSL SetTreeTile                           ; Remove the berry from the bush tile.
    JSR CODE_01F0D3                           ; Increase berry counters and decide whether to lay an egg.
    PLA
    STA.B _E
  + INC.W PlayerIsFrozen                      ; Briefly freeze Mario.
    LDA.B #$00
    LDY.B #$2A                                ; Tile to use for Yoshi's head at the beginning of the swallow animation (open).
    BRA CODE_01F03A

CODE_01F038:
; Draw Yoshi's throat tile.
    LDY.B #$04                                ; Tile to use for Yoshi's head during the middle part of the swallow animation (full)
CODE_01F03A:
    PHA
    TYA
    LDY.B _E                                  ; Change tile for Yoshi's head (to either 00, 04, or 2A).
    STA.W OAMTileNo+$100,Y
    PLA
    CMP.B #$0F
    BCS Return01F0A0                          ; Only animate when the swallow timer is 05-0E.
    CMP.B #$05
    BCC Return01F0A0
    SBC.B #$05
    LDY.W SpriteMisc157C,X
    BEQ +                                     ; Increase index by 0A if facing left.
    CLC
    ADC.B #$0A
  + LDY.W SpriteMisc1602,X
    CPY.B #$0A
    BNE +                                     ; Increase index by 14 if ducking.
    CLC
    ADC.B #$14
  + STA.B _2
    JSR IsSprOffScreen                        ; Return if offscreen.
    BNE Return01F0A0
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    PHX                                       ; Set X/Y offset.
    LDX.B _2
    LDA.B _0
    CLC
    ADC.L DATA_03C176,X
    STA.W OAMTileXPos+$100
    LDA.B _1
    CLC
    ADC.L DATA_03C19E,X
    STA.W OAMTileYPos+$100
    LDA.B #$3F                                ; Tile for Yoshi's throat as he swallows.
    STA.W OAMTileNo+$100
    PLX
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileAttr+$100,Y
    ORA.B #$01                                ; Use GFX page 2.
    STA.W OAMTileAttr+$100
    LDA.B #$00                                ; Set size (8x8).
    STA.W OAMTileSize+$40
Return01F0A0:
    RTS

Return01F0A1:
    RTS

CODE_01F0A2:
    LDA.B SpriteTableC2,X                     ; Routine to handle Yoshi's mouth functionality.
    CMP.B #$01                                ; If riding Yoshi, process interaction with berries.
    BNE +
    JSL CODE_02D0D4
  + LDA.W YoshiHasWingsGfx                    ; \ Branch if $1410 == #$01
    CMP.B #$01                                ; | This never happens; Prevent sticking out Yoshi's tongue if $1410 is #$01 (Mario can shoot fireballs).
    BEQ Return01F0A1                          ; / (fireball on Yoshi ability)
    LDA.W YoshiTongueTimer
    CMP.B #$10
    BNE +
    LDA.W YoshiStartEatTimer                  ; If being hit, stick out Yoshi's tongue.
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
; Pointers to different phases for Yoshi's mouth.
; 0 - Normal
; 1 - Extending tongue
; 2 - Retracting tongue
; 3 - Spitting
; Routine for Yoshi swallowing a sprite and handling berry counters.
    LDA.B #!SFX_GULP                          ; \ Play sound effect; SFX for swallowing a sprite.
    STA.W SPCIO0                              ; /
    JSL CODE_05B34A                           ; Give a coin.
    LDA.W EatenBerryType                      ; Return if not a berry.
    BEQ Return01F12D
    STZ.W EatenBerryType
    CMP.B #$01                                ; Branch if not a red berry.
    BNE CODE_01F0F9
    INC.W RedBerriesEaten
    LDA.W RedBerriesEaten
    CMP.B #$0A                                ; Number of red berries Yoshi needs to eat to lay an egg.
    BNE Return01F12D
    STZ.W RedBerriesEaten
    LDA.B #$74                                ; Sprite spawned by Yoshi for eating 10 red berries.
    BRA CODE_01F125

CODE_01F0F9:
; Not a red berry; check if green berry.
    CMP.B #$03                                ; Branch if not a green berry.
    BNE CODE_01F116
    LDA.B #!SFX_CORRECT                       ; \ Play sound effect; SFX for eating a green berry.
    STA.W SPCIO3                              ; /
    LDA.W InGameTimerTens
    CLC
    ADC.B #$02
    CMP.B #$0A
    BCC +                                     ; Add 20 seconds to the in-game timer.
    SBC.B #$0A
    INC.W InGameTimerHundreds
  + STA.W InGameTimerTens
    BRA Return01F12D

CODE_01F116:
    INC.W PinkBerriesEaten                    ; Not green or red; assume pink.
    LDA.W PinkBerriesEaten
    CMP.B #$02                                ; Number of pink berries Yoshi needs to eat to lay an egg.
    BNE Return01F12D
    STZ.W PinkBerriesEaten
    LDA.B #$6A                                ; Sprite spawned by Yoshi for eating 2 pink berries.
CODE_01F125:
    STA.W YoshiEggSpriteHatch
    LDY.B #$20                                ; Set egg timer and sprite.
    STY.W EggLaidTimer
Return01F12D:
    RTS

CODE_01F12E:
    LDA.W SpriteMisc1558,X                    ; Spitting.
    BNE +                                     ; Temporarily disable tongue before returning to normal.
    STZ.W SpriteMisc1594,X
  + RTS


YoshiShellAbility:
    db $00,$00,$01,$02,$00,$00,$01,$02
    db $01,$01,$01,$03,$02,$02

YoshiAbilityIndex:
    db $03,$02,$02,$03,$01,$00

CODE_01F14B:
; Yoshi powers for each Yoshi/shell combination.
; 4 bytes per Yoshi with each byte being a shell color, with the colors ordered gryb for both.
; Format: %------fg
; f = flight, g = ground stomp
; Which set of abilities in the above table that each Yoshi corresponds to, ordered ybrg.
    LDA.W YoshiHeavenFlag                     ; Routine to handle Yoshi's mouth when not spitting out his tongue.
    BEQ +                                     ; If in the Yoshi Wings minigame, give wings.
    LDA.B #$02                                ; \ Set Yoshi wing ability
    STA.W YoshiHasWingsEvt                    ; /
  + LDA.W YoshiSwallowTimer                   ; Branch if Yoshi doesn't have a sprite in his mouth.
    BEQ CODE_01F1A2
    LDY.W SpriteMisc160E,X
    LDA.W SpriteNumber,Y                      ; If the sprite in Yoshi's mouth is a key,
    CMP.B #$80                                ; take note of that for keyholes.
    BNE +
    INC.W YoshiHasKey
  + CMP.B #$0D                                ; Branch if the sprite in Yoshi's mouth is not a shell.
    BCS CODE_01F1A2
    PHY
    LDA.W SpriteMisc187B,Y
    CMP.B #$01                                ; If Yoshi has a disco shell, give both wings and stomp power.
    LDA.B #$03
    BCS +
    LDA.W SpriteOBJAttribute,X                ; \ Set yoshi stomp/wing ability,
    LSR A                                     ; | based on palette of sprite and Yoshi
    AND.B #$07                                ; |
    TAY                                       ; |
    LDA.W YoshiAbilityIndex,Y                 ; |
    ASL A                                     ; |
    ASL A                                     ; |
    STA.B _0                                  ; |; Decide what abilities to give Yoshi,
    PLY                                       ; |; based on both Yoshi and the shell's palettes.
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
    AND.B #$02                                ; | ($141E = #$02); Store wings flag.
    STA.W YoshiHasWingsEvt                    ; /
    PLA                                       ; \ If Yoshi gets stomp ability,
    AND.B #$01                                ; | $18E7 = #$01; Store stomp flag.
    STA.W YoshiCanStomp                       ; /
    PLY
CODE_01F1A2:
    LDA.B EffFrame
    AND.B #$03
    BNE +                                     ; Handle swallow timer;
    LDA.W YoshiSwallowTimer                   ; decrease every 4th frame,
    BEQ +                                     ; and if branch if not time to swallow (or if no sprite in mouth at all).
    DEC.W YoshiSwallowTimer
    BNE +
    LDY.W SpriteMisc160E,X
    LDA.B #$00
    STA.W SpriteStatus,Y
    DEC A                                     ; Erase the sprite, clear the slot in Yoshi's mouth, and give a coin.
    STA.W SpriteMisc160E,X                    ; Also set the timer for the swallowing animation.
    LDA.B #$1B
    STA.W SpriteMisc1564,X
    JMP CODE_01F0D3

; Not swallowing; check if preparing to stick out tongue.
  + LDA.W YoshiStartEatTimer                  ; Branch if not waiting to stick out Yoshi's tongue.
    BEQ CODE_01F1DF
    DEC.W YoshiStartEatTimer
    BNE Return01F1DE
    INC.W SpriteMisc1594,X
    STZ.W SpriteMisc151C,X                    ; If time to stick out Yoshi's tongue, set up related addresses.
    LDA.B #$FF
    STA.W SpriteMisc160E,X
    STZ.W SpriteMisc1564,X
Return01F1DE:
    RTS

CODE_01F1DF:
    LDA.B SpriteTableC2,X                     ; Not preparing to stick out tongue; check for X/Y being pressed.
    CMP.B #$01
    BNE Return01F1DE                          ; Return if not being ridden or X/Y not pressed.
    BIT.B byetudlrFrame
    BVC Return01F1DE
    LDA.W YoshiSwallowTimer                   ; Branch if Yoshi has a sprite in his mouth.
    BNE +
    JMP CODE_01F309                           ; Prepare to punch Yoshi.

; Spitting out a sprite.
  + STZ.W YoshiSwallowTimer                   ; Register mouth as empty.
    LDY.W SpriteMisc160E,X
    PHY
    PHY
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_01F305,Y
    PLY
    STA.W SpriteXPosLow,Y                     ; Set sprite X position.
    LDY.W SpriteMisc157C,X
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_01F307,Y
    PLY
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y                     ; Set sprite Y position.
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    LDA.B #$00
    STA.W SpriteTableC2,Y                     ; Clear sprite-being-eaten flag and enemies-killed count for the item.
    STA.W SpriteOnYoshiTongue,Y               ; Also clear $C2 for whatever reason (as far as I know, this has no effect).
    STA.W SpriteMisc1626,Y
    LDA.W PlayerDuckingOnYoshi
    CMP.B #$01
    LDA.B #$0A                                ; Set sprite state based on whether Yoshi is ducking or not;
    BCC +                                     ; if not ducking, give it thrown status (0A).
    LDA.B #$09                                ; \ Sprite status = Carryable; if ducking, give it carryable status (09).
  + STA.W SpriteStatus,Y                      ; /
    PHX
    LDA.W SpriteMisc157C,X                    ; Face the sprite the same direction as Yoshi.
    STA.W SpriteMisc157C,Y
    TAX
    BCC +
    INX
    INX                                       ; Give it an X speed based on ducking or not.
  + LDA.W DATA_01F301,X
    STA.W SpriteXSpeed,Y
    LDA.B #$00                                ; Clear the sprite's Y speed.
    STA.W SpriteYSpeed,Y
    PLX
    LDA.B #$10                                ; Briefly prevent sticking out Yoshi's tongue after spitting.
    STA.W SpriteMisc1558,X
    LDA.B #$03                                ; Switch Yoshi to spitting status.
    STA.W SpriteMisc1594,X
    LDA.B #$FF                                ; Clear slot in mouth.
    STA.W SpriteMisc160E,X
    LDA.W SpriteNumber,Y
    CMP.B #$0D                                ; Branch if not a Koopa shell or not set to spawn fire when spit.
    BCS CODE_01F2DF                           ; Situations for spawning fire are:
    LDA.W SpriteMisc187B,Y                    ; Disco shell
    BNE CODE_01F27C                           ; Red shell
    LDA.W SpriteOBJAttribute,Y                ; Red Yoshi
    AND.B #$0E
    CMP.B #$08                                ; Which color shell spawns fire when spit out.
    BEQ CODE_01F27C
    LDA.W SpriteOBJAttribute,X
    AND.B #$0E
    CMP.B #$08                                ; Which color Yoshi spits out fire by default.
    BNE CODE_01F2DF
CODE_01F27C:
    PHX                                       ; Spit fire.
    TYX
    STZ.W SpriteStatus,X                      ; Erase the shell.
    LDA.B #$02
    STA.B _0
    JSR CODE_01F295                           ; Spawn three flames.
    JSR CODE_01F295
    JSR CODE_01F295
    PLX
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect; SFX for spitting out flames.
    STA.W SPCIO3                              ; /
    RTS

CODE_01F295:
; Spawn a flame.
    JSR CODE_018EEF                           ; Find an extended sprite slot.
    LDA.B #$11                                ; \ Extended sprite = Yoshi fireball
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W ExtSpriteXPosHigh,Y                 ; Spawn a fire at Yoshi's position.
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
    BCC +                                     ; Set X speed.
    EOR.B #$FF
    INC A
  + STA.W ExtSpriteXSpeed,Y
    LDA.W DATA_01F2DC,X                       ; Set Y speed.
    STA.W ExtSpriteYSpeed,Y
    LDA.B #$A0                                ; Useless?
    STA.W ExtSpriteMisc176F,Y
    PLX
    DEC.B _0
    RTS


DATA_01F2D9:
    db $28,$24,$24

DATA_01F2DC:
    db $00,$F8,$08

CODE_01F2DF:
; X speeds for Yoshi's fireballs.
; Y speeds for Yoshi's fireballs.
; Spit out sprite normally.
    LDA.B #!SFX_SPIT                          ; \ Play sound effect; SFX for spitting.
    STA.W SPCIO0                              ; /
    LDA.W SpriteTweakerE,Y                    ; \ Return if sprite doesn't spawn a new one
    AND.B #$40                                ; |
    BEQ +                                     ; /
    PHX                                       ; \ Load sprite to spawn and store it
    LDX.W SpriteNumber,Y                      ; |; If set to spawn a new sprite, spawn said sprite.
    LDA.L SpriteToSpawn,X                     ; |; This code actually can't normally run; the only actual cases for it are handled at $01F360.
    PLX                                       ; |; However, it can end up being used for unintentionally stunned sprites.
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
; Unused?
; X speeds to give spit sprites. First two are when in thrown status, second are stationary.
; X offsets for a spit sprite from Yoshi, low.
; X offsets for a spit sprite from Yoshi, high.
; Prepare to punch routine for Yoshi.
    LDA.B #$12                                ; Initialize Yoshi tongue timer.
    STA.W YoshiTongueTimer
    LDA.B #!SFX_YOSHITONGUE                   ; \ Play sound effect; SFX for sticking out Yoshi's tongue.
    STA.W SPCIO3                              ; /
    RTS

CODE_01F314:
    LDA.W SpriteMisc151C,X                    ; Extending tongue.
    CLC                                       ; Increase length of Yoshi's tongue, and branch if at max length.
    ADC.B #$03                                ; Speed of Yoshi's tongue when sticking out.
    STA.W SpriteMisc151C,X
    CMP.B #$20                                ; Maximum length of Yoshi's tongue.
    BCS +
CODE_01F321:
; Standard Yoshi tongue routines.
    JSR CODE_01F3FE                           ; GFX routine.
    JSR CODE_01F4B2                           ; Interaction routine.
    RTS

; At max length.
  + LDA.B #$08                                ; How long to leave Yoshi's tongue at full length before retracting.
    STA.W SpriteMisc1558,X                    ; Switch to retracting.
    INC.W SpriteMisc1594,X
    BRA CODE_01F321

CODE_01F332:
    LDA.W SpriteMisc1558,X                    ; Retracting tongue.
    BNE CODE_01F321
    LDA.W SpriteMisc151C,X
    SEC                                       ; Reduce length of Yoshi's tongue, and branch if not fully retracted.
    SBC.B #$04                                ; Speed of Yoshi's tongue when retracting.
    BMI CODE_01F344
    STA.W SpriteMisc151C,X
    BRA CODE_01F321

CODE_01F344:
    STZ.W SpriteMisc151C,X                    ; Tongue fully retracted; put sprite in mouth.
    STZ.W SpriteMisc1594,X
    LDY.W SpriteMisc160E,X                    ; Branch if there wasn't a sprite on Yoshi's tongue.
    BMI CODE_01F370
    LDA.W SpriteTweakerE,Y
    AND.B #$02                                ; Branch if it isn't meant to stay in Yoshi's mouth.
    BEQ CODE_01F373
    LDA.B #$07                                ; \ Sprite status = Unused (todo: look here); Change sprite state to in mouth.
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$FF                                ; How long before Yoshi swallows the sprite.
    STA.W YoshiSwallowTimer
    LDA.W SpriteNumber,Y                      ; \ Branch if not a Koopa
    CMP.B #$0D                                ; | (sprite number >= #$0D)
    BCS CODE_01F370                           ; /
    PHX                                       ; If the sprite was a Koopa, turn it into a shell.
    TAX
    LDA.W SpriteToSpawn,X
    STA.W SpriteNumber,Y
    PLX
CODE_01F370:
    JMP CODE_01F3FA

CODE_01F373:
; Sprite doesn't stay in Yoshi's mouth.
    LDA.B #$00                                ; Erase sprite.
    STA.W SpriteStatus,Y
    LDA.B #$1B                                ; Set swallow animation timer.
    STA.W SpriteMisc1564,X
    LDA.B #$FF                                ; Clear slot in Yoshi's mouth.
    STA.W SpriteMisc160E,X
    STY.B _0
    LDA.W SpriteNumber,Y
    CMP.B #$9D
    BNE +
    LDA.W SpriteTableC2,Y
    CMP.B #$03                                ; If the sprite is a bubble containing a mushroom,
    BNE +                                     ; change it into an actual mushroom.
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
    LSR A                                     ; If the sprite is the roulette item,
    LSR A                                     ; change it into its current powerup.
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
    ASL A                                     ; Branch if not set to give a powerup when eaten.
    ASL A
    PLA
    BCC +
    PHX
    TYX
    STZ.B SpriteTableC2,X                     ; Give powerup.
    JSR CODE_01C4BF
    PLX
    LDY.W PlayerDuckingOnYoshi
    LDA.W DATA_01F3D9,Y                       ; Set Yoshi's animation frame.
    STA.W SpriteMisc1602,X
    JMP CODE_01F321                           ; Continue to handle tongue functionality, for some reason.


DATA_01F3D9:
    db $00,$04

; Animation frames for Yoshi during the powerup animation, based on crouching or not.
  + CMP.B #$7E                                ; Sprite not set to give powerup when eaten.
    BNE CODE_01F3F7                           ; Branch if not Yoshi Wings.
    LDA.W SpriteTableC2,Y
    BEQ CODE_01F3F7
    CMP.B #$02
    BNE +
    LDA.B #$08                                ; Warp to Yoshi Wings game.
    STA.B PlayerAnimation
    LDA.B #!SFX_VINEBLOCK                     ; \ Play sound effect; SFX for collecting wings, when eaten with Yoshi's tongue.
    STA.W SPCIO3                              ; /
  + JSR CODE_01F6CD                           ; Give Yoshi wings and erase the sprite.
    JMP CODE_01F321                           ; Continue to handle tongue functionality, for some reason.

CODE_01F3F7:
; Not Yoshi wings.
    JSR CODE_01F0D3                           ; Give a coin.
CODE_01F3FA:
    JMP CODE_01F321                           ; Continue to handle tongue functionality, for some reason.

Return01F3FD:
    RTS

CODE_01F3FE:
    LDA.W SpriteOffscreenX,X                  ; \ Branch if sprite off screen...; Yoshi's tongue GFX routine.
    ORA.W SpriteOffscreenVert,X               ; |; Return if offscreen or entering pipe.
    ORA.W YoshiInPipeSetting                  ; | ...or going down pipe
    BNE Return01F3FD                          ; /
    LDY.W SpriteMisc1602,X
    LDA.W DATA_01F61A,Y
    STA.W TileGenerateTrackA
    CLC                                       ; Get Y position to draw the tongue at.
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
  + LDA.W DATA_01F60A,Y                       ; Get X position to draw the tongue at.
    STA.B _D
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.B _D
    STA.B _0
    LDA.W SpriteMisc157C,X
    BNE CODE_01F43C
    BCS Return01F3FD                          ; Return if it would draw offscreen.
    BRA CODE_01F43E

CODE_01F43C:
    BCC Return01F3FD
CODE_01F43E:
    LDA.W SpriteMisc151C,X
    STA.W HW_WRDIV+1
    STZ.W HW_WRDIV
    LDA.B #$04                                ; Number of tongue tiles to calculate for, -1.
    STA.W HW_WRDIV+2
    NOP
    NOP                                       ; Calculate how to space the tongue tiles.
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDA.W SpriteMisc157C,X
    STA.B _7
    LSR A
    LDA.W HW_RDDIV+1                          ; Invert spacing amount if facing left.
    BCC +
    EOR.B #$FF
    INC A
  + STA.B _5
    LDA.B #$04                                ; How many tiles actually make up Yoshi's tongue (also affects visual length).
    STA.B _6
    LDY.B #$0C                                ; Base OAM index (from $0200) of Yoshi's tongue.
CODE_01F46A:
    LDA.B _0                                  ; Tongue tile loop.
    STA.W OAMTileXPos,Y
    CLC                                       ; Set X position.
    ADC.B _5
    STA.B _0
    LDA.B _5
    BPL CODE_01F47C
    BCC Return01F4B1                          ; Return GFX routine if the current tile would go offscreen.
    BRA CODE_01F47E

CODE_01F47C:
    BCS Return01F4B1
CODE_01F47E:
    LDA.B _1                                  ; Set Y position
    STA.W OAMTileYPos,Y
    LDA.B _6                                  ; Set tile number.
    CMP.B #$01
    LDA.B #$76                                ; Tile used by the middle of Yoshi's tongue.
    BCS +
    LDA.B #$66                                ; Tile used by the end of Yoshi's tongue.
  + STA.W OAMTileNo,Y
    LDA.B _7
    LSR A
    LDA.B #$09                                ; Base YXPPCCCT properties for Yoshi's tongue.
    BCS +
    ORA.B #!OBJ_XFlip                         ; Set YXPPCCCT.
  + ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00                                ; Set size (8x8).
    STA.W OAMTileSize,Y
    PLY
    INY
    INY
    INY                                       ; Move to next tile.
    INY
    DEC.B _6
    BPL CODE_01F46A
Return01F4B1:
    RTS

CODE_01F4B2:
; Note: this routine is intended to be run after the GFX routine. Interaction will mess up if it doesn't! (hence why offscreen messes)
; Yoshi's tongue interaction routine.
    LDA.W SpriteMisc160E,X                    ; Branch if nothing is currently on his tongue.
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
  + SEC                                       ; Attach the sprite horizontally to Yoshi's tongue.
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
  + STZ.B _1                                  ; Attach the sprite vertically to Yoshi's tongue.
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
    STA.W SpriteYSpeed,Y                      ; Clear sprite X/Y speed.
    STA.W SpriteXSpeed,Y
    INC A                                     ; Set flag to disable further interaction.
    STA.W SpriteOnYoshiTongue,Y
    RTS

CODE_01F524:
    PHY                                       ; Currently no sprite on Yoshi's tongue.
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
  + CLC                                       ; Set interaction point X position.
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
    ADC.B SpriteYPosLow,X                     ; Set interaction point Y position.
    STA.B _1
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _9
    LDA.B #$08
    STA.B _2                                  ; Set interaction width/height.
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
    CMP.B #$08                                ; |; Loop through all sprite slots and
    BCC +                                     ; /; see if Yoshi's tongue is touching an edible one.
    LDA.W SpriteBehindScene,Y                 ; \ Skip sprite if behind scenery
    BNE +                                     ; /
    PHY
    JSR TryEatSprite
    PLY
  + DEY
    BPL CODE_01F568
    JSL CODE_02B9FA                           ; Try berry interaction.
    RTS

TryEatSprite:
    PHX                                       ; Subroutine to attach a sprite to Yoshi's tongue if applicable.
    TYX
    JSL GetSpriteClippingA
    PLX                                       ; Return if not in contact.
    JSL CheckForContact
    BCC Return01F609
    LDA.W SpriteTweakerE,Y                    ; \ If sprite inedible
    LSR A                                     ; |; Return if not edible.
    BCC +                                     ; |
    LDA.B #!SFX_BONK                          ; | Play sound effect; SFX for tonguing a sprite Yoshi can't eat.
    STA.W SPCIO0                              ; |
    RTS                                       ; / Return

  + LDA.W SpriteNumber,Y                      ; \ Branch if sprite being eaten not Pokey; Sprite is edible and in contact.
    CMP.B #$70                                ; |; Branch if not sprite 70 (Pokey).
    BNE CODE_01F5FB                           ; /
    STY.W TileGenerateTrackA                  ; $185E = Index of sprite being eaten
    LDA.B _1
    SEC
    SBC.W SpriteYPosLow,Y
    CLC                                       ; Remove the Pokey segment that Yoshi's tongue is touching.
    ADC.B #$00
    PHX
    TYX                                       ; X = Index of sprite being eaten
    JSL RemovePokeySegment
    PLX
    JSL FindFreeSprSlot                       ; \ Return if no free slots; If no sprite slots are available, don't spawn anything. (...which results in a glitch, gg)
    BMI Return01F609                          ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$70                                ; \ Sprite = Pokey; Sprite Yoshi grabs when eating a Pokey.
    STA.W SpriteNumber,Y                      ; /
    LDA.B _0
    STA.W SpriteXPosLow,Y
    LDA.B _8                                  ; Spawn a new Pokey on Yoshi's tongue.
    STA.W SpriteXPosHigh,Y                    ; Note: YXPPCCCT comes from tweaker bytes, unlike how the Pokey normally gets it!
    LDA.B _1
    STA.W SpriteYPosLow,Y
    LDA.B _9
    STA.W SpriteYPosHigh,Y
    PHX
    TYX                                       ; X = Index of new sprite
    JSL InitSpriteTables                      ; Reset sprite tables
    LDX.W TileGenerateTrackA                  ; X = Index of sprite being eaten
    LDA.B SpriteTableC2,X                     ; Set some value for the Pokey segment?
    AND.B _D
    STA.W SpriteTableC2,Y                     ; y = index of new sptr here??
    LDA.B #$01                                ; Mark as a segment.
    STA.W SpriteMisc1534,Y
    PLX
CODE_01F5FB:
; Not specifically Pokey.
    TYA                                       ; \ $160E,x = Index of sprite being eaten; Store slot on Yoshi's tongue.
    STA.W SpriteMisc160E,X                    ; /
    LDA.B #$02
    STA.W SpriteMisc1594,X                    ; Change tongue state to retracting.
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
; X offsets of Yoshi's tongue from Yoshi's head, indexed by animation frame.
; Left
; Right
; Y offsets of Yoshi's tongue from Yoshi's head, indexed by animation frame.
    LDA.W SpriteMisc163E,X                    ; Yoshi-Sprite interaction routine.
    ORA.B SpriteLock                          ; Return if game frozen or sprite contact is disabled.
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
    LDA.W SpriteStatus,Y                      ; Skip the slot if:
    CMP.B #$08                                ; Not time to process (even slots on even frames, odd slots on odd frames)
    BCC +                                     ; It's on Yoshi's tongue.
    LDA.W SpriteNumber,Y                      ; It's literally Yoshi.
    LDA.W SpriteStatus,Y                      ; It's dying.
    CMP.B #$09                                ; It's carryable.
    BEQ +                                     ; It's invincible to star/cape/fire ($167A bit 1).
    LDA.W SpriteTweakerD,Y                    ; It has Yoshi interaction disabled (e.g. already on tongue).
    AND.B #$02                                ; It's on the wrong layer.
    ORA.W SpriteOnYoshiTongue,Y
    ORA.W SpriteBehindScene,Y                 ; For anything else, process interaction.
    BNE +
    JSR CODE_01F668
  + LDY.W SpriteInterIndex
    DEY
    BPL CODE_01F62B
Return01F667:
    RTS

CODE_01F668:
    PHX                                       ; Processing Yoshi-sprite interaction.
    TYX
    JSL GetSpriteClippingB
    PLX
    JSL GetSpriteClippingA                    ; Return if sprites are not in contact.
    JSL CheckForContact
    BCC Return01F667
    LDA.W SpriteNumber,Y
    CMP.B #$9D
    BEQ Return01F667
    CMP.B #$15                                ; Return if sprite 9D (Bubble).
    BEQ CODE_01F69E
    CMP.B #$16                                ; Kick-kill the sprite if it is a:
    BEQ CODE_01F69E                           ; Fish not in water.
    CMP.B #$04                                ; Shell-less non-blue Koopa sliding out of shell.
    BCS CODE_01F6A3
    CMP.B #$02                                ; If anything else, branch to check whether Yoshi should be hurt.
    BEQ CODE_01F6A3
    LDA.W SpriteMisc163E,Y
    BPL CODE_01F6A3
  - PHY                                       ; Sprite is in a kickable state.
    PHX
    TYX
    JSR CODE_01B12A                           ; Kick-kill the sprite.
    PLX
    PLY
    RTS

CODE_01F69E:
; Sprite is a fish.
    LDA.W SpriteInLiquid,Y                    ; If not in water, kick-kill it.
    BEQ -
CODE_01F6A3:
    LDA.W SpriteNumber,Y                      ; Sprite is not kickable.
    CMP.B #$BF
    BNE CODE_01F6B4                           ; Return if sprite BF (Mega Mole)
    LDA.B PlayerYPosNext                      ; and too far to the right.
    SEC                                       ; (basically, this is accounting for 32x32)
    SBC.W SpriteYPosLow,Y
    CMP.B #$E8
    BMI Return01F6DC
CODE_01F6B4:
    LDA.W SpriteNumber,Y
    CMP.B #$7E                                ; Branch if not sprite 7E (wings).
    BNE CODE_01F6DD
    LDA.W SpriteTableC2,Y                     ; Return if in flying red coin form.
    BEQ Return01F6DC
    CMP.B #$02
    BNE CODE_01F6CD
    LDA.B #$08                                ; Warp to Yoshi Wings game.
    STA.B PlayerAnimation
    LDA.B #!SFX_VINEBLOCK                     ; \ Play sound effect; SFX for collecting wings, when touched.
    STA.W SPCIO3                              ; /
CODE_01F6CD:
    LDA.B #$40                                ; (useless)
    STA.W YoshiWingGrabTimer
    LDA.B #$02                                ; \ Set Yoshi wing ability; Give Yoshi wings.
    STA.W YoshiHasWingsEvt                    ; /
    LDA.B #$00                                ; Erase sprite.
    STA.W SpriteStatus,Y
Return01F6DC:
    RTS

CODE_01F6DD:
    CMP.B #$4E                                ; Not wings.
    BEQ CODE_01F6E5
    CMP.B #$4D
    BNE CODE_01F6EC                           ; Return if touching either sprite 4D or sprite 4E (Monty Moles)
CODE_01F6E5:
    LDA.W SpriteTableC2,Y                     ; while they're still in the ground.
    CMP.B #$02
    BCC Return01F6DC
CODE_01F6EC:
    LDA.B _5
    CLC                                       ; Return if the sprite is below Yoshi's 'lower body', i.e. Mario is mostly above the enemy.
    ADC.B #$0D                                ; (mainly meant to reduce risk of being damaged while jumping over an enemy)
    CMP.B _1
    BMI Return01F74B
    LDA.W SpriteStatus,Y
    CMP.B #$0A
    BNE CODE_01F70E
    PHX
    TYX
    JSR SubHorizPos                           ; If the sprite is in a thrown state,
    STY.B _0                                  ; return if it's moving away from Yoshi.
    LDA.B SpriteXSpeed,X                      ; (to prevent spit shells from hurting him)
    PLX
    ASL A
    ROL A
    AND.B #$01
    CMP.B _0
    BNE Return01F74B
CODE_01F70E:
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star; Return if Mario has star power.
    BNE Return01F74B                          ; /
    LDA.B #$10                                ; Briefly disable sprite contact.
    STA.W SpriteMisc163E,X
    LDA.B #!SFX_YOSHIDRUMOFF                  ; \ Play sound effect; Turn off Yoshi drums.
    STA.W SPCIO1                              ; /
    LDA.B #!SFX_YOSHIHURT                     ; \ Play sound effect; SFX for losing Yoshi.
    STA.W SPCIO3                              ; /
    LDA.B #$02
    STA.B SpriteTableC2,X                     ; Send Yoshi running.
    STZ.W PlayerRidingYoshi
    LDA.B #$C0                                ; Y speed to give Mario when knocked off Yoshi by a standard sprite.
    STA.B PlayerYSpeed+1
    STZ.B PlayerXSpeed+1
    JSR SubHorizPos
    LDA.W DATA_01EBBE,Y                       ; Make Yoshi run away from Mario.
    STA.B SpriteXSpeed,X
    STZ.W SpriteMisc1594,X
    STZ.W SpriteMisc151C,X                    ; Clear tongue-related addresses.
    STZ.W YoshiStartEatTimer
    STZ.W CarryYoshiThruLvls                  ; Don't let Mario carry Yoshi to the next level.
    LDA.B #$30                                ; \ Mario invincible timer = #$30; How long to make Mario invincible after being knocked off Yoshi.
    STA.W IFrameTimer                         ; /
    JSR CODE_01EDCC                           ; Offset Mario vertically from Yoshi.
Return01F74B:
    RTS

CODE_01F74C:
; Subroutine for intiating the Yoshi's egg hatching.
    LDA.B #$08                                ; \ Sprite status = Normal; Return the egg to normal status.
    STA.W SpriteStatus,X                      ; /
CODE_01F751:
    LDA.B #$20                                ; Set the timer for the Yoshi egg hatching animation.
    STA.W SpriteMisc1540,X
    LDA.B #!SFX_EGGHATCH                      ; \ Play sound effect; SFX for the Yoshi egg hatching.
    STA.W SPCIO3                              ; /
    RTL


DATA_01F75C:
    db $00,$01,$01,$01

YoshiEggTiles:
    db $62,$02,$02,$00

YoshiEgg:
; GFX pages for each of the tiles in the Yoshi egg's hatching animation.
; Tile numbers for each frame in the Yoshi egg's hatching animation.
; Yoshi egg misc RAM:
; $151C - Sprite ID of the sprite contained inside (2D or 78).
; $1540 - Timer for the hatching animation.
; $187B - Flag to prevent immediate hatching; if set, waits until Mario gets close.
; Yoshi egg MAIN
    LDA.W SpriteMisc187B,X                    ; Branch if currently hatching.
    BEQ CODE_01F799
    JSR IsSprOffScreen                        ; Skip checking whether to hatch when offscreen (doesn't actually fix screen wrapping, though...).
    BNE CODE_01F78D
    JSR SubHorizPos
    LDA.B _F
    CLC
    ADC.B #$20                                ; If Mario is within two tiles horizontally, start hatching.
    CMP.B #$40
    BCS CODE_01F78D
    STZ.W SpriteMisc187B,X
    JSL CODE_01F751
    LDA.B #$2D                                ; Sprite that spawns out of colored Yoshi eggs (Baby Yoshi).
    LDY.W YoshiIsLoose
    BEQ +
    LDA.B #$78                                ; Sprite that spawns out of colored Yoshi eggs when Mario has a Yoshi (1up).
  + STA.W SpriteMisc151C,X
CODE_01F78D:
    JSR SubSprGfx2Entry1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$00                                ; Tile to use for the Yoshi egg.
    STA.W OAMTileNo+$100,Y
    RTS

CODE_01F799:
; Egg is hatching.
    LDA.W SpriteMisc1540,X                    ; Branch if fully hatched.
    BEQ +
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W YoshiEggTiles,Y
    PHA
    LDA.W DATA_01F75C,Y                       ; Handle the hatching animation.
    PHA
    JSR SubSprGfx2Entry1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PLA
    STA.B _0
    LDA.W OAMTileAttr+$100,Y
    AND.B #$FE                                ; Set tilemap page based on the current frame of animation.
    ORA.B _0
    STA.W OAMTileAttr+$100,Y
    PLA                                       ; Set tile number.
    STA.W OAMTileNo+$100,Y
    RTS

; Fully hatched.
  + JSR CODE_01F7C8                           ; Spawn the egg shards.
    JMP CODE_01F83D

CODE_01F7C8:
; Subroutine to spawn the Yoshi egg shards after hatching.
    JSR IsSprOffScreen                        ; Return if offscreen.
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
    DEX                                       ; Find an empty minor extended sprite slot,
    BPL CODE_01F7DF                           ; or overwrite on if none are found.
    DEC.W MinExtSpriteSlotIdx
    BPL +
    LDA.B #$0B
    STA.W MinExtSpriteSlotIdx
  + LDX.W MinExtSpriteSlotIdx
CODE_01F7F4:
    LDA.B #$03                                ; Set minor extended sprite number.
    STA.W MinExtSpriteNumber,X
    LDA.B _0
    CLC
    ADC.W DATA_01F831,Y
    STA.W MinExtSpriteXPosLow,X
    LDA.B _2                                  ; Set X/Y position for the shard, offset from the egg's original position.
    CLC
    ADC.W DATA_01F82D,Y
    STA.W MinExtSpriteYPosLow,X
    LDA.B _3
    STA.W MinExtSpriteYPosHigh,X
    LDA.W DATA_01F835,Y
    STA.W MinExtSpriteYSpeed,X                ; Set initial X/Y speed.
    LDA.W DATA_01F839,Y
    STA.W MinExtSpriteXSpeed,X
    TYA
    ASL A
    ASL A
    ASL A                                     ; Set X/Y flip and timer for each shard.
    ASL A
    ASL A
    ASL A
    ORA.B #$28                                ; How long each shard stays active for.
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
; Y position offsets for each of the Yoshi egg's shards.
; X position offsets for each of the Yoshi egg's shards.
; Y speeds for each of the Yoshi egg's shards.
; X speeds for each of the YOshi egg's shards.
; Subroutine to spawn the baby Yoshi / 1up from a Yoshi egg.
    LDA.W SpriteMisc151C,X                    ; Set sprite number.
    STA.B SpriteNumber,X
    CMP.B #$35                                ; Branch if spawning an adult Yoshi (from a ? block).
    BEQ CODE_01F86C
    CMP.B #$2D                                ; Branch if spawning a 1up (or any other sprite besides Baby Yoshi).
    BNE +
    LDA.B #$09                                ; \ Sprite status = Carryable; Set sprite status (09 - carryable).
    STA.W SpriteStatus,X                      ; /
    LDA.W SpriteOBJAttribute,X
    AND.B #$0E
    PHA
    JSL InitSpriteTables
    PLA                                       ; Initialize and set YXPPCCCT for the baby Yoshi.
    STA.B _0
    LDA.W SpriteOBJAttribute,X
    AND.B #$F1
    ORA.B _0
    STA.W SpriteOBJAttribute,X
    RTS

  + JSL InitSpriteTables                      ; Spawning a 1up: just initialize the sprite.
    RTS

CODE_01F86C:
    JSL InitSpriteTables                      ; Spawning a Yoshi: run animation.
    JMP CODE_01A2B5                           ; Run hatching aniamtion.


    db $08,$F8

UnusedInit:
; Unused table.
    JSR FaceMario                             ; Unused sprite INIT.
    STA.W SpriteMisc1534,X
Return01F87B:
    RTS

InitEerie:
    JSR SubHorizPos                           ; Eerie INIT.
    LDA.W EerieSpeedX,Y                       ; Set initial X speed towards Mario.
    STA.B SpriteXSpeed,X
InitBigBoo:
; Big Boo INIT.
    JSL GetRand                               ; Initialize animation timer.
    STA.W SpriteMisc1570,X
    RTS


EerieSpeedX:
    db $10,$F0

EerieSpeedY:
    db $18,$E8

Eerie:
; X speeds for Eeries.
; Max Y speeds for Eeries.
; Eerie misc RAM:
; $C2   - Direction of vertical acceleration for the wave Eerie. Even = down, odd = up.
; $1570 - Frame counter for animation.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame. 0/1 = normal.
    LDA.W SpriteStatus,X                      ; Eerie MAIN.
    CMP.B #$08
    BNE CODE_01F8C9                           ; Branch if game frozen or not in a normal state.
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01F8C9                           ; /
    JSR SubSprXPosNoGrvty                     ; Update X position.
    LDA.B SpriteNumber,X
    CMP.B #$39                                ; Branch if not sprite 39 (wave Eerie).
    BNE CODE_01F8C0
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_01EBB4,Y                       ; Alternate vertical acceleration, to create the wave motion.
    STA.B SpriteYSpeed,X
    CMP.W EerieSpeedY,Y
    BNE +
    INC.B SpriteTableC2,X
  + JSR SubSprYPosNoGrvty
    JSR SubOffscreen3Bnk1                     ; Process offscreen from -$70 to +$60.
    BRA +

CODE_01F8C0:
; Straight-line Eerie.
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
; Both Eeries reconvene here.
  + JSR MarioSprInteractRt                    ; Process interaction with Mario.
    JSR SetAnimationFrame                     ; Use a 2-frame animation.
CODE_01F8C9:
; Game frozen, just draw GFX.
    JSR UpdateDirection                       ; Set direction based on X speed.
    JMP SubSprGfx2Entry1                      ; Draw a 16x16.


DATA_01F8CF:
    db $08,$F8

DATA_01F8D1:
    db $01,$02,$02,$01

BigBoo:
; Max X/Y speeds for the Boo / Boo Block / Big Boo.
; Turning animation frames for the Big Boo.
; Big Boo / Boo / Boo Block misc RAM:
; $C2   - Flag for stationary (1) or following Mario (0).
; $1540 - Timer until the next check of whether Mario is facing the Boo.
; $1558 - Timer for the Big Boo's 'peeking' animation, and normal Boo's 'tongue waggle' animation. Block Boos also set this, but don't use it.
; $1570 - Frame timer for animation. Used to wait until showing the Boo's 'tongue waggle' or Big Boo's 'peeking' animations.
; $157C - Horizontal direction the Boo is facing.
; $15AC - Timer for turning the Boo around. Set to #$1F when starting.
; $1602 - Animation frame.
; Boo: 0 = moving, 2/3 = tongue waggle, 6 = stationary
; Boo Block: 0 = moving, 1 = semi-block, 2 = block
; Big Boo: 0 = moving, 1/2 = turning, 3 = stationary (eyes covered)
; $18B6 - Used temporarily as the height of the sprite, for deciding which way to accelerate vertically towards Mario.
; Big Boo MAIN
    JSR SubOffscreen1Bnk1                     ; Process offscreen from -$40 to +$A0.
    LDA.B #$20
    BRA +

Boo_BooBlock:
; Boo MAIN, Boo Block MAIN (also shared with the Big Boo)
    JSR SubOffscreen0Bnk1                     ; Process offscreen from -$40 to +$30.
    LDA.B #$10
  + STA.W TileGenerateTrackB
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE CODE_01F8EF
    LDA.B SpriteLock                          ; If sprites are locked or not in a normal state, just draw graphics and interaction.
    BEQ +
CODE_01F8EF:
    JMP CODE_01F9CE

  + JSR SubHorizPos                           ; Game not frozen / sprite is alive.
    LDA.W SpriteMisc1540,X
    BNE CODE_01F914                           ; Set timer until next check for whether Mario is facing the Boo.
    LDA.B #$20
    STA.W SpriteMisc1540,X
    LDA.B SpriteTableC2,X
    BEQ CODE_01F90C
    LDA.B _F
    CLC                                       ; If the Boo is too close to Mario, don't start moving toward him.
    ADC.B #$0A
    CMP.B #$14
    BCC CODE_01F92F
CODE_01F90C:
    STZ.B SpriteTableC2,X
    CPY.B PlayerDirection                     ; If Mario is facing away from the sprite, start moving towards him.
    BNE CODE_01F914
    INC.B SpriteTableC2,X
CODE_01F914:
    LDA.B _F
    CLC
    ADC.B #$0A
    CMP.B #$14
    BCC CODE_01F92F
    LDA.W SpriteMisc15AC,X                    ; Branch if the Boo needs to turn around.
    BNE CODE_01F971
    TYA
    CMP.W SpriteMisc157C,X
    BEQ CODE_01F92F
    LDA.B #$1F                                ; \ Set turning timer; Set timer for turning the Boo around.
    STA.W SpriteMisc15AC,X                    ; /
    BRA CODE_01F971

CODE_01F92F:
    STZ.W SpriteMisc1602,X                    ; Boo is not turning.
    LDA.B SpriteTableC2,X                     ; Branch if the Boo is moving.
    BEQ CODE_01F989
    LDA.B #$03                                ; Stationary animation frame for the Big Boo.
    STA.W SpriteMisc1602,X
    LDY.B SpriteNumber,X
    CPY.B #$28
    BEQ +
    LDA.B #$00
    CPY.B #$AF                                ; Get animation rate. Boo Block uses every frame, Boo / Big Boo use every two.
    BEQ +                                     ; If not time to change frame, skip down.
    INC A
  + AND.B TrueFrame
    BNE CODE_01F96F
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    BNE +                                     ; If the animation timer hits 0, set the timer for the Boo's special animation (peeking/tongue waggle).
    LDA.B #$20
    STA.W SpriteMisc1558,X
  + LDA.B SpriteXSpeed,X
    BEQ CODE_01F962
    BPL +
    INC A
    INC A                                     ; Decelerate horizontally.
  + DEC A
CODE_01F962:
    STA.B SpriteXSpeed,X
    LDA.B SpriteYSpeed,X
    BEQ CODE_01F96D
    BPL +
    INC A
    INC A                                     ; Decelerate vertically.
  + DEC A
CODE_01F96D:
    STA.B SpriteYSpeed,X
CODE_01F96F:
    BRA CODE_01F9C8

CODE_01F971:
    CMP.B #$10                                ; Boo is turning.
    BNE +
    PHA
    LDA.W SpriteMisc157C,X                    ; Flip facing direction when the turn timer gets low enough.
    EOR.B #$01
    STA.W SpriteMisc157C,X
    PLA
  + LSR A
    LSR A
    LSR A                                     ; Set turning animation frame (for the Big Boo).
    TAY
    LDA.W DATA_01F8D1,Y
    STA.W SpriteMisc1602,X
CODE_01F989:
    STZ.W SpriteMisc1570,X                    ; Boo is moving.
    LDA.B TrueFrame
    AND.B #$07                                ; Branch if not a frame for accelerating towards Mario.
    BNE CODE_01F9C8
    JSR SubHorizPos
    LDA.B SpriteXSpeed,X
    CMP.W DATA_01F8CF,Y
    BEQ +                                     ; Accelerate horizontally towards Mario.
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
    JSR CODE_01AD42                           ; Accelerate vertically towards Mario.
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
; Boo's code reconvenes.
    JSR SubSprXPosNoGrvty                     ; Update X/Y position.
    JSR SubSprYPosNoGrvty
CODE_01F9CE:
    LDA.B SpriteNumber,X
    CMP.B #$AF                                ; Branch if not the Boo Block.
    BNE CODE_01FA3D
    LDA.B SpriteXSpeed,X
    BPL +
    EOR.B #$FF                                ; Branch if moving faster than #$08 (i.e. not in block form).
    INC A
  + LDY.B #$00                                ; Animation frame for the Boo Block when non-solid (0).
    CMP.B #$08
    BCS CODE_01FA09
    PHA
    LDA.W SpriteTweakerB,X
    PHA
    LDA.W SpriteTweakerD,X
    PHA
    ORA.B #$80
    STA.W SpriteTweakerD,X                    ; Act like a solid block.
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
    BCS +                                     ; Set animation frame for the block (semi-solid = 1, solid = 2).
    INY
    BRA +

CODE_01FA09:
    LDA.W SpriteStatus,X                      ; Non-solid Boo block.
    CMP.B #$08
    BNE +                                     ; Interact with Mario.
    PHY
    JSR MarioSprInteractRt
    PLY
  + TYA                                       ; Set animation frame.
    STA.W SpriteMisc1602,X
    JSR SubSprGfx2Entry1
    LDA.W SpriteMisc1602,X
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    TAX
    LDA.W BooBlockTiles,X                     ; Draw a 16x16 sprite.
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
; Tile numbers for the Boo Block's frames.
; YXPPCCCT for the Boo Block's frames.
    LDA.W SpriteStatus,X                      ; Not the Boo Block (i.e. normal Boo or Big Boo).
    CMP.B #$08                                ; Interact with Mario.
    BNE +
    JSR MarioSprInteractRt
  + JSL CODE_038398                           ; Draw GFX.
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
; X flip values for Iggy's ball.
; Tile numbers for Iggy's ball.
; YXPPCCCT for Iggy's ball.
; X speeds for Iggy's ball.
; Iggy's ball misc RAM:
; $157C - Horizontal direction the sprite is facing.
; Iggy's ball MAIN.
    JSR SubSprGfx2Entry1                      ; Set up a 16x16.
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01FA4C,Y                       ; Get X flip based on direction.
    STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03                                ; Animate the ball's tile.
    PHX
    TAX
    LDA.W IggyBallTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_01FA52,X
    EOR.B _0                                  ; Set YXPCCCT for the ball.
    STA.W OAMTileAttr+$100,Y
    PLX
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if game frozen.
    BNE Return01FAB3                          ; /
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01FA56,Y                       ; Set X speed.
    STA.B SpriteXSpeed,X
    JSR SubSprXPosNoGrvty                     ; Update X/Y position.
    JSR SubSprYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +                                     ; Accelerate downwards.
    CLC
    ADC.B #$04                                ; Gravity for Iggy's balls.
    STA.B SpriteYSpeed,X
  + JSR CODE_01FF98
    BCC +                                     ; If hitting Iggy's platform, bounce upwards.
    LDA.B #$F0                                ; Bounce Y speed for Iggy's balls.
    STA.B SpriteYSpeed,X
  + JSR MarioSprInteractRt                    ; Interact with Mario.
    LDA.B SpriteYPosLow,X
    CMP.B #$44
    BCC Return01FAB3                          ; Erase in a cloud of smoke if it falls in the lava.
    CMP.B #$50
    BCS Return01FAB3
    JSR CODE_019ACB
Return01FAB3:
    RTS


    db $FF,$01,$00,$80,$60,$A0,$40,$D0
    db $D8,$C0,$C8,$0C,$F4

KoopaKid:
; Unused?
    LDA.B SpriteTableC2,X                     ; Koopa Kid MAIN.
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
; Pointers to routines for the different Koopa Kids.
; Unused?...
; X speeds for Iggy/Larry during their hurt animation slide, indexed by the steepness of the platform.
; Animation frames for Iggy/Larry's 'walking' animation.
; Iggy/Larry misc RAM:
; $C2   - Which boss the sprite is. 3 = Iggy, 4 = Larry.
; $1534 - Frame counter for Iggy's attacks. Throws a ball when this is 00 or 80.
; $154C - Timer for the hurt animation. Set to #$18 when bounced on, and #$10 when fireballed.
; $1558 - Timer for disabling interaction with Mario. Set to #$08 after touching the boss.
; $1564 - Timer for Iggy's ball throw animation.
; $1570 - Frame counter for animation.
; $157C - Horizontal direction the sprite is facing.
; $15AC - Timer for turning.
; $1602 - Animation frame. 0/1/2 = walking, 3 = hurt, 4/5/7/8/9/A/B = throwing, 6 = turning
; $160E - Flag for not being on the platform (i.e., falling into the lava).
; $163E - Timer for sinking in lava. Set to #$50 when the boss lands in it.
    LDA.B SpriteLock                          ; Iggy/Larry MAIN.
    ORA.W SpriteMisc154C,X                    ; If game not frozen and boss not hurt...
    BNE +
    JSR SubHorizPos
    STY.B _0
    LDA.B Mode7Angle
    ASL A                                     ; ...and Mario is above a lower portion of the platform...
    ROL A                                     ; (i.e. Iggy is aiming downwards)
    AND.B #$01
    CMP.B _0
    BNE +
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X                    ; ...and Iggy's attack timer is #$00 or #$80...
    AND.B #$7F
    BNE +
    LDA.B #$7F                                ; \ Set time to go in shell; Set timer to throw a ball.
    STA.W SpriteMisc1564,X                    ; /
  + STZ.W SpriteOffscreenX,X
    LDA.W SpriteMisc163E,X                    ; Branch if the boss is not in lava.
    BEQ CODE_01FB36
    DEC A                                     ; Return if the boss isn't done sinking in lava.
    BNE +
    INC.W CutsceneID
    LDA.B #$FF                                ; End the level.
    STA.W EndLevelTimer
    LDA.B #!BGM_BOSSCLEAR                     ; SFX (music) played after Iggy/Larry is defeated.
    STA.W SPCIO2                              ; / Change music
    STZ.W SpriteStatus,X                      ; Erase the boss.
  + RTS

CODE_01FB36:
    JSL LoadTweakerBytes                      ; Boss is not dying/dead.
    LDA.B SpriteLock
    BEQ +                                     ; If game frozen, skip movement.
    JMP CODE_01FC08

  + LDA.W SpriteMisc160E,X                    ; Branch if still on the platform (i.e., not falling).
    BEQ CODE_01FB7B
    JSR SubSprXPosNoGrvty                     ; Update X/Y position.
    JSR SubSprYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +                                     ; Apply gravity.
    INC.B SpriteYSpeed,X
    INC.B SpriteYSpeed,X
  + LDA.B SpriteYPosLow,X
    CMP.B #$58
    BCC +                                     ; Once the boss falls into the lava, set its sinking timer and erase other sprites.
    CMP.B #$80
    BCS +
    LDA.B #!SFX_BOSSINLAVA                    ; \ Play sound effect; SFX for Iggy/Larry falling in lava.
    STA.W SPCIO3                              ; /
    LDA.B #$50                                ; How long the boss takes to sink in the lava.
    STA.W SpriteMisc163E,X
    JSL KillMostSprites                       ; Kill all sprites
  + LDA.B SpriteXPosLow,X
    STA.W IggyLarryTempXPos
    LDA.B SpriteYPosLow,X
    STA.W IggyLarryTempYPos
    JMP CODE_01FC0E

CODE_01FB7B:
; Boss is on the platform.
    JSR SubSprXPosNoGrvty                     ; Update X position.
    LDA.B TrueFrame
    AND.B #$1F
    ORA.W SpriteMisc1564,X
    BNE +
    LDA.W SpriteMisc157C,X
    PHA                                       ; If not throwing a ball, check whether Iggy should turn towards Mario.
    JSR FaceMario
    PLA
    CMP.W SpriteMisc157C,X
    BEQ +
    LDA.B #$10
    STA.W SpriteMisc15AC,X
  + STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Clear X/Y speed for current frame.
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.B Mode7Angle
    BPL +
    CLC
    ADC.B #$08
  + LSR A
    LSR A                                     ; Stores a value representing the steepness of the platform in $00,
    LSR A                                     ; and inverted steepness (for tilting left) in $01.
    LSR A
    TAY
    STY.B _0
    EOR.B #$FF
    INC A
    AND.B #$0F
    STA.B _1
    LDA.W SpriteMisc154C,X                    ; Branch if the boss is currently in its hurt animation.
    BNE CODE_01FBD9
    LDA.B Mode7Angle+1                        ; Branch if the platform is tilted leftwards (not rightwards).
    BNE CODE_01FBC9
    LDA.B SpriteXPosLow,X
    CMP.B #$78
    BCC CODE_01FBC5
    LDA.B #$FF                                ; Get an X speed so that the boss moves towards the center of the platform.
    BRA CODE_01FBEE

CODE_01FBC5:
    LDA.B #$01
    BRA CODE_01FBEE

CODE_01FBC9:
    LDY.B _1                                  ; Platform is tilted left.
    LDA.B SpriteXPosLow,X
    CMP.B #$78
    BCS CODE_01FBD5
    LDA.B #$01                                ; ...Also get an X speed so that the boss moves towards the center.
    BRA CODE_01FBEE

CODE_01FBD5:
    LDA.B #$FF
    BRA CODE_01FBEE

CODE_01FBD9:
    LDA.B Mode7Angle+1                        ; Boss is in its hurt animation.
    BNE CODE_01FBE7
    LDY.B _0
    LDA.W DATA_01FADD,Y
    EOR.B #$FF
    INC A                                     ; Get an X speed to slide the boss with, based on the current steepness of the platform.
    BRA +

CODE_01FBE7:
    LDY.B _1
    LDA.W DATA_01FADD,Y
  + ASL A
    ASL A
CODE_01FBEE:
    STA.B SpriteXSpeed,X                      ; X speed is done.
    INC.W SpriteMisc1570,X
    LDA.B SpriteXSpeed,X                      ; Increase animation timer.
    BEQ +                                     ; This actually always increases by 2 each frame, since the boss's X speed is never exactly 0.
    INC.W SpriteMisc1570,X
  + LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    AND.B #$0F                                ; Handle the boss's 'walking' animation.
    TAY
    LDA.W DATA_01FAE5,Y
    STA.W SpriteMisc1602,X
CODE_01FC08:
    JSR CODE_01FD50                           ; Get the actual X/Y position of the boss, accounting for the rotation of the platform.
    JSR CODE_01FC62                           ; Handle Mario/fireball contact.
CODE_01FC0E:
    LDA.W SpriteMisc154C,X                    ; Branch if the boss is in its hurt animation.
    BNE CODE_01FC4E
    LDA.W SpriteMisc157C,X
    PHA
    LDY.W SpriteMisc15AC,X
    BEQ CODE_01FC2A
    CPY.B #$08                                ; Handle the turning animation if applicable.
    BCC +
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + LDA.B #$06                                ; Animation frame for turning (6).
    STA.W SpriteMisc1602,X
CODE_01FC2A:
    LDA.W SpriteMisc1564,X
    BEQ +
    PHA
    LSR A
    LSR A
    LSR A
    TAY                                       ; Handle Iggy/Larry's ball-throwing animation if applicable.
    LDA.W DATA_01FD95,Y
    STA.W SpriteMisc1602,X
    PLA
    CMP.B #$28
    BNE +
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    JSR ThrowBall                             ; Throw ball
  + JSR CODE_01FEBC                           ; Draw GFX.
    PLA
    STA.W SpriteMisc157C,X
    RTS

CODE_01FC4E:
    CMP.B #$10                                ; Iggy/Larry is in their hurt animation.
    BCC +
  - LDA.B #$03
    STA.W SpriteMisc1602,X                    ; If in their 'spinning shell' hurt frame, run the special GFX subroutine at $01FF5B.
    JMP CODE_01FEBC                           ; Else, run the normal one at $01FEBC.

  + CMP.B #$08
    BCC -
    JSR CODE_01FF5B
  - RTS

CODE_01FC62:
    LDA.B PlayerAnimation                     ; Subroutine for Iggy/Larry, to handle Mario and fireball interaction.
    CMP.B #$01
    BCS -                                     ; Return if Mario is currently frozen or Iggy/Larry are falling into the lava.
    LDA.W SpriteMisc160E,X
    BNE -
    LDA.B SpriteXPosLow,X
    CMP.B #$20
    BCC CODE_01FC77
    CMP.B #$D8
    BCC +                                     ; If Iggy/Larry just fell off the platform, set the flag for such.
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
    ADC.B #$60                                ; Get clipping information for Iggy.
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
    ADC.B #$10                                ; Get clipping information for Mario.
    STA.B _5
    LDA.B #$0C
    STA.B _6
    LDA.B #$0E
    STA.B _7
    STZ.B _A
    STZ.B _B
    JSL CheckForContact                       ; Branch if not in contact; check fireball contact instead.
    BCC CODE_01FD0A
    LDA.W SpriteMisc1558,X                    ; Return if interaction is disabled.
    BNE Return01FD09
    LDA.B #$08                                ; Disable interaction for a few frames after.
    STA.W SpriteMisc1558,X
    LDA.B PlayerInAir                         ; If Mario is on the ground, branch to hurt him. Else, he just hurt the boss.
    BEQ CODE_01FD05
    LDA.B #!SFX_ENEMYHURT                     ; \ Play sound effect; SFX for hitting Iggy/Larry.
    STA.W SPCIO3                              ; /
    JSL BoostMarioSpeed                       ; Bounce Mario upwards.
    LDA.B SpriteXPosLow,X
    PHA
    LDA.B SpriteYPosLow,X
    PHA
    LDA.W IggyLarryTempXPos
    SEC
    SBC.B #$08
    STA.B SpriteXPosLow,X
    LDA.W IggyLarryTempYPos                   ; Display a contact sprite at the boss's position.
    SEC
    SBC.B #$10
    STA.B SpriteYPosLow,X
    STZ.W SpriteOffscreenX,X
    JSL DisplayContactGfx
    PLA
    STA.B SpriteYPosLow,X
    PLA
    STA.B SpriteXPosLow,X
    LDA.W SpriteMisc154C,X                    ; Return if Iggy/Larry is already sliding.
    BNE Return01FD09
    LDA.B #$18                                ; Length of Iggy/Larry slide when bounced on.
    STA.W SpriteMisc154C,X
    RTS

CODE_01FD05:
    JSL HurtMario                             ; Mario touched Iggy/Larry while on the ground; hurt him.
Return01FD09:
    RTS

CODE_01FD0A:
    LDY.B #$0A                                ; Mario isn't in contact with the boss; check for fireball contact.
CODE_01FD0C:
    STY.W SpriteInterIndex
    LDA.W ExtSpriteNumber,Y                   ; Find an extended sprite slot with a fireball in it.
    CMP.B #$05
    BNE +
    LDA.W ExtSpriteXPosLow,Y
    SEC
    SBC.B Layer1XPos
    STA.B _4
    STZ.B _A
    LDA.W ExtSpriteYPosLow,Y
    SEC                                       ; Get clipping information for the fireball.
    SBC.B Layer1YPos
    STA.B _5
    STZ.B _B
    LDA.B #$08
    STA.B _6
    STA.B _7
    JSL CheckForContact                       ; Branch to next slot if this one isn't in contact with the boss.
    BCC +
    LDA.B #$01                                ; \ Extended sprite = Smoke puff
    STA.W ExtSpriteNumber,Y                   ; /; If it did hit, erase in a cloud of smoke.
    LDA.B #$0F
    STA.W ExtSpriteMisc176F,Y
    LDA.B #!SFX_BONK                          ; \ Play sound effect; SFX for a fireball hitting Iggy/Larry.
    STA.W SPCIO0                              ; /
    LDA.B #$10                                ; Length of Iggy/Larry slide when bounced on.
    STA.W SpriteMisc154C,X
  + DEY
    CPY.B #$07
    BNE CODE_01FD0C
    RTS

CODE_01FD50:
    LDA.B SpriteXPosLow,X                     ; Subroutine for getting Iggy/Larry's position on top of the platform.
    CLC
    ADC.B #$08
    STA.W IggyLarryPlatIntXPos
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W IggyLarryPlatIntXPos+1              ; Set up the interaction point to check.
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
    INC A                                     ; Temporarily invert the platform's angle?
    AND.W #$01FF
    STA.B Mode7Angle
    SEP #$20                                  ; A->8
    PHX
    JSL CODE_01CC9D                           ; Get actual position on the platform.
    PLX
    REP #$20                                  ; A->16
    LDA.B Mode7Angle
    EOR.W #$01FF
    INC A                                     ; Restore the platform's angle.
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
; Animation frames for Iggy/Larry's ball throwing animation
; X offsets from Iggy/Larry to spawn the ball at, based on his direction.
    LDY.B #$05                                ; \ Find an open sprite index; Subroutine for Iggy/Larry to spawn a ball.
CODE_01FDA9:
    LDA.W SpriteStatus,Y                      ; |
    BEQ GenerateBall                          ; |; Find an empty slot in slots #$00-#$05. Return if none found.
    DEY                                       ; |
    BPL CODE_01FDA9                           ; /
    RTS

GenerateBall:
    LDA.B #!SFX_SPIT                          ; \ Play sound effect; SFX for Iggy/Larry throwing a ball.
    STA.W SPCIO0                              ; /
    LDA.B #$08                                ; \ Sprite status = normal
    STA.W SpriteStatus,Y                      ; /; Set sprite number and status.
    LDA.B #$A7                                ; \ Sprite to throw = Ball
    STA.W SpriteNumber,Y                      ; /
    PHX                                       ; \ Before: X must have index of sprite being generated
    TYX                                       ; | Routine clears *all* old sprite values...
    JSL InitSpriteTables                      ; | ...and loads in new values for the 6 main sprite tables; Initialize the sprite.
    PLX                                       ; /
    PHX                                       ; Push Iggy's sprite index
    LDA.W SpriteMisc157C,X                    ; \ Ball's direction = Iggy'direction; Set facing direction to be the same as the boss.
    STA.W SpriteMisc157C,Y                    ; /
    TAX                                       ; X = Ball's direction
    LDA.W IggyLarryTempXPos                    ; \ Set Ball X position
    SEC                                       ; |
    SBC.B #$08                                ; |
    ADC.W BallPositionDispX,X                 ; |
    STA.W SpriteXPosLow,Y                     ; |
    LDA.B #$00                                ; |
    STA.W SpriteXPosHigh,Y                    ; /; Spawn at Iggy/Larry's position.
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
; X position offsets for each of Iggy/Larry's tiles. Left/right refer to the direction the boss is facing.
; 00 - Left - Walking A
; 01 - Left - Walking B
; 02 - Left - Walking C
; 03 - Left - Hurt
; 04 - Left - Ball throw A
; 05 - Left - Ball throw B
; 06 - Left - Turning
; 07 - Left - Ball throw C
; 08 - Left - Ball throw D
; 09 - Left - Ball throw E
; 0A - Left - Ball throw F
; 0B - Left - Ball throw G
; 00 - Right - Walking A
; 01 - Right - Walking B
; 02 - Right - Walking C
; 03 - Right - Hurt
; 04 - Right - Ball throw A
; 05 - Right - Ball throw B
; 06 - Right - Turning
; 07 - Right - Ball throw C
; 08 - Right - Ball throw D
; 09 - Right - Ball throw E
; 0A - Right - Ball throw F
; 0B - Right - Ball throw G
; Y position offsets for each of Iggy/Larry's tiles.
; 00 - Walking A
; 01 - Walking B
; 02 - Walking C
; 03 - Hurt
; 04 - Ball throw A
; 05 - Ball throw B
; 06 - Turning
; 07 - Ball throw C
; 08 - Ball throw D
; 09 - Ball throw E
; 0A - Ball throw F
; 0B - Ball throw G
; Tile numbers for each of Iggy/Larry's tiles.
; 00 - Walking A
; 01 - Walking B
; 02 - Walking C
; 03 - Hurt
; 04 - Ball throw A
; 05 - Ball throw B
; 06 - Turning
; 07 - Ball throw C
; 08 - Ball throw D
; 09 - Ball throw E
; 0A - Ball throw F
; 0B - Ball throw G
; Tiles for Larry's hair.
; Sizes for each of Iggy/Larry's tiles.
; YXPPCCCT values for Iggy/Larry.
; Iggy
; Larry
    LDY.B SpriteTableC2,X                     ; Main GFX subroutine for Iggy/Larry.
    LDA.W DATA_01FEB7,Y                       ; $0D - YXPPCCCT.
    STA.B _D
    STY.B _5
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc157C,X
    LSR A
    ROR A
    LSR A                                     ; $02 - X flip.
    AND.B #$40
    EOR.B #$40
    STA.B _2
    LDA.W SpriteMisc1602,X
    ASL A                                     ; $03 - Animation frame index.
    ASL A
    STA.B _3
    PHX
    LDX.B #$03
CODE_01FEDE:
    PHX
    TXA
    CLC                                       ; Get index to current tile.
    ADC.B _3
    TAX
    PHX
    LDA.B _2
    BEQ +
    TXA
    CLC
    ADC.B #$30
    TAX                                       ; Store X position of the tile.
  + LDA.W IggyLarryTempXPos
    SEC
    SBC.B #$08
    CLC
    ADC.W DATA_01FDF3,X
    STA.W OAMTileXPos+$100,Y
    PLX
    LDA.W IggyLarryTempYPos
    CLC
    ADC.B #$60                                ; Store Y position of the tile.
    CLC
    ADC.W DATA_01FE53,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_01FE83,X                       ; Store the tile number.
    STA.W OAMTileNo+$100,Y
    PHX
    LDX.B _5
    CPX.B #$03
    BNE +
    CMP.B #$05
    BCS +                                     ; Change Larry's hair tiles, to make him look different from Iggy.
    LSR A
    TAX
    LDA.W DATA_01FEB3,X
    STA.W OAMTileNo+$100,Y
  + LDA.W OAMTileNo+$100,Y
    CMP.B #$4A
    LDA.B _D                                  ; Set the YXPPCCCT for the boss.
    BCC +
    LDA.B #$35                                ;  Iggy ball palette; YXPPCCCT for Iggy/Larry's hand, during the ball-throwing animation.
  + ORA.B _2
    STA.W OAMTileAttr+$100,Y
    PLA
    AND.B #$03
    TAX
    PHY
    TYA
    LSR A
    LSR A                                     ; Set the size of the tile.
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
    LDA.B #$03                                ; Draw 4 tiles with a manually set size.
    JSR FinishOAMWriteRt
    RTS


DATA_01FF53:
    db $2C,$2E,$2C,$2E

DATA_01FF57:
    db $00,$00,$40,$00

CODE_01FF5B:
; Tile numbers for the shell's animation.
; Y/X flip for the shell's animation.
    PHX                                       ; GFX subroutine for Iggy/Larry when in their 'spinning shell' frame (while being hurt).
    LDY.B SpriteTableC2,X
    LDA.W DATA_01FEB7,Y                       ; Get the YXPPCCCT for the boss.
    STA.B _D
    LDY.B #$70
    LDA.W IggyLarryTempXPos
    SEC                                       ; Store the X position.
    SBC.B #$08
    STA.W OAMTileXPos+$100,Y
    LDA.W IggyLarryTempYPos
    CLC                                       ; Store the Y position.
    ADC.B #$60
    STA.W OAMTileYPos+$100,Y
    LDA.B EffFrame
    LSR A
    AND.B #$03                                ; Store the tile number.
    TAX
    LDA.W DATA_01FF53,X
    STA.W OAMTileNo+$100,Y
    LDA.B #$30
    ORA.W DATA_01FF57,X                       ; Store YXPPCCCT.
    ORA.B _D
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A                                     ; Set size as a 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLX
    RTS

CODE_01FF98:
    LDA.B SpriteXPosLow,X                     ; \ $14B4,$14B5 = Sprite X position + #$08; Subroutine to handle interaction for Iggy's balls with his platform. Returns carry set if so.
    CLC                                       ; |
    ADC.B #$08                                ; |
    STA.W IggyLarryPlatIntXPos                ; |
    LDA.W SpriteXPosHigh,X                    ; |
    ADC.B #$00                                ; |
    STA.W IggyLarryPlatIntXPos+1              ; /; Set up $14B4-$14B7 with the ball's position.
    LDA.B SpriteYPosLow,X                     ; \ $14B6,$14B7 = Sprite Y position + #$0F
    CLC                                       ; |
    ADC.B #$0F                                ; |
    STA.W IggyLarryPlatIntYPos                ; |
    LDA.W SpriteYPosHigh,X                    ; |
    ADC.B #$00                                ; |
    STA.W IggyLarryPlatIntYPos+1              ; /
    PHX
    JSL CODE_01CC9D                           ; Check for contact with the platform.
    PLX
    RTS

    %insert_empty($3E,$41,$41,$41,$41)
