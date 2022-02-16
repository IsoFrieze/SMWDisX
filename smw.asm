;================================
; Super Mario World Disassembly X
;================================

lorom
math pri on
incsrc "constants.asm"

; version to assemble
; !__VER_J  = Japanese
; !__VER_U  = North American
; !__VER_SS = Super System
; !__VER_E0 = PAL 1.0
; !__VER_E1 = PAL 1.1
!_VER = !__VER_U

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

ORG $00FFC0

ROMName:              db "SUPER MARIOWORLD     "                ; Internal ROM name
MemoryMap:            db $20                                    ; LoROM, slow
CatridgeType:         db $02                                    ; ROM + SRAM + Battery
ROMSize:              db $09                                    ; <= 4Mb ROM
SRAMSize:             db $01                                    ; 16Kb SRAM
DestinationCode:      db con($00,$01,$00,$02,$02)
LicenseeCode:         db $01                                    ; Nintendo EAD
MaskROMVersion:       db con($00,$00,$00,$00,$01)
Checksum:             dw $0000,$FFFF                            ; asar does this on its own

NativeVectors:        dw con($FFFF,$FFFF,$0000,$0000,$0000)     ; \ Fairly certain these differences have to do with
                      dw con($FFFF,$FFFF,$0400,$0001,$0400)     ; | the weird freespace pattern & stray bits
                      dw I_EMPTY                                ; |
                      dw con($50B2,$FFFF,$0000,I_RESET,$0000)   ; | Except for this $50B2 maybe?
                      dw I_EMPTY                                ; |
                      dw I_NMI                                  ; |
                      dw I_RESET                                ; |
                      dw I_IRQ                                  ; |
EmulationVectors:     dw con($FFFF,$FFFF,$0000,$0000,$0000)     ; |
                      dw con($FFFF,$FFFF,$0000,$0102,$0000)     ; /
                      dw I_EMPTY
                      dw I_EMPTY
                      dw I_EMPTY
                      dw I_EMPTY
                      dw I_RESET
                      dw I_EMPTY