; checks if the level mode is a vertical level
function isverticallevel(m) = or(equal(m,3),or(equal(m,4),or(equal(m,7),or(equal(m,8),or(equal(m,10),equal(m,13))))))

; gets the tileset from the fg/bg graphics setting
function tileset(s) = select(or(equal(s,0),or(equal(s,7),or(equal(s,12),equal(s,15)))),0,select(equal(s,1),1,select(or(equal(s,2),or(equal(s,6),equal(s,8))),2,select(or(equal(s,4),or(equal(s,5),equal(s,13))),4,3))))

!__screen = 0
!__newscreen = 0
!__vertical = 0
!__tileset = 0

; go to the coordinates (x,y) in the level
; by either setting the new screen flag, inserting a
; screen jump object, or doing nothing
macro L_GoTo(x, y)
    if !__vertical
        if or(greaterequal(<y>,$200),greaterequal(<x>,$20))
            error ; "The coordinates (",x,",",y,") are out of bounds for a vertical level, at ",pc
        elseif equal(<y>>>4,!__screen+1)
            !__newscreen #= 1
            !__screen #= !__screen+1
        elseif not(equal(<y>>>4,!__screen))
            %L_ScreenJump(<y>>>4)
        endif
    else
        if or(greaterequal(<x>,$200),greaterequal(<y>,$1B))
            error ; "The coordinates (",x,",",y,") are out of bounds for a horizontal level, at ",pc
        elseif equal(<x>>>4,!__screen+1)
            !__newscreen #= 1
            !__screen #= !__screen+1
        elseif not(equal(<x>>>4,!__screen))
            %L_ScreenJump(<x>>>4)
        endif
    endif
endmacro

; insert a generic level object
;         x: x position within the level
;         y: y position within the level
;       obj: ID of the object (0-63)
;  settings: 8-bit settings byte which depends on the object
macro L_Object(x, y, obj, settings)
    %L_GoTo(<x>,<y>)
    if !__vertical
        if equal(!__newscreen,1)
            db $80|((<obj>&$30)<<1)|(<x>&$1F)
        else
            db ((<obj>&$30)<<1)|(<x>&$1F)
        endif
        db (<obj><<4)|(<y>&$F)
    else
        if equal(!__newscreen,1)
            db $80|((<obj>&$30)<<1)|(<y>&$1F)
        else
            db ((<obj>&$30)<<1)|(<y>&$1F)
        endif
        db (<obj><<4)|(<x>&$F)
    endif
    db <settings>
    !__newscreen #= 0
endmacro

; insert a screen exit object
;    screen: the screen that has the exit
;     level: the lower 8 bits of the level to exit to or secondary exit number
; secondary: 0 to use level number, 1 to use secondary exit number
macro L_ScreenExit(screen, level, secondary)
    db <screen>&$1F
    db (<secondary>&1)<<1
    db 0
    db <level>
endmacro

; insert a screen jump object
;    screen: the screen to jump to (0-31)
macro L_ScreenJump(screen)
    db <screen>&$1F
    db 0,1
    !__screen #= <screen>
    !__newscreen #= 0
endmacro

; insert primary level header and prepare inserting new objects
;     bgpal: background palette index (0-7)
;       len: level length in screens (1-32)
;     color: back area color index (0-7)
;      mode: level mode (0-31)
;        l3: layer 3 priority (1 if set, 0 if not)
;     music: level music index (0-7)
;    sprgfx: sprite GFX setting (0-7)
;      time: level timer index (0-3)
;    sprpal: sprite palette index (0-7)
;     fgpal: foreground palette index (0-7)
;       mem: item memory settings (0-3)
;    scroll: vertical scroll setting (0-3)
;     bggfx: FG/BG GFX setting (0-15)
macro L_Header(bgpal, len, color, mode, l3, music, sprgfx, time, sprpal, fgpal, mem, scroll, bggfx)
    db (<len>-1)|(<bgpal><<5)
    db <mode>|(<color><<5)
    db (<l3><<7)|(<music><<4)|<sprgfx> 
    db (<time><<6)|(<sprpal><<3)|<fgpal> 
    db (<mem><<6)|(<scroll><<4)|<bggfx> 
    !__screen #= 0
    !__newscreen #= 0
    !__vertical #= isverticallevel(<mode>)
    !__tileset #= tileset(<bggfx>)
endmacro

; insert end of level data marker
macro L_End()
    db $FF
endmacro

; insert a water object
;         x: x position within the level
;         y: y position within the level
;   surface:
;      "surface": object includes the surface part of the water
;         "deep": object does not include the surface part of the water
;  animated:
;     "animated": the dark blue water that has an animated surface
;        "still": the alternate water that is not animated
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_Water(x, y, surface, animated, width, height)
    if stringsequal("<surface>","surface")
        if stringsequal("<animated>","animated")
            %L_Object(<x>,<y>, 24, concat(<height>-1,<width>-1))
        elseif stringsequal("<animated>","still")
            %L_Object(<x>,<y>, 25, concat(<height>-1,<width>-1))
        else
            ; warn "bad parameter for %L_Water animated (",<animated>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<surface>","deep")
        if stringsequal("<animated>","animated")
            %L_Object(<x>,<y>, 1, concat(<height>-1,<width>-1))
        elseif stringsequal("<animated>","still")
            %L_Object(<x>,<y>, 7, concat(<height>-1,<width>-1))
        else
            ; warn "bad parameter for %L_Water animated (",<animated>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_Water surface (",<surface>,") at ",pc,", skipping"
    endif
endmacro

; insert a lava object (used in castles)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_Lava(x, y, width, height)
    %L_Object(<x>,<y>, 26, concat(<height>-1,<width>-1))
endmacro

; insert a lava object (used in caves)
; tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
;   surface:
;      "surface": object includes the surface part of the lava
;         "deep": object does not include the surface part of the lava
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_CaveLava(x, y, surface, width, height)
    assert equal(!__tileset,3) ;,"cannot insert CaveLava, tileset must be 3 (was ",!__tileset,"), at ",pc
    if stringsequal("<surface>","surface")
        %L_Object(<x>,<y>, 58, concat(<height>-1,<width>-1))
    elseif stringsequal("<surface>","deep")
        %L_Object(<x>,<y>, 59, concat(<height>-1,<width>-1))
    else
        ; warn "bad parameter for %L_CaveLava surface (",<surface>,") at ",pc,", skipping"
    endif
endmacro

; insert a lava edge object (used in caves)
; tileset must be 3 (underground) for top and middle sections
;         x: x position within the level
;         y: y position within the level
;      type:
;          "top": object includes a top-right corner with the right wall
;       "middle": object consists of right wall only
;       "bottom": down-left inner corner tile (length must be 1)
;    length: length of object in tiles (1-16)
macro L_CaveLavaEdge(x, y, type, length)
    if stringsequal("<type>","top")
        assert equal(!__tileset,3) ;,"cannot insert CaveLavaEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
        %L_Object(<x>,<y>, 56, concat(<length>-1,0))
    elseif stringsequal("<type>","middle")
        assert equal(!__tileset,3) ;,"cannot insert CaveLavaEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
        %L_Object(<x>,<y>, 56, concat(<length>-1,1))
    elseif stringsequal("<type>","bottom")
        if not(equal(<length>,1))
            ; warn "bad parameter for %L_CaveLavaEdge length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        %L_Object(<x>, <y>, 0, 96)
    else
        ; warn "bad parameter for %L_CaveLavaEdge type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a lava slope object (used in caves)
; tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
; direction:
;           "up": lava slopes up to the right
;         "down": lava slopes down to the right
;     angle:
;       "normal": 2 tiles across for every tile up or down
;        "steep": 1 tile across for every tile up or down
;    length: width of object in tiles (1-16)
macro L_CaveLavaSlope(x, y, direction, angle, length)
    assert equal(!__tileset,3) ;,"cannot insert CaveLava, tileset must be 3 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","up")
        if stringsequal("<angle>","normal")
            %L_Object(<x>,<y>, 57, concat(<length>-1,0))
        elseif stringsequal("<angle>","steep")
            %L_Object(<x>,<y>, 57, concat(<length>-1,1))
        else
            ; warn "bad parameter for %L_CaveLavaSlope angle (",<angle>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","down")
        if stringsequal("<angle>","normal")
            %L_Object(<x>,<y>, 57, concat(<length>-1,2))
        elseif stringsequal("<angle>","steep")
            %L_Object(<x>,<y>, 57, concat(<length>-1,3))
        else
            ; warn "bad parameter for %L_CaveLavaSlope angle (",<angle>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_CaveLavaSlope direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a midway posts object
;         x: x position within the level
;         y: y position within the level
;    length: height of object in tiles (1-16)
macro L_MidwayPosts(x, y, length)
    %L_Object(<x>,<y>, 21, concat(<length>-1,0))
endmacro

; insert a midway tape object
;         x: x position within the level
;         y: y position within the level
macro L_MidwayTape(x, y)
    %L_Object(<x>, <y>, 0, 70)
endmacro

; insert an unused tile which is the bottom right post of the midway
;         x: x position within the level
;         y: y position within the level
;      type: which of the two tiles to use (1-2)
macro L_MidwayTile(x, y, type)
    if equal(<type>,1)
        %L_Object(<x>, <y>, 0, 33)
    elseif equal(<type>,2)
        %L_Object(<x>, <y>, 0, 34)
    else
        ; warn "bad parameter for %L_MidwayTile type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a goal posts object
;         x: x position within the level
;         y: y position within the level
;    length: height of object in tiles (1-16) (the standard is 10)
macro L_GoalPosts(x, y, length)
    %L_Object(<x>,<y>, 21, concat(<length>-1,1))
endmacro

; insert a door object
;         x: x position within the level
;         y: y position within the level
;      size:
;          "big": 2-tile high door
;        "small": 1-tile high door
;      type:
;       "normal": standard brown door
;      "pswitch": blue door that only appears when a P-switch is active
macro L_Door(x, y, size, type)
    if stringsequal("<size>","big")
        if stringsequal("<type>","normal")
            %L_Object(<x>, <y>, 0, 71)
        elseif stringsequal("<type>","pswitch")
            %L_Object(<x>, <y>, 0, 72)
        else
            ; warn "bad parameter for %L_Door type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<size>","small")
        if stringsequal("<type>","normal")
            %L_Object(<x>, <y>, 0, 16)
        elseif stringsequal("<type>","pswitch")
            %L_Object(<x>, <y>, 0, 21)
        else
            ; warn "bad parameter for %L_Door type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_Door size (",<size>,") at ",pc,", skipping"
    endif
endmacro

; insert a big boss door object
;         x: x position within the level
;         y: y position within the level
macro L_BossDoor(x, y)
    %L_Object(<x>, <y>, 0, 144)
endmacro

; insert a berry object
;         x: x position within the level
;         y: y position within the level
;      type:
;          "red": red berry, 10 = mushroom
;         "pink": pink berry, 2 = bonus cloud
;        "green": green berry, 1 = +10 seconds
macro L_Berry(x, y, type)
    if stringsequal("<type>","red")
        %L_Object(<x>, <y>, 0, 29)
    elseif stringsequal("<type>","pink")
        %L_Object(<x>, <y>, 0, 30)
    elseif stringsequal("<type>","green")
        %L_Object(<x>, <y>, 0, 31)
    else
        ; warn "bad parameter for %L_Berry type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a 1-up checkpoint object
;         x: x position within the level
;         y: y position within the level
;      flag: which checkpoint this is (1-4)
macro L_1upCheckpoint(x, y, flag)
    if equal(<flag>,1)
        %L_Object(<x>, <y>, 0, 25)
    elseif equal(<flag>,2)
        %L_Object(<x>, <y>, 0, 26)
    elseif equal(<flag>,3)
        %L_Object(<x>, <y>, 0, 27)
    elseif equal(<flag>,4)
        %L_Object(<x>, <y>, 0, 28)
    else
        ; warn "bad parameter for %L_1upCheckpoint flag (",<flag>,") at ",pc,", skipping"
    endif
endmacro

; insert a 3-Up moon object
;         x: x position within the level
;         y: y position within the level
macro L_3upMoon(x, y)
    %L_Object(<x>, <y>, 0, 24)
endmacro

; insert the Yoshi's House object
;         x: x position within the level
;         y: y position within the level
macro L_YoshisHouse(x, y)
    %L_Object(<x>, <y>, 0, 133)
endmacro

; insert a structure facade object
; note that there is no castle exit object
;         x: x position within the level
;         y: y position within the level
;      type:
;   "ghosthouse": ghost house
;       "castle": castle
;      exit:
;     "entrance": entrance to the structure
;         "exit": exit of the structure
macro L_StructureFacade(x, y, type, exit)
    if stringsequal("<type>","ghosthouse")
        if stringsequal("<exit>","entrance")
            %L_Object(<x>, <y>, 0, 128)
        elseif stringsequal("<exit>","exit")
            %L_Object(<x>, <y>, 0, 73)
        else
            ; warn "bad parameter for %L_StructureFacade exit (",<exit>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","castle")
        if stringsequal("<exit>","entrance")
            %L_Object(<x>, <y>, 0, 132)
        else
            ; warn "bad parameter for %L_StructureFacade exit (",<exit>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_StructureFacade type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a green star block object
;         x: x position within the level
;         y: y position within the level
macro L_GreenStarBlock(x, y)
    %L_Object(<x>, <y>, 0, 23)
endmacro

; insert an ON/OFF block object
;         x: x position within the level
;         y: y position within the level
macro L_OnOffBlock(x, y)
    %L_Object(<x>, <y>, 0, 36)
endmacro

; insert a glass block object for use with the roulette item
;         x: x position within the level
;         y: y position within the level
macro L_GlassBlock(x, y)
    %L_Object(<x>, <y>, 0, 64)
endmacro

; insert a switch palace ! block
; tileset can be anything for yellow and green
; tileset must not be 4 (bonus/ghost house) for red and blue
;         x: x position within the level
;         y: y position within the level
;     color:
;       "yellow": yellow ! block with a mushroom (limited to 1x1)
;        "green": green ! block with a feather (limited to 1x1)
;          "red": red ! blocks
;         "blue": blue ! blocks
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_SwitchBlocks(x, y, color, width, height)
    if stringsequal("<color>","yellow")
        assert equal(<width>,1) ;,"cannot insert yellow SwitchBlock, width must be 1 (was ",<width>,"), at ",pc
        assert equal(<height>,1) ;,"cannot insert yellow SwitchBlock, height must be 1 (was ",<height>,"), at ",pc
        %L_Object(<x>, <y>, 0, 142)
    elseif stringsequal("<color>","green")
        assert equal(<width>,1) ;,"cannot insert green SwitchBlock, width must be 1 (was ",<width>,"), at ",pc
        assert equal(<height>,1) ;,"cannot insert green SwitchBlock, height must be 1 (was ",<height>,"), at ",pc
        %L_Object(<x>, <y>, 0, 135)
    elseif stringsequal("<color>","red")
        if equal(!__tileset,0)
            %L_Object(<x>,<y>, 56, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,1)
            %L_Object(<x>,<y>, 58, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,2)
            %L_Object(<x>,<y>, 52, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,3)
            %L_Object(<x>,<y>, 53, concat(<height>-1,<width>-1))
        else
            error ; "cannot insert red SwitchBlock, tileset must not be 4 (was ",!__tileset,"), at ",pc
        endif
    elseif stringsequal("<color>","blue")
        if equal(!__tileset,0)
            %L_Object(<x>,<y>, 50, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,1)
            %L_Object(<x>,<y>, 57, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,2)
            %L_Object(<x>,<y>, 51, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,3)
            %L_Object(<x>,<y>, 52, concat(<height>-1,<width>-1))
        else
            error ; "cannot insert blue SwitchBlock, tileset must not be 4 (was ",!__tileset,"), at ",pc
        endif
    else
        ; warn "bad parameter for %L_SwitchBlock color (",<color>,") at ",pc,", skipping"
    endif
endmacro

; insert a set of throw blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_ThrowBlocks(x, y, width, height)
    %L_Object(<x>,<y>, 11, concat(<height>-1,<width>-1))
endmacro

; insert a set of munchers object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_Munchers(x, y, width, height)
    %L_Object(<x>,<y>, 12, concat(<height>-1,<width>-1))
endmacro

; insert a set of cement blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_CementBlocks(x, y, width, height)
    %L_Object(<x>,<y>, 13, concat(<height>-1,<width>-1))
endmacro

; insert a set of brown used blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_UsedBlocks(x, y, width, height)
    %L_Object(<x>,<y>, 14, concat(<height>-1,<width>-1))
endmacro

; insert a set of wooden blocks object
; tileset must be 4 (bonus/ghost house)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_WoodenBlocks(x, y, width, height)
    assert equal(!__tileset,4) ;,"cannot insert WoodenBlocks, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 54, concat(<height>-1,<width>-1))
endmacro

; insert a set of coins object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_Coins(x, y, width, height)
    %L_Object(<x>,<y>, 5, concat(<height>-1,<width>-1))
endmacro

; insert a set of P-switch coins object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_PSwitchCoins(x, y, width, height)
    %L_Object(<x>,<y>, 4, concat(<height>-1,<width>-1))
endmacro

; insert a set of unused blue coins object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_BlueCoins(x, y, width, height)
    %L_Object(<x>,<y>, 22, concat(<height>-1,<width>-1))
endmacro

; insert a dragon coin object
;         x: x position within the level
;         y: y position within the level
macro L_DragonCoin(x, y)
    %L_Object(<x>, <y>, 0, 65)
endmacro

; insert a set of note blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_NoteBlocks(x, y, width, height)
    %L_Object(<x>,<y>, 8, concat(<height>-1,<width>-1))
    ;%L_Object(<x>, <y>, 0, 38) ; unused single note block extended object
endmacro

; insert a set of invisible note blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_InvisibleNoteBlocks(x, y, width, height)
    %L_Object(<x>,<y>, 3, concat(<height>-1,<width>-1))
    ;%L_Object(<x>, <y>, 0, 18) ; unused single invisible note block extended object
endmacro

; insert an item-containing note block object
; the contents are actually determined by the x position
; in the current screen mod 3, but specifying the contents
; can warn when it isn't what is expected
;         x: x position within the level
;         y: y position within the level
;  contents:
;       "flower": fire flower (x pos mod 3 == 0)
;      "feather": cape feather (x pos mod 3 == 1)
;         "star": super star (x pos mod 3 == 2)
macro L_ItemNoteBlock(x, y, contents)
    if and(equal(mod(<x>&$F,3),0),not(stringsequal("<contents>","flower")))
        ; warn "ItemNoteBlock will not match contents, will be flower (was ",<contents>,"), at ",pc
    elseif and(equal(mod(<x>&$F,3),1),not(stringsequal("<contents>","feather")))
        ; warn "ItemNoteBlock will not match contents, will be feather (was ",<contents>,"), at ",pc
    elseif and(equal(mod(<x>&$F,3),2),not(stringsequal("<contents>","star")))
        ; warn "ItemNoteBlock will not match contents, will be star (was ",<contents>,"), at ",pc
    endif
    %L_Object(<x>, <y>, 0, 35)
endmacro

; insert an extra bouncy note block object
;         x: x position within the level
;         y: y position within the level
macro L_BouncyNoteBlock(x, y)
    %L_Object(<x>, <y>, 0, 39)
endmacro

; insert a set of turn blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_TurnBlocks(x, y, width, height)
    %L_Object(<x>,<y>, 9, concat(<height>-1,<width>-1))
endmacro

; insert a set of icy turn blocks object
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_IcyTurnBlocks(x, y, width, height)
    assert equal(!__tileset,0) ;,"cannot insert IcyTurnBlocks, tileset must be 0 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 49, concat(<height>-1,<width>-1))
endmacro

; insert an item-containing turn block object
; some of the contents of blocks are determined by the tile's
; x position on the current screen, but specifying the contents
; can warn when it isn't what is expected
;         x: x position within the level
;         y: y position within the level
;  contents:
;         "coin": coin
;        "coins": multiple coins
;       "flower": fire flower
;      "feather": cape feather
;         "star": super star
;    "chainstar": super star if you have star power already (x pos mod 3 == 0)
;          "1up": 1-up mushroom (x pos mod 3 == 1)
;         "vine": growing vine (x pos mod 3 == 2)
;  "bluepswitch": blue P-switch (x pos mod 2 == 0)
;  "graypswitch": gray P-switch (x pos mod 2 == 1)
;        "empty": nothing
;  "sidefeather": cape feather only if bumped from the side
macro L_ItemTurnBlock(x, y, contents)
    if stringsequal("<contents>","coin")
        %L_Object(<x>, <y>, 0, 45)
    elseif stringsequal("<contents>","coins")
        %L_Object(<x>, <y>, 0, 44)
    elseif stringsequal("<contents>","flower")
        %L_Object(<x>, <y>, 0, 40)
    elseif stringsequal("<contents>","feather")
        %L_Object(<x>, <y>, 0, 41)
    elseif stringsequal("<contents>","star")
        %L_Object(<x>, <y>, 0, 42)
    elseif or(stringsequal("<contents>","chainstar"),or(stringsequal("<contents>","1up"),stringsequal("<contents>","vine")))
        if and(equal(mod(<x>&$F,3),0),not(stringsequal("<contents>","chainstar")))
            ; warn "ItemTurnBlock will not match contents, will be chainstar (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,3),1),not(stringsequal("<contents>","1up")))
            ; warn "ItemTurnBlock will not match contents, will be 1up (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,3),2),not(stringsequal("<contents>","vine")))
            ; warn "ItemTurnBlock will not match contents, will be vine (was ",<contents>,"), at ",pc
        endif
        %L_Object(<x>, <y>, 0, 43)
    elseif or(stringsequal("<contents>","bluepswitch"),stringsequal("<contents>","graypswitch"))
        if and(equal(mod(<x>&$F,2),0),not(stringsequal("<contents>","bluepswitch")))
            ; warn "ItemTurnBlock will not match contents, will be bluepswitch (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,2),1),not(stringsequal("<contents>","graypswitch")))
            ; warn "ItemTurnBlock will not match contents, will be graypswitch (was ",<contents>,"), at ",pc
        endif
        %L_Object(<x>, <y>, 0, 47)
    elseif stringsequal("<contents>","empty")
        %L_Object(<x>, <y>, 0, 46)
    elseif stringsequal("<contents>","sidefeather")
        %L_Object(<x>, <y>, 0, 57)
    else
        ; warn "bad parameter for %L_ItemTurnBlock contents (",<contents>,") at ",pc,", skipping"
    endif
endmacro

; insert an always spinning turn block object
;         x: x position within the level
;         y: y position within the level
macro L_SpinningTurnBlock(x, y)
    %L_Object(<x>, <y>, 0, 32)
endmacro

; insert a set of prize blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_PrizeBlocks(x, y, width, height)
    %L_Object(<x>,<y>, 10, concat(<height>-1,<width>-1))
endmacro

; insert a set of invisible prize blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_InvisiblePrizeBlocks(x, y, width, height)
    %L_Object(<x>,<y>, 2, concat(<height>-1,<width>-1))
endmacro

; insert an item-containing prize block object
; some of the contents of blocks are determined by the tile's
; x position on the current screen, but specifying the contents
; can warn when it isn't what is expected
;         x: x position within the level
;         y: y position within the level
;  contents:
;        "coins": multiple coins
;       "flower": fire flower
;      "feather": cape feather
;         "star": super star
;    "chainstar": super star if you have star power already
;          "1up": 1-up mushroom (block is invisible)
;        "yoshi": green yoshi
;    "coinsnake": controllable coin snake
;          "key": key (x pos mod 4 == 0)
;        "wings": yoshi wings (x pos mod 4 == 1)
;     "pballoon": P-balloon (x pos mod 4 == 2)
;        "shell": green shell (x pos mod 4 == 3)
;       "shell2": green shell again
;       "shell3": green shell again again
macro L_ItemPrizeBlock(x, y, contents)
    if stringsequal("<contents>","coins")
        %L_Object(<x>, <y>, 0, 52)
    elseif stringsequal("<contents>","flower")
        %L_Object(<x>, <y>, 0, 48)
    elseif stringsequal("<contents>","feather")
        %L_Object(<x>, <y>, 0, 49)
    elseif stringsequal("<contents>","star")
        %L_Object(<x>, <y>, 0, 50)
    elseif stringsequal("<contents>","chainstar")
        %L_Object(<x>, <y>, 0, 51)
    elseif stringsequal("<contents>","1up")
        %L_Object(<x>, <y>, 0, 17)
    elseif stringsequal("<contents>","yoshi")
        %L_Object(<x>, <y>, 0, 54)
    elseif stringsequal("<contents>","coinsnake")
        %L_Object(<x>, <y>, 0, 37)
    elseif or(stringsequal("<contents>","key"),or(stringsequal("<contents>","wings"),or(stringsequal("<contents>","pballoon"),stringsequal("<contents>","shell"))))
        if and(equal(mod(<x>&$F,4),0),not(stringsequal("<contents>","key")))
            ; warn "ItemPrizeBlock will not match contents, will be key (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,4),1),not(stringsequal("<contents>","wings")))
            ; warn "ItemPrizeBlock will not match contents, will be wings (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,4),2),not(stringsequal("<contents>","pballoon")))
            ; warn "ItemPrizeBlock will not match contents, will be pballoon (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,4),3),not(stringsequal("<contents>","shell")))
            ; warn "ItemPrizeBlock will not match contents, will be shell (was ",<contents>,"), at ",pc
        endif
        %L_Object(<x>, <y>, 0, 53)
    elseif stringsequal("<contents>","shell2")
        %L_Object(<x>, <y>, 0, 55)
    elseif stringsequal("<contents>","shell3")
        %L_Object(<x>, <y>, 0, 56)
    else
        ; warn "bad parameter for %L_ItemPrizeBlock contents (",<contents>,") at ",pc,", skipping"
    endif
endmacro

; insert a P-switch prize block object
;         x: x position within the level
;         y: y position within the level
macro L_PSwitchPrizeBlock(x, y)
    %L_Object(<x>, <y>, 0, 22)
endmacro

; insert a pipe object
; tileset must be 0 (grassy/forest/bonus) for icytop
; tileset must be 1 (castle) bothspecial
;         x: x position within the level
;         y: y position within the level
; direction:
;   "horizontal": ends on the left and right
;     "vertical": ends on the top and bottom
;      type:
;          "top": the lip is on the top
;       "icytop": the lip is on the top (icy pipe)
;       "bottom": the lip is on the bottom
;         "both": lips on both ends
;  "bothspecial": lips on both ends, non-solid center
;         "none": no lips
;         "left": the lip is on the left
;        "right": the lip is on the right
;      exit:
;         "open": you can go in the pipe
;       "closed": you cannot go in the pipe
;    length: length of object in tiles (1-16)
macro L_Pipe(x, y, direction, type, exit, length)
    if stringsequal("<direction>","horizontal")
        if stringsequal("<type>","left")
            if stringsequal("<exit>","open")
                %L_Object(<x>,<y>, 16, concat(1, <length>-1))
            elseif stringsequal("<exit>","closed")
                %L_Object(<x>,<y>, 16, concat(0, <length>-1))
            else
                ; warn "bad parameter for %L_Pipe exit (",<exit>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<type>","right")
            if stringsequal("<exit>","open")
                %L_Object(<x>,<y>, 16, concat(3, <length>-1))
            elseif stringsequal("<exit>","closed")
                %L_Object(<x>,<y>, 16, concat(2, <length>-1))
            else
                ; warn "bad parameter for %L_Pipe exit (",<exit>,") at ",pc,", skipping"
            endif
        else
            ; warn "bad parameter for %L_Pipe type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","vertical")
        if stringsequal("<type>","top")
            if stringsequal("<exit>","open")
                %L_Object(<x>,<y>, 15, concat(<length>-1,1))
            elseif stringsequal("<exit>","closed")
                %L_Object(<x>,<y>, 15, concat(<length>-1,0))
            else
                ; warn "bad parameter for %L_Pipe exit (",<exit>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<type>","bottom")
            if stringsequal("<exit>","open")
                %L_Object(<x>,<y>, 15, concat(<length>-1,4))
            elseif stringsequal("<exit>","closed")
                %L_Object(<x>,<y>, 15, concat(<length>-1,3))
            else
                ; warn "bad parameter for %L_Pipe exit (",<exit>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<type>","both")
            %L_Object(<x>,<y>, 15, concat(<length>-1,2))
        elseif stringsequal("<type>","bothspecial")
            assert equal(!__tileset,1) ;,"cannot insert bothspecial Pipe, tileset must be 1 (was ",!__tileset,"), at ",pc
            %L_Object(<x>,<y>, 52, concat(<length>-1,1))
        elseif stringsequal("<type>","none")
            %L_Object(<x>,<y>, 15, concat(<length>-1,5))
        elseif stringsequal("<type>","icytop")
            assert equal(!__tileset,0) ;,"cannot insert icytop Pipe, tileset must be 0 (was ",!__tileset,"), at ",pc
            %L_Object(<x>,<y>, 48, concat(<length>-1,0))
        else
            ; warn "bad parameter for %L_Pipe type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_Pipe direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a diagonal pipe object
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_DiagonalPipe(x, y, length)
    assert equal(!__tileset,0) ;,"cannot insert DiagonalPipe, tileset must be 0 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 57, concat(<length>-1,0))
endmacro

; insert a bush object
; big and medium should have length 1
; all the others must have tileset 0
;         x: x position within the level
;         y: y position within the level
;      type:
;          "big": largest bush
;       "medium": next largest bush
;        "small": long green bush
;         "tiny": unused short foreground bush
;         "dirt": grass growing out of ledge dirt
;     "glitched": completely glitched
;        "grass": small grass (forest graphics only)
;    length: length of object in tiles (1-16)
macro L_Bush(x, y, type, length)
    if stringsequal("<type>","big")
        if not(equal(<length>,1))
            ; warn "bad parameter for %L_Bush length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        %L_Object(<x>, <y>, 0, 130)
    elseif stringsequal("<type>","medium")
        if not(equal(<length>,1))
            ; warn "bad parameter for %L_Bush length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        %L_Object(<x>, <y>, 0, 131)
    else
        assert equal(!__tileset,0) ;,"cannot insert Bush, tileset must be 0 (was ",!__tileset,"), at ",pc
        if stringsequal("<type>","small")
            %L_Object(<x>,<y>, 63, concat(0, <length>-1))
        elseif stringsequal("<type>","tiny")
            %L_Object(<x>,<y>, 63, concat(1, <length>-1))
        elseif stringsequal("<type>","dirt")
            %L_Object(<x>,<y>, 63, concat(2, <length>-1))
        elseif stringsequal("<type>","glitched")
            %L_Object(<x>,<y>, 63, concat(3, <length>-1))
        elseif stringsequal("<type>","grass")
            %L_Object(<x>,<y>, 63, concat(4, <length>-1))
        else
            ; warn "bad parameter for %L_Bush type (",<type>,") at ",pc,", skipping"
        endif
    endif
endmacro

; insert an arrow sign object
;         x: x position within the level
;         y: y position within the level
macro L_ArrowSign(x, y)
    %L_Object(<x>, <y>, 0, 134)
endmacro

; insert a forest canopy object
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in screens (1-256)
macro L_ForestCanopy(x, y, length)
    assert equal(!__tileset,0) ;,"cannot insert ForestCanopy, tileset must be 0 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 51,  <length>-1)
endmacro

; insert a tree trunk object
; tileset must be 0 (grassy/forest/cloud)
; note there is no big tree trunk that stays in the background
;         x: x position within the level
;         y: y position within the level
;      type:
;          "big": 2-tile wide tree trunk
;        "small": 1-tile wide tree trunk
;  priority:
;   "background": Mario goes in front of it
;   "foreground": Mario goes behind it
;    length: length of object in tiles (1-16)
macro L_TreeTrunk(x, y, type, priority, length)
    assert equal(!__tileset,0) ;,"cannot insert TreeTrunk, tileset must be 0 (was ",!__tileset,"), at ",pc
    if stringsequal("<type>","small")
        if stringsequal("<priority>","foreground")
            %L_Object(<x>,<y>, 55, concat(<length>-1,1))
        elseif stringsequal("<priority>","background")
            %L_Object(<x>,<y>, 55, concat(<length>-1,0))
        else
            ; warn "bad parameter for %L_TreeTrunk priority (",<priority>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","big")
        if stringsequal("<priority>","foreground")
            %L_Object(<x>,<y>, 54, concat(<length>-1,0))
        else
            ; warn "bad parameter for %L_TreeTrunk priority (",<priority>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_TreeTrunk type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a tree branch object
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
; direction:
;         "left": branch to the left of the tree
;        "right": branch to the right of the tree
macro L_TreeBranch(x, y, direction)
    assert equal(!__tileset,0) ;,"cannot insert TreeBranch, tileset must be 0 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","left")
        %L_Object(<x>, <y>, 0, 136)
    elseif stringsequal("<direction>","right")
        %L_Object(<x>, <y>, 0, 137)
    else
        ; warn "bad parameter for %L_TreeBranch direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a rocky background object
; tileset must be 1 (castle)
; the base unit of this object is 2x2 tiles, so it can be
; twice as long and tall as general objects
; hence the width and height in tiles must be even
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (2-32)
;    height: height of object in tiles (2-32)
macro L_RockyBackground(x, y, width, height)
    assert equal(!__tileset,1) ;,"cannot insert RockyBackground, tileset must be 1 (was ",!__tileset,"), at ",pc
    if equal(<width>&1,1)
        ; warn "bad parameter for %L_RockyBackground width (",<width>,") at ",pc,", using ",<width>&$FE," instead"
    endif
    if equal(<height>&1,1)
        ; warn "bad parameter for %L_RockyBackground height (",<height>,") at ",pc,", using ",<height>&$FE," instead"
    endif
    %L_Object(<x>,<y>, 53, concat(( <height>/2)-1,(<width>/2)-1))
endmacro

; insert a large background object
; unused, fills up 4x16x16 screens
;         x: x position within the level
;         y: y position within the level
macro L_LargeBackground(x, y)
    %L_Object(<x>, <y>, 0, 95)
endmacro

; insert an escalator start/end tile
; the two types are identical but animate out
; of phase with each other
;         x: x position within the level
;         y: y position within the level
;      type: which tile to use (1-2)
macro L_EscalatorEnd(x, y, type)
    if equal(<type>,1)
        %L_Object(<x>, <y>, 0, 75)
    elseif equal(<type>,2)
        %L_Object(<x>, <y>, 0, 76)
    else
        ; warn "bad parameter for %L_EscalatorEnd type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a seaweed object
; unused, generally found in the background
;         x: x position within the level
;         y: y position within the level
macro L_Seaweed(x, y)
    %L_Object(<x>, <y>, 0, 129)
endmacro

; insert a cloud fringe object
; the cloud ledge tileset has these extra tiles to make the
; ground feel softer, but hardly any of them were ever used
; tileset must be 0 (grassy/forest/cloud) for all tiles that can be longer than 1 tile
;         x: x position within the level
;         y: y position within the level
; direction:
;          "top": fringe for floor
;         "left": fringe for left wall (graphics on right)
;        "right": fringe for right wall (graphics on left)
;      "topleft": fringe for left inner corner (graphics on right)
;     "topright": fringe for right inner corner (graphics on left)
;      type:
;         "long": fringe on every 8x8 tile
;        "short": one 8x8 tile is missing (for outer corner)
;    "shortleft": one 8x8 tile missing on right
;   "shortright": one 8x8 tile missing on left
;        bg:
;  "transparent": no background
;        "solid": solid white background
;    length: length of object in tiles (1-16)
macro L_CloudFringe(x, y, direction, type, bg, length)
    if stringsequal("<direction>","top")
        if stringsequal("<type>","long")
            assert equal(!__tileset,0) ;,"cannot insert CloudFringe, tileset must be 0 (was ",!__tileset,"), at ",pc
            if stringsequal("<bg>","transparent")
                %L_Object(<x>,<y>, 61, concat(0, <length>-1))
            elseif stringsequal("<bg>","solid")
                %L_Object(<x>,<y>, 61, concat(1, <length>-1))
            else
                ; warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<type>","shortleft")
            if not(equal(<length>,1))
                ; warn "bad parameter for %L_CloudFringe length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
            endif
            if stringsequal("<bg>","transparent")
                %L_Object(<x>, <y>, 0, 107)
            elseif stringsequal("<bg>","solid")
                %L_Object(<x>, <y>, 0, 111)
            else
                ; warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<type>","shortright")
            if not(equal(<length>,1))
                ; warn "bad parameter for %L_CloudFringe length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
            endif
            if stringsequal("<bg>","transparent")
                %L_Object(<x>, <y>, 0, 106)
            elseif stringsequal("<bg>","solid")
                %L_Object(<x>, <y>, 0, 110)
            else
                ; warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        else
            ; warn "bad parameter for %L_CloudFringe type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","left")
        assert equal(!__tileset,0) ;,"cannot insert CloudFringe, tileset must be 0 (was ",!__tileset,"), at ",pc
        if stringsequal("<type>","long")
            if stringsequal("<bg>","transparent")
                %L_Object(<x>,<y>, 62, concat(<length>-1,1))
            elseif stringsequal("<bg>","solid")
                %L_Object(<x>,<y>, 62, concat(<length>-1,3))
            else
                ; warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<type>","short")
            if stringsequal("<bg>","transparent")
                %L_Object(<x>,<y>, 62, concat(<length>-1,0))
            elseif stringsequal("<bg>","solid")
                %L_Object(<x>,<y>, 62, concat(<length>-1,2))
            else
                ; warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        else
            ; warn "bad parameter for %L_CloudFringe type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","right")
        assert equal(!__tileset,0) ;,"cannot insert CloudFringe, tileset must be 0 (was ",!__tileset,"), at ",pc
        if stringsequal("<type>","long")
            if stringsequal("<bg>","transparent")
                %L_Object(<x>,<y>, 62, concat(<length>-1,5))
            elseif stringsequal("<bg>","solid")
                %L_Object(<x>,<y>, 62, concat(<length>-1,7))
            else
                ; warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<type>","short")
            if stringsequal("<bg>","transparent")
                %L_Object(<x>,<y>, 62, concat(<length>-1,4))
            elseif stringsequal("<bg>","solid")
                %L_Object(<x>,<y>, 62, concat(<length>-1,6))
            else
                ; warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        else
            ; warn "bad parameter for %L_CloudFringe type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","topleft")
        if not(equal(<length>,1))
            ; warn "bad parameter for %L_CloudFringe length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        if not(stringsequal("<type>","long"))
            ; warn "bad parameter for %L_CloudFringe type, must be long, was (",<type>,") at ",pc,", using long instead"
        endif
        if stringsequal("<bg>","transparent")
            %L_Object(<x>, <y>, 0, 104)
        elseif stringsequal("<bg>","solid")
            %L_Object(<x>, <y>, 0, 108)
        else
            ; warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","topright")
        if not(equal(<length>,1))
            ; warn "bad parameter for %L_CloudFringe length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        if not(stringsequal("<type>","long"))
            ; warn "bad parameter for %L_CloudFringe type, must be long, was (",<type>,") at ",pc,", using long instead"
        endif
        if stringsequal("<bg>","transparent")
            %L_Object(<x>, <y>, 0, 105)
        elseif stringsequal("<bg>","solid")
            %L_Object(<x>, <y>, 0, 109)
        else
            ; warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_CloudFringe direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a log background object
; tileset must be 4 (ghosthouse/bonus)
; vertical log must have width 1
;         x: x position within the level
;         y: y position within the level
; direction:
;   "horizontal": horizontal logs
;     "vertical": vertical logs
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_LogBackground(x, y, direction, width, height)
    assert equal(!__tileset,4) ;,"cannot insert LogBackground, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","horizontal")
        if equal(<height>,1)
            ; special object used in case height == 1
            %L_Object(<x>,<y>, 55, concat(0, <width>-1))
        else
            ; technically means you can't place this object with height == 1
            ; it was never used in vanilla for some reason
            %L_Object(<x>,<y>, 47, concat(<height>-1,<width>-1))
        endif
    elseif stringsequal("<direction>","vertical")
        assert equal(<width>,1) ;,"cannot insert vertical LogBackground, width must be 1 (was ",<width>,"), at ",pc
        %L_Object(<x>,<y>, 57, concat(<height>-1,0))
    else
        ; warn "bad parameter for %L_LogBackground direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a diagonal beam object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
; direction:
;       "upleft": bottom left to top right
;      "upright": bottom right to top left
;      size:
;        "short": 3x3 tiles, brighter
;         "long": 4x4 tiles, darker
macro L_DiagonalBeam(x, y, direction, size)
    assert equal(!__tileset,4) ;,"cannot insert DiagonalBeam, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","upleft")
        if stringsequal("<size>","short")
            %L_Object(<x>, <y>, 0, 99)
        elseif stringsequal("<size>","long")
            %L_Object(<x>, <y>, 0, 103)
        else
            ; warn "bad parameter for %L_DiagonalBeam size (",<size>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","upright")
        if stringsequal("<size>","short")
            %L_Object(<x>, <y>, 0, 98)
        elseif stringsequal("<size>","long")
            %L_Object(<x>, <y>, 0, 102)
        else
            ; warn "bad parameter for %L_DiagonalBeam size (",<size>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_DiagonalBeam direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a brick background object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_BrickBackground(x, y, width, height)
    assert equal(!__tileset,4) ;,"cannot insert BrickBackground, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 53, concat(<height>-1,<width>-1))
endmacro

; insert a small brick tile background object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;      type:
;     "topright": 3 8x8 tiles on top right
;       "bottom": 2 8x8 tiles on bottom
;      "topleft": 3 8x8 tiles on top left
;   "bottomleft": 1 8x8 tile on bottom left
macro L_BrickTile(x, y, type)
    assert equal(!__tileset,4) ;,"cannot insert BrickTile, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal("<type>","topright")
        %L_Object(<x>, <y>, 0, 91)
    elseif stringsequal("<type>","bottom")
        %L_Object(<x>, <y>, 0, 92)
    elseif stringsequal("<type>","topleft")
        %L_Object(<x>, <y>, 0, 93)
    elseif stringsequal("<type>","bottomleft")
        %L_Object(<x>, <y>, 0, 94)
    else
        ; warn "bad parameter for %L_BrickTile type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a background clock object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
macro L_BackgroundClock(x, y)
    assert equal(!__tileset,4) ;,"cannot insert BackgroundClock, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(<x>, <y>, 0, 97)
endmacro

; insert a background window object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
macro L_BackgroundWindow(x, y)
    assert equal(!__tileset,4) ;,"cannot insert BackgroundWindow, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(<x>, <y>, 0, 143)
endmacro

; insert a cobweb object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
; direction:
;       "upleft": connects on top and left
;      "upright": connects on top and right
macro L_Cobweb(x, y, direction)
    assert equal(!__tileset,4) ;,"cannot insert Cobweb, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","upleft")
        %L_Object(<x>, <y>, 0, 101)
    elseif stringsequal("<direction>","upright")
        %L_Object(<x>, <y>, 0, 100)
    else
        ; warn "bad parameter for %L_Cobweb direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a background cloud object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_BackgroundCloud(x, y, length)
    assert equal(!__tileset,4) ;,"cannot insert BackgroundCloud, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 51, concat(0, <length>-1))
endmacro

; insert a hand rail object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;      part:
;         "rail": top half
;        "posts": bottom half
;    length: length of object in tiles (1-16)
macro L_HandRail(x, y, part, length)
    assert equal(!__tileset,4) ;,"cannot insert HandRail, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal("<part>","rail")
        %L_Object(<x>,<y>, 55, concat(1, <length>-1))
    elseif stringsequal("<part>","posts")
        %L_Object(<x>,<y>, 55, concat(2, <length>-1))
    else
        ; warn "bad parameter for %L_HandRail part (",<part>,") at ",pc,", skipping"
    endif
endmacro

; insert a switch palace switch object
;         x: x position within the level
;         y: y position within the level
;     color:
;       "yellow": yellow
;        "green": green
;          "red": red
;         "blue": blue
macro L_PalaceSwitch(x, y, color)
    if stringsequal("<color>","yellow")
        %L_Object(<x>, <y>, 0, 139)
    elseif stringsequal("<color>","green")
        %L_Object(<x>, <y>, 0, 138)
    elseif stringsequal("<color>","red")
        %L_Object(<x>, <y>, 0, 141)
    elseif stringsequal("<color>","blue")
        %L_Object(<x>, <y>, 0, 140)
    else
        ; warn "bad parameter for %L_PalaceSwitch color (",<color>,") at ",pc,", skipping"
    endif
endmacro

; insert an inner corner ledge tile for bonus rooms tile
;         x: x position within the level
;         y: y position within the level
; direction:
;       "upleft": tile on bottom right
;      "upright": tile on bottom left
;     "downleft": tile on top right
;    "downright": tile on top left
macro L_PalaceInnerCorner(x, y, direction)
    if stringsequal("<direction>","upleft")
        %L_Object(<x>, <y>, 0, 87)
    elseif stringsequal("<direction>","upright")
        %L_Object(<x>, <y>, 0, 88)
    elseif stringsequal("<direction>","downleft")
        %L_Object(<x>, <y>, 0, 89)
    elseif stringsequal("<direction>","downright")
        %L_Object(<x>, <y>, 0, 90)
    else
        ; warn "bad parameter for %L_PalaceInnerCorner direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert an outer corner ledge tile for bonus rooms tile
; only the bottom right exists (shoutout to switchpalacecorner)
;         x: x position within the level
;         y: y position within the level
; direction:
;    "downright": corner on bottom right
macro L_PalaceOuterCorner(x, y, direction)
    if stringsequal("<direction>","downright")
        %L_Object(<x>, <y>, 0, 151)
    else
        ; warn "bad parameter for %L_PalaceOuterCorner direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a bonus room walls/ceiling/ledge object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;      type:
;      "ceiling": tiles on bottom
;        "floor": tiles on top
;         "left": tiles on right
;        "right": tiles on left
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_PalaceWalls(x, y, type, width, height)
    assert equal(!__tileset,4) ;,"cannot insert PalaceWalls, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal("<type>","ceiling")
        %L_Object(<x>,<y>, 60, concat(<height>-1,<width>-1))
    elseif stringsequal("<type>","floor")
        %L_Object(<x>,<y>, 61, concat(<height>-1,<width>-1))
    elseif stringsequal("<type>","left")
        %L_Object(<x>,<y>, 62, concat(<height>-1,<width>-1))
    elseif stringsequal("<type>","right")
        %L_Object(<x>,<y>, 63, concat(<height>-1,<width>-1))
    else
        ; warn "bad parameter for %L_PalaceWalls type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a bullet bill shooter object
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_BulletShooter(x, y, length)
    %L_Object(<x>,<y>, 17, concat(<length>-1,0))
endmacro

; insert a torpedo ted launcher object
;         x: x position within the level
;         y: y position within the level
macro L_TorpedoLauncher(x, y)
    %L_Object(<x>, <y>, 0, 127)
endmacro

; insert a climbing vine object
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_Vine(x, y, length)
    %L_Object(<x>,<y>, 19, concat(<length>-1,2))
endmacro

; insert a horizontal rope object
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_Rope(x, y, length)
    %L_Object(<x>,<y>, 23, concat(0, <length>-1))
endmacro

; insert a set of clouds object
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_Clouds(x, y, length)
    %L_Object(<x>,<y>, 23, concat(1, <length>-1))
endmacro

; insert a skinny platform object
; this can be a small pipe, bone, or wodden log depending
; on the exact graphics file loaded (not tileset)
;         x: x position within the level
;         y: y position within the level
; direction:
;   "horizontal": left and right
;     "vertical": up and down
;    length: length of object in tiles (1-16)
macro L_SkinnyPlatform(x, y, direction, length)
    if stringsequal("<direction>","horizontal")
        %L_Object(<x>,<y>, 32, concat(0, <length>-1))
    elseif stringsequal("<direction>","vertical")
        %L_Object(<x>,<y>, 31, concat(<length>-1,0))
    else
        ; warn "bad parameter for %L_SkinnyPlatform direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a wooden post object
; tileset must be 2 (rope/mushroom)
;         x: x position within the level
;         y: y position within the level
; direction:
;   "horizontal": left and right
;     "vertical": up and down
;    length: length of object in tiles (1-16)
macro L_WoodenPost(x, y, direction, length)
    assert equal(!__tileset,2) ;,"cannot insert WoodenPost, tileset must be 2 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","horizontal")
        %L_Object(<x>,<y>, 62, concat(0, <length>-1))
    elseif stringsequal("<direction>","vertical")
        %L_Object(<x>,<y>, 63, concat(<length>-1,0))
    else
        ; warn "bad parameter for %L_WoodenPost direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a purple triangle object
;         x: x position within the level
;         y: y position within the level
; direction:
;         "left": run to the right to go up
;        "right": run to the left to go up
macro L_PurpleTriangle(x, y, direction)
    if stringsequal("<direction>","left")
        %L_Object(<x>, <y>, 0, 68)
    elseif stringsequal("<direction>","right")
        %L_Object(<x>, <y>, 0, 69)
    else
        ; warn "bad parameter for %L_PurpleTriangle direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a wooden bonus room ledge object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_BonusLedge(x, y, length)
    assert equal(!__tileset,4) ;,"cannot insert BonusLedge, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 59, concat(0, <length>-1))
endmacro

; insert a bridge object
; tileset must be 2 (rope/mushroom) for log bridge
; log bridges came with an inherent height even though
; it doesn't do anything; need to include it to match
; the base game
;         x: x position within the level
;         y: y position within the level
;      type:
;        "donut": yellow donuts with rails
;          "log": wooden logs
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_Bridge(x, y, type, width, height)
    if stringsequal("<type>","donut")
        if not(equal(<height>,1))
            ; warn "bad parameter for donut %L_Bridge height, must be 1, was (",<height>,") at ",pc,", using 1 instead"
        endif
        %L_Object(<x>,<y>, 28, concat(0, <width>-1))
    elseif stringsequal("<type>","log")
        assert equal(!__tileset,2) ;,"cannot insert log Bridge, tileset must be 2 (was ",!__tileset,"), at ",pc
        %L_Object(<x>,<y>, 50, concat(<height>-1, <width>-1))
    else
        ; warn "bad parameter for %L_Bridge type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a plant pillar object
; tileset must be 2 (rope/mushroom)
;         x: x position within the level
;         y: y position within the level
;     color:
;        "green": green
;       "orange": orange
;       "yellow": yellow
;         "blue": blue
;    length: length of object in tiles (1-16)
macro L_PlantPillar(x, y, color, length)
    assert equal(!__tileset,2) ;,"cannot insert PlantPillar, tileset must be 2 (was ",!__tileset,"), at ",pc
    if stringsequal("<color>","green")
        %L_Object(<x>,<y>, 53, concat(<length>-1,0))
    elseif stringsequal("<color>","orange")
        %L_Object(<x>,<y>, 53, concat(<length>-1,1))
    elseif stringsequal("<color>","yellow")
        %L_Object(<x>,<y>, 53, concat(<length>-1,2))
    elseif stringsequal("<color>","blue")
        %L_Object(<x>,<y>, 53, concat(<length>-1,3))
    else
        ; warn "bad parameter for %L_PlantPillar color (",<color>,") at ",pc,", skipping"
    endif
endmacro

; insert a guide line object
; tileset must be 2 (rope/mushroom) for sloped and on/off line segments
; tileset must be 1 (castle) or 2 (rope/mushroom) for straight line segments
; length must be 1 for quarter circle line segments
;         x: x position within the level
;         y: y position within the level
;      type:
;   "horizontal": left to right segment
;     "vertical": top to bottom segment
;  "largecircle": 2x2 quarter circle
;  "smallcircle": 1x1 quarter circle
;      "slopeup": angled segments, bottom left to top right
;    "slopedown": angled segments, top left to bottom right
;      "onoffup": angled segments that react to ON/OFF block, bottom left to top right
;    "onoffdown": angled segments that react to ON/OFF block, top left to bottom right
; direction:
;           "up": segment on top of tile
;         "down": segment on bottom of tile
;         "left": segment on left of tile
;        "right": segment on right of tile
;       "upleft": top left quarter
;      "upright": top right quarter
;     "downleft": bottom left quarter
;    "downright": bottom right quarter
;       "normal": 2 across per 1 up
;        "steep": 1 across per 1 up
;    "verysteep": 1 across per 2 up
;    length: length of object in tiles (1-16)
macro L_GuideLine(x, y, type, direction, length)
    if stringsequal("<type>","horizontal")
        if equal(!__tileset,1)
            if stringsequal("<direction>","up")
                %L_Object(<x>,<y>, 55, concat(0, <length>-1))
            elseif stringsequal("<direction>","down")
                %L_Object(<x>,<y>, 55, concat(1, <length>-1))
            else
                ; warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
            endif
        elseif equal(!__tileset,2)
            if stringsequal("<direction>","up")
                %L_Object(<x>,<y>, 56, concat(0, <length>-1))
            elseif stringsequal("<direction>","down")
                %L_Object(<x>,<y>, 56, concat(1, <length>-1))
            else
                ; warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
            endif
        else
            error ; "cannot insert GuideLine, tileset must be 1-2 (was ",!__tileset,"), at ",pc
        endif
    elseif stringsequal("<type>","vertical")
        if equal(!__tileset,1)
            if stringsequal("<direction>","left")
                %L_Object(<x>,<y>, 56, concat(<length>-1,0))
            elseif stringsequal("<direction>","right")
                %L_Object(<x>,<y>, 56, concat(<length>-1,1))
            else
                ; warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
            endif
        elseif equal(!__tileset,2)
            if stringsequal("<direction>","left")
                %L_Object(<x>,<y>, 57, concat(<length>-1,0))
            elseif stringsequal("<direction>","right")
                %L_Object(<x>,<y>, 57, concat(<length>-1,1))
            else
                ; warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
            endif
        else
            error ; "cannot insert GuideLine, tileset must be 1-2 (was ",!__tileset,"), at ",pc
        endif
    elseif stringsequal("<type>","largecircle")
        if not(equal(<length>,1))
            ; warn "bad parameter for %L_GuideLine length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        if stringsequal("<direction>","upleft")
            %L_Object(<x>, <y>, 0, 77)
        elseif stringsequal("<direction>","upright")
            %L_Object(<x>, <y>, 0, 78)
        elseif stringsequal("<direction>","downleft")
            %L_Object(<x>, <y>, 0, 79)
        elseif stringsequal("<direction>","downright")
            %L_Object(<x>, <y>, 0, 80)
        else
            ; warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","smallcircle")
        if not(equal(<length>,1))
            ; warn "bad parameter for %L_GuideLine length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        if stringsequal("<direction>","upleft")
            %L_Object(<x>, <y>, 0, 81)
        elseif stringsequal("<direction>","upright")
            %L_Object(<x>, <y>, 0, 82)
        elseif stringsequal("<direction>","downleft")
            %L_Object(<x>, <y>, 0, 83)
        elseif stringsequal("<direction>","downright")
            %L_Object(<x>, <y>, 0, 84)
        else
            ; warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","slopeup")
        assert equal(!__tileset,2) ;,"cannot insert GuideLine, tileset must be 2 (was ",!__tileset,"), at ",pc
        if stringsequal("<direction>","normal")
            %L_Object(<x>,<y>, 58, concat(<length>-1,0))
        elseif stringsequal("<direction>","steep")
            %L_Object(<x>,<y>, 58, concat(<length>-1,1))
        elseif stringsequal("<direction>","verysteep")
            %L_Object(<x>,<y>, 59, concat(<length>-1,0))
        else
            ; warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","slopedown")
        assert equal(!__tileset,2) ;,"cannot insert GuideLine, tileset must be 2 (was ",!__tileset,"), at ",pc
        if stringsequal("<direction>","normal")
            %L_Object(<x>,<y>, 58, concat(<length>-1,2))
        elseif stringsequal("<direction>","steep")
            %L_Object(<x>,<y>, 58, concat(<length>-1,3))
        elseif stringsequal("<direction>","verysteep")
            %L_Object(<x>,<y>, 59, concat(<length>-1,1))
        else
            ; warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","onoffup")
        assert equal(!__tileset,2) ;,"cannot insert GuideLine, tileset must be 2 (was ",!__tileset,"), at ",pc
        %L_Object(<x>,<y>, 58, concat(<length>-1,4))
    elseif stringsequal("<type>","onoffdown")
        assert equal(!__tileset,2) ;,"cannot insert GuideLine, tileset must be 2 (was ",!__tileset,"), at ",pc
        %L_Object(<x>,<y>, 58, concat(<length>-1,5))
    else
        ; warn "bad parameter for %L_GuideLine type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert an end to a guide line object
;         x: x position within the level
;         y: y position within the level
; direction:
;   "horizontal": tile to terminate a horizontal guide line
;     "vertical": tile to terminate a vertical guide line
macro L_GuideLineEnd(x, y, direction)
    if stringsequal("<direction>","horizontal")
        %L_Object(<x>, <y>, 0, 85)
    elseif stringsequal("<direction>","vertical")
        %L_Object(<x>, <y>, 0, 86)
    else
        ; warn "bad parameter for %L_GuideLineEnd direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a mushroom top platform object
; tileset must be 2 (rope/mushroom)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_MushroomPlatform(x, y, length)
    assert equal(!__tileset,2) ;,"cannot insert MushroomPlatform, tileset must be 2 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 60, concat(0, <length>-1))
endmacro

; insert a mushroom support object
; tileset must be 2 (rope/mushroom)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_MushroomSupport(x, y, width, height)
    assert equal(!__tileset,2) ;,"cannot insert MushroomSupport, tileset must be 2 (was ",!__tileset,"), at ",pc
    if equal(<width>,1)
        ; special case for width == 1
        %L_Object(<x>,<y>, 57, concat(<height>-1,2))
    else
        ; technically can't place this object with width == 1
        ; but it glitches out anyway and wasn't used like that
        %L_Object(<x>,<y>, 61, concat(<height>-1,<width>-1))
    endif
endmacro

; insert a set of castle spikes object
; tileset must be 1 (castle)
;         x: x position within the level
;         y: y position within the level
; direction:
;           "up": pointing up
;         "down": pointing down
;         "left": pointing left
;        "right": pointing right
;    length: length of object in tiles (1-16)
macro L_CastleSpikes(x, y, direction, length)
    assert equal(!__tileset,1) ;,"cannot insert CastleSpikes, tileset must be 1 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","up")
        %L_Object(<x>,<y>, 62, concat(1, <length>-1))
    elseif stringsequal("<direction>","down")
        %L_Object(<x>,<y>, 62, concat(0, <length>-1))
    elseif stringsequal("<direction>","left")
        %L_Object(<x>,<y>, 63, concat(<length>-1,1))
    elseif stringsequal("<direction>","right")
        %L_Object(<x>,<y>, 63, concat(<length>-1,0))
    else
        ; warn "bad parameter for %L_CastleSpikes direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a castle column object
; unused object
; tileset must be 1 (castle)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_CastleColumn(x, y, length)
    assert equal(!__tileset,1) ;,"cannot insert CastleColumn, tileset must be 1 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 63, concat(<length>-1,2))
endmacro

; insert a large spiked crusher object
; tileset must be 1 (castle)
;         x: x position within the level
;         y: y position within the level
; direction:
;           "up": pointing up
;         "down": pointing down
;    length: length of object in tiles (1-16)
;            (tip doesn't count towards length)
macro L_SpikedCrusher(x, y, direction, length)
    assert equal(!__tileset,1) ;,"cannot insert SpikedCrusher, tileset must be 1 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","up")
        %L_Object(<x>,<y>, 54, concat(<length>-1,1))
    elseif stringsequal("<direction>","down")
        %L_Object(<x>,<y>, 54, concat(<length>-1,0))
    else
        ; warn "bad parameter for %L_SpikedCrusher direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a castle stone block object
; tileset must be 1 (castle)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_StoneBlock(x, y, width, height)
    assert equal(!__tileset,1) ;,"cannot insert StoneBlock, tileset must be 1 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 60, concat(<height>-1,<width>-1))
endmacro

; insert a climbing net object
; only top and bottom edge object can have width > 1
;         x: x position within the level
;         y: y position within the level
; direction:
;          "top": edge on the top
;       "bottom": edge on the bottom
;         "left": edge on the left
;        "right": edge on the right
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_ClimbingNet(x, y, direction, width, height)
    if stringsequal("<direction>","top")
        %L_Object(<x>,<y>, 27, concat(<height>-1,<width>-1))
    elseif stringsequal("<direction>","bottom")
        %L_Object(<x>,<y>, 29, concat(<height>-1,<width>-1))
    elseif stringsequal("<direction>","left")
        assert equal(<width>,1) ;,"cannot insert left ClimbingNet, width must be 1 (was ",<width>,"), at ",pc
        %L_Object(<x>,<y>, 30, concat(<height>-1,0))
    elseif stringsequal("<direction>","right")
        assert equal(<width>,1) ;,"cannot insert right ClimbingNet, width must be 1 (was ",<width>,"), at ",pc
        %L_Object(<x>,<y>, 30, concat(<height>-1,1))
    else
        ; warn "bad parameter for %L_ClimbingNet direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a climbing net door object
;         x: x position within the level
;         y: y position within the level
macro L_ClimbingNetDoor(x, y)
    %L_Object(<x>, <y>, 0, 74)
endmacro

; insert a set of arches object
; each support of the arches after the first adds 3 tiles horizontally
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in arches (0-15) (0 is glitched)
macro L_Arches(x, y, length)
    assert equal(!__tileset,0) ;,"cannot insert Arches, tileset must be 0 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 60, concat(0, <length>))
endmacro

; insert a set of canvases object
; tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in screens (1-16)
macro L_CanvasGrid(x, y, length)
    assert equal(!__tileset,3) ;,"cannot insert CanvasGrid, tileset must be 3 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 55, concat(0, <length>-1))
endmacro

; insert a single canvas object
;         x: x position within the level
;         y: y position within the level
;   pattern:
;          "big": big diamonds
;        "small": small diamonds
;      type:
;        "solid": the canvas is completely solid
;        "holes": the canvas has some holes in it
macro L_Canvas(x, y, pattern, type)
    if stringsequal("<pattern>","big")
        if stringsequal("<type>","solid")
            %L_Object(<x>, <y>, 0, 114)
        elseif stringsequal("<type>","holes")
            %L_Object(<x>, <y>, 0, 116)
        else
            ; warn "bad parameter for %L_Canvas type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<pattern>","small")
        if stringsequal("<type>","solid")
            %L_Object(<x>, <y>, 0, 113)
        elseif stringsequal("<type>","holes")
            %L_Object(<x>, <y>, 0, 115)
        else
            ; warn "bad parameter for %L_Canvas type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_Canvas pattern (",<pattern>,") at ",pc,", skipping"
    endif
endmacro

; insert a small canvas tile object
;         x: x position within the level
;         y: y position within the level
;   pattern:
;          "big": big diamonds
;        "small": small diamonds
;      edge:
;         "left": edge on the left
;         "none": no edges
;        "right": edge on the right
;      type:
;     "lefthole": left small diamond has a hole
;    "righthole": right small diamond has a hole
;      "tophalf": top half of big diamond with hole
;   "bottomhalf": bottom half of big diamonds with holes
;         "full": both halves of a big diamond with hole
macro L_CanvasTile(x, y, pattern, edge, type)
    if stringsequal("<pattern>","big")
        if stringsequal("<type>","tophalf")
            if stringsequal("<edge>","left")
                %L_Object(<x>, <y>, 0, 121)
            elseif stringsequal("<edge>","none")
                %L_Object(<x>, <y>, 0, 122)
            elseif stringsequal("<edge>","right")
                %L_Object(<x>, <y>, 0, 123)
            else
                ; warn "bad parameter for big tophalf %L_CanvasTile edge (",<edge>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<type>","bottomhalf")
            if stringsequal("<edge>","left")
                %L_Object(<x>, <y>, 0, 112)
            else
                ; warn "bad parameter for big bottomhalf %L_CanvasTile edge (",<edge>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<type>","full")
            if stringsequal("<edge>","left")
                %L_Object(<x>, <y>, 0, 124)
            elseif stringsequal("<edge>","none")
                %L_Object(<x>, <y>, 0, 125)
            elseif stringsequal("<edge>","right")
                %L_Object(<x>, <y>, 0, 126)
            else
                ; warn "bad parameter for big full %L_CanvasTile edge (",<edge>,") at ",pc,", skipping"
            endif
        else
            ; warn "bad parameter for big %L_CanvasTile type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<pattern>","small")
        if stringsequal("<type>","lefthole")
            if stringsequal("<edge>","none")
                %L_Object(<x>, <y>, 0, 117)
            elseif stringsequal("<edge>","right")
                %L_Object(<x>, <y>, 0, 120)
            else
                ; warn "bad parameter for small lefthole %L_CanvasTile edge (",<edge>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<type>","righthole")
            if stringsequal("<edge>","none")
                %L_Object(<x>, <y>, 0, 118)
            elseif stringsequal("<edge>","left")
                %L_Object(<x>, <y>, 0, 119)
            else
                ; warn "bad parameter for small righthole %L_CanvasTile edge (",<edge>,") at ",pc,", skipping"
            endif
        else
            ; warn "bad parameter for small %L_CanvasTile type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_CanvasTile pattern (",<pattern>,") at ",pc,", skipping"
    endif
endmacro

; insert a wooden crate object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_WoodenCrate(x, y, width, height)
    assert equal(!__tileset,4) ;,"cannot insert WoodenCrate, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 49, concat(<height>-1,<width>-1))
endmacro

; insert a wooden platform object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-48)
;    height: height of object in tiles (1-16)
;            if height == 1, width is limited to (1-16)
;            if height > 1, width is limited to multiples of 3
macro L_WoodenPlatform(x, y, width, height)
    assert equal(!__tileset,4) ;,"cannot insert WoodenPlatform, tileset must be 4 (was ",!__tileset,"), at ",pc
    if equal(<height>,1)
        ; special case for height == 1
        assert lessequal(<width>,16) ;,"cannot insert WoodenPlatform, width must be <= 16 (was ",<width>,"), at ",pc
        %L_Object(<x>,<y>, 56, concat(0, <width>-1))
    else
        if not(equal(mod(<width>,3),0))
            ; warn "bad parameter for %L_WoodenPlatform width, must be 0 mod 3, was (",<width>,") at ",pc,", using ",3*floor(<width>/3)
        endif
        ; technically can't place this object with height == 1
        ; but it glitches out anyway and wasn't used like that
        %L_Object(<x>,<y>, 52, concat(<height>-1,(<width>/3)-1))
    endif
endmacro

; insert a wooden support object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;      type:
;       "shadow": includes shadow at top
;        "plain": no shadow
;    length: length of object in tiles (1-16)
macro L_WoodenSupport(x, y, type, length)
    assert equal(!__tileset,4) ;,"cannot insert WoodenSupport, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal("<type>","shadow")
        %L_Object(<x>,<y>, 57, concat(<length>-1,1))
    elseif stringsequal("<type>","plain")
        %L_Object(<x>,<y>, 57, concat(<length>-1,2))
    else
        ; warn "bad parameter for %L_WoodenSupport type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a wooden brick wall object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
; direction:
;         "left": left half of wall
;        "right": right half of wall
;    length: length of object in tiles (1-16)
macro L_WoodenBrickWall(x, y, direction, length)
    assert equal(!__tileset,4) ;,"cannot insert WoodenBrickWall, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","left")
        %L_Object(<x>,<y>, 58, concat(<length>-1,0))
    elseif stringsequal("<direction>","right")
        %L_Object(<x>,<y>, 58, concat(<length>-1,1))
    else
        ; warn "bad parameter for %L_WoodenBrickWall direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a set of thin spikes object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
; direction:
;           "up": spikes pointing up
;         "left": spikes pointing left
;        "right": spikes pointing right
;    length: length of object in tiles (1-16)
macro L_ThinSpikes(x, y, direction, length)
    assert equal(!__tileset,4) ;,"cannot insert ThinSpikes, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","up")
        %L_Object(<x>,<y>, 46, concat(0, <length>-1))
    elseif stringsequal("<direction>","left")
        %L_Object(<x>,<y>, 58, concat(<length>-1,3))
    elseif stringsequal("<direction>","right")
        %L_Object(<x>,<y>, 58, concat(<length>-1,2))
    else
        ; warn "bad parameter for %L_ThinSpikes direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a ledge object
; if the width is > 16, height must be 3
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-256)
;    height: height of object in tiles (1-16)
macro L_Ledge(x, y, width, height)
    if greater(<width>,16)
        assert equal(<height>,3) ;,"cannot insert Ledge, when width is > 16, height must be 3 (was ",<height>,"), at ",pc
        %L_Object(<x>,<y>, 33,  <width>-1)
    else
        %L_Object(<x>,<y>, 20, concat(<height>-1,<width>-1))
    endif
endmacro

; insert a ceiling object
; tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_Ceiling(x, y, width, height)
    assert equal(!__tileset,3) ;,"cannot insert Ceiling, tileset must be 3 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 61, concat(<height>-1,<width>-1))
endmacro

; insert a ledge bacgkround object
; if solid, tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
;      type:
;         "open": intangible
;        "solid": solid
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_LedgeBackground(x, y, type, width, height)
    if stringsequal("<type>","open")
        %L_Object(<x>,<y>, 6, concat(<height>-1,<width>-1))
    elseif stringsequal("<type>","solid")
        assert equal(!__tileset,3) ;,"cannot insert solid LedgeBackground, tileset must be 3 (was ",!__tileset,"), at ",pc
        %L_Object(<x>,<y>, 63, concat(<height>-1,<width>-1))
    else
        ; warn "bad parameter for %L_LedgeBackground type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a ledge edge object
; if bottom or nonealt, tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
;      type:
;         "open": side is intangible
;        "solid": side is solid
; direction:
;         "left": edge is on the left
;        "right": edge is on the right
;      ends:
;         "none": no top or bottom edge
;          "top": top edge to make an outer corner
;   "steepslope": top sloped edge to make a very steep slope corner
;        "inner": no top edge, bottom has inner corner edge
;     "topinner": top edge, bottom has inner corner edge
;       "bottom": bottom edge to make an outer corner
;      "nonealt": same as none, but graphically upsidedown
;    length: length of object in tiles (1-16)
;            inner and topinner are one tile longer (the inner corner tile)
macro L_LedgeEdge(x, y, type, direction, ends, length)
    if stringsequal("<type>","open")
        if stringsequal("<direction>","left")
            if stringsequal("<ends>","none")
                %L_Object(<x>,<y>, 19, concat(<length>-1,0))
            elseif stringsequal("<ends>","top")
                %L_Object(<x>,<y>, 19, concat(<length>-1,7))
            else
                ; warn "bad parameter for %L_LedgeEdge open ends (",<ends>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<direction>","right")
            if stringsequal("<ends>","none")
                %L_Object(<x>,<y>, 19, concat(<length>-1,1))
            elseif stringsequal("<ends>","top")
                %L_Object(<x>,<y>, 19, concat(<length>-1,8))
            else
                ; warn "bad parameter for %L_LedgeEdge open ends (",<ends>,") at ",pc,", skipping"
            endif
        else
            ; warn "bad parameter for %L_LedgeEdge direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","solid")
        if stringsequal("<direction>","left")
            if stringsequal("<ends>","none")
                %L_Object(<x>,<y>, 19, concat(<length>-1,4))
            elseif stringsequal("<ends>","top")
                %L_Object(<x>,<y>, 19, concat(<length>-1,3))
            elseif stringsequal("<ends>","steepslope")
                %L_Object(<x>,<y>, 19, concat(<length>-1,9))
            elseif stringsequal("<ends>","topinner")
                %L_Object(<x>,<y>, 19, concat(<length>-1,11))
            elseif stringsequal("<ends>","inner")
                %L_Object(<x>,<y>, 19, concat(<length>-1,12))
            elseif stringsequal("<ends>","bottom")
                assert equal(!__tileset,3) ;,"cannot insert solid bottom LedgeEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
                %L_Object(<x>,<y>, 62, concat(<length>-1,0))
            elseif stringsequal("<ends>","nonealt")
                assert equal(!__tileset,3) ;,"cannot insert solid nonealt LedgeEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
                %L_Object(<x>,<y>, 62, concat(<length>-1,1))
            else
                ; warn "bad parameter for %L_LedgeEdge solid ends (",<ends>,") at ",pc,", skipping"
            endif
        elseif stringsequal("<direction>","right")
            if stringsequal("<ends>","none")
                %L_Object(<x>,<y>, 19, concat(<length>-1,6))
            elseif stringsequal("<ends>","top")
                %L_Object(<x>,<y>, 19, concat(<length>-1,5))
            elseif stringsequal("<ends>","steepslope")
                %L_Object(<x>,<y>, 19, concat(<length>-1,10))
            elseif stringsequal("<ends>","topinner")
                %L_Object(<x>,<y>, 19, concat(<length>-1,13))
            elseif stringsequal("<ends>","inner")
                %L_Object(<x>,<y>, 19, concat(<length>-1,14))
            elseif stringsequal("<ends>","bottom")
                assert equal(!__tileset,3) ;,"cannot insert solid bottom LedgeEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
                %L_Object(<x>,<y>, 62, concat(<length>-1,2))
            elseif stringsequal("<ends>","nonealt")
                assert equal(!__tileset,3) ;,"cannot insert solid nonealt LedgeEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
                %L_Object(<x>,<y>, 62, concat(<length>-1,3))
            else
                ; warn "bad parameter for %L_LedgeEdge solid ends (",<ends>,") at ",pc,", skipping"
            endif
        else
            ; warn "bad parameter for %L_LedgeEdge direction (",<direction>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_LedgeEdge type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a forest ledge object
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_ForestLedge(x, y, width, height)
    assert equal(!__tileset,0) ;,"cannot insert ForestLedge, tileset must be 0 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 53, concat(<height>-1,<width>-1))
endmacro

; insert a forest ledge edge object
;         x: x position within the level
;         y: y position within the level
;      type:
;         "open": side is intangible
;        "solid": side is solid
; direction:
;         "left": edge is on the left
;        "right": edge is on the right
;    length: length of object in tiles (1-16)
macro L_ForestLedgeEdge(x, y, type, direction, length)
    assert equal(!__tileset,0) ;,"cannot insert ForestLedgeEdge, tileset must be 0 (was ",!__tileset,"), at ",pc
    if stringsequal("<type>","open")
        if stringsequal("<direction>","left")
            %L_Object(<x>,<y>, 52, concat(<length>-1,3))
        elseif stringsequal("<direction>","right")
            %L_Object(<x>,<y>, 52, concat(<length>-1,2))
        else
            ; warn "bad parameter for %L_ForestLedgeEdge direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","solid")
        if stringsequal("<direction>","left")
            %L_Object(<x>,<y>, 52, concat(<length>-1,0))
        elseif stringsequal("<direction>","right")
            %L_Object(<x>,<y>, 52, concat(<length>-1,1))
        else
            ; warn "bad parameter for %L_ForestLedgeEdge direction (",<direction>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_ForestLedgeEdge type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a special ledge object
; for castle, tileset must be 1 (castle) and height must be 2
; otherwise, tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;      type:
;       "castle": used in castle entrance cutscene
;  "yoshishouse": used in yoshi's house
;   "ghosthouse": used in ghost house entrance and exit
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_SpecialLedge(x, y, type, width, height)
    if stringsequal("<type>","castle")
        assert equal(!__tileset,1) ;,"cannot insert castle SpecialLedge, tileset must be 1 (was ",!__tileset,"), at ",pc
        assert equal(<height>,2) ;,"cannot insert castle SpecialLedge, height must be 2 (was ",<height>,"), at ",pc
        %L_Object(<x>,<y>, 59, concat(<height>-1, <width>-1))
    elseif stringsequal("<type>","yoshishouse")
        assert equal(!__tileset,4) ;,"cannot insert castle SpecialLedge, tileset must be 4 (was ",!__tileset,"), at ",pc
        %L_Object(<x>,<y>, 48, concat(<height>-1,<width>-1))
    elseif stringsequal("<type>","ghosthouse")
        assert equal(!__tileset,4) ;,"cannot insert castle SpecialLedge, tileset must be 4 (was ",!__tileset,"), at ",pc
        %L_Object(<x>,<y>, 50, concat(<height>-1,<width>-1))
    else
        ; warn "bad parameter for %L_SpecialLedge type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a ledge inner corner tile object
;         x: x position within the level
;         y: y position within the level
; direction:
;       "upleft": corner bit is in the bottom right
;      "upright": corner bit is in the bottom left
;     "downleft": corner bit is in the top right
;    "downright": corner bit is in the top left
;      type:
;        "inset": used to make an inset ledge (mostly unused)
;       "normal": used for a normal 2:1 slope
;        "steep": used for a 90 degree corner or steep slope
;      "gradual": used for a gradual 4:1 slope (2 tiles big)
macro L_LedgeInnerCorner(x, y, direction, type)
    if stringsequal("<direction>","upleft")
        if stringsequal("<type>","steep")
            %L_Object(<x>, <y>, 0, 63)
        else
            ; warn "bad parameter for upleft %L_LedgeInnerCorner type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","upright")
        if stringsequal("<type>","steep")
            %L_Object(<x>, <y>, 0, 62)
        else
            ; warn "bad parameter for upright %L_LedgeInnerCorner type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","downleft")
        if stringsequal("<type>","inset")
            %L_Object(<x>, <y>, 0, 20)
        elseif stringsequal("<type>","normal")
            %L_Object(<x>, <y>, 0, 59)
        elseif stringsequal("<type>","steep")
            %L_Object(<x>, <y>, 0, 61)
        elseif stringsequal("<type>","gradual")
            %L_Object(<x>, <y>, 0, 67)
        else
            ; warn "bad parameter for downleft %L_LedgeInnerCorner type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","downright")
        if stringsequal("<type>","inset")
            %L_Object(<x>, <y>, 0, 19)
        elseif stringsequal("<type>","normal")
            %L_Object(<x>, <y>, 0, 58)
        elseif stringsequal("<type>","steep")
            %L_Object(<x>, <y>, 0, 60)
        elseif stringsequal("<type>","gradual")
            %L_Object(<x>, <y>, 0, 66)
        else
            ; warn "bad parameter for downright %L_LedgeInnerCorner type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_LedgeInnerCorner direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a rectangular ledge object
; tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_LedgeRectangle(x, y, width, height)
    assert equal(!__tileset,3) ;,"cannot insert LedgeRectangle, tileset must be 3 (was ",!__tileset,"), at ",pc
    %L_Object(<x>,<y>, 54, concat(<height>-1,<width>-1))
endmacro

; insert a slope object
; for verysteep, tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
; direction:
;           "up": bottom left to top right
;         "down": top left to bottom right
;      type:
;      "gradual": across 4 tiles for every 1 tile up/down
;       "normal": across 2 tiles for every 1 tile up/down
;        "steep": across 1 tile for every 1 tile up/down
;    "verysteep": across 1 tile for every 2 tiles up/down
;    length: length of object in tiles (1-16)
macro L_Slope(x, y, direction, type, length)
    if stringsequal("<direction>","up")
        if stringsequal("<type>","gradual")
            %L_Object(<x>,<y>, 18, concat(<length>-1,2))
        elseif stringsequal("<type>","normal")
            %L_Object(<x>,<y>, 18, concat(<length>-1,0))
        elseif stringsequal("<type>","steep")
            %L_Object(<x>,<y>, 18, concat(<length>-1,1))
        elseif stringsequal("<type>","verysteep")
            assert equal(!__tileset,3) ;,"cannot insert verysteep Slope, tileset must be 3 (was ",!__tileset,"), at ",pc
            %L_Object(<x>,<y>, 60, concat(0,<length>-1))
        else
            ; warn "bad parameter for up %L_Slope type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","down")
        if stringsequal("<type>","gradual")
            %L_Object(<x>,<y>, 18, concat(<length>-1,5))
        elseif stringsequal("<type>","normal")
            %L_Object(<x>,<y>, 18, concat(<length>-1,3))
        elseif stringsequal("<type>","steep")
            %L_Object(<x>,<y>, 18, concat(<length>-1,4))
        elseif stringsequal("<type>","verysteep")
            assert equal(!__tileset,3) ;,"cannot insert verysteep Slope, tileset must be 3 (was ",!__tileset,"), at ",pc
            %L_Object(<x>,<y>, 60, concat(1,<length>-1))
        else
            ; warn "bad parameter for down %L_Slope type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_Slope direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a special slope object
; used for slopes that cross vertical screne boundaries in vertical levles
;         x: x position within the level
;         y: y position within the level
; direction:
;           "up": bottom left to top right
;         "down": top left to bottom right
;      type:
;       "normal": across 2 tiles for every 1 tile up/down
;        "steep": across 1 tile for every 1 tile up/down
;    "verysteep": across 1 tile for every 2 tiles up/down
macro L_SpecialSlope(x, y, direction, type)
    if stringsequal("<direction>","up")
        if stringsequal("<type>","normal")
            %L_Object(<x>, <y>, 0, 147)
        elseif stringsequal("<type>","steep")
            %L_Object(<x>, <y>, 0, 145)
        elseif stringsequal("<type>","verysteep")
            %L_Object(<x>, <y>, 0, 149)
        else
            ; warn "bad parameter for up %L_SpecialSlope type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","down")
        if stringsequal("<type>","normal")
            %L_Object(<x>, <y>, 0, 148)
        elseif stringsequal("<type>","steep")
            %L_Object(<x>, <y>, 0, 146)
        elseif stringsequal("<type>","verysteep")
            %L_Object(<x>, <y>, 0, 150)
        else
            ; warn "bad parameter for down %L_SpecialSlope type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_SpecialSlope direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a ceiling slope object
;         x: x position within the level
;         y: y position within the level
; direction:
;           "up": bottom left to top right
;         "down": top left to bottom right
;      type:
;       "normal": across 2 tiles for every 1 tile up/down
;        "steep": across 1 tile for every 1 tile up/down
;    length: length of object in tiles (1-16)
macro L_CeilingSlope(x, y, direction, type, length)
    if stringsequal("<direction>","up")
        if stringsequal("<type>","normal")
            %L_Object(<x>,<y>, 18, concat(<length>-1,7))
        elseif stringsequal("<type>","steep")
            %L_Object(<x>,<y>, 18, concat(<length>-1,9))
        else
            ; warn "bad parameter for up %L_CeilingSlope type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","down")
        if stringsequal("<type>","normal")
            %L_Object(<x>,<y>, 18, concat(<length>-1,6))
        elseif stringsequal("<type>","steep")
            %L_Object(<x>,<y>, 18, concat(<length>-1,8))
        else
            ; warn "bad parameter for down %L_CeilingSlope type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_CeilingSlope direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a diagonal ledge object
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
; direction:
;         "left": platform protrudes up and left
;        "right": platform protrudes up and right
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_DiagonalLedge(x, y, direction, width, height)
    assert equal(!__tileset,0) ;,"cannot insert DiagonalLedge, tileset must be 0 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","left")
        %L_Object(<x>,<y>, 58, concat(<height>-1,<width>-1))
    elseif stringsequal("<direction>","right")
        %L_Object(<x>,<y>, 59, concat(<height>-1,<width>-1))
    else
        ; warn "bad parameter for %L_DiagonalLedge direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert an escalator object
; tileset must be 1 (castle)
;         x: x position within the level
;         y: y position within the level
; direction:
;           "up": bottom left to top right
;         "down": top left to bottom right
;    stairs:
;      "goingup": stairs move you up
;    "goingdown": stairs move you down
;    length: length of object in tiles (1-16)
macro L_Escalator(x, y, direction, stairs, length)
    assert equal(!__tileset,1) ;,"cannot insert Escalator, tileset must be 1 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","up")
        if stringsequal("<stairs>","goingup")
            %L_Object(<x>,<y>, 61, concat(<length>-1,0))
        elseif stringsequal("<stairs>","goingdown")
            %L_Object(<x>,<y>, 61, concat(<length>-1,1))
        else
            ; warn "bad parameter for up %L_Escalator stairs (",<stairs>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","down")
        if stringsequal("<stairs>","goingup")
            %L_Object(<x>,<y>, 61, concat(<length>-1,3))
        elseif stringsequal("<stairs>","goingdown")
            %L_Object(<x>,<y>, 61, concat(<length>-1,2))
        else
            ; warn "bad parameter for down %L_Escalator stairs (",<stairs>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_Escalator direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a rope converyor object
; tileset must be 2 (rope/mushroom)
;         x: x position within the level
;         y: y position within the level
; direction:
;           "up": bottom left to top right
;         "down": top left to bottom right
;   "horizontal": just left to right
;    moving:
;    "goingleft": moves you left
;   "goingright": moves you right
;    length: length of object in tiles (1-16)
macro L_RopeConveyor(x, y, direction, moving, length)
    assert equal(!__tileset,2) ;,"cannot insert RopeConveyor, tileset must be 2 (was ",!__tileset,"), at ",pc
    if stringsequal("<direction>","up")
        if stringsequal("<moving>","goingleft")
            %L_Object(<x>,<y>, 55, concat(<height>-1,1))
        elseif stringsequal("<moving>","goingright")
            %L_Object(<x>,<y>, 55, concat(<height>-1,0))
        else
            ; warn "bad parameter for up %L_RopeConveyor moving (",<moving>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","down")
        if stringsequal("<moving>","goingleft")
            %L_Object(<x>,<y>, 55, concat(<height>-1,3))
        elseif stringsequal("<moving>","goingright")
            %L_Object(<x>,<y>, 55, concat(<height>-1,2))
        else
            ; warn "bad parameter for down %L_RopeConveyor moving (",<moving>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","horizontal")
        if stringsequal("<moving>","goingleft")
            %L_Object(<x>,<y>, 54, concat(<height>-1,1))
        elseif stringsequal("<moving>","goingright")
            %L_Object(<x>,<y>, 54, concat(<height>-1,0))
        else
            ; warn "bad parameter for horizontal %L_RopeConveyor moving (",<moving>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %L_RopeConveyor direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a generic level sprite
;         x: x position within the level
;         y: y position within the level
;       spr: ID of the sprite (0-255)
;  settings: 2-bit settings which depends on the object
macro S_Sprite(x, y, spr, settings)
    if !__vertical
        db (<x><<4)|((<settings>&3)<<2)|((<y>>>7)&2)|((<x>>>4)&1)
        db (<y><<4)|((<y>>>4)&$F)
    else
        db (<y><<4)|((<settings>&3)<<2)|((<x>>>7)&2)|((<y>>>4)&1)
        db (<x><<4)|((<x>>>4)&$F)
    endif
    db <spr>
endmacro

; insert primary sprite header and prepare inserting new sprites
;     buoy1: buoyancy flag; sprites interact with water
;     buoy2: buoyancy flag; sprites only interact with water on layers 2/3
;       mem: sprite slot memory setting (0-18)
;      vert: vertical level flag (not used, but for placing sprites correctly
macro S_Header(buoy1, buoy2, mem, vert)
    db ((<buoy1>&1)<<7)|((<buoy2>&1)<<6)|(<mem>&$3F)
    !__vertical = stringsequal("<vert>","vertical")
endmacro

; insert end of sprite data marker
macro S_End()
    db $FF
endmacro

; insert a koopa sprite
; green and red non-winged koopas turn yellow and blue after special
;         x: x position within the level
;         y: y position within the level
;     color:
;        "green": green
;          "red": red
;         "blue": blue
;       "yellow": yellow
;      type:
;    "shellless": naked koopa
;       "normal": standard koopa
;      "flyleft": green koopa flies left only
;      "boucing": green koopa that jumps
; "flyleftright": red koopa that flies
;    "flyupdown": red koopa that flies
;       "winged": yellow koopa that walks
;      "sliding": blue koopa that slides
;        "shell": shell only
;       "shell2": green shell that stays green after special
macro S_Koopa(x, y, color, type)
    if stringsequal("<color>","green")
        if stringsequal("<type>","shellless")
            %S_Sprite(<x>,<y>, 0, 0)
        elseif stringsequal("<type>","normal")
            %S_Sprite(<x>,<y>, 4, 0)
        elseif stringsequal("<type>","flyleft")
            %S_Sprite(<x>,<y>, 8, 0)
        elseif stringsequal("<type>","bouncing")
            %S_Sprite(<x>,<y>, 9, 0)
        elseif stringsequal("<type>","shell")
            %S_Sprite(<x>,<y>, 218, 0)
        elseif stringsequal("<type>","shell2")
            %S_Sprite(<x>,<y>, 223, 0)
        else
            ; warn "bad parameter for green %S_Koopa type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<color>","red")
        if stringsequal("<type>","shellless")
            %S_Sprite(<x>,<y>, 1, 0)
        elseif stringsequal("<type>","normal")
            %S_Sprite(<x>,<y>, 5, 0)
        elseif stringsequal("<type>","flyupdown")
            %S_Sprite(<x>,<y>, 10, 0)
        elseif stringsequal("<type>","flyleftright")
            %S_Sprite(<x>,<y>, 11, 0)
        elseif stringsequal("<type>","shell")
            %S_Sprite(<x>,<y>, 219, 0)
        else
            ; warn "bad parameter for red %S_Koopa type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<color>","blue")
        if stringsequal("<type>","shellless")
            %S_Sprite(<x>,<y>, 2, 0)
        elseif stringsequal("<type>","normal")
            %S_Sprite(<x>,<y>, 6, 0)
        elseif stringsequal("<type>","sliding")
            %S_Sprite(<x>,<y>, 189, 0)
        elseif stringsequal("<type>","shell")
            %S_Sprite(<x>,<y>, 220, 0)
        else
            ; warn "bad parameter for blue %S_Koopa type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<color>","yellow")
        if stringsequal("<type>","shellless")
            %S_Sprite(<x>,<y>, 3, 0)
        elseif stringsequal("<type>","normal")
            %S_Sprite(<x>,<y>, 7, 0)
        elseif stringsequal("<type>","winged")
            %S_Sprite(<x>,<y>, 12, 0)
        elseif stringsequal("<type>","shell")
            %S_Sprite(<x>,<y>, 221, 0)
        else
            ; warn "bad parameter for yellow %S_Koopa type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_Koopa color (",<color>,") at ",pc,", skipping"
    endif
endmacro

; insert a climing net koopa sprite
; type is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;     color:
;        "green": green
;          "red": red
; direction:
;       "updown": vertical
;    "leftright": horizontal
;      type:
;   "foreground": in front of the net
;   "background": behind the net
macro S_NetKoopa(x, y, color, direction, type)
    if and(equal(<x>&1,0),not(stringsequal("<type>","foreground")))
        ; warn "NetKoopa will not match type, will be foreground (was ",<type>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<type>","background")))
        ; warn "NetKoopa will not match type, will be background (was ",<type>,"), at ",pc
    endif
    if stringsequal("<direction>","updown")
        if stringsequal("<color>","green")
            %S_Sprite(<x>,<y>, 34, 0)
        elseif stringsequal("<color>","red")
            %S_Sprite(<x>,<y>, 35, 0)
        else
            ; warn "bad parameter for updown %S_NetKoopa color (",<color>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","leftright")
        if stringsequal("<color>","green")
            %S_Sprite(<x>,<y>, 36, 0)
        elseif stringsequal("<color>","red")
            %S_Sprite(<x>,<y>, 37, 0)
        else
            ; warn "bad parameter for leftright %S_NetKoopa color (",<color>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_NetKoopa direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a bob-omb sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;       "normal": walking
;    "parachute": falling with parachute
macro S_Bobomb(x, y, type)
    if stringsequal("<type>","normal")
        %S_Sprite(<x>,<y>, 13, 0)
    elseif stringsequal("<type>","parachute")
        %S_Sprite(<x>,<y>, 64, 0)
    else
        ; warn "bad parameter for %S_Bombomb type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a keyhole sprite
;         x: x position within the level
;         y: y position within the level
macro S_Keyhole(x, y)
    %S_Sprite(<x>,<y>, 14, 0)
endmacro

; insert a goomba sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;       "normal": walking
;       "winged": jumping with wings
;    "parachute": falling with parachute
macro S_Goomba(x, y, type)
    if stringsequal("<type>","normal")
        %S_Sprite(<x>,<y>, 15, 0)
    elseif stringsequal("<type>","winged")
        %S_Sprite(<x>,<y>, 16, 0)
    elseif stringsequal("<type>","parachute")
        %S_Sprite(<x>,<y>, 63, 0)
    else
        ; warn "bad parameter for %S_Goomba type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a buzzy beetle sprite
;         x: x position within the level
;         y: y position within the level
macro S_BuzzyBeetle(x, y)
    %S_Sprite(<x>,<y>, 17, 0)
endmacro

; insert a spiny sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;      "walking": walking
;      "falling": balled up and falling
macro S_Spiny(x, y, type)
    if stringsequal("<type>","walking")
        %S_Sprite(<x>,<y>, 19, 0)
    elseif stringsequal("<type>","falling")
        %S_Sprite(<x>,<y>, 20, 0)
    else
        ; warn "bad parameter for %S_Spiny type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a cheep cheep sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;    "swimupdown": up and down in water, flopping out of water
; "swimleftright": left and rigth in water, flopping out of water
;        "flying": big arc through the sky
;      "skipping": swimming left and jumping small and big
;       "jumping": swimming back and forth and jumping
macro S_CheepCheep(x, y, type)
    if stringsequal("<type>","swimupdown")
        %S_Sprite(<x>,<y>, 21, 0)
    elseif stringsequal("<type>","swimleftright")
        %S_Sprite(<x>,<y>, 22, 0)
    elseif stringsequal("<type>","flying")
        %S_Sprite(<x>,<y>, 23, 0)
    elseif stringsequal("<type>","skipping")
        %S_Sprite(<x>,<y>, 24, 0)
    elseif stringsequal("<type>","jumping")
        %S_Sprite(<x>,<y>, 71, 0)
    else
        ; warn "bad parameter for %S_CheepCheep type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert an instant text box sprite
; spawns the intro message immediately
;         x: x position within the level
;         y: y position within the level
macro S_InstantTextBox(x, y)
    %S_Sprite(<x>,<y>, 25, 0)
endmacro

; insert a piranha plant sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;        "pipeup": coming out of pipe pointing up
;      "pipedown": coming out of pipe pointing down
;       "jumping": jumping out of a pipe
;   "jumpingfire": jumping out of a pipe spitting fire
macro S_PiranhaPlant(x, y, type)
    if stringsequal("<type>","pipeup")
        %S_Sprite(<x>,<y>, 26, 0)
    elseif stringsequal("<type>","pipedown")
        %S_Sprite(<x>,<y>, 42, 0)
    elseif stringsequal("<type>","jumping")
        %S_Sprite(<x>,<y>, 79, 0)
    elseif stringsequal("<type>","jumpingfire")
        %S_Sprite(<x>,<y>, 80, 0)
    else
        ; warn "bad parameter for %S_PiranhaPlant type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a football sprite
; spawns the intro message immediately
;         x: x position within the level
;         y: y position within the level
macro S_Football(x, y)
    %S_Sprite(<x>,<y>, 27, 0)
endmacro

; insert a bullet bill sprite
; spawns the intro message immediately
;         x: x position within the level
;         y: y position within the level
macro S_BulletBill(x, y)
    %S_Sprite(<x>,<y>, 28, 0)
endmacro

; insert a hopping flame sprite
; spawns the intro message immediately
;         x: x position within the level
;         y: y position within the level
macro S_HoppingFlame(x, y)
    %S_Sprite(<x>,<y>, 29, 0)
endmacro

; insert a lakitu sprite
; type is dependent on x pos mod 2 if not pipe
;         x: x position within the level
;         y: y position within the level
;      type:
;       "normal": in a cloud
;      "fishing": in a cloud with fishing pole
;         "pipe": in a pipe
macro S_Lakitu(x, y, type)
    if stringsequal("<type>","pipe")
        %S_Sprite(<x>,<y>, 75, 0)
    elseif or(stringsequal("<type>","normal"),stringsequal("<type>","fishing"))
        if and(equal(<x>&1,0),not(stringsequal("<type>","normal")))
            ; warn "Lakitu will not match type, will be normal (was ",<type>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<type>","fishing")))
            ; warn "Lakitu will not match type, will be fishing (was ",<type>,"), at ",pc
        endif
        %S_Sprite(<x>,<y>, 30, 0)
    else
        ; warn "bad parameter for %S_Lakitu type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a magikoopa sprite
;         x: x position within the level
;         y: y position within the level
macro S_Magikoopa(x, y)
    %S_Sprite(<x>,<y>, 31, 0)
endmacro

; insert a magikoopa's magic sprite
;         x: x position within the level
;         y: y position within the level
macro S_Magic(x, y)
    %S_Sprite(<x>,<y>, 32, 0)
endmacro

; insert a moving coin sprite
;         x: x position within the level
;         y: y position within the level
macro S_Coin(x, y)
    %S_Sprite(<x>,<y>, 33, 0)
endmacro

; insert a thwomp sprite
;         x: x position within the level
;         y: y position within the level
macro S_Thwomp(x, y)
    %S_Sprite(<x>,<y>, 38, 0)
endmacro

; insert a thwimp sprite
;         x: x position within the level
;         y: y position within the level
macro S_Thwimp(x, y)
    %S_Sprite(<x>,<y>, 39, 0)
endmacro

; insert a big boo sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;        "normal": standard big boo
;          "boss": boss fight
macro S_BigBoo(x, y, type)
    if stringsequal("<type>","normal")
        %S_Sprite(<x>,<y>, 40, 0)
    elseif stringsequal("<type>","boss")
        %S_Sprite(<x>,<y>, 197, 0)
    else
        ; warn "bad parameter for %S_BigBoo type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a koopaling sprite
; type is dependent on y pos
;         x: x position within the level
;         y: y position within the level
;      type:
;         "iggy": iggy koopa
;       "morton": morton koopa
;        "lemmy": lemmy koopa
;       "ludwig": ludwig von koopa
;          "roy": roy koopa
;        "wendy": wendy o koopa
;        "larry": larry koopa
macro S_Koopaling(x, y, type)
    if and(equal(<y>,0),not(stringsequal("<type>","morton")))
        ; warn "Koopaling will not match type, will be morton (was ",<type>,"), at ",pc
    elseif and(equal(<y>,1),not(stringsequal("<type>","roy")))
        ; warn "Koopaling will not match type, will be roy (was ",<type>,"), at ",pc
    elseif and(equal(<y>,2),not(stringsequal("<type>","ludwig")))
        ; warn "Koopaling will not match type, will be ludwig (was ",<type>,"), at ",pc
    elseif and(equal(<y>,3),not(stringsequal("<type>","iggy")))
        ; warn "Koopaling will not match type, will be iggy (was ",<type>,"), at ",pc
    elseif and(equal(<y>,4),not(stringsequal("<type>","larry")))
        ; warn "Koopaling will not match type, will be larry (was ",<type>,"), at ",pc
    elseif and(equal(<y>,5),not(stringsequal("<type>","lemmy")))
        ; warn "Koopaling will not match type, will be lemmy (was ",<type>,"), at ",pc
    elseif and(equal(<y>,6),not(stringsequal("<type>","wendy")))
        ; warn "Koopaling will not match type, will be wendy (was ",<type>,"), at ",pc
    endif
    if or(stringsequal("<type>","iggy"),or(stringsequal("<type>","morton"),or(stringsequal("<type>","lemmy"),or(stringsequal("<type>","ludwig"),or(stringsequal("<type>","roy"),or(stringsequal("<type>","wendy"),stringsequal("<type>","larry")))))))
        %S_Sprite(<x>,<y>, 41, 0)
    else
        ; warn "bad parameter for %S_Koopaling type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a sumo bro lightning sprite
;         x: x position within the level
;         y: y position within the level
macro S_SumoLightning(x, y)
    %S_Sprite(<x>,<y>, 43, 0)
endmacro

; insert a yoshi egg sprite
; color is dependent on x pos mod 4
;         x: x position within the level
;         y: y position within the level
;     color:
;          "red": iggy koopa
;         "blue": morton koopa
;       "yellow": lemmy koopa
macro S_YoshiEgg(x, y, color)
    if and(equal(<x>&3,0),not(stringsequal("<color>","red")))
        ; warn "YoshiEgg will not match color, will be red (was ",<color>,"), at ",pc
    elseif and(equal(<x>&3,2),not(stringsequal("<color>","yellow")))
        ; warn "YoshiEgg will not match color, will be yellow (was ",<color>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<color>","blue")))
        ; warn "Koopaling will not match color, will be blue (was ",<color>,"), at ",pc
    endif
    if or(stringsequal("<color>","red"),or(stringsequal("<color>","yellow"),stringsequal("<color>","blue")))
        %S_Sprite(<x>,<y>, 44, 0)
    else
        ; warn "bad parameter for %S_YoshiEgg color (",<color>,") at ",pc,", skipping"
    endif
endmacro

; insert a baby yoshi sprite
;         x: x position within the level
;         y: y position within the level
macro S_BabyYoshi(x, y)
    %S_Sprite(<x>,<y>, 45, 0)
endmacro

; insert a yoshi sprite
;         x: x position within the level
;         y: y position within the level
macro S_Yoshi(x, y)
    %S_Sprite(<x>,<y>, 53, 0)
endmacro

; insert a spiketop sprite
;         x: x position within the level
;         y: y position within the level
macro S_SpikeTop(x, y)
    %S_Sprite(<x>,<y>, 46, 0)
endmacro

; insert a springboard sprite
;         x: x position within the level
;         y: y position within the level
macro S_Springboard(x, y)
    %S_Sprite(<x>,<y>, 47, 0)
endmacro

; insert a dry bones sprite
; note that dry bones in bowsers castle will always throw bones and stay on ledges
;         x: x position within the level
;         y: y position within the level
;      type:
;        "throws": throws bones
;        "ledges": stays on ledges
macro S_DryBones(x, y, type)
    if stringsequal("<type>","throws")
        %S_Sprite(<x>,<y>, 48, 0)
    elseif stringsequal("<type>","ledges")
        %S_Sprite(<x>,<y>, 50, 0)
    else
        ; warn "bad parameter for %S_DryBones type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a bony beetle sprite
;         x: x position within the level
;         y: y position within the level
macro S_BonyBeetle(x, y)
    %S_Sprite(<x>,<y>, 49, 0)
endmacro

; insert a podoboo sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;       "jumping": jumps out of lava
;      "bouncing": bounces against walls
macro S_Podoboo(x, y, type)
    if stringsequal("<type>","jumping")
        %S_Sprite(<x>,<y>, 51, 0)
    elseif stringsequal("<type>","bouncing")
        %S_Sprite(<x>,<y>, 182, 0)
    else
        ; warn "bad parameter for %S_Podoboo type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a boo sprite
;         x: x position within the level
;         y: y position within the level
macro S_Boo(x, y)
    %S_Sprite(<x>,<y>, 55, 0)
endmacro

; insert a stationary fireball from ludwig sprite
;         x: x position within the level
;         y: y position within the level
macro S_LudwigFireball(x, y)
    %S_Sprite(<x>,<y>, 52, 0)
endmacro

; insert an eerie sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;      "straight": flies horizontally
;         "waves": flies in sine wave or regular interesting
macro S_Eerie(x, y, type)
    if stringsequal("<type>","straight")
        %S_Sprite(<x>,<y>, 56, 0)
    elseif stringsequal("<type>","waves")
        %S_Sprite(<x>,<y>, 57, 0)
    else
        ; warn "bad parameter for %S_Eerie type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert an urchin sprite
; direction is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;      type:
;        "fixed": moves a fixed distance back and forth
;        "walls": moves back and forth between two walls
;      "follows": follows walls
; direction:
;       "updown": vertically up and down
;    "leftright": horizontally left and right
;          "ccw": follows walls counterclockwise
;           "cw": follows walls clockwise
macro S_Urchin(x, y, type, direction)
    if stringsequal("<type>","fixed")
        if and(equal(<x>&1,0),not(stringsequal("<direction>","updown")))
            ; warn "Urchin will not match direction, will be updown (was ",<direction>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<direction>","leftright")))
            ; warn "Urchin will not match direction, will be leftright (was ",<direction>,"), at ",pc
        endif
        %S_Sprite(<x>,<y>, 58, 0)
    elseif stringsequal("<type>","walls")
        if and(equal(<x>&1,0),not(stringsequal("<direction>","updown")))
            ; warn "Urchin will not match direction, will be updown (was ",<direction>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<direction>","leftright")))
            ; warn "Urchin will not match direction, will be leftright (was ",<direction>,"), at ",pc
        endif
        %S_Sprite(<x>,<y>, 59, 0)
    elseif stringsequal("<type>","follows")
        if and(equal(<x>&1,0),not(stringsequal("<direction>","ccw")))
            ; warn "Urchin will not match direction, will be ccw (was ",<direction>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<direction>","cw")))
            ; warn "Urchin will not match direction, will be cw (was ",<direction>,"), at ",pc
        endif
        %S_Sprite(<x>,<y>, 60, 0)
    else
        ; warn "bad parameter for %S_Urchin type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a rip van fish sprite
;         x: x position within the level
;         y: y position within the level
macro S_RipVanFish(x, y)
    %S_Sprite(<x>,<y>, 61, 0)
endmacro

; insert a P-Switch sprite
; type is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;      type:
;          "blue": coins into used blocks and vise versa
;          "gray": enemies into coins
macro S_PSwitch(x, y, type)
    if and(equal(<x>&1,0),not(stringsequal("<type>","blue")))
        ; warn "PSwitch will not match type, will be blue (was ",<type>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<type>","gray")))
        ; warn "PSwitch will not match type, will be gray (was ",<type>,"), at ",pc
    endif
    %S_Sprite(<x>,<y>, 62, 0)
endmacro

; insert a dolphin sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;       "bigjump": jumps back and forth about 16 tiles
;     "smalljump": jumps back and forth about 5 tiles
;        "updown": jumps in place up and down
macro S_Dolphin(x, y, type)
    if stringsequal("<type>","bigjump")
        %S_Sprite(<x>,<y>, 65, 0)
    elseif stringsequal("<type>","smalljump")
        %S_Sprite(<x>,<y>, 66, 0)
    elseif stringsequal("<type>","updown")
        %S_Sprite(<x>,<y>, 67, 0)
    else
        ; warn "bad parameter for %S_Dolphin type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a torpedo ted sprite
;         x: x position within the level
;         y: y position within the level
macro S_TorpedoTed(x, y)
    %S_Sprite(<x>,<y>, 68, 0)
endmacro

; insert a coin snake sprite
;         x: x position within the level
;         y: y position within the level
macro S_CoinSnake(x, y)
    %S_Sprite(<x>,<y>, 69, 0)
endmacro

; insert a diggin' chuck's rock sprite
;         x: x position within the level
;         y: y position within the level
macro S_Rock(x, y)
    %S_Sprite(<x>,<y>, 72, 0)
endmacro

; insert a moving pipe lip sprite
;         x: x position within the level
;         y: y position within the level
macro S_PipeLip(x, y)
    %S_Sprite(<x>,<y>, 73, 0)
endmacro

; insert a green ? orb sprite
;         x: x position within the level
;         y: y position within the level
macro S_Orb(x, y)
    %S_Sprite(<x>,<y>, 74, 0)
endmacro

; insert an exploding turn block sprite
; contents is dependent on x pos mod 4
;         x: x position within the level
;         y: y position within the level
;  contents:
;    "cheepcheep": cheep cheep inside
;        "goomba": goomba inside
;"shelllesskoopa": green shellless koopa inside
;         "koopa": green koopa inside
macro S_ExplodingTurnBlock(x, y, contents)
    if and(equal(<x>&3,0),not(stringsequal("<contents>","cheepcheep")))
        ; warn "ExplodingTurnBlock will not match contents, will be cheepcheep (was ",<contents>,"), at ",pc
    elseif and(equal(<x>&3,1),not(stringsequal("<contents>","goomba")))
        ; warn "ExplodingTurnBlock will not match contents, will be goomba (was ",<contents>,"), at ",pc
    elseif and(equal(<x>&3,2),not(stringsequal("<contents>","shelllesskoopa")))
        ; warn "ExplodingTurnBlock will not match contents, will be shelllesskoopa (was ",<contents>,"), at ",pc
    elseif and(equal(<x>&3,3),not(stringsequal("<contents>","koopa")))
        ; warn "ExplodingTurnBlock will not match contents, will be koopa (was ",<contents>,"), at ",pc
    endif
    if or(stringsequal("<contents>","cheepcheep"),or(stringsequal("<contents>","goomba"),or(stringsequal("<contents>","shelllesskoopa"),stringsequal("<contents>","koopa"))))
        %S_Sprite(<x>,<y>, 76, 0)
    else
        ; warn "bad parameter for %S_ExplodingTurnBlock contents (",<contents>,") at ",pc,", skipping"
    endif
endmacro

; insert a monty mole sprite
; action is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;      type:
;        "ground": pops out of the ground
;         "ledge": pops out of the background ledge
;    action:
;       "follows": follows mario
;          "hops": runs and hops around
macro S_MontyMole(x, y, type, action)
    if and(equal(<x>&1,0),not(stringsequal("<action>","follows")))
        ; warn "MontyMole will not match action, will be follows (was ",<action>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<action>","hops")))
        ; warn "MontyMole will not match action, will be hops (was ",<action>,"), at ",pc
    endif
    if or(stringsequal("<action>","follows"),stringsequal("<action>","hops"))
        if stringsequal("<type>","ground")
            %S_Sprite(<x>,<y>, 77, 0)
        elseif stringsequal("<type>","ledge")
            %S_Sprite(<x>,<y>, 78, 0)
        else
            ; warn "bad parameter for %S_MontyMole type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_MontyMole action (",<action>,") at ",pc,", skipping"
    endif
endmacro

; insert a ninji sprite
;         x: x position within the level
;         y: y position within the level
macro S_Ninji(x, y)
    %S_Sprite(<x>,<y>, 81, 0)
endmacro

; insert a moving hole sprite
;         x: x position within the level
;         y: y position within the level
macro S_MovingHole(x, y)
    %S_Sprite(<x>,<y>, 82, 0)
endmacro

; insert a throw block sprite
;         x: x position within the level
;         y: y position within the level
macro S_ThrowBlock(x, y)
    %S_Sprite(<x>,<y>, 83, 0)
endmacro

; insert a climbing net door sprite
;         x: x position within the level
;         y: y position within the level
macro S_ClimbingNetDoor(x, y)
    %S_Sprite(<x>,<y>, 84, 0)
endmacro

; insert a moving platform sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;     "checkered": long and checkered
;          "rock": short and thick
; direction:
;     "leftright": horizontal
;        "updown": vertical
macro S_MovingPlatform(x, y, type, direction)
    if stringsequal("<type>","checkered")
        if stringsequal("<direction>","leftright")
            %S_Sprite(<x>,<y>, 85, 0)
        elseif stringsequal("<direction>","updown")
            %S_Sprite(<x>,<y>, 87, 0)
        else
            ; warn "bad parameter for checkered %S_MovingPlatform direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","rock")
        if stringsequal("<direction>","leftright")
            %S_Sprite(<x>,<y>, 86, 0)
        elseif stringsequal("<direction>","updown")
            %S_Sprite(<x>,<y>, 88, 0)
        else
            ; warn "bad parameter for rock %S_MovingPlatform direction (",<direction>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_MovingPlatform type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a turn block bridge sprite
;         x: x position within the level
;         y: y position within the level
; direction:
;          "both": horizontal and vertical
;    "horizontal": horizontal only
macro S_TurnBlockBridge(x, y, direction)
    if stringsequal("<direction>","both")
        %S_Sprite(<x>,<y>, 89, 0)
    elseif stringsequal("<direction>","horizontal")
        %S_Sprite(<x>,<y>, 90, 0)
    else
        ; warn "bad parameter for %S_TurnBlockBridge direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a floating platform sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;         "brown": short and brown
;     "checkered": long and checkered
;        "orange": short and thick
;     "orangebig": long and thick
;                  if buoyancy is disabled, doesn't float but
;                  rather stays in place and moves when landed on
macro S_FloatingPlatform(x, y, type)
    if stringsequal("<type>","brown")
        %S_Sprite(<x>,<y>, 91, 0)
    elseif stringsequal("<type>","checkered")
        %S_Sprite(<x>,<y>, 92, 0)
    elseif stringsequal("<type>","orange")
        %S_Sprite(<x>,<y>, 93, 0)
    elseif stringsequal("<type>","orangebig")
        %S_Sprite(<x>,<y>, 94, 0)
    else
        ; warn "bad parameter for %S_FloatingPlatform type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a swinging brown platform sprite
;         x: x position within the level
;         y: y position within the level
macro S_BrownSwingingPlatform(x, y)
    %S_Sprite(<x>,<y>, 95, 0)
endmacro

; insert a flat palace switch sprite
;         x: x position within the level
;         y: y position within the level
macro S_FlatPalaceSwitch(x, y)
    %S_Sprite(<x>,<y>, 96, 0)
endmacro

; insert a skull raft sprite
;         x: x position within the level
;         y: y position within the level
macro S_SkullRaft(x, y)
    %S_Sprite(<x>,<y>, 97, 0)
endmacro

; insert a guide line platform sprite
; type is dependent on x pos mod 2 if waits
;         x: x position within the level
;         y: y position within the level
;      type:
;         "brown": short and brown
;     "checkered": long and checkered
;    action:
;         "moves": starts moving immediately
;         "waits": stationary until mario lands on it
macro S_GuideLinePlatform(x, y, type, action)
    if stringsequal("<action>","moves")
        if stringsequal("<type>","brown")
            %S_Sprite(<x>,<y>, 98, 0)
        else
            ; warn "bad parameter for moves %S_GuideLinePlatform type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<action>","waits")
        if and(equal(<x>&1,0),not(stringsequal("<type>","checkered")))
            ; warn "GuideLinePlatform will not match type, will be checkered (was ",<type>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<type>","brown")))
            ; warn "GuideLinePlatform will not match type, will be brown (was ",<type>,"), at ",pc
        endif
        if or(stringsequal("<type>","checkered"),stringsequal("<type>","brown"))
            %S_Sprite(<x>,<y>, 99, 0)
        else
            ; warn "bad parameter for waits %S_GuideLinePlatform type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_GuideLinePlatform action (",<action>,") at ",pc,", skipping"
    endif
endmacro

; insert a guide line rope sprite
; type is dependent on x pos mod 2
; long ropes can be short if sprite slot memory is wrong
; or if too many other ropes already exist
;         x: x position within the level
;         y: y position within the level
;      type:
;         "short": short
;          "long": long
macro S_Rope(x, y, type)
    if and(equal(<x>&1,0),not(stringsequal("<type>","long")))
        ; warn "Rope will not match type, will be long (was ",<type>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<type>","short")))
        ; warn "Rope will not match type, will be short (was ",<type>,"), at ",pc
    endif
    if or(stringsequal("<type>","long"),stringsequal("<type>","short"))
        %S_Sprite(<x>,<y>, 100, 0)
    else
        ; warn "bad parameter for %S_Rope type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a guide line chainsaw sprite
; direction is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;      type:
;            "up": pointing up
;          "down": pointing down
; direction:
;     "goingleft": spawns moving left as normal
;    "goingright": spawns moving right, but from the opposite side of the screen
macro S_Chainsaw(x, y, type, direction)
    if and(equal(<x>&1,0),not(stringsequal("<direction>","goingright")))
        ; warn "Chainsaw will not match direction, will be goingright (was ",<direction>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<direction>","goingleft")))
        ; warn "Chainsaw will not match direction, will be goingleft (was ",<direction>,"), at ",pc
    endif
    if or(stringsequal("<direction>","goingright"),stringsequal("<direction>","goingleft"))
        if stringsequal("<type>","up")
            %S_Sprite(<x>,<y>, 101, 0)
        elseif stringsequal("<type>","down")
            %S_Sprite(<x>,<y>, 102, 0)
        else
            ; warn "bad parameter for %S_Chainsaw type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_Chainsaw direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a grinder sprite
; type is dependent on x pos mod 2 if not ground
;         x: x position within the level
;         y: y position within the level
;      type:
;     "goingleft": line guided, spawns moving left as normal
;    "goingright": line guided, spawns moving right, but from the opposite side of the screen
;        "ground": grounded and moving left
macro S_Grinder(x, y, type)
    if stringsequal("<type>","ground")
        %S_Sprite(<x>,<y>, 180, 0)
    else
        if and(equal(<x>&1,0),not(stringsequal("<type>","goingright")))
            ; warn "Grinder will not match type, will be goingright (was ",<type>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<type>","goingleft")))
            ; warn "Grinder will not match type, will be goingleft (was ",<type>,"), at ",pc
        endif
        if or(stringsequal("<type>","goingleft"),stringsequal("<type>","goingright"))
            %S_Sprite(<x>,<y>, 103, 0)
        else
            ; warn "bad parameter for %S_Grinder type (",<type>,") at ",pc,", skipping"
        endif
    endif
endmacro

; insert a fuzzy sprite
; type is dependent on x pos mod 2
; if follows and in a level with tileset 1 (castle), it
; will be a lil sparky instead
;         x: x position within the level
;         y: y position within the level
;      type:
;    "lineguided": line guided
;       "follows": follows walls
; direction:
;     "goingleft": line guided, spawns moving left as normal
;    "goingright": line guided, spawns moving right, but from the opposite side of the screen
;           "ccw": follows walls counterclockwise
;            "cw": follows walls clockwise
macro S_Fuzzy(x, y, type, direction)
    if stringsequal("<type>","lineguided")
        if and(equal(<x>&1,0),not(stringsequal("<direction>","goingright")))
            ; warn "Fuzzy will not match direction, will be goingright (was ",<direction>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<direction>","goingleft")))
            ; warn "Fuzzy will not match direction, will be goingleft (was ",<direction>,"), at ",pc
        endif
        if or(stringsequal("<direction>","goingright"),stringsequal("<direction>","goingleft"))
            %S_Sprite(<x>,<y>, 104, 0)
        else
            ; warn "bad parameter for lineguided %S_Fuzzy direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","follows")
        if and(equal(<x>&1,0),not(stringsequal("<direction>","cw")))
            ; warn "Fuzzy will not match direction, will be cw (was ",<direction>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<direction>","ccw")))
            ; warn "Fuzzy will not match direction, will be ccw (was ",<direction>,"), at ",pc
        endif
        if or(stringsequal("<direction>","ccw"),stringsequal("<direction>","cw"))
            %S_Sprite(<x>,<y>, 165, 0)
        else
            ; warn "bad parameter for follows %S_Fuzzy direction (",<direction>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_Fuzzy type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a game cloud sprite
;         x: x position within the level
;         y: y position within the level
macro S_GameCloud(x, y)
    %S_Sprite(<x>,<y>, 106, 0)
endmacro

; insert a wall spring sprite
;         x: x position within the level
;         y: y position within the level
; direction:
;          "left": connected to wall on the left
;         "right": connected to wall on the right
macro S_WallSpring(x, y, direction)
    if stringsequal("<direction>","left")
        %S_Sprite(<x>,<y>, 107, 0)
    elseif stringsequal("<direction>","right")
        %S_Sprite(<x>,<y>, 108, 0)
    else
        ; warn "bad parameter for %S_WallSpring direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert an invisible solid block sprite
;         x: x position within the level
;         y: y position within the level
macro S_SolidBlock(x, y)
    %S_Sprite(<x>,<y>, 109, 0)
endmacro

; insert a dino rhino sprite
;         x: x position within the level
;         y: y position within the level
macro S_DinoRhino(x, y)
    %S_Sprite(<x>,<y>, 110, 0)
endmacro

; insert a dino torch sprite
;         x: x position within the level
;         y: y position within the level
macro S_DinoTorch(x, y)
    %S_Sprite(<x>,<y>, 111, 0)
endmacro

; insert a pokey sprite
;         x: x position within the level
;         y: y position within the level
macro S_Pokey(x, y)
    %S_Sprite(<x>,<y>, 112, 0)
endmacro

; insert a super koopa sprite
; if walking, color is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;      type:
;        "flying": already in flight
;       "walking": runs on the ground to take off
;     color:
;           "red": red cape
;        "yellow": yellow cape
;      "flashing": flashing cape with feather
macro S_SuperKoopa(x, y, type, color)
    if stringsequal("<type>","flying")
        if stringsequal("<color>","red")
            %S_Sprite(<x>,<y>, 113, 0)
        elseif stringsequal("<color>","yellow")
            %S_Sprite(<x>,<y>, 114, 0)
        else
            ; warn "bad parameter for flying %S_SuperKoopa color (",<color>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","walking")
        if and(equal(<x>&1,0),not(stringsequal("<color>","yellow")))
            ; warn "SuperKoopa will not match color, will be yellow (was ",<color>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<color>","flashing")))
            ; warn "SuperKoopa will not match color, will be flashing (was ",<color>,"), at ",pc
        endif
        if or(stringsequal("<color>","yellow"),stringsequal("<color>","flashing"))
            %S_Sprite(<x>,<y>, 115, 0)
        else
            ; warn "bad parameter for walking %S_SuperKoopa color (",<color>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_SuperKoopa type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a super mushroom sprite
;         x: x position within the level
;         y: y position within the level
macro S_Mushroom(x, y)
    %S_Sprite(<x>,<y>, 116, 0)
endmacro

; insert a fire flower sprite
;         x: x position within the level
;         y: y position within the level
macro S_FireFlower(x, y)
    %S_Sprite(<x>,<y>, 117, 0)
endmacro

; insert a super star sprite
;         x: x position within the level
;         y: y position within the level
macro S_SuperStar(x, y)
    %S_Sprite(<x>,<y>, 118, 0)
endmacro

; insert a cape feather sprite
;         x: x position within the level
;         y: y position within the level
macro S_CapeFeather(x, y)
    %S_Sprite(<x>,<y>, 119, 0)
endmacro

; insert a 1up mushroom sprite
;         x: x position within the level
;         y: y position within the level
macro S_1upMushroom(x, y)
    %S_Sprite(<x>,<y>, 120, 0)
endmacro

; insert a growing vine sprite
;         x: x position within the level
;         y: y position within the level
macro S_GrowingVine(x, y)
    %S_Sprite(<x>,<y>, 121, 0)
endmacro

; insert a firework sprite
;         x: x position within the level
;         y: y position within the level
macro S_Firework(x, y)
    %S_Sprite(<x>,<y>, 122, 0)
endmacro

; insert a goal tape sprite
;         x: x position within the level
;         y: y position within the level
;      exit:
;        "normal": normal exit
;        "secret": secret exit
macro S_GoalTape(x, y, exit)
    if stringsequal("<exit>","normal")
        %S_Sprite(<x>,<y>, 123, 0)
    elseif stringsequal("<exit>","secret")
        %S_Sprite(<x>,<y>, 123, 1)
    else
        ; warn "bad parameter for %S_GoalTape exit (",<exit>,") at ",pc,", skipping"
    endif
endmacro

; insert a princess peach sprite
;         x: x position within the level
;         y: y position within the level
macro S_PrincessPeach(x, y)
    %S_Sprite(<x>,<y>, 124, 0)
endmacro

; insert a pballoon sprite
;         x: x position within the level
;         y: y position within the level
macro S_PBalloon(x, y)
    %S_Sprite(<x>,<y>, 125, 0)
endmacro

; insert a winged item sprite
;         x: x position within the level
;         y: y position within the level
;      type:
;       "redcoin": red coin worth 5 coins
;    "yoshiwings": yoshi wings to coin heaven
;  "goldmushroom": golden 1up
macro S_WingedSprite(x, y, type)
    if stringsequal("<exit>","redcoin")
        %S_Sprite(<x>,<y>, 126, 0)
    elseif stringsequal("<exit>","yoshiwings")
        %S_Sprite(<x>,<y>, 126, 1)
    elseif stringsequal("<exit>","goldmushroom")
        %S_Sprite(<x>,<y>, 127, 0)
    else
        ; warn "bad parameter for %S_WingedSprite type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a key sprite
;         x: x position within the level
;         y: y position within the level
macro S_Key(x, y)
    %S_Sprite(<x>,<y>, 128, 0)
endmacro

; insert a roulette item sprite
;         x: x position within the level
;         y: y position within the level
macro S_RouletteItem(x, y)
    %S_Sprite(<x>,<y>, 129, 0)
endmacro

; insert a tic tac toe bonus game sprite
;         x: x position within the level
;         y: y position within the level
macro S_BonusGame(x, y)
    %S_Sprite(<x>,<y>, 130, 0)
endmacro

; insert a flying prize block sprite
; contents is dependent on x pos mod 4
;         x: x position within the level
;         y: y position within the level
; direction:
;     "goingleft": flies to the left
;     "leftright": flies back and forth
;  contents:
;          "coin": 1 coin
;        "flower": fire flower
;       "feather": cape feather
;           "1up": 1up mushroom
macro S_FlyingPrizeBlock(x, y, direction, contents)
    if and(equal(<x>&3,0),not(stringsequal("<contents>","coin")))
        ; warn "FlyingPrizeBlock will not match contents, will be coin (was ",<contents>,"), at ",pc
    elseif and(equal(<x>&3,1),not(stringsequal("<contents>","flower")))
        ; warn "FlyingPrizeBlock will not match contents, will be flower (was ",<contents>,"), at ",pc
    elseif and(equal(<x>&3,2),not(stringsequal("<contents>","feather")))
        ; warn "FlyingPrizeBlock will not match contents, will be feather (was ",<contents>,"), at ",pc
    elseif and(equal(<x>&3,3),not(stringsequal("<contents>","1up")))
        ; warn "FlyingPrizeBlock will not match contents, will be 1up (was ",<contents>,"), at ",pc
    endif
    if or(stringsequal("<contents>","coin"),or(stringsequal("<contents>","flower"),or(stringsequal("<contents>","feather"),stringsequal("<contents>","1up"))))
        if stringsequal("<direction>","goingleft")
            %S_Sprite(<x>,<y>, 131, 0)
        elseif stringsequal("<direction>","leftright")
            %S_Sprite(<x>,<y>, 132, 0)
        else
            ; warn "bad parameter for %S_FlyingPrizeBlock direction (",<direction>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_FlyingPrizeBlock contents (",<contents>,") at ",pc,", skipping"
    endif
endmacro

; insert a wiggler sprite
;         x: x position within the level
;         y: y position within the level
macro S_Wiggler(x, y)
    %S_Sprite(<x>,<y>, 134, 0)
endmacro

; insert a lakitu cloud sprite
;         x: x position within the level
;         y: y position within the level
macro S_LakituCloud(x, y)
    %S_Sprite(<x>,<y>, 135, 0)
endmacro

; insert a winged cage sprite
;         x: x position within the level
;         y: y position within the level
macro S_WingedCage(x, y)
    %S_Sprite(<x>,<y>, 136, 0)
endmacro

; insert a yoshi's house bird sprite
;         x: x position within the level
;         y: y position within the level
macro S_Bird(x, y)
    %S_Sprite(<x>,<y>, 138, 0)
endmacro

; insert a yoshi's house smoke cloud sprite
;         x: x position within the level
;         y: y position within the level
macro S_SmokeCloud(x, y)
    %S_Sprite(<x>,<y>, 139, 0)
endmacro

; insert a side exit enabler sprite
; type is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;      type:
;        "normal": just the side exit
;     "fireplace": also draws the fire in yoshi's house
macro S_SideExit(x, y, type)
    if and(equal(<x>&1,0),not(stringsequal("<type>","normal")))
        ; warn "SideExit will not match type, will be normal (was ",<type>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<type>","fireplace")))
        ; warn "SideExit will not match type, will be fireplace (was ",<type>,"), at ",pc
    endif
    if or(stringsequal("<type>","normal"),stringsequal("<type>","fireplace"))
        %S_Sprite(<x>,<y>, 140, 0)
    else
        ; warn "bad parameter for %S_SideExit type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a ghost house exit sign sprite
;         x: x position within the level
;         y: y position within the level
macro S_ExitSign(x, y)
    %S_Sprite(<x>,<y>, 141, 0)
endmacro

; insert a warp hole sprite
;         x: x position within the level
;         y: y position within the level
macro S_WarpHole(x, y)
    %S_Sprite(<x>,<y>, 142, 0)
endmacro

; insert a pair of scale mushroom platforms sprite
; distance is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;  distance:
;          "near": 3 tiles apart
;           "far": 7 tiles apart
macro S_MushroomScales(x, y, distance)
    if and(equal(<x>&1,0),not(stringsequal("<distance>","far")))
        ; warn "MushroomScales will not match distance, will be far (was ",<distance>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<distance>","near")))
        ; warn "MushroomScales will not match distance, will be near (was ",<distance>,"), at ",pc
    endif
    if or(stringsequal("<distance>","far"),stringsequal("<distance>","near"))
        %S_Sprite(<x>,<y>, 143, 0)
    else
        ; warn "bad parameter for %S_MushroomScales distance (",<distance>,") at ",pc,", skipping"
    endif
endmacro

; insert a big green bubble sprite
;         x: x position within the level
;         y: y position within the level
macro S_BigGreenBubble(x, y)
    %S_Sprite(<x>,<y>, 144, 0)
endmacro

; insert a chargin chuck sprite
; subtype is dependent on x pos mod 2 for whistlin, x pos mod 4 for pitchin
;         x: x position within the level
;         y: y position within the level
;      type:
;       "chargin": charges
;      "splittin": splits into 3
;       "bouncin": bounces
;      "whistlin": wakes up rip van fish or summons super koopas
;       "clappin": jumps and claps
;        "puntin": kicks footballs
;       "pitchin": throws baseballs
;        "diggin": digs up rocks
;   subtype:
;        "normal": standard
;        "unused": unused chargin chuck
;    "ripvanfish": whistlin chuck awakes
;   "superkoopas": whistlin chuck summons
;        "2balls": pitchin chuck throws
;        "4balls": pitchin chuck throws
;        "5balls": pitchin chuck throws
;        "6balls": pitchin chuck throws
macro S_Chuck(x, y, type, subtype)
    if stringsequal("<type>","chargin")
        if stringsequal("<subtype>","normal")
            %S_Sprite(<x>,<y>, 145, 0)
        elseif stringsequal("<subtype>","unused")
            %S_Sprite(<x>,<y>, 150, 0)
        else
            ; warn "bad parameter for chargin %S_Chuck subtype (",<subtype>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","splittin")
        if stringsequal("<subtype>","normal")
            %S_Sprite(<x>,<y>, 146, 0)
        else
            ; warn "bad parameter for splittin %S_Chuck subtype (",<subtype>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","bouncin")
        if stringsequal("<subtype>","normal")
            %S_Sprite(<x>,<y>, 147, 0)
        else
            ; warn "bad parameter for bouncin %S_Chuck subtype (",<subtype>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","whistlin")
        if and(equal(<x>&1,0),not(stringsequal("<subtype>","superkoopas")))
            ; warn "Chuck will not match subtype, will be superkoopas (was ",<subtype>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<subtype>","ripvanfish")))
            ; warn "Chuck will not match subtype, will be ripvanfish (was ",<subtype>,"), at ",pc
        endif
        if or(stringsequal("<subtype>","superkoopas"),stringsequal("<subtype>","ripvanfish"))
            %S_Sprite(<x>,<y>, 148, 0)
        else
            ; warn "bad parameter for whistlin %S_Chuck subtype (",<subtype>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","clappin")
        if stringsequal("<subtype>","normal")
            %S_Sprite(<x>,<y>, 149, 0)
        else
            ; warn "bad parameter for clappin %S_Chuck subtype (",<subtype>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","puntin")
        if stringsequal("<subtype>","normal")
            %S_Sprite(<x>,<y>, 151, 0)
        else
            ; warn "bad parameter for puntin %S_Chuck subtype (",<subtype>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","pitchin")
        if and(equal(<x>&3,0),not(stringsequal("<subtype>","2balls")))
            ; warn "Chuck will not match subtype, will be 2balls (was ",<subtype>,"), at ",pc
        elseif and(equal(<x>&3,1),not(stringsequal("<subtype>","4balls")))
            ; warn "Chuck will not match subtype, will be 4balls (was ",<subtype>,"), at ",pc
        elseif and(equal(<x>&3,2),not(stringsequal("<subtype>","6balls")))
            ; warn "Chuck will not match subtype, will be 6balls (was ",<subtype>,"), at ",pc
        elseif and(equal(<x>&3,3),not(stringsequal("<subtype>","5balls")))
            ; warn "Chuck will not match subtype, will be 5balls (was ",<subtype>,"), at ",pc
        endif
        if or(stringsequal("<subtype>","2balls"),or(stringsequal("<subtype>","4balls"),or(stringsequal("<subtype>","5balls"),stringsequal("<subtype>","6balls"))))
            %S_Sprite(<x>,<y>, 152, 0)
        else
            ; warn "bad parameter for pitchin %S_Chuck subtype (",<subtype>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<type>","diggin")
        if stringsequal("<subtype>","normal")
            %S_Sprite(<x>,<y>, 70, 0)
        else
            ; warn "bad parameter for diggin %S_Chuck subtype (",<subtype>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_Chuck type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a volcano lotus sprite
;         x: x position within the level
;         y: y position within the level
macro S_VolcanoLotus(x, y)
    %S_Sprite(<x>,<y>, 153, 0)
endmacro

; insert a sumo bro sprite
;         x: x position within the level
;         y: y position within the level
macro S_SumoBro(x, y)
    %S_Sprite(<x>,<y>, 154, 0)
endmacro

; insert an amazing flying hammer bro sprite
;         x: x position within the level
;         y: y position within the level
macro S_HammerBro(x, y)
    %S_Sprite(<x>,<y>, 155, 0)
endmacro

; insert an amazing flying hammer bro platform sprite
;         x: x position within the level
;         y: y position within the level
macro S_HammerBroPlatform(x, y)
    %S_Sprite(<x>,<y>, 156, 0)
endmacro

; insert a sprite in a bubble sprite
; contents is dependent on x pos mod 4
;         x: x position within the level
;         y: y position within the level
;  contents:
;        "goomba": goomba
;        "bobomb": bobomb
;    "cheepcheep": cheep cheep
;      "mushroom": mushroom
macro S_Bubble(x, y, contents)
    if and(equal(<x>&3,0),not(stringsequal("<contents>","goomba")))
        ; warn "Bubble will not match contents, will be goomba (was ",<contents>,"), at ",pc
    elseif and(equal(<x>&3,1),not(stringsequal("<contents>","bobomb")))
        ; warn "Bubble will not match contents, will be bobomb (was ",<contents>,"), at ",pc
    elseif and(equal(<x>&3,2),not(stringsequal("<contents>","cheepcheep")))
        ; warn "Bubble will not match contents, will be cheepcheep (was ",<contents>,"), at ",pc
    elseif and(equal(<x>&3,3),not(stringsequal("<contents>","mushroom")))
        ; warn "Bubble will not match contents, will be mushroom (was ",<contents>,"), at ",pc
    endif
    if or(stringsequal("<contents>","goomba"),or(stringsequal("<contents>","bobomb"),or(stringsequal("<contents>","cheepcheep"),stringsequal("<contents>","mushroom"))))
        %S_Sprite(<x>,<y>, 157, 0)
    else
        ; warn "bad parameter for %S_Bubble contents (",<contents>,") at ",pc,", skipping"
    endif
endmacro

; insert a ball n chain sprite
; direction is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
; direction:
;            "cw": clockwise
;           "ccw": counterclockwise
macro S_BallNChain(x, y, direction)
    if and(equal(<x>&1,0),not(stringsequal("<direction>","cw")))
        ; warn "BallNChain will not match direction, will be cw (was ",<direction>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<direction>","ccw")))
        ; warn "BallNChain will not match direction, will be ccw (was ",<direction>,"), at ",pc
    endif
    if or(stringsequal("<direction>","cw"),stringsequal("<direction>","ccw"))
        %S_Sprite(<x>,<y>, 158, 0)
    else
        ; warn "bad parameter for %S_BallNChain direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a banzai bill sprite
;         x: x position within the level
;         y: y position within the level
macro S_BanzaiBill(x, y)
    %S_Sprite(<x>,<y>, 159, 0)
endmacro

; insert a bowser sprite
;         x: x position within the level
;         y: y position within the level
macro S_Bowser(x, y)
    %S_Sprite(<x>,<y>, 160, 0)
endmacro

; insert a big steelie sprite
;         x: x position within the level
;         y: y position within the level
macro S_BigSteelie(x, y)
    %S_Sprite(<x>,<y>, 161, 0)
endmacro

; insert a mechakoopa sprite
;         x: x position within the level
;         y: y position within the level
macro S_Mechakoopa(x, y)
    %S_Sprite(<x>,<y>, 162, 0)
endmacro

; insert a gray rotating platform sprite
; direction is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
; direction:
;            "cw": clockwise
;           "ccw": counterclockwise
macro S_RotatingPlatform(x, y, direction)
    if and(equal(<x>&1,0),not(stringsequal("<direction>","cw")))
        ; warn "RotatingPlatform will not match direction, will be cw (was ",<direction>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<direction>","ccw")))
        ; warn "RotatingPlatform will not match direction, will be ccw (was ",<direction>,"), at ",pc
    endif
    if or(stringsequal("<direction>","cw"),stringsequal("<direction>","ccw"))
        %S_Sprite(<x>,<y>, 163, 0)
    else
        ; warn "bad parameter for %S_RotatingPlatform direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a spike ball sprite
; speed is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;     speed:
;          "slow": slow
;          "fast": fast
macro S_SpikeBall(x, y, speed)
    if and(equal(<x>&1,0),not(stringsequal("<speed>","slow")))
        ; warn "SpikeBall will not match speed, will be slow (was ",<speed>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<speed>","fast")))
        ; warn "SpikeBall will not match speed, will be fast (was ",<speed>,"), at ",pc
    endif
    if or(stringsequal("<speed>","slow"),stringsequal("<speed>","fast"))
        %S_Sprite(<x>,<y>, 164, 0)
    else
        ; warn "bad parameter for %S_SpikeBall speed (",<speed>,") at ",pc,", skipping"
    endif
endmacro

; insert a lil sparky sprite
; if inserted in a level with tileset 2 (rope/mushroom), it
; will be a fuzzy instead
; direction is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
; direction:
;            "cw": clockwise
;           "ccw": counterclockwise
macro S_LilSparky(x, y, direction)
    if and(equal(<x>&1,0),not(stringsequal("<direction>","cw")))
        ; warn "LilSparky will not match direction, will be cw (was ",<direction>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<direction>","ccw")))
        ; warn "LilSparky will not match direction, will be ccw (was ",<direction>,"), at ",pc
    endif
    if or(stringsequal("<direction>","cw"),stringsequal("<direction>","ccw"))
        %S_Sprite(<x>,<y>, 165, 0)
    else
        ; warn "bad parameter for %S_LilSparky direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a hothead sprite
; direction is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
; direction:
;            "cw": clockwise
;           "ccw": counterclockwise
macro S_Hothead(x, y, direction)
    if and(equal(<x>&1,0),not(stringsequal("<direction>","cw")))
        ; warn "Hothead will not match direction, will be cw (was ",<direction>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<direction>","ccw")))
        ; warn "Hothead will not match direction, will be ccw (was ",<direction>,"), at ",pc
    endif
    if or(stringsequal("<direction>","cw"),stringsequal("<direction>","ccw"))
        %S_Sprite(<x>,<y>, 166, 0)
    else
        ; warn "bad parameter for %S_Hothead direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a ball from iggy sprite
;         x: x position within the level
;         y: y position within the level
macro S_IggyBall(x, y)
    %S_Sprite(<x>,<y>, 167, 0)
endmacro

; insert a blargg sprite
;         x: x position within the level
;         y: y position within the level
macro S_Blargg(x, y)
    %S_Sprite(<x>,<y>, 168, 0)
endmacro

; insert a reznor sprite
;         x: x position within the level
;         y: y position within the level
macro S_Reznor(x, y)
    %S_Sprite(<x>,<y>, 169, 0)
endmacro

; insert a fishbone sprite
;         x: x position within the level
;         y: y position within the level
macro S_Fishbone(x, y)
    %S_Sprite(<x>,<y>, 170, 0)
endmacro

; insert a rex sprite
;         x: x position within the level
;         y: y position within the level
macro S_Rex(x, y)
    %S_Sprite(<x>,<y>, 171, 0)
endmacro

; insert a wooden spike sprite
; if up, moving is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
; direction:
;            "up": pointing up
;          "down": pointing down
;    moving:
;       "goingup": moves up first
;     "goingdown": moves down first
macro S_WoodenSpike(x, y, direction, moving)
    if stringsequal("<direction>","down")
        if stringsequal("<moving>","goingdown")
            %S_Sprite(<x>,<y>, 172, 0)
        else
            ; warn "bad parameter for down %S_WoodenSpike moving (",<moving>,") at ",pc,", skipping"
        endif
    elseif  stringsequal("<direction>","up")
        if and(equal(<x>&1,0),not(stringsequal("<moving>","goingup")))
            ; warn "Hothead will not match moving, will be goingup (was ",<moving>,"), at ",pc
        elseif and(equal(<x>&1,1),not(stringsequal("<moving>","goingdown")))
            ; warn "Hothead will not match moving, will be goingdown (was ",<moving>,"), at ",pc
        endif
        if or(stringsequal("<moving>","goingup"),stringsequal("<moving>","goingdown"))
            %S_Sprite(<x>,<y>, 173, 0)
        else
            ; warn "bad parameter for up %S_WoodenSpike moving (",<moving>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_WoodenSpike direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a fishin boo sprite
;         x: x position within the level
;         y: y position within the level
macro S_FishinBoo(x, y)
    %S_Sprite(<x>,<y>, 174, 0)
endmacro

; insert a boo block sprite
;         x: x position within the level
;         y: y position within the level
macro S_BooBlock(x, y)
    %S_Sprite(<x>,<y>, 175, 0)
endmacro

; insert a boo laser sprite
;         x: x position within the level
;         y: y position within the level
macro S_BooLaser(x, y)
    %S_Sprite(<x>,<y>, 176, 0)
endmacro

; insert a block snake sprite
; type is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;      type:
;          "head": creates blocks
;          "tail": destroys blocks
macro S_BlockSnake(x, y, type)
    if and(equal(<x>&1,0),not(stringsequal("<type>","head")))
        ; warn "BlockSnake will not match type, will be head (was ",<type>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<type>","tail")))
        ; warn "BlockSnake will not match type, will be tail (was ",<type>,"), at ",pc
    endif
    if or(stringsequal("<type>","head"),stringsequal("<type>","tail"))
        %S_Sprite(<x>,<y>, 177, 0)
    else
        ; warn "bad parameter for %S_BlockSnake type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a falling spike sprite
;         x: x position within the level
;         y: y position within the level
macro S_FallingSpike(x, y)
    %S_Sprite(<x>,<y>, 178, 0)
endmacro

; insert a statue fireball sprite
;         x: x position within the level
;         y: y position within the level
macro S_StatueFireball(x, y)
    %S_Sprite(<x>,<y>, 179, 0)
endmacro

; insert a diagonal platform sprite
;         x: x position within the level
;         y: y position within the level
; direction:
;       "upright": bottom left to top right
;     "downright": top left to bottom right
macro S_DiagonalPlatform(x, y, direction)
    if stringsequal("<direction>","upright")
        %S_Sprite(<x>,<y>, 183, 0)
    elseif stringsequal("<direction>","downright")
        %S_Sprite(<x>,<y>, 184, 0)
    else
        ; warn "bad parameter for %S_DiagonalPlatform direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a message block sprite
; message is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;   message: message to use (1-2)
macro S_MessageBlock(x, y, message)
    if and(equal(<x>&1,0),not(equal(<message>,1)))
        ; warn "MessageBlock will not match message, will be 1 (was ",<message>,"), at ",pc
    elseif and(equal(<x>&1,1),not(equal(<message>,2)))
        ; warn "MessageBlock will not match message, will be 2 (was ",<message>,"), at ",pc
    endif
    if or(equal(<message>,1),equal(<message>,2))
        %S_Sprite(<x>,<y>, 185, 0)
    else
        ; warn "bad parameter for %S_MessageBlock message (",<message>,") at ",pc,", skipping"
    endif
endmacro

; insert a timed platform sprite
; time is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
;      time: time to fall (1 or 4)
macro S_TimedPlatform(x, y, time)
    if and(equal(<x>&1,0),not(equal(<time>,4)))
        ; warn "TimedPlatform will not match time, will be 4 (was ",<time>,"), at ",pc
    elseif and(equal(<x>&1,1),not(equal(<time>,1)))
        ; warn "TimedPlatform will not match time, will be 1 (was ",<time>,"), at ",pc
    endif
    if or(equal(<time>,4),equal(<time>,1))
        %S_Sprite(<x>,<y>, 186, 0)
    else
        ; warn "bad parameter for %S_TimedPlatform time (",<time>,") at ",pc,", skipping"
    endif
endmacro

; insert a moving stone block sprite
;         x: x position within the level
;         y: y position within the level
macro S_StoneBlock(x, y)
    %S_Sprite(<x>,<y>, 187, 0)
endmacro

; insert a bowser statue sprite
; type is dependent on x pos mod 4
;         x: x position within the level
;         y: y position within the level
;      type:
;        "normal": doesn't do anything
;          "fire": shoots fire
;       "jumping": golden and jumps
macro S_Statue(x, y, type)
    if and(equal(<x>&3,0),not(stringsequal("<type>","normal")))
        ; warn "Statue will not match type, will be normal (was ",<type>,"), at ",pc
    elseif and(equal(<x>&3,2),not(stringsequal("<type>","jumping")))
        ; warn "Statue will not match type, will be jumping (was ",<type>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<type>","fire")))
        ; warn "Statue will not match type, will be fire (was ",<type>,"), at ",pc
    endif
    if or(stringsequal("<type>","normal"),or(stringsequal("<type>","jumping"),stringsequal("<type>","fire")))
        %S_Sprite(<x>,<y>, 188, 0)
    else
        ; warn "bad parameter for %S_Statue type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a swooper sprite
;         x: x position within the level
;         y: y position within the level
macro S_Swooper(x, y)
    %S_Sprite(<x>,<y>, 190, 0)
endmacro

; insert a mega mole sprite
;         x: x position within the level
;         y: y position within the level
macro S_MegaMole(x, y)
    %S_Sprite(<x>,<y>, 191, 0)
endmacro

; insert a sinking lava platform sprite
;         x: x position within the level
;         y: y position within the level
macro S_LavaPlatform(x, y)
    %S_Sprite(<x>,<y>, 192, 0)
endmacro

; insert a flying gray turn block platform sprite
; direction is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
; direction:
;       "goingup": goes up first
;     "goingdown": goes down first
macro S_AutoscrollPlatform(x, y, direction)
    if and(equal(<x>&1,0),not(stringsequal("<direction>","goingup")))
        ; warn "AutoscrollPlatform will not match direction, will be goingup (was ",<direction>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<direction>","goingdown")))
        ; warn "AutoscrollPlatform will not match direction, will be goingdown (was ",<direction>,"), at ",pc
    endif
    if or(stringsequal("<direction>","goingup"),stringsequal("<direction>","goingdown"))
        %S_Sprite(<x>,<y>, 193, 0)
    else
        ; warn "bad parameter for %S_AutoscrollPlatform direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a blurp sprite
;         x: x position within the level
;         y: y position within the level
macro S_Blurp(x, y)
    %S_Sprite(<x>,<y>, 194, 0)
endmacro

; insert a porcupuffer sprite
;         x: x position within the level
;         y: y position within the level
macro S_Porcupuffer(x, y)
    %S_Sprite(<x>,<y>, 195, 0)
endmacro

; insert a gray falling platform sprite
;         x: x position within the level
;         y: y position within the level
macro S_FallingPlatform(x, y)
    %S_Sprite(<x>,<y>, 196, 0)
endmacro

; insert a dark room and spotlight sprite
;         x: x position within the level
;         y: y position within the level
macro S_Spotlight(x, y)
    %S_Sprite(<x>,<y>, 198, 0)
endmacro

; insert an invisible mushroom sprite
;         x: x position within the level
;         y: y position within the level
macro S_InvisibleMushroom(x, y)
    %S_Sprite(<x>,<y>, 199, 0)
endmacro

; insert a dark room light switch sprite
;         x: x position within the level
;         y: y position within the level
macro S_LightSwitch(x, y)
    %S_Sprite(<x>,<y>, 200, 0)
endmacro

; insert a sprite spawner
;         x: x position within the level
;         y: y position within the level
;      type:
;    "bulletbill": bullet bill
;    "torpedoted": torpedo ted
macro S_Spawner(x, y, type)
    if stringsequal("<type>","bulletbill")
        %S_Sprite(<x>,<y>, 201, 0)
    elseif stringsequal("<type>","torpedoted")
        %S_Sprite(<x>,<y>, 202, 0)
    else
        ; warn "bad parameter for %S_Spawner type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a sprite generator
;         x: x position within the level
;         y: y position within the level
;      type:
;        "eeries": eeries
;       "goombas": parachuting goombas
;       "bobombs": parachuting bobombs
;"goombasbobombs": parachuting goombas and bobombs
;  "dolphinsleft": dolphins jumping left
; "dolphinsright": dolphins jumping right
;   "cheepcheeps": flying cheep cheeps
;   "superkoopas": flying super koopas
;       "bubbles": bubbles with goombas, bobombs, and cheep cheeps
; "bulletsrandom": single bullet bills at random
;   "bullets5way": 5 horizontal and vertical bullet bills at once
;   "bullets4way": 4 diagonal bullet bills at once
;     "fireballs": statue fireballs
macro S_Generator(x, y, type)
    if stringsequal("<type>","eeries")
        %S_Sprite(<x>,<y>, 203, 0)
    elseif stringsequal("<type>","goombas")
        %S_Sprite(<x>,<y>, 204, 0)
    elseif stringsequal("<type>","bobombs")
        %S_Sprite(<x>,<y>, 205, 0)
    elseif stringsequal("<type>","goombasbobombs")
        %S_Sprite(<x>,<y>, 206, 0)
    elseif stringsequal("<type>","dolphinsleft")
        %S_Sprite(<x>,<y>, 207, 0)
    elseif stringsequal("<type>","dolphinsright")
        %S_Sprite(<x>,<y>, 208, 0)
    elseif stringsequal("<type>","cheepcheeps")
        %S_Sprite(<x>,<y>, 209, 0)
    elseif stringsequal("<type>","superkoopas")
        %S_Sprite(<x>,<y>, 211, 0)
    elseif stringsequal("<type>","bubbles")
        %S_Sprite(<x>,<y>, 212, 0)
    elseif stringsequal("<type>","bulletsrandom")
        %S_Sprite(<x>,<y>, 213, 0)
    elseif stringsequal("<type>","bullets5way")
        %S_Sprite(<x>,<y>, 214, 0)
    elseif stringsequal("<type>","bullets4way")
        %S_Sprite(<x>,<y>, 215, 0)
    elseif stringsequal("<type>","fireballs")
        %S_Sprite(<x>,<y>, 216, 0)
    else
        ; warn "bad parameter for %S_Generator type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a sprite to turn off of generators and swarming sprites
;         x: x position within the level
;         y: y position within the level
;      type:
;       "general": turns off generators
;        "goaway": turns off boofog and makes lakitu and magikoopa go away
macro S_StopGenerator(x, y, type)
    if stringsequal("<type>","general")
        %S_Sprite(<x>,<y>, 217, 0)
    elseif stringsequal("<type>","goaway")
        %S_Sprite(<x>,<y>, 210, 0)
    else
        ; warn "bad parameter for %S_StopGenerator type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a group of 5 eerie sprites
;         x: x position within the level
;         y: y position within the level
macro S_5Eeries(x, y)
    %S_Sprite(<x>,<y>, 222, 0)
endmacro

; insert a triple gray rotating platform
; direction is dependent on x pos mod 2
;         x: x position within the level
;         y: y position within the level
; direction:
;            "cw": clockwise
;           "ccw": counterclockwise
macro S_3RotatingPlatforms(x, y, direction)
    if and(equal(<x>&1,0),not(stringsequal("<direction>","cw")))
        ; warn "3RotatingPlatforms will not match direction, will be cw (was ",<direction>,"), at ",pc
    elseif and(equal(<x>&1,1),not(stringsequal("<direction>","ccw")))
        ; warn "3RotatingPlatforms will not match direction, will be ccw (was ",<direction>,"), at ",pc
    endif
    if or(stringsequal("<direction>","cw"),stringsequal("<direction>","ccw"))
        %S_Sprite(<x>,<y>, 224, 0)
    else
        ; warn "bad parameter for %S_3RotatingPlatforms direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a boo ceiling sprite
;         x: x position within the level
;         y: y position within the level
macro S_BooCeiling(x, y)
    %S_Sprite(<x>,<y>, 225, 0)
endmacro

; insert a boo ring sprite
;         x: x position within the level
;         y: y position within the level
; direction:
;            "cw": clockwise
;           "ccw": direction
macro S_BooRing(x, y, direction)
    if stringsequal("<direction>","cw")
        %S_Sprite(<x>,<y>, 227, 0)
    elseif stringsequal("<direction>","ccw")
        %S_Sprite(<x>,<y>, 226, 0)
    else
        ; warn "bad parameter for %S_BooRing direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a swooper ceiling sprite
;         x: x position within the level
;         y: y position within the level
macro S_SwooperCeiling(x, y)
    %S_Sprite(<x>,<y>, 228, 0)
endmacro

; insert a boo fog sprite
;         x: x position within the level
;         y: y position within the level
macro S_BooFog(x, y)
    %S_Sprite(<x>,<y>, 229, 0)
endmacro

; insert a background candle flames sprite
;         x: x position within the level
;         y: y position within the level
macro S_BackgroundFlames(x, y)
    %S_Sprite(<x>,<y>, 230, 0)
endmacro

; insert an autoscroller command
;         x: x position within the level (y pos for vertical level)
; type:
;           "dp2": special movement for donut plains 2
;           "bb1": special movement for butter bridge 1
;    "coinheaven": special movement for dark coin heaven in cheese bridge area
;          "slow": slow horizontal movement
;          "fast": fast horizontal movement
macro S_AutoScroll(x, type)
    if stringsequal("<type>","dp2")
        %S_Sprite(<x>, 0, 232, 0)
    elseif stringsequal("<type>","bb1")
        %S_Sprite(<x>, 0, 232, 3)
    elseif stringsequal("<type>","coinheaven")
        %S_Sprite(<x>, 1, 232, 0)
    elseif stringsequal("<type>","slow")
        %S_Sprite(<x>, 0, 243, 0)
    elseif stringsequal("<type>","fast")
        %S_Sprite(<x>, 0, 243, 1)
    else
        ; warn "bad parameter for %S_AutoScroll type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a layer 3 smash command
;         x: x position within the level (y pos for vertical level)
macro S_Layer3Smash(x)
    %S_Sprite(<x>, 0, 137, 0)
endmacro

; insert a layer 2 smash command
;         x: x position within the level (y pos for vertical level)
;      type:
;            "c6": special movement for wendy's castle
;          "vobf": special movement for valley fortress
;            "fd": special movement for front door room 5
macro S_Layer2Smash(x, type)
    if stringsequal("<type>","c6")
        %S_Sprite(<x>, 0, 233, 0)
    elseif stringsequal("<type>","vobf")
        %S_Sprite(<x>, 0, 233, 1)
    elseif stringsequal("<type>","fd")
        %S_Sprite(<x>, 0, 233, 2)
    else
        ; warn "bad parameter for %S_Layer2Smash type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a layer 2 scroll command
;         x: x position within the level (y pos for vertical level)
; direction:
;    "horizontal": movement left and right
;      "vertical": movement up and down
;      type:
;          "c2r3": special movement for morton's castle room 2
;          "c3r3": special movement for lemmy's castle room 3
;          "c6r1": special movement for wendy's castle room 2
;        "vob2r1": special movement for valley of bowser 2 room 1
;        "vob2r2": special movement for valley of bowser 2 room 2
;          "fdr4": special movement for bowser's castle room 4
;          "fdr6": special movement for bowser's caslte room 6
;            "up": movement upwards
;          "down": movement downwards
;         "onoff": movement driven by on/off switch
macro S_Layer2Scroll(x, direction, type)
    if stringsequal("<direction>","horizontal")
        if stringsequal("<type>","c2r3")
            %S_Sprite(0, <x>, 239, 0)
        elseif stringsequal("<type>","fdr6")
            %S_Sprite(0, <x>, 239, 1)
        else
            ; warn "bad parameter for horizontal %S_Layer2Smash type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal("<direction>","vertical")
        if stringsequal("<type>","c3r3")
            %S_Sprite(<x>, 0, 234, 3)
        elseif stringsequal("<type>","c6r1")
            %S_Sprite(<x>, 0, 234, 0)
        elseif stringsequal("<type>","vob2r1")
            %S_Sprite(<x>, 0, 234, 2)
        elseif stringsequal("<type>","vob2r2")
            %S_Sprite(<x>, 0, 234, 1)
        elseif stringsequal("<type>","fdr4")
            %S_Sprite(<x>, 1, 234, 0)
        elseif stringsequal("<type>","up")
            %S_Sprite(<x>, 0, 235, 1)
        elseif stringsequal("<type>","down")
            %S_Sprite(<x>, 0, 235, 0)
        elseif stringsequal("<type>","onoff")
            %S_Sprite(<x>, 0, 242, 0)
        else
            ; warn "bad parameter for vertical %S_Layer2Smash type (",<type>,") at ",pc,", skipping"
        endif
    else
        ; warn "bad parameter for %S_Layer2Scroll direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a layer 2 falls command
;         x: x position within the level (y pos for vertical level)
macro S_Layer2Falls(x)
    %S_Sprite(<x>, 0, 237, 0)
endmacro

; insert a fast background command
;         x: x position within the level (y pos for vertical level)
macro S_FastBackground(x)
    %S_Sprite(<x>, 0, 244, 0)
endmacro

; insert a layer 2 reacts command
;         x: x position within the level (y pos for vertical level)
;      type:
;         "vd1r2": special movement for vanilla dome 1 room 2
;          "csr3": special movement for chocolate secret room 3
;        "vob2r3": special movement for valley of bowser 2 room 3
macro S_Layer2Reacts(x, type)
    if stringsequal("<type>","csr3")
        %S_Sprite(<x>, 0, 245, 0)
    elseif stringsequal("<type>","vd1r2")
        %S_Sprite(<x>, 0, 245, 1)
    elseif stringsequal("<type>","vob2r3")
        %S_Sprite(<x>, 0, 245, 2)
    else
        ; warn "bad parameter for %S_Layer2Reacts type (",<type>,") at ",pc,", skipping"
    endif
endmacro