;========================
; Super Mario World Disassembly X
; by Dotsarecool
;========================

incsrc "rammap.asm"

lorom

incsrc "bank_00/bank_00.asm"
incsrc "bank_01/bank_01.asm"
incsrc "bank_02/bank_02.asm"
incsrc "bank_03/bank_03.asm"
incsrc "bank_04/bank_04.asm"
incsrc "bank_05/bank_05.asm"
incsrc "bank_06/bank_06.asm"
incsrc "bank_07/bank_07.asm"
incsrc "bank_08/bank_08.asm"
incsrc "bank_09/bank_09.asm"
incsrc "bank_0A/bank_0A.asm"
incsrc "bank_0B/bank_0B.asm"
incsrc "bank_0C/bank_0C.asm"
incsrc "bank_0D/bank_0D.asm"
incsrc "bank_0E/bank_0E.asm"
incsrc "bank_0F/bank_0F.asm"

cleartable

; internal rom name
ORG $00FFC0
		db "SUPER MARIOWORLD     "

; memory map mode + high speed (see page 1-2-17)
; cartridge type (see page 1-2-18)
; ROM size (see page 1-2-19)
; SRAM size (see page 1-2-19)
; destination code (see page 1-2-20)
; #$33
; mask ROM version
ORG $00FFD5
		db $20,$02,$09,$01,$01,$01,$00

; checksum
ORG $00FFDC
		; asar does this automatically

; vectors
ORG $00FFE0
		dw $FFFF
		dw $FFFF
		dw I_EMPTY
		dw $FFFF
		dw I_EMPTY
		dw I_NMI
		dw I_RESET
		dw I_IRQ
		
		dw $FFFF
		dw $FFFF
		dw I_EMPTY
		dw I_EMPTY
		dw I_EMPTY
		dw I_EMPTY
		dw I_RESET
		dw I_EMPTY