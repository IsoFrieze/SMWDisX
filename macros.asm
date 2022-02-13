; human-readable function names for version-exclusive code/data
function ver_is_japanese(v) = equal(v,!__VER_J)
function ver_is_english(v) = notequal(v,!__VER_J)
function ver_is_hires(v) = equal(v,!__VER_E1)
function ver_is_lores(v) = notequal(v,!__VER_E1)
function ver_is_pal(v) = or(equal(v,!__VER_E0),equal(v,!__VER_E1))
function ver_is_ntsc(v) = nor(equal(v,!__VER_E0),equal(v,!__VER_E1))
function ver_is_arcade(v) = equal(v,!__VER_SS)
function ver_is_console(v) = notequal(v,!__VER_SS)
function ver_has_rev_gfx(v) = or(equal(v,!__VER_J),equal(v,!__VER_E1))

; instruction address mode $byte if J, $word otherwise
macro BorW(cmd, addr)
    if ver_is_japanese(!_VER)
        <cmd>.B <addr>
    else
        <cmd>.W <addr>
    endif
endmacro

; instruction address mode $word if J, $byte otherwise
macro WorB(cmd, addr)
    if ver_is_japanese(!_VER)
        <cmd>.W <addr>
    else
        <cmd>.B <addr>
    endif
endmacro

; instruction address mode $word,X if J, $long,X otherwise
macro WorL_X(cmd, addr)
    if ver_is_japanese(!_VER)
        <cmd>.W <addr>,X
    else
        <cmd>.L <addr>,X
    endif
endmacro

; instruction address mode $long,X if J, $word,X otherwise
macro LorW_X(cmd, addr)
    if ver_is_japanese(!_VER)
        <cmd>.L <addr>,X
    else
        <cmd>.W <addr>,X
    endif
endmacro

; instruction address mode $long if J, $word otherwise
macro LorW(cmd, addr)
    if ver_is_japanese(!_VER)
        <cmd>.L <addr>
    else
        <cmd>.W <addr>
    endif
endmacro

; insert freespace into the ROM at the location specified
; J & U: all $FF
; E0 & E1 & SS: alternating $00 and $FF every $20 bytes
; many stray bits are set/reset in the PAL/SS empty pattern.
; until I find a way to replicate this easily, I'm just treating the freespace the same as U/J versions.
macro insert_empty(j, u, ss, e0, e1)
    if !_VER == !__VER_J
        rep <j> : db $FF
    elseif !_VER == !__VER_U
        rep <u> : db $FF
    elseif !_VER == !__VER_SS
        rep <ss> : db $FF
    elseif !_VER == !__VER_E0
        rep <e0> : db $FF
    else;if !_VER == !__VER_E1
        rep <e1> : db $FF
    endif
endmacro

; create an entry to a table of pointers where the high and low bytes are seperated
; this is for 16-bit pointers, where the high bytes are first, then the low bytes
macro Ptr16_Table_Entry(ptr, start, end)
    pushpc
    skip (start-end)/2
    db <ptr>
    pullpc
    db <ptr>>>8
endmacro

; convert a *.pal palette file into SNES 15-bit color and insert it into the ROM.
macro incpal(file)
	!i = 0
	while !i < (filesize("<file>")/3)
		!r = readfile1("<file>", 3*!i)
		!g = readfile1("<file>", 3*!i+1)
		!b = readfile1("<file>", 3*!i+2)
		dw ((!b&$F8)<<7)|((!g&$F8)<<2)|((!r&$F8)>>3)
		!i #= !i+1
	endif
endmacro

; select a constant value depending on the region
; easier to read than an if/else block for a single LDA instruction for example
function con(u, j, ss, e0, e1) = select(equal(!_VER,!__VER_J),u,select(equal(!_VER,!__VER_U),j,select(equal(!_VER,!__VER_SS),ss,select(equal(!_VER,!__VER_E0),e0,e1))))

