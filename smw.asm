;========================
; Super Mario World Disassembly X
; by Dotsarecool
;========================

lorom
math pri on
incsrc "constants.asm"

; version to assemble
; !__VER_J  = Japanese
; !__VER_U  = North American
; !__VER_SS = Super System
; !__VER_E0 = PAL 1.0
; !__VER_E1 = PAL 1.1
!_VER ?= !__VER_U

incsrc "macros.asm"
incsrc "rammap.asm"

incsrc "bank_00.asm"
incsrc "bank_01.asm"
incsrc "bank_02.asm"
incsrc "bank_03.asm"
incsrc "bank_04.asm"
incsrc "bank_05.asm"
incsrc "bank_06.asm"
incsrc "bank_07.asm"
incsrc "bank_08-0B.asm"
incsrc "bank_0C.asm"
incsrc "bank_0D.asm"
incsrc "bank_0E.asm"
incsrc "bank_0F.asm"

ORG $00FFC0                                                     ;  J |  U + SS / E0 \ E1 ;
                                                                ;                        ;
ROMName:              db "SUPER MARIOWORLD     "                ;FFC0|FFC0+FFC0/FFC0\FFC0; Internal ROM name
MemoryMap:            db $20                                    ;FFD5|FFD5+FFD5/FFD5\FFD5; LoROM, slow
CatridgeType:         db $02                                    ;FFD6|FFD6+FFD6/FFD6\FFD6; ROM + SRAM + Battery
ROMSize:              db $09                                    ;FFD7|FFD7+FFD7/FFD7\FFD7; <= 4Mb ROM
SRAMSize:             db $01                                    ;FFD8|FFD8+FFD8/FFD8\FFD8; 16Kb SRAM
DestinationCode:      db con($00,$01,$00,$02,$02)               ;FFD9|FFD9+FFD9/FFD9\FFD9;
LicenseeCode:         db $01                                    ;FFDA|FFDA+FFDA/FFDA\FFDA; Nintendo EAD
MaskROMVersion:       db con($00,$00,$00,$00,$01)               ;FFDB|FFDB+FFDB/FFDB\FFDB;
Checksum:             dw $0000,$FFFF                            ;FFDC|FFDC+FFDC/FFDC\FFDC; asar does this on its own
                                                                ;                        ;
NativeVectors:        dw con($FFFF,$FFFF,$0000,$0000,$0000)     ;FFE0|FFE0+FFE0/FFE0\FFE0; \ Fairly certain these differences have to do with
                      dw con($FFFF,$FFFF,$0400,$0001,$0400)     ;FFE2|FFE2+FFE2/FFE2\FFE2; | the weird freespace pattern & stray bits
                      dw I_EMPTY                                ;FFE4|FFE4+FFE4/FFE4\FFE4; |
                      dw con($50B2,$FFFF,$0000,I_RESET,$0000)   ;FFE6|FFE6+FFE6/FFE6\FFE6; | Except for this $50B2 maybe?
                      dw I_EMPTY                                ;FFE8|FFE8+FFE8/FFE8\FFE8; |
                      dw I_NMI                                  ;FFEA|FFEA+FFEA/FFEA\FFEA; |
                      dw I_RESET                                ;FFEC|FFEC+FFEC/FFEC\FFEC; |
                      dw I_IRQ                                  ;FFEE|FFEE+FFEE/FFEE\FFEE; |
EmulationVectors:     dw con($FFFF,$FFFF,$0000,$0000,$0000)     ;FFF0|FFF0+FFF0/FFF0\FFF0; |
                      dw con($FFFF,$FFFF,$0000,$0102,$0000)     ;FFF2|FFF2+FFF2/FFF2\FFF2; /
                      dw I_EMPTY                                ;FFF4|FFF4+FFF4/FFF4\FFF4;
                      dw I_EMPTY                                ;FFF6|FFF6+FFF6/FFF6\FFF6;
                      dw I_EMPTY                                ;FFF8|FFF8+FFF8/FFF8\FFF8;
                      dw I_EMPTY                                ;FFFA|FFFA+FFFA/FFFA\FFFA;
                      dw I_RESET                                ;FFFC|FFFC+FFFC/FFFC\FFFC;
                      dw I_EMPTY                                ;FFFE|FFFE+FFFE/FFFE\FFFE;
