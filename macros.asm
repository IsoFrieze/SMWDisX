; instruction address mode $byte if J, $word otherwise
macro BorW(cmd, addr)
    if !_VER == 0
        <cmd>.B <addr>
    else
        <cmd>.W <addr>
    endif
endmacro

; instruction address mode $word if J, $byte otherwise
macro WorB(cmd, addr)
    if !_VER == 0
        <cmd>.W <addr>
    else
        <cmd>.B <addr>
    endif
endmacro

; instruction address mode $word,X if J, $long,X otherwise
macro WorL_X(cmd, addr)
    if !_VER == 0
        <cmd>.W <addr>,X
    else
        <cmd>.L <addr>,X
    endif
endmacro

; instruction address mode $long,X if J, $word,X otherwise
macro LorW_X(cmd, addr)
    if !_VER == 0
        <cmd>.L <addr>,X
    else
        <cmd>.W <addr>,X
    endif
endmacro

; instruction address mode $long if J, $word otherwise
macro LorW(cmd, addr)
    if !_VER == 0
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
    if !_VER == 0
        rep <j> : db $FF
    elseif !_VER == 1
        rep <u> : db $FF
    elseif !_VER == 2
        rep <ss> : db $FF
    elseif !_VER == 3
        rep <e0> : db $FF
    else
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

; select a constant value depending on the region
; easier to read than an if/else block for a single LDA instruction for example
function con(u, j, ss, e0, e1) = select(equal(!_VER,0),u,select(equal(!_VER,1),j,select(equal(!_VER,2),ss,select(equal(!_VER,3),e0,e1))))