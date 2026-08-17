; combine two nybbles into a byte
function concat(a,b) = ((a&$F)<<4)|(b&$F)

; a mod b
function mod(a,b) = a-(b*floor(a/b))

; checks if the level mode is a vertical level
function isverticallevel(m) = or(equal(m,3),or(equal(m,4),or(equal(m,7),or(equal(m,8),or(equal(m,10),or(equal(m,13)))))))

; go to the coordinates (x,y) in the level
; by either setting the new screen flag, inserting a
; screen jump object, or doing nothing
macro L_GoTo(x, y)
    if !__vertical
        if or(greaterequal(<y>,$200),greaterequal(<x>,$20))
            error "The coordinates (",x,",",y,") are out of bounds for a vertical level, at ",pc
        elseif equal(<y>>>8,!__screen+1)
            !__newscreen #= 1
        elseif not(equal(<y>>>8,!__screen))
            %L_ScreenJump(<y>>>8)
        endif
    else
        if or(greaterequal(<x>,$200),greaterequal(<y>,$1B))
            error "The coordinates (",x,",",y,") are out of bounds for a horizontal level, at ",pc
        elseif equal(<x>>>8,!__screen+1)
            !__newscreen #= 1
        elseif not(equal(<x>>>8,!__screen))
            %L_ScreenJump(<x>>>8)
        endif
    endif
endmacro

; insert a generic level object
;         x: x position within the level
;         y: y position within the level
;       obj: ID of the object (0-63)
;  settings: 8-bit settings byte which depends on the object
macro L_Object(x, y, obj, settings)
    %L_GoTo(x, y)
    if !__vertical
        db (!__newscreen<<7)|((<obj>&$30)<<1)|(<x>&$1F)
        db (<obj><<4)|(<y>&$F)
    else
        db (!__newscreen<<7)|((<obj>&$30)<<1)|(<y>&$1F)
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
    !__tileset #= <bggfx>
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
    if stringsequal(<surface>,"surface")
        if stringsequal(<animated>,"animated")
            %L_Object(x, y, 24, concat(<height>-1,<width>-1))
        elseif stringsequal(<animated>,"still")
            %L_Object(x, y, 25, concat(<height>-1,<width>-1))
        else
            warn "bad parameter for %L_Water animated (",<animated>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<surface>,"deep")
        if stringsequal(<animated>,"animated")
            %L_Object(x, y, 1, concat(<height>-1,<width>-1))
        elseif stringsequal(<animated>,"still")
            %L_Object(x, y, 7, concat(<height>-1,<width>-1))
        else
            warn "bad parameter for %L_Water animated (",<animated>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_Water surface (",<surface>,") at ",pc,", skipping"
    endif
endmacro

; insert a lava object (used in castles)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_Lava(x, y, width, height)
    %L_Object(x, y, 26, concat(<height>-1,<width>-1))
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
    assert equal(!__tileset,3),"cannot insert CaveLava, tileset must be 3 (was ",!__tileset,"), at ",pc
    if stringsequal(<surface>,"surface")
        %L_Object(x, y, 58, concat(<height>-1,<width>-1))
    elseif stringsequal(<surface>,"deep")
        %L_Object(x, y, 59, concat(<height>-1,<width>-1))
    else
        warn "bad parameter for %L_CaveLava surface (",<surface>,") at ",pc,", skipping"
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
    if stringsequal(<type>,"top")
        assert equal(!__tileset,3),"cannot insert CaveLavaEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
        %L_Object(x, y, 56, concat(<height>-1,0))
    elseif stringsequal(<type>,"middle")
        assert equal(!__tileset,3),"cannot insert CaveLavaEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
        %L_Object(x, y, 56, concat(<height>-1,1))
    elseif stringsequal(<type>,"bottom")
        %L_Object(x, y, 0, 96)
    else
        warn "bad parameter for %L_CaveLavaEdge type (",<type>,") at ",pc,", skipping"
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
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_CaveLavaSlope(x, y, direction, angle, width, height)
    assert equal(!__tileset,3),"cannot insert CaveLava, tileset must be 3 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"up")
        if stringsequal(<angle>,"normal")
            %L_Object(x, y, 57, concat(<height>-1,0))
        elseif stringsequal(<angle>,"steep")
            %L_Object(x, y, 57, concat(<height>-1,1))
        else
            warn "bad parameter for %L_CaveLavaSlope angle (",<angle>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"down")
        if stringsequal(<angle>,"normal")
            %L_Object(x, y, 57, concat(<height>-1,2))
        elseif stringsequal(<angle>,"steep")
            %L_Object(x, y, 57, concat(<height>-1,3))
        else
            warn "bad parameter for %L_CaveLavaSlope angle (",<angle>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_CaveLavaSlope direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a midway posts object
;         x: x position within the level
;         y: y position within the level
;    length: height of object in tiles (1-16)
macro L_MidwayPosts(x, y, length)
    %L_Object(x, y, 21, concat(<height>-1,0))
endmacro

; insert a midway tape object
;         x: x position within the level
;         y: y position within the level
macro L_MidwayTape(x, y)
    %L_Object(x, y, 0, 70)
endmacro

; insert an unused tile which is the bottom right post of the midway
;         x: x position within the level
;         y: y position within the level
;      type: which of the two tiles to use (1-2)
macro L_MidwayTile(x, y, type)
    if equal(<type>,1)
        %L_Object(x, y, 0, 33)
    elseif equal(<type>,2)
        %L_Object(x, y, 0, 34)
    else
        warn "bad parameter for %L_MidwayTile type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a goal posts object
;         x: x position within the level
;         y: y position within the level
;    length: height of object in tiles (1-16) (the standard is 10)
macro L_GoalPosts(x, y, length)
    %L_Object(x, y, 21, concat(<height>-1,1))
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
    if stringsequal(<size>,"big")
        if stringsequal(<type>,"normal")
            %L_Object(x, y, 0, 71)
        elseif stringsequal(<type>,"pswitch")
            %L_Object(x, y, 0, 72)
        else
            warn "bad parameter for %L_Door type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<size>,"small")
        if stringsequal(<type>,"normal")
            %L_Object(x, y, 0, 16)
        elseif stringsequal(<type>,"pswitch")
            %L_Object(x, y, 0, 21)
        else
            warn "bad parameter for %L_Door type (",<type>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_Door size (",<size>,") at ",pc,", skipping"
    endif
endmacro

; insert a big boss door object
;         x: x position within the level
;         y: y position within the level
macro L_BossDoor(x, y)
    %L_Object(x, y, 0, 144)
endmacro

; insert a berry object
;         x: x position within the level
;         y: y position within the level
;      type:
;          "red": red berry, 10 = mushroom
;         "pink": pink berry, 2 = bonus cloud
;        "green": green berry, 1 = +10 seconds
macro L_Berry(x, y, type)
    if stringequal(<type>,"red")
        %L_Object(x, y, 0, 29)
    elseif stringequal(<type>,"pink")
        %L_Object(x, y, 0, 30)
    elseif stringequal(<type>,"green")
        %L_Object(x, y, 0, 31)
    else
        warn "bad parameter for %L_Berry type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a 1-up checkpoint object
;         x: x position within the level
;         y: y position within the level
;      flag: which checkpoint this is (1-4)
macro L_1upCheckpoint(x, y, flag)
    if equal(<flag>,1)
        %L_Object(x, y, 0, 25)
    elseif equal(<flag>,2)
        %L_Object(x, y, 0, 26)
    elseif equal(<flag>,3)
        %L_Object(x, y, 0, 27)
    elseif equal(<flag>,4)
        %L_Object(x, y, 0, 28)
    else
        warn "bad parameter for %L_1upCheckpoint flag (",<flag>,") at ",pc,", skipping"
    endif
endmacro

; insert a 3-Up moon object
;         x: x position within the level
;         y: y position within the level
macro L_3upMoon(x, y)
    %L_Object(x, y, 0, 24)
endmacro

; insert the Yoshi's House object
;         x: x position within the level
;         y: y position within the level
macro L_YoshisHouse(x, y)
    %L_Object(x, y, 0, 133)
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
    if stringsequal(<type>,"ghosthouse")
        if stringsequal(<type>,"entrance")
            %L_Object(x, y, 0, 128)
        elseif stringsequal(<type>,"exit")
            %L_Object(x, y, 0, 73)
        else
            warn "bad parameter for %L_StructureFacade exit (",<exit>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<type>,"castle")
        if stringsequal(<type>,"entrance")
            %L_Object(x, y, 0, 132)
        else
            warn "bad parameter for %L_StructureFacade exit (",<exit>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_StructureFacade type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a green star block object
;         x: x position within the level
;         y: y position within the level
macro L_GreenStarBlock(x, y)
    %L_Object(x, y, 0, 23)
endmacro

; insert an ON/OFF block object
;         x: x position within the level
;         y: y position within the level
macro L_OnOffBlock(x, y)
    %L_Object(x, y, 0, 36)
endmacro

; insert a glass block object for use with the roulette item
;         x: x position within the level
;         y: y position within the level
macro L_GlassBlock(x, y)
    %L_Object(x, y, 0, 64)
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
macro L_SwitchBlock(x, y, color, width, height)
    if stringsequal(<color>,"yellow")
        assert equal(<width>,1),"cannot insert yellow SwitchBlock, width must be 1 (was ",<width>,"), at ",pc
        assert equal(<height>,1),"cannot insert yellow SwitchBlock, height must be 1 (was ",<height>,"), at ",pc
        %L_Object(x, y, 0, 142)
    elseif stringsequal(<color>,"green")
        assert equal(<width>,1),"cannot insert green SwitchBlock, width must be 1 (was ",<width>,"), at ",pc
        assert equal(<height>,1),"cannot insert green SwitchBlock, height must be 1 (was ",<height>,"), at ",pc
        %L_Object(x, y, 0, 135)
    elseif stringsequal(<color>,"red")
        if equal(!__tileset,0)
            %L_Object(x, y, 56, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,1)
            %L_Object(x, y, 58, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,2)
            %L_Object(x, y, 52, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,3)
            %L_Object(x, y, 53, concat(<height>-1,<width>-1))
        else
            error "cannot insert red SwitchBlock, tileset must not be 4 (was ",!__tileset,"), at ",pc
        endif
    elseif stringsequal(<color>,"blue")
        if equal(!__tileset,0)
            %L_Object(x, y, 50, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,1)
            %L_Object(x, y, 57, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,2)
            %L_Object(x, y, 51, concat(<height>-1,<width>-1))
        elseif equal(!__tileset,3)
            %L_Object(x, y, 52, concat(<height>-1,<width>-1))
        else
            error "cannot insert blue SwitchBlock, tileset must not be 4 (was ",!__tileset,"), at ",pc
        endif
    else
        warn "bad parameter for %L_SwitchBlock color (",<color>,") at ",pc,", skipping"
    endif
endmacro

; insert a set of throw blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_ThrowBlocks(x, y, width, height)
    %L_Object(x, y, 11, concat(<height>-1,<width>-1))
endmacro

; insert a set of munchers object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_Munchers(x, y, width, height)
    %L_Object(x, y, 12, concat(<height>-1,<width>-1))
endmacro

; insert a set of cement blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_CementBlocks(x, y, width, height)
    %L_Object(x, y, 13, concat(<height>-1,<width>-1))
endmacro

; insert a set of brown used blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_UsedBlocks(x, y, width, height)
    %L_Object(x, y, 14, concat(<height>-1,<width>-1))
endmacro

; insert a set of wooden blocks object
; tileset must be 4 (bonus/ghost house)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_WoodenBlocks(x, y, width, height)
    assert equal(!__tileset,4),"cannot insert WoodenBlocks, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 54, concat(<height>-1,<width>-1))
endmacro

; insert a set of coins object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_Coins(x, y, width, height)
    %L_Object(x, y, 5, concat(<height>-1,<width>-1))
endmacro

; insert a set of P-switch coins object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_PSwitchCoins(x, y, width, height)
    %L_Object(x, y, 4, concat(<height>-1,<width>-1))
endmacro

; insert a set of unused blue coins object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_BlueCoins(x, y, width, height)
    %L_Object(x, y, 22, concat(<height>-1,<width>-1))
endmacro

; insert a dragon coin object
;         x: x position within the level
;         y: y position within the level
macro L_DragonCoin(x, y)
    %L_Object(x, y, 0, 65)
endmacro

; insert a set of note blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_NoteBlocks(x, y, width, height)
    %L_Object(x, y, 8, concat(<height>-1,<width>-1))
    ;%L_Object(x, y, 0, 38) ; unused single note block extended object
endmacro

; insert a set of invisible note blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_InvisibleNoteBlocks(x, y, width, height)
    %L_Object(x, y, 3, concat(<height>-1,<width>-1))
    ;%L_Object(x, y, 0, 18) ; unused single invisible note block extended object
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
    if and(equal(mod(<x>&$F,3),0),not(stringequal(<contents>,"flower"))
        warn "ItemNoteBlock will not match contents, will be flower (was ",<contents>,"), at ",pc
    elseif and(equal(mod(<x>&$F,3),1),not(stringequal(<contents>,"feather"))
        warn "ItemNoteBlock will not match contents, will be feather (was ",<contents>,"), at ",pc
    elseif and(equal(mod(<x>&$F,3),2),not(stringequal(<contents>,"star"))
        warn "ItemNoteBlock will not match contents, will be star (was ",<contents>,"), at ",pc
    endif
    %L_Object(x, y, 0, 35)
endmacro

; insert an extra bouncy note block object
;         x: x position within the level
;         y: y position within the level
macro L_BouncyNoteBlock(x, y)
    %L_Object(x, y, 0, 39)
endmacro

; insert a set of turn blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_TurnBlocks(x, y, width, height)
    %L_Object(x, y, 9, concat(<height>-1,<width>-1))
endmacro

; insert a set of icy turn blocks object
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_IcyTurnBlocks(x, y, width, height)
    assert equal(!__tileset,0),"cannot insert IcyTurnBlocks, tileset must be 0 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 49, concat(<height>-1,<width>-1))
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
    if stringequal(<contents>,"coin")
        %L_Object(x, y, 0, 45)
    elseif stringequal(<contents>,"coins")
        %L_Object(x, y, 0, 44)
    elseif stringequal(<contents>,"flower")
        %L_Object(x, y, 0, 40)
    elseif stringequal(<contents>,"feather")
        %L_Object(x, y, 0, 41)
    elseif stringequal(<contents>,"star")
        %L_Object(x, y, 0, 42)
    elseif or(stringequal(<contents>,"chainstar"),stringequal(<contents>,"1up"),stringequal(<contents>,"vine"))
        if and(equal(mod(<x>&$F,3),0),not(stringequal(<contents>,"chainstar"))
            warn "ItemTurnBlock will not match contents, will be chainstar (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,3),1),not(stringequal(<contents>,"1up"))
            warn "ItemTurnBlock will not match contents, will be 1up (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,3),2),not(stringequal(<contents>,"vine"))
            warn "ItemTurnBlock will not match contents, will be vine (was ",<contents>,"), at ",pc
        endif
        %L_Object(x, y, 0, 43)
    elseif or(stringequal(<contents>,"bluepswitch"),stringequal(<contents>,"graypswitch"))
        if and(equal(mod(<x>&$F,2),0),not(stringequal(<contents>,"bluepswitch"))
            warn "ItemTurnBlock will not match contents, will be bluepswitch (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,2),1),not(stringequal(<contents>,"graypswitch"))
            warn "ItemTurnBlock will not match contents, will be graypswitch (was ",<contents>,"), at ",pc
        endif
        %L_Object(x, y, 0, 47)
    elseif stringequal(<contents>,"empty")
        %L_Object(x, y, 0, 46)
    elseif stringequal(<contents>,"sidefeather")
        %L_Object(x, y, 0, 57)
    else
        warn "bad parameter for %L_ItemTurnBlock contents (",<contents>,") at ",pc,", skipping"
    endif
endmacro

; insert an always spinning turn block object
;         x: x position within the level
;         y: y position within the level
macro L_SpinningTurnBlock(x, y)
    %L_Object(x, y, 0, 32)
endmacro

; insert a set of prize blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_PrizeBlocks(x, y, width, height)
    %L_Object(x, y, 10, concat(<height>-1,<width>-1))
endmacro

; insert a set of invisible prize blocks object
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_InvisiblePrizeBlocks(x, y, width, height)
    %L_Object(x, y, 2, concat(<height>-1,<width>-1))
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
    if stringequal(<contents>,"coins")
        %L_Object(x, y, 0, 52)
    elseif stringequal(<contents>,"flower")
        %L_Object(x, y, 0, 48)
    elseif stringequal(<contents>,"feather")
        %L_Object(x, y, 0, 49)
    elseif stringequal(<contents>,"star")
        %L_Object(x, y, 0, 50)
    elseif stringequal(<contents>,"chainstar")
        %L_Object(x, y, 0, 51)
    elseif stringequal(<contents>,"1up")
        %L_Object(x, y, 0, 17)
    elseif stringequal(<contents>,"yoshi")
        %L_Object(x, y, 0, 54)
    elseif stringequal(<contents>,"coinsnake")
        %L_Object(x, y, 0, 37)
    elseif or(stringequal(<contents>,"key"),stringequal(<contents>,"wings"),stringequal(<contents>,"pballoon"),stringequal(<contents>,"shell"))
        if and(equal(mod(<x>&$F,4),0),not(stringequal(<contents>,"key"))
            warn "ItemPrizeBlock will not match contents, will be key (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,4),1),not(stringequal(<contents>,"wings"))
            warn "ItemPrizeBlock will not match contents, will be wings (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,4),2),not(stringequal(<contents>,"pballoon"))
            warn "ItemPrizeBlock will not match contents, will be pballoon (was ",<contents>,"), at ",pc
        elseif and(equal(mod(<x>&$F,4),3),not(stringequal(<contents>,"shell"))
            warn "ItemPrizeBlock will not match contents, will be shell (was ",<contents>,"), at ",pc
        endif
        %L_Object(x, y, 0, 53)
    elseif stringequal(<contents>,"shell2")
        %L_Object(x, y, 0, 55)
    elseif stringequal(<contents>,"shell3")
        %L_Object(x, y, 0, 56)
    else
        warn "bad parameter for %L_ItemPrizeBlock contents (",<contents>,") at ",pc,", skipping"
    endif
endmacro

; insert a P-switch prize block object
;         x: x position within the level
;         y: y position within the level
macro L_PSwitchPrizeBlock(x, y)
    %L_Object(x, y, 0, 22)
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
    if stringsequal(<direction>,"horizontal")
        if stringsequal(<type>,"left")
            if stringsequal(<exit>,"open")
                %L_Object(x, y, 16, concat(1,<length>-1))
            elseif stringsequal(<exit>,"closed")
                %L_Object(x, y, 16, concat(0,<length>-1))
            else
                warn "bad parameter for %L_Pipe exit (",<exit>,") at ",pc,", skipping"
            endif
        elseif stringsequal(<type>,"right")
            if stringsequal(<exit>,"open")
                %L_Object(x, y, 16, concat(3,<length>-1))
            elseif stringsequal(<exit>,"closed")
                %L_Object(x, y, 16, concat(2,<length>-1))
            else
                warn "bad parameter for %L_Pipe exit (",<exit>,") at ",pc,", skipping"
            endif
        else
            warn "bad parameter for %L_Pipe type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"vertical")
        if stringsequal(<type>,"top")
            if stringsequal(<exit>,"open")
                %L_Object(x, y, 15, concat(<length>-1,1))
            elseif stringsequal(<exit>,"closed")
                %L_Object(x, y, 15, concat(<length>-1,0))
            else
                warn "bad parameter for %L_Pipe exit (",<exit>,") at ",pc,", skipping"
            endif
        elseif stringsequal(<type>,"bottom")
            if stringsequal(<exit>,"open")
                %L_Object(x, y, 15, concat(<length>-1,4))
            elseif stringsequal(<exit>,"closed")
                %L_Object(x, y, 15, concat(<length>-1,3))
            else
                warn "bad parameter for %L_Pipe exit (",<exit>,") at ",pc,", skipping"
            endif
        elseif stringsequal(<type>,"both")
            %L_Object(x, y, 15, concat(<length>-1,2))
        elseif stringsequal(<type>,"bothspecial")
            assert equal(!__tileset,1),"cannot insert bothspecial Pipe, tileset must be 1 (was ",!__tileset,"), at ",pc
            %L_Object(x, y, 52, concat(<length>-1,0))
        elseif stringsequal(<type>,"none")
            %L_Object(x, y, 15, concat(<length>-1,5))
        elseif stringsequal(<type>,"icytop")
            assert equal(!__tileset,0),"cannot insert icytop Pipe, tileset must be 0 (was ",!__tileset,"), at ",pc
            %L_Object(x, y, 48, concat(<length>-1,0))
        else
            warn "bad parameter for %L_Pipe type (",<type>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_Pipe direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a diagonal pipe object
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_DiagonalPipe(x, y, length)
    assert equal(!__tileset,0),"cannot insert DiagonalPipe, tileset must be 0 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 57, concat(<length>-1,0))
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
    if stringsequal(<type>,"big")
        if not(equal(<length>,1))
            warn "bad parameter for %L_Bush length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        %L_Object(x, y, 0, 130)
    elseif stringsequal(<type>,"medium")
        if not(equal(<length>,1))
            warn "bad parameter for %L_Bush length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        %L_Object(x, y, 0, 131)
    else
        assert equal(!__tileset,0),"cannot insert Bush, tileset must be 0 (was ",!__tileset,"), at ",pc
        if stringsequal(<type>,"small")
            %L_Object(x, y, 63, concat(0,<length>-1))
        elseif stringsequal(<type>,"tiny")
            %L_Object(x, y, 63, concat(1,<length>-1))
        elseif stringsequal(<type>,"dirt")
            %L_Object(x, y, 63, concat(2,<length>-1))
        elseif stringsequal(<type>,"glitched")
            %L_Object(x, y, 63, concat(3,<length>-1))
        elseif stringsequal(<type>,"grass")
            %L_Object(x, y, 63, concat(4,<length>-1))
        else
            warn "bad parameter for %L_Bush type (",<type>,") at ",pc,", skipping"
        endif
    endif
endmacro

; insert an arrow sign object
;         x: x position within the level
;         y: y position within the level
macro L_ArrowSign(x, y)
    %L_Object(x, y, 0, 134)
endmacro

; insert a forest canopy object
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in screens (1-256)
macro L_ForestCanopy(x, y, length)
    assert equal(!__tileset,0),"cannot insert ForestCanopy, tileset must be 0 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 51, <length>-1)
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
    assert equal(!__tileset,0),"cannot insert TreeTrunk, tileset must be 0 (was ",!__tileset,"), at ",pc
    if stringsequal(<type>,"small")
        if stringsequal(<priority>,"foreground")
            %L_Object(x, y, 55, concat(<length>-1,1))
        elseif stringsequal(<priority>,"background")
            %L_Object(x, y, 55, concat(<length>-1,0))
        else
            warn "bad parameter for %L_TreeTrunk priority (",<priority>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<type>,"big")
        if stringsequal(<priority>,"foreground")
            %L_Object(x, y, 54, concat(<length>-1,0))
        else
            warn "bad parameter for %L_TreeTrunk priority (",<priority>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_TreeTrunk type (",<type>,") at ",pc,", skipping"
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
    assert equal(!__tileset,0),"cannot insert TreeBranch, tileset must be 0 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"left")
        %L_Object(x, y, 0, 136)
    elseif stringsequal(<direction>,"right")
        %L_Object(x, y, 0, 137)
    else
        warn "bad parameter for %L_TreeBranch direction (",<direction>,") at ",pc,", skipping"
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
    assert equal(!__tileset,1),"cannot insert RockyBackground, tileset must be 1 (was ",!__tileset,"), at ",pc
    if equal(<width>&1,1)
        warn "bad parameter for %L_RockyBackground width (",<width>,") at ",pc,", using ",<width>&$FE," instead"
    endif
    if equal(<height>&1,1)
        warn "bad parameter for %L_RockyBackground height (",<height>,") at ",pc,", using ",<height>&$FE," instead"
    endif
    %L_Object(x, y, 53, concat((<height>/2)-1,(<width>/2)-1))
endmacro

; insert a large background object
; unused, fills up 4x16x16 screens
;         x: x position within the level
;         y: y position within the level
macro L_LargeBackground(x, y)
    %L_Object(x, y, 0, 95)
endmacro

; insert an escalator start/end tile
; the two types are identical but animate out
; of phase with each other
;         x: x position within the level
;         y: y position within the level
;      type: which tile to use (1-2)
macro L_EscalatorEnd(x, y, type)
    if equal(<type>,1)
        %L_Object(x, y, 0, 75)
    elseif equal(<type>,2)
        %L_Object(x, y, 0, 76)
    else
        warn "bad parameter for %L_EscalatorEnd type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a seaweed object
; unused, generally found in the background
;         x: x position within the level
;         y: y position within the level
macro L_Seaweed(x, y)
    %L_Object(x, y, 0, 129)
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
    if stringequal(<direction>,"top")
        if stringequal(<type>,"long")
            assert equal(!__tileset,0),"cannot insert CloudFringe, tileset must be 0 (was ",!__tileset,"), at ",pc
            if stringequal(<bg>,"transparent")
                %L_Object(x, y, 61, concat(0,<length>-1))
            elseif stringequal(<bg>,"solid")
                %L_Object(x, y, 61, concat(1,<length>-1))
            else
                warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        elseif stringequal(<type>,"shortleft")
            if not(equal(<length>,1))
                warn "bad parameter for %L_CloudFringe length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
            endif
            if stringequal(<bg>,"transparent")
                %L_Object(x, y, 0, 107)
            elseif stringequal(<bg>,"solid")
                %L_Object(x, y, 0, 111)
            else
                warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        elseif stringequal(<type>,"shortright")
            if not(equal(<length>,1))
                warn "bad parameter for %L_CloudFringe length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
            endif
            if stringequal(<bg>,"transparent")
                %L_Object(x, y, 0, 106)
            elseif stringequal(<bg>,"solid")
                %L_Object(x, y, 0, 110)
            else
                warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        else
            warn "bad parameter for %L_CloudFringe type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringequal(<direction>,"left")
        assert equal(!__tileset,0),"cannot insert CloudFringe, tileset must be 0 (was ",!__tileset,"), at ",pc
        if stringequal(<type>,"long")
            if stringequal(<bg>,"transparent")
                %L_Object(x, y, 62, concat(<length>-1,1))
            elseif stringequal(<bg>,"solid")
                %L_Object(x, y, 62, concat(<length>-1,3))
            else
                warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        elseif stringequal(<type>,"short")
            if stringequal(<bg>,"transparent")
                %L_Object(x, y, 62, concat(<length>-1,0))
            elseif stringequal(<bg>,"solid")
                %L_Object(x, y, 62, concat(<length>-1,2))
            else
                warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        else
            warn "bad parameter for %L_CloudFringe type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringequal(<direction>,"right")
        assert equal(!__tileset,0),"cannot insert CloudFringe, tileset must be 0 (was ",!__tileset,"), at ",pc
        if stringequal(<type>,"long")
            if stringequal(<bg>,"transparent")
                %L_Object(x, y, 62, concat(<length>-1,5))
            elseif stringequal(<bg>,"solid")
                %L_Object(x, y, 62, concat(<length>-1,7))
            else
                warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        elseif stringequal(<type>,"short")
            if stringequal(<bg>,"transparent")
                %L_Object(x, y, 62, concat(<length>-1,4))
            elseif stringequal(<bg>,"solid")
                %L_Object(x, y, 62, concat(<length>-1,6))
            else
                warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
            endif
        else
            warn "bad parameter for %L_CloudFringe type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringequal(<direction>,"topleft")
        if not(equal(<length>,1))
            warn "bad parameter for %L_CloudFringe length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        if not(stringsequal(<type>,"long"))
            warn "bad parameter for %L_CloudFringe type, must be long, was (",<type>,") at ",pc,", using long instead"
        endif
        if stringequal(<bg>,"transparent")
            %L_Object(x, y, 0, 104)
        elseif stringequal(<bg>,"solid")
            %L_Object(x, y, 0, 108)
        else
            warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
        endif
    elseif stringequal(<direction>,"topright")
        if not(equal(<length>,1))
            warn "bad parameter for %L_CloudFringe length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        if not(stringsequal(<type>,"long"))
            warn "bad parameter for %L_CloudFringe type, must be long, was (",<type>,") at ",pc,", using long instead"
        endif
        if stringequal(<bg>,"transparent")
            %L_Object(x, y, 0, 105)
        elseif stringequal(<bg>,"solid")
            %L_Object(x, y, 0, 109)
        else
            warn "bad parameter for %L_CloudFringe bg (",<bg>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_CloudFringe direction (",<direction>,") at ",pc,", skipping"
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
macro L_LogBackground(x, y, type, width, height)
    assert equal(!__tileset,4),"cannot insert LogBackground, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"horizontal")
        if equal(<height>,1)
            ; special object used in case height == 1
            %L_Object(x, y, 55, concat(0,<width>-1))
        else
            ; technically means you can't place this object with height == 1
            ; it was never used in vanilla for some reason
            %L_Object(x, y, 47, concat(<height>-1,<width>-1))
        endif
    elseif stringsequal(<direction>,"vertical")
        assert equal(<width>,1),"cannot insert vertical LogBackground, width must be 1 (was ",<width>,"), at ",pc
        %L_Object(x, y, 57, concat(<height>-1,0))
    else
        warn "bad parameter for %L_LogBackground direction (",<direction>,") at ",pc,", skipping"
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
    assert equal(!__tileset,4),"cannot insert DiagonalBeam, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"upleft")
        if stringsequal(<size>,"short")
            %L_Object(x, y, 0, 99)
        elseif stringsequal(<size>,"long")
            %L_Object(x, y, 0, 103)
        else
            warn "bad parameter for %L_DiagonalBeam size (",<size>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"upright")
        if stringsequal(<size>,"short")
            %L_Object(x, y, 0, 98)
        elseif stringsequal(<size>,"long")
            %L_Object(x, y, 0, 102)
        else
            warn "bad parameter for %L_DiagonalBeam size (",<size>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_DiagonalBeam direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a brick background object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_BrickBackground(x, y, width, height)
    assert equal(!__tileset,4),"cannot insert BrickBackground, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 53, concat(<height>-1,<width>-1))
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
    assert equal(!__tileset,4),"cannot insert BrickTile, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal(<type>,"topright")
        %L_Object(x, y, 0, 91)
    elseif stringsequal(<type>,"bottom")
        %L_Object(x, y, 0, 92)
    elseif stringsequal(<type>,"topleft")
        %L_Object(x, y, 0, 93)
    elseif stringsequal(<type>,"bottomleft")
        %L_Object(x, y, 0, 94)
    else
        warn "bad parameter for %L_BrickTile type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a background clock object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
macro L_BackgroundClock(x, y)
    assert equal(!__tileset,4),"cannot insert BackgroundClock, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 0, 97)
endmacro

; insert a background window object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
macro L_BackgroundWindow(x, y)
    assert equal(!__tileset,4),"cannot insert BackgroundWindow, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 0, 143)
endmacro

; insert a cobweb object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
; direction:
;       "upleft": connects on top and left
;      "upright": connects on top and right
macro L_Cobweb(x, y, direction)
    assert equal(!__tileset,4),"cannot insert Cobweb, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"upleft")
        %L_Object(x, y, 0, 101)
    elseif stringsequal(<direction>,"upright")
        %L_Object(x, y, 0, 100)
    else
        warn "bad parameter for %L_Cobweb direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a background cloud object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_BackgroundCloud(x, y, length)
    assert equal(!__tileset,4),"cannot insert BackgroundCloud, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 51, concat(0,<length>-1))
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
    assert equal(!__tileset,4),"cannot insert HandRail, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal(<part>,"rail")
        %L_Object(x, y, 55, concat(1,<length>-1))
    elseif stringsequal(<part>,"posts")
        %L_Object(x, y, 55, concat(2,<length>-1))
    else
        warn "bad parameter for %L_HandRail part (",<part>,") at ",pc,", skipping"
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
    if stringsequal(<color>,"yellow")
        %L_Object(x, y, 0, 139)
    elseif stringsequal(<color>,"green")
        %L_Object(x, y, 0, 138)
    elseif stringsequal(<color>,"red")
        %L_Object(x, y, 0, 141)
    elseif stringsequal(<color>,"blue")
        %L_Object(x, y, 0, 140)
    else
        warn "bad parameter for %L_PalaceSwitch color (",<color>,") at ",pc,", skipping"
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
    if stringsequal(<direction>,"upleft")
        %L_Object(x, y, 0, 87)
    elseif stringsequal(<direction>,"upright")
        %L_Object(x, y, 0, 88)
    elseif stringsequal(<direction>,"downleft")
        %L_Object(x, y, 0, 89)
    elseif stringsequal(<direction>,"downright")
        %L_Object(x, y, 0, 90)
    else
        warn "bad parameter for %L_PalaceInnerCorner direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert an outer corner ledge tile for bonus rooms tile
; only the bottom right exists (shoutout to switchpalacecorner)
;         x: x position within the level
;         y: y position within the level
; direction:
;    "downright": corner on bottom right
macro L_PalaceOuterCorner(x, y, direction)
    if stringsequal(<direction>,"downright")
        %L_Object(x, y, 0, 151)
    else
        warn "bad parameter for %L_PalaceOuterCorner direction (",<direction>,") at ",pc,", skipping"
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
    assert equal(!__tileset,4),"cannot insert PalaceWalls, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal(<type>,"ceiling")
        %L_Object(x, y, 60, concat(<height>-1,<width>-1))
    elseif stringsequal(<type>,"floor")
        %L_Object(x, y, 61, concat(<height>-1,<width>-1))
    elseif stringsequal(<type>,"left")
        %L_Object(x, y, 62, concat(<height>-1,<width>-1))
    elseif stringsequal(<type>,"right")
        %L_Object(x, y, 63, concat(<height>-1,<width>-1))
    else
        warn "bad parameter for %L_PalaceWalls type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a bullet bill shooter object
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_BulletShooter(x, y, length)
    %L_Object(x, y, 17, concat(<length>-1,0))
endmacro

; insert a torpedo ted launcher object
;         x: x position within the level
;         y: y position within the level
macro L_TorpedoLauncher(x, y)
    %L_Object(x, y, 0, 127)
endmacro

; insert a climbing vine object
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_Vine(x, y, length)
    %L_Object(x, y, 19, concat(<length>-1,2))
endmacro

; insert a horizontal rope object
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_Rope(x, y, length)
    %L_Object(x, y, 23, concat(0,<length>-1))
endmacro

; insert a set of clouds object
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_Clouds(x, y, length)
    %L_Object(x, y, 23, concat(1,<length>-1))
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
    if stringsequal(<direction>,"horizontal")
        %L_Object(x, y, 32, concat(0,<length>-1))
    elseif stringsequal(<direction>,"vertical")
        %L_Object(x, y, 31, concat(<length>-1,0))
    else
        warn "bad parameter for %L_SkinnyPlatform direction (",<direction>,") at ",pc,", skipping"
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
    assert equal(!__tileset,2),"cannot insert WoodenPost, tileset must be 2 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"horizontal")
        %L_Object(x, y, 62, concat(0,<length>-1))
    elseif stringsequal(<direction>,"vertical")
        %L_Object(x, y, 63, concat(<length>-1,0))
    else
        warn "bad parameter for %L_WoodenPost direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a purple triangle object
;         x: x position within the level
;         y: y position within the level
; direction:
;         "left": run to the right to go up
;        "right": run to the left to go up
macro L_PurpleTriangle(x, y, direction)
    if stringsequal(<direction>,"left")
        %L_Object(x, y, 0, 68)
    elseif stringsequal(<direction>,"right")
        %L_Object(x, y, 0, 69)
    else
        warn "bad parameter for %L_PurpleTriangle direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a wooden bonus room ledge object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_BonusLedge(x, y, length)
    assert equal(!__tileset,4),"cannot insert BonusLedge, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 59, concat(0,<length>-1))
endmacro

; insert a bridge object
; tileset must be 2 (rope/mushroom) for log bridge
;         x: x position within the level
;         y: y position within the level
;      type:
;        "donut": yellow donuts with rails
;          "log": wooden logs
;    length: length of object in tiles (1-16)
macro L_Bridge(x, y, type, length)
    if stringsequal(<type>,"donut")
        %L_Object(x, y, 28, concat(0,<length>-1))
    elseif stringsequal(<type>,"log")
        assert equal(!__tileset,2),"cannot insert log Bridge, tileset must be 2 (was ",!__tileset,"), at ",pc
        %L_Object(x, y, 50, concat(0,<length>-1))
    else
        warn "bad parameter for %L_Bridge type (",<type>,") at ",pc,", skipping"
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
    assert equal(!__tileset,2),"cannot insert PlantPillar, tileset must be 2 (was ",!__tileset,"), at ",pc
    if stringsequal(<color>,"green")
        %L_Object(x, y, 53, concat(<length>-1,0))
    elseif stringsequal(<color>,"orange")
        %L_Object(x, y, 53, concat(<length>-1,1))
    elseif stringsequal(<color>,"yellow")
        %L_Object(x, y, 53, concat(<length>-1,2))
    elseif stringsequal(<color>,"blue")
        %L_Object(x, y, 53, concat(<length>-1,3))
    else
        warn "bad parameter for %L_PlantPillar color (",<color>,") at ",pc,", skipping"
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
    if stringsequal(<type>,"horizontal")
        if equal(!__tileset,1)
            if stringsequal(<direction>,"up")
                %L_Object(x, y, 55, concat(0,<length>-1))
            elseif stringsequal(<direction>,"down")
                %L_Object(x, y, 55, concat(1,<length>-1))
            else
                warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
            endif
        elseif equal(!__tileset,2)
            if stringsequal(<direction>,"up")
                %L_Object(x, y, 56, concat(0,<length>-1))
            elseif stringsequal(<direction>,"down")
                %L_Object(x, y, 56, concat(1,<length>-1))
            else
                warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
            endif
        else
            error "cannot insert GuideLine, tileset must be 1-2 (was ",!__tileset,"), at ",pc
        endif
    elseif stringsequal(<type>,"vertical")
        if equal(!__tileset,1)
            if stringsequal(<direction>,"left")
                %L_Object(x, y, 56, concat(<length>-1,0))
            elseif stringsequal(<direction>,"right")
                %L_Object(x, y, 56, concat(<length>-1,1))
            else
                warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
            endif
        elseif equal(!__tileset,2)
            if stringsequal(<direction>,"left")
                %L_Object(x, y, 57, concat(<length>-1,0))
            elseif stringsequal(<direction>,"right")
                %L_Object(x, y, 57, concat(<length>-1,1))
            else
                warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
            endif
        else
            error "cannot insert GuideLine, tileset must be 1-2 (was ",!__tileset,"), at ",pc
        endif
    elseif stringsequal(<type>,"largecircle")
        if not(equal(<length>,1))
            warn "bad parameter for %L_GuideLine length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        if stringsequal(<direction>,"upleft")
            %L_Object(x, y, 0, 77)
        elseif stringsequal(<direction>,"upright")
            %L_Object(x, y, 0, 78)
        elseif stringsequal(<direction>,"downleft")
            %L_Object(x, y, 0, 79)
        elseif stringsequal(<direction>,"downright")
            %L_Object(x, y, 0, 80)
        else
            warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<type>,"smallcircle")
        if not(equal(<length>,1))
            warn "bad parameter for %L_GuideLine length, must be 1, was (",<length>,") at ",pc,", using 1 instead"
        endif
        if stringsequal(<direction>,"upleft")
            %L_Object(x, y, 0, 81)
        elseif stringsequal(<direction>,"upright")
            %L_Object(x, y, 0, 82)
        elseif stringsequal(<direction>,"downleft")
            %L_Object(x, y, 0, 83)
        elseif stringsequal(<direction>,"downright")
            %L_Object(x, y, 0, 84)
        else
            warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<type>,"slopeup")
        assert equal(!__tileset,2),"cannot insert GuideLine, tileset must be 2 (was ",!__tileset,"), at ",pc
        if stringsequal(<direction>,"normal")
            %L_Object(x, y, 58, concat(<length>-1,0))
        elseif stringsequal(<direction>,"steep")
            %L_Object(x, y, 58, concat(<length>-1,1))
        elseif stringsequal(<direction>,"verysteep")
            %L_Object(x, y, 59, concat(<length>-1,0))
        else
            warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<type>,"slopedown")
        assert equal(!__tileset,2),"cannot insert GuideLine, tileset must be 2 (was ",!__tileset,"), at ",pc
        if stringsequal(<direction>,"normal")
            %L_Object(x, y, 58, concat(<length>-1,2))
        elseif stringsequal(<direction>,"steep")
            %L_Object(x, y, 58, concat(<length>-1,3))
        elseif stringsequal(<direction>,"verysteep")
            %L_Object(x, y, 59, concat(<length>-1,1))
        else
            warn "bad parameter for %L_GuideLine direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<type>,"onoffup")
        assert equal(!__tileset,2),"cannot insert GuideLine, tileset must be 2 (was ",!__tileset,"), at ",pc
        %L_Object(x, y, 58, concat(<length>-1,4))
    elseif stringsequal(<type>,"onoffdown")
        assert equal(!__tileset,2),"cannot insert GuideLine, tileset must be 2 (was ",!__tileset,"), at ",pc
        %L_Object(x, y, 58, concat(<length>-1,5))
    else
        warn "bad parameter for %L_GuideLine type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert an end to a guide line object
;         x: x position within the level
;         y: y position within the level
; direction:
;   "horizontal": tile to terminate a horizontal guide line
;     "vertical": tile to terminate a vertical guide line
macro L_GuideLineEnd(x, y, direction)
    if stringsequal(<direction>,"horizontal")
        %L_Object(x, y, 0, 85)
    elseif stringsequal(<direction>,"vertical")
        %L_Object(x, y, 0, 86)
    else
        warn "bad parameter for %L_GuideLineEnd direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a mushroom top platform object
; tileset must be 2 (rope/mushroom)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_MushroomPlatform(x, y, length)
    assert equal(!__tileset,2),"cannot insert MushroomPlatform, tileset must be 2 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 60, concat(0,<length>-1))
endmacro

; insert a mushroom support object
; tileset must be 2 (rope/mushroom)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_MushroomSupport(x, y, width, height)
    assert equal(!__tileset,2),"cannot insert MushroomSupport, tileset must be 2 (was ",!__tileset,"), at ",pc
    if equal(<width>,1)
        ; special case for width == 1
        %L_Object(x, y, 57, concat(<height>-1,0))
    else
        ; technically can't place this object with width == 1
        ; but it glitches out anyway and wasn't used like that
        %L_Object(x, y, 61, concat(<height>-1,<width>-1))
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
    assert equal(!__tileset,1),"cannot insert CastleSpikes, tileset must be 1 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"up")
        %L_Object(x, y, 62, concat(1,<length>-1))
    elseif stringsequal(<direction>,"down")
        %L_Object(x, y, 62, concat(0,<length>-1))
    elseif stringsequal(<direction>,"left")
        %L_Object(x, y, 63, concat(<length>-1,1))
    elseif stringsequal(<direction>,"right")
        %L_Object(x, y, 63, concat(<length>-1,0))
    else
        warn "bad parameter for %L_CastleSpikes direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a castle column object
; unused object
; tileset must be 1 (castle)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in tiles (1-16)
macro L_CastleColumn(x, y, length)
    assert equal(!__tileset,1),"cannot insert CastleColumn, tileset must be 1 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 63, concat(<length>-1,2))
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
    assert equal(!__tileset,1),"cannot insert SpikedCrusher, tileset must be 1 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"up")
        %L_Object(x, y, 54, concat(<length>-1),1)
    elseif stringsequal(<direction>,"down")
        %L_Object(x, y, 54, concat(<length>-1),0)
    else
        warn "bad parameter for %L_SpikedCrusher direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a castle stone block object
; tileset must be 1 (castle)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_StoneBlock(x, y, width, height)
    assert equal(!__tileset,1),"cannot insert StoneBlock, tileset must be 1 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 60, concat(<height>-1,<width>-1))
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
    if stringsequal(<direction>,"top")
        %L_Object(x, y, 27, concat(<height>-1,<width>-1))
    elseif stringsequal(<direction>,"bottom")
        %L_Object(x, y, 29, concat(<height>-1,<width>-1))
    elseif stringsequal(<direction>,"left")
        assert equal(<width>,1),"cannot insert left ClimbingNet, width must be 1 (was ",<width>,"), at ",pc
        %L_Object(x, y, 30, concat(<height>-1,0))
    elseif stringsequal(<direction>,"right")
        assert equal(<width>,1),"cannot insert right ClimbingNet, width must be 1 (was ",<width>,"), at ",pc
        %L_Object(x, y, 30, concat(<length>-1,1))
    else
        warn "bad parameter for %L_ClimbingNet direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a climbing net door object
;         x: x position within the level
;         y: y position within the level
macro L_ClimbingNetDoor(x, y)
    %L_Object(x, y, 0, 74)
endmacro

; insert a set of arches object
; each support of the arches after the first adds 3 tiles horizontally
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in arches (0-15) (0 is glitched)
macro L_Arches(x, y, length)
    assert equal(!__tileset,0),"cannot insert Arches, tileset must be 0 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 60, concat(0,<length>))
endmacro

; insert a set of canvases object
; tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
;    length: length of object in screens (1-16)
macro L_CanvasGrid(x, y, length)
    assert equal(!__tileset,3),"cannot insert CanvasGrid, tileset must be 3 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 55, concat(0,<length>-1))
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
    if stringsequal(<pattern>,"big")
        if stringsequal(<type>,"solid")
            %L_Object(x, y, 0, 114)
        elseif stringsequal(<type>,"holes")
            %L_Object(x, y, 0, 116)
        else
            warn "bad parameter for %L_Canvas type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<pattern>,"small")
        if stringsequal(<type>,"solid")
            %L_Object(x, y, 0, 113)
        elseif stringsequal(<type>,"holes")
            %L_Object(x, y, 0, 115)
        else
            warn "bad parameter for %L_Canvas type (",<type>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_Canvas pattern (",<pattern>,") at ",pc,", skipping"
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
    if stringsequal(<pattern>,"big")
        if stringsequal(<type>,"tophalf")
            if stringsequal(<edge>,"left")
                %L_Object(x, y, 0, 121)
            elseif stringsequal(<edge>,"none")
                %L_Object(x, y, 0, 122)
            elseif stringsequal(<edge>,"right")
                %L_Object(x, y, 0, 123)
            else
                warn "bad parameter for big tophalf %L_CanvasTile edge (",<edge>,") at ",pc,", skipping"
            endif
        elseif stringsequal(<type>,"bottomhalf")
            if stringsequal(<edge>,"left")
                %L_Object(x, y, 0, 112)
            else
                warn "bad parameter for big bottomhalf %L_CanvasTile edge (",<edge>,") at ",pc,", skipping"
            endif
        elseif stringsequal(<type>,"full")
            if stringsequal(<edge>,"left")
                %L_Object(x, y, 0, 124)
            elseif stringsequal(<edge>,"none")
                %L_Object(x, y, 0, 125)
            elseif stringsequal(<edge>,"right")
                %L_Object(x, y, 0, 126)
            else
                warn "bad parameter for big full %L_CanvasTile edge (",<edge>,") at ",pc,", skipping"
            endif
        else
            warn "bad parameter for big %L_CanvasTile type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<pattern>,"small")
        if stringsequal(<type>,"lefthole")
            if stringsequal(<edge>,"none")
                %L_Object(x, y, 0, 117)
            elseif stringsequal(<edge>,"right")
                %L_Object(x, y, 0, 120)
            else
                warn "bad parameter for small lefthole %L_CanvasTile edge (",<edge>,") at ",pc,", skipping"
            endif
        elseif stringsequal(<type>,"righthole")
            if stringsequal(<edge>,"none")
                %L_Object(x, y, 0, 118)
            elseif stringsequal(<edge>,"left")
                %L_Object(x, y, 0, 119)
            else
                warn "bad parameter for small righthole %L_CanvasTile edge (",<edge>,") at ",pc,", skipping"
            endif
        else
            warn "bad parameter for small %L_CanvasTile type (",<type>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_CanvasTile pattern (",<pattern>,") at ",pc,", skipping"
    endif
endmacro

; insert a wooden crate object
; tileset must be 4 (ghosthouse/bonus)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_WoodenCrate(x, y, width, height)
    assert equal(!__tileset,4),"cannot insert WoodenCrate, tileset must be 4 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 49, concat(<height>-1,<width>-1))
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
    assert equal(!__tileset,4),"cannot insert WoodenPlatform, tileset must be 4 (was ",!__tileset,"), at ",pc
    if equal(<height>,1)
        ; special case for height == 1
        assert lessequal(<width>,16),"cannot insert WoodenPlatform, width must be <= 16 (was ",<width>,"), at ",pc
        %L_Object(x, y, 56, concat(0,<width>-1))
    else
        if not(equal(mod(<width>,3),0))
            warn "bad parameter for %L_WoodenPlatform width, must be 0 mod 3, was (",<width>,") at ",pc,", using ",3*floor(<width>/3)
        endif
        ; technically can't place this object with height == 1
        ; but it glitches out anyway and wasn't used like that
        %L_Object(x, y, 52, concat(<height>-1,(<width>/3)-1))
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
    assert equal(!__tileset,4),"cannot insert WoodenSupport, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal(<type>,"shadow")
        %L_Object(x, y, 57, concat(<length>-1,1))
    elseif stringsequal(<type>,"plain")
        %L_Object(x, y, 57, concat(<length>-1,2))
    else
        warn "bad parameter for %L_WoodenSupport type (",<type>,") at ",pc,", skipping"
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
    assert equal(!__tileset,4),"cannot insert WoodenBrickWall, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"left")
        %L_Object(x, y, 58, concat(<length>-1,0))
    elseif stringsequal(<direction>,"right")
        %L_Object(x, y, 58, concat(<length>-1,1))
    else
        warn "bad parameter for %L_WoodenBrickWall direction (",<direction>,") at ",pc,", skipping"
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
    assert equal(!__tileset,4),"cannot insert ThinSpikes, tileset must be 4 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"up")
        %L_Object(x, y, 46, concat(0,<length>-1))
    elseif stringsequal(<direction>,"left")
        %L_Object(x, y, 58, concat(<length>-1,3))
    elseif stringsequal(<direction>,"right")
        %L_Object(x, y, 58, concat(<length>-1,2))
    else
        warn "bad parameter for %L_ThinSpikes direction (",<direction>,") at ",pc,", skipping"
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
        assert equal(<height>,3),"cannot insert Ledge, when width is > 16, height must be 3 (was ",<height>,"), at ",pc
        %L_Object(x, y, 33, <width>-1)
    else
        %L_Object(x, y, 20, concat(<height>-1,<width>-1))
    endif
endmacro

; insert a ceiling object
; tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_Ceiling(x, y, width, height)
    assert equal(!__tileset,3),"cannot insert Ceiling, tileset must be 3 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 61, concat(<height>-1,<width>-1))
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
    if stringsequal(<type>,"open")
        %L_Object(x, y, 6, concat(<height>-1,<width>-1))
    elseif stringsequal(<type>,"solid")
        assert equal(!__tileset,3),"cannot insert solid LedgeBackground, tileset must be 3 (was ",!__tileset,"), at ",pc
        %L_Object(x, y, 63, concat(<height>-1,<width>-1))
    else
        warn "bad parameter for %L_LedgeBackground type (",<type>,") at ",pc,", skipping"
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
    if stringsequal(<type>,"open")
        if stringsequal(<direction>,"left")
            if stringsequal(<ends>,"none")
                %L_Object(x, y, 19, concat(<height>-1,0))
            elseif stringsequal(<ends>,"top")
                %L_Object(x, y, 19, concat(<height>-1,7))
            else
                warn "bad parameter for %L_LedgeEdge open ends (",<ends>,") at ",pc,", skipping"
            endif
        elseif stringsequal(<direction>,"right")
            if stringsequal(<ends>,"none")
                %L_Object(x, y, 19, concat(<height>-1,1))
            elseif stringsequal(<ends>,"top")
                %L_Object(x, y, 19, concat(<height>-1,8))
            else
                warn "bad parameter for %L_LedgeEdge open ends (",<ends>,") at ",pc,", skipping"
            endif
        else
            warn "bad parameter for %L_LedgeEdge direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<type>,"solid")
        if stringsequal(<direction>,"left")
            if stringsequal(<ends>,"none")
                %L_Object(x, y, 19, concat(<height>-1,4))
            elseif stringsequal(<ends>,"top")
                %L_Object(x, y, 19, concat(<height>-1,3))
            elseif stringsequal(<ends>,"steepslope")
                %L_Object(x, y, 19, concat(<height>-1,9))
            elseif stringsequal(<ends>,"topinner")
                %L_Object(x, y, 19, concat(<height>-1,11))
            elseif stringsequal(<ends>,"inner")
                %L_Object(x, y, 19, concat(<height>-1,12))
            elseif stringsequal(<ends>,"bottom")
                assert equal(!__tileset,3),"cannot insert solid bottom LedgeEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
                %L_Object(x, y, 62, concat(<height>-1,0))
            elseif stringsequal(<ends>,"nonealt")
                assert equal(!__tileset,3),"cannot insert solid nonealt LedgeEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
                %L_Object(x, y, 62, concat(<height>-1,1))
            else
                warn "bad parameter for %L_LedgeEdge solid ends (",<ends>,") at ",pc,", skipping"
            endif
        elseif stringsequal(<direction>,"right")
            if stringsequal(<ends>,"none")
                %L_Object(x, y, 19, concat(<height>-1,6))
            elseif stringsequal(<ends>,"top")
                %L_Object(x, y, 19, concat(<height>-1,5))
            elseif stringsequal(<ends>,"steepslope")
                %L_Object(x, y, 19, concat(<height>-1,10))
            elseif stringsequal(<ends>,"topinner")
                %L_Object(x, y, 19, concat(<height>-1,13))
            elseif stringsequal(<ends>,"inner")
                %L_Object(x, y, 19, concat(<height>-1,14))
            elseif stringsequal(<ends>,"bottom")
                assert equal(!__tileset,3),"cannot insert solid bottom LedgeEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
                %L_Object(x, y, 62, concat(<height>-1,2))
            elseif stringsequal(<ends>,"nonealt")
                assert equal(!__tileset,3),"cannot insert solid nonealt LedgeEdge, tileset must be 3 (was ",!__tileset,"), at ",pc
                %L_Object(x, y, 62, concat(<height>-1,3))
            else
                warn "bad parameter for %L_LedgeEdge solid ends (",<ends>,") at ",pc,", skipping"
            endif
        else
            warn "bad parameter for %L_LedgeEdge direction (",<direction>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_LedgeEdge type (",<type>,") at ",pc,", skipping"
    endif
endmacro

; insert a forest ledge object
; tileset must be 0 (grassy/forest/cloud)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_ForestLedge(x, y, width, height)
    assert equal(!__tileset,0),"cannot insert ForestLedge, tileset must be 0 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 53, concat(<height>-1,<width>-1))
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
    assert equal(!__tileset,0),"cannot insert ForestLedgeEdge, tileset must be 0 (was ",!__tileset,"), at ",pc
    if stringsequal(<type>,"open")
        if stringsequal(<direction>,"left")
            %L_Object(x, y, 52, concat(<height>-1,3))
        elseif stringsequal(<direction>,"right")
            %L_Object(x, y, 52, concat(<height>-1,2))
        else
            warn "bad parameter for %L_ForestLedgeEdge direction (",<direction>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<type>,"solid")
        if stringsequal(<direction>,"left")
            %L_Object(x, y, 52, concat(<height>-1,0))
        elseif stringsequal(<direction>,"right")
            %L_Object(x, y, 52, concat(<height>-1,1))
        else
            warn "bad parameter for %L_ForestLedgeEdge direction (",<direction>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_ForestLedgeEdge type (",<type>,") at ",pc,", skipping"
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
    if stringsequal(<type>,"castle")
        assert equal(!__tileset,1),"cannot insert castle SpecialLedge, tileset must be 1 (was ",!__tileset,"), at ",pc
        assert equal(<height>,2),"cannot insert castle SpecialLedge, height must be 2 (was ",<height>,"), at ",pc
        %L_Object(x, y, 59, concat(0,<width>-1))
    elseif stringsequal(<type>,"yoshishouse")
        assert equal(!__tileset,4),"cannot insert castle SpecialLedge, tileset must be 4 (was ",!__tileset,"), at ",pc
        %L_Object(x, y, 48, concat(<height>-1,<width>-1))
    elseif stringsequal(<type>,"ghosthouse")
        assert equal(!__tileset,4),"cannot insert castle SpecialLedge, tileset must be 4 (was ",!__tileset,"), at ",pc
        %L_Object(x, y, 50, concat(<height>-1,<width>-1))
    else
        warn "bad parameter for %L_SpecialLedge type (",<type>,") at ",pc,", skipping"
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
    if stringsequal(<direction>,"upleft")
        if stringsequal(<type>,"steep")
            %L_Object(x, y, 0, 63)
        else
            warn "bad parameter for upleft %L_LedgeInnerCorner type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"upright")
        if stringsequal(<type>,"steep")
            %L_Object(x, y, 0, 62)
        else
            warn "bad parameter for upright %L_LedgeInnerCorner type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"downleft")
        if stringsequal(<type>,"inset")
            %L_Object(x, y, 0, 20)
        elseif stringsequal(<type>,"normal")
            %L_Object(x, y, 0, 59)
        elseif stringsequal(<type>,"steep")
            %L_Object(x, y, 0, 61)
        elseif stringsequal(<type>,"gradual")
            %L_Object(x, y, 0, 67)
        else
            warn "bad parameter for downleft %L_LedgeInnerCorner type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"downright")
        if stringsequal(<type>,"inset")
            %L_Object(x, y, 0, 19)
        elseif stringsequal(<type>,"normal")
            %L_Object(x, y, 0, 58)
        elseif stringsequal(<type>,"steep")
            %L_Object(x, y, 0, 60)
        elseif stringsequal(<type>,"gradual")
            %L_Object(x, y, 0, 66)
        else
            warn "bad parameter for downright %L_LedgeInnerCorner type (",<type>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_LedgeInnerCorner direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro

; insert a rectangular ledge object
; tileset must be 3 (underground)
;         x: x position within the level
;         y: y position within the level
;     width: width of object in tiles (1-16)
;    height: height of object in tiles (1-16)
macro L_LedgeRectangle(x, y, width, height)
    assert equal(!__tileset,3),"cannot insert LedgeRectangle, tileset must be 3 (was ",!__tileset,"), at ",pc
    %L_Object(x, y, 54, concat(<height>-1,<width>-1))
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
    if stringsequal(<direction>,"up")
        if stringsequal(<type>,"gradual")
            %L_Object(x, y, 18, concat(<length>-1,2))
        elseif stringsequal(<type>,"normal")
            %L_Object(x, y, 18, concat(<length>-1,0))
        elseif stringsequal(<type>,"steep")
            %L_Object(x, y, 18, concat(<length>-1,1))
        elseif stringsequal(<type>,"verysteep")
            assert equal(!__tileset,3),"cannot insert verysteep Slope, tileset must be 3 (was ",!__tileset,"), at ",pc
            %L_Object(x, y, 60, concat(<length>-1,0))
        else
            warn "bad parameter for up %L_Slope type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"down")
        if stringsequal(<type>,"gradual")
            %L_Object(x, y, 18, concat(<length>-1,5))
        elseif stringsequal(<type>,"normal")
            %L_Object(x, y, 18, concat(<length>-1,3))
        elseif stringsequal(<type>,"steep")
            %L_Object(x, y, 18, concat(<length>-1,4))
        elseif stringsequal(<type>,"verysteep")
            assert equal(!__tileset,3),"cannot insert verysteep Slope, tileset must be 3 (was ",!__tileset,"), at ",pc
            %L_Object(x, y, 60, concat(<length>-1,1))
        else
            warn "bad parameter for down %L_Slope type (",<type>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_Slope direction (",<direction>,") at ",pc,", skipping"
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
    if stringsequal(<direction>,"up")
        if stringsequal(<type>,"normal")
            %L_Object(x, y, 0, 147)
        elseif stringsequal(<type>,"steep")
            %L_Object(x, y, 0, 145)
        elseif stringsequal(<type>,"verysteep")
            %L_Object(x, y, 0, 149)
        else
            warn "bad parameter for up %L_SpecialSlope type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"down")
        if stringsequal(<type>,"normal")
            %L_Object(x, y, 0, 148)
        elseif stringsequal(<type>,"steep")
            %L_Object(x, y, 0, 146)
        elseif stringsequal(<type>,"verysteep")
            %L_Object(x, y, 0, 150)
        else
            warn "bad parameter for down %L_SpecialSlope type (",<type>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_SpecialSlope direction (",<direction>,") at ",pc,", skipping"
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
    if stringsequal(<direction>,"up")
        if stringsequal(<type>,"normal")
            %L_Object(x, y, 18, concat(<length>-1,7))
        elseif stringsequal(<type>,"steep")
            %L_Object(x, y, 18, concat(<length>-1,9))
        else
            warn "bad parameter for up %L_CeilingSlope type (",<type>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"down")
        if stringsequal(<type>,"normal")
            %L_Object(x, y, 18, concat(<length>-1,6))
        elseif stringsequal(<type>,"steep")
            %L_Object(x, y, 18, concat(<length>-1,8))
        else
            warn "bad parameter for down %L_CeilingSlope type (",<type>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_CeilingSlope direction (",<direction>,") at ",pc,", skipping"
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
    assert equal(!__tileset,0),"cannot insert DiagonalLedge, tileset must be 0 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"left")
        %L_Object(x, y, 58, concat(<height>-1,<width>-1))
    elseif stringsequal(<direction>,"right")
        %L_Object(x, y, 59, concat(<height>-1,<width>-1))
    else
        warn "bad parameter for %L_DiagonalLedge direction (",<direction>,") at ",pc,", skipping"
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
    assert equal(!__tileset,1),"cannot insert Escalator, tileset must be 1 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"up")
        if stringsequal(<stairs>,"goingup")
            %L_Object(x, y, 61, concat(<height>-1,0))
        elseif stringsequal(<stairs>,"goingdown")
            %L_Object(x, y, 61, concat(<height>-1,1))
        else
            warn "bad parameter for up %L_Escalator stairs (",<stairs>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"down")
        if stringsequal(<stairs>,"goingup")
            %L_Object(x, y, 61, concat(<height>-1,3))
        elseif stringsequal(<stairs>,"goingdown")
            %L_Object(x, y, 61, concat(<height>-1,2))
        else
            warn "bad parameter for down %L_Escalator stairs (",<stairs>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_Escalator direction (",<direction>,") at ",pc,", skipping"
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
    assert equal(!__tileset,2),"cannot insert RopeConveyor, tileset must be 2 (was ",!__tileset,"), at ",pc
    if stringsequal(<direction>,"up")
        if stringsequal(<moving>,"goingleft")
            %L_Object(x, y, 55, concat(<height>-1,1))
        elseif stringsequal(<moving>,"goingright")
            %L_Object(x, y, 55, concat(<height>-1,0))
        else
            warn "bad parameter for up %L_RopeConveyor moving (",<moving>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"down")
        if stringsequal(<moving>,"goingleft")
            %L_Object(x, y, 55, concat(<height>-1,3))
        elseif stringsequal(<moving>,"goingright")
            %L_Object(x, y, 55, concat(<height>-1,2))
        else
            warn "bad parameter for down %L_RopeConveyor moving (",<moving>,") at ",pc,", skipping"
        endif
    elseif stringsequal(<direction>,"horizontal")
        if stringsequal(<moving>,"goingleft")
            %L_Object(x, y, 54, concat(<height>-1,1))
        elseif stringsequal(<moving>,"goingright")
            %L_Object(x, y, 54, concat(<height>-1,0))
        else
            warn "bad parameter for horizontal %L_RopeConveyor moving (",<moving>,") at ",pc,", skipping"
        endif
    else
        warn "bad parameter for %L_RopeConveyor direction (",<direction>,") at ",pc,", skipping"
    endif
endmacro