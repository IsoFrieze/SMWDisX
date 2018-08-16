;========================
; Super Mario World Disassembly X
; by Dotsarecool
;========================

lorom
math pri on
incsrc "macros.asm"
incsrc "rammap.asm"

; version to assemble
; 0 = Japanese
; 1 = North American
; 2 = PAL 1.0
; 3 = PAL 1.1
!_VER = 1
                                                          ;                   ;
                      incsrc "bank_00.asm"                ;                   ;
                      incsrc "bank_01.asm"                ;                   ;
                      incsrc "bank_02.asm"                ;                   ;
                      incsrc "bank_03.asm"                ;                   ;
                      incsrc "bank_04.asm"                ;                   ;
                      incsrc "bank_05.asm"                ;                   ;
                      incsrc "bank_06.asm"                ;                   ;
                      incsrc "bank_07.asm"                ;                   ;
                      incsrc "bank_08-0B.asm"             ;                   ;
                      incsrc "bank_0C.asm"                ;                   ;
                      incsrc "bank_0D.asm"                ;                   ;
                      incsrc "bank_0E.asm"                ;                   ;
                      incsrc "bank_0F.asm"                ;                   ;
                                                          ;                   ;
ORG $00FFC0                                               ;                   ;
                                                          ;                   ;
ROMName:              db "SUPER MARIOWORLD  ",$20,$20,$20 ;FFC0|FFC0/FFC0\FFC0; Internal ROM name (PLEASE SOMEONE TELL ME WHY STRINGS ALONE DON'T ASSEMBLE)
MemoryMap:            db $20                              ;FFD5|FFD5/FFD5\FFD5; LoROM, slow
CatridgeType:         db $02                              ;FFD6|FFD6/FFD6\FFD6; ROM + SRAM + Battery
ROMSize:              db $09                              ;FFD7|FFD7/FFD7\FFD7; <= 4Mb ROM
SRAMSize:             db $01                              ;FFD8|FFD8/FFD8\FFD8; 16Kb SRAM
                                                          ;                   ;
                   if !_VER == 0                ;\   IF   ;+++++++++++++++++++; J
DestinationCode:      db $00                              ;FFD9|              ; Japan
                   elseif !_VER == 1            ;< ELSEIF ;-------------------; U
DestinationCode:      db $01                              ;    |FFD9          ; North America (USA and Canada)
                   else                         ;<  ELSE  ;-------------------; E0 & E1
DestinationCode:      db $02                              ;         /FFD9\FFD9; All of Europe
                   endif                        ;/ ENDIF  ;+++++++++++++++++++;
                                                          ;                   ;
LicenseeCode:         db $01                              ;FFDA|FFDA/FFDA\FFDA; Nintendo EAD
                                                          ;                   ;
                   if !_VER != 3                ;\   IF   ;+++++++++++++++++++; J & U & E0
MaskROMVersion:       db $00                              ;FFDB|FFDB/FFDB     ; V 1.0
                   else                         ;<  ELSE  ;-------------------; E1
MaskROMVersion:       db $01                              ;              \FFDB; V 1.1
                   endif                        ;/ ENDIF  ;+++++++++++++++++++;
                                                          ;                   ;
Checksum:             dw $0000,$FFFF                      ;FFDC|FFDC/FFDC\FFDC; asar does this on its own
                                                          ;                   ;
                   if !_VER == 0                ;\   IF   ;+++++++++++++++++++; J
NativeVectors:        dw $FFFF                            ;FFE0|              ;
                      dw $FFFF                            ;FFE2|              ;
                      dw I_EMPTY                          ;FFE4|              ;
                      dw $50B2                            ;FFE6|              ;
                      dw I_EMPTY                          ;FFE8|              ;
                      dw I_NMI                            ;FFEA|              ;
                      dw I_RESET                          ;FFEC|              ;
                      dw I_IRQ                            ;FFEE|              ;
EmulationVectors:     dw $FFFF                            ;FFF0|              ;
                      dw $FFFF                            ;FFF2|              ;
                      dw I_EMPTY                          ;FFF4|              ;
                      dw I_EMPTY                          ;FFF6|              ;
                      dw I_EMPTY                          ;FFF8|              ;
                      dw I_EMPTY                          ;FFFA|              ;
                      dw I_RESET                          ;FFFC|              ;
                      dw I_EMPTY                          ;FFFE|              ;
                   elseif !_VER == 1            ;< ELSEIF ;-------------------; U
NativeVectors:        dw $FFFF                            ;    |FFE0          ;
                      dw $FFFF                            ;    |FFE2          ;
                      dw I_EMPTY                          ;    |FFE4          ;
                      dw $FFFF                            ;    |FFE6          ;
                      dw I_EMPTY                          ;    |FFE8          ;
                      dw I_NMI                            ;    |FFEA          ;
                      dw I_RESET                          ;    |FFEC          ;
                      dw I_IRQ                            ;    |FFEE          ;
EmulationVectors:     dw $FFFF                            ;    |FFF0          ;
                      dw $FFFF                            ;    |FFF2          ;
                      dw I_EMPTY                          ;    |FFF4          ;
                      dw I_EMPTY                          ;    |FFF6          ;
                      dw I_EMPTY                          ;    |FFF8          ;
                      dw I_EMPTY                          ;    |FFFA          ;
                      dw I_RESET                          ;    |FFFC          ;
                      dw I_EMPTY                          ;    |FFFE          ;
                   elseif !_VER == 2            ;< ELSEIF ;-------------------; E0
NativeVectors:        dw $0000                            ;         /FFE0     ;
                      dw $0001                            ;         /FFE2     ;
                      dw I_EMPTY                          ;         /FFE4     ;
                      dw I_RESET                          ;         /FFE6     ;
                      dw I_EMPTY                          ;         /FFE8     ;
                      dw I_NMI                            ;         /FFEA     ;
                      dw I_RESET                          ;         /FFEC     ;
                      dw I_IRQ                            ;         /FFEE     ;
EmulationVectors:     dw $0000                            ;         /FFF0     ;
                      dw $0102                            ;         /FFF2     ;
                      dw I_EMPTY                          ;         /FFF4     ;
                      dw I_EMPTY                          ;         /FFF6     ;
                      dw I_EMPTY                          ;         /FFF8     ;
                      dw I_EMPTY                          ;         /FFFA     ;
                      dw I_RESET                          ;         /FFFC     ;
                      dw I_EMPTY                          ;         /FFFE     ;
                   else                         ;<  ELSE  ;-------------------; E1
NativeVectors:        dw $0000                            ;              \FFE0;
                      dw $0400                            ;              \FFE2;
                      dw I_EMPTY                          ;              \FFE4;
                      dw $0000                            ;              \FFE6;
                      dw I_EMPTY                          ;              \FFE8;
                      dw I_NMI                            ;              \FFEA;
                      dw I_RESET                          ;              \FFEC;
                      dw I_IRQ                            ;              \FFEE;
EmulationVectors:     dw $0000                            ;              \FFF0;
                      dw $0000                            ;              \FFF2;
                      dw I_EMPTY                          ;              \FFF4;
                      dw I_EMPTY                          ;              \FFF6;
                      dw I_EMPTY                          ;              \FFF8;
                      dw I_EMPTY                          ;              \FFFA;
                      dw I_RESET                          ;              \FFFC;
                      dw I_EMPTY                          ;              \FFFE;
                   endif                        ;/ ENDIF  ;+++++++++++++++++++;