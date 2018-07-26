;========================
; Super Mario World Disassembly X
; by Dotsarecool
;========================

; version to assemble
; 0 = Japanese
; 1 = North American
; 2 = PAL 1.0
; 3 = PAL 1.1
!_VER = 1
                                                          ;                      ;
                      incsrc "rammap.asm"                 ;                      ;
                                                          ;                      ;
                      lorom                               ;                      ;
                                                          ;                      ;
                      incsrc "bank_00.asm"                ;                      ;
                      incsrc "bank_01.asm"                ;                      ;
                      incsrc "bank_02.asm"                ;                      ;
                      incsrc "bank_03.asm"                ;                      ;
                      incsrc "bank_04.asm"                ;                      ;
                      incsrc "bank_05.asm"                ;                      ;
                      incsrc "bank_06.asm"                ;                      ;
                      incsrc "bank_07.asm"                ;                      ;
                      incsrc "bank_08.asm"                ;                      ;
                      incsrc "bank_09.asm"                ;                      ;
                      incsrc "bank_0A.asm"                ;                      ;
                      incsrc "bank_0B.asm"                ;                      ;
                      incsrc "bank_0C.asm"                ;                      ;
                      incsrc "bank_0D.asm"                ;                      ;
                      incsrc "bank_0E.asm"                ;                      ;
                      incsrc "bank_0F.asm"                ;                      ;
                                                          ;                      ;
ORG $00FFC0                                               ;                      ;
                                                          ;                      ;
ROMName:              db "SUPER MARIOWORLD  ",$20,$20,$20 ; 00FFC0               ; Internal ROM name (PLEASE SOMEONE TELL ME WHY STRINGS ALONE DON'T ASSEMBLE)
MemoryMap:            db $20                              ; 00FFD5               ; LoROM, slow
CatridgeType:         db $02                              ; 00FFD6               ; ROM + SRAM + Battery
ROMSize:              db $09                              ; 00FFD7               ; <= 4Mb ROM
SRAMSize:             db $01                              ; 00FFD8               ; 16Kb SRAM
                                                          ;                      ;
                   if !_VER == 0                ;\   IF   ; ++++++++++++++++++++ ; J
DestinationCode:      db $00                              ; 00FFD9               ; Japan
                   elseif !_VER == 1            ;< ELSEIF ; -------------------- ; U
DestinationCode:      db $01                              ; 00FFD9               ; North America (USA and Canada)
                   else                         ;<  ELSE  ; -------------------- ; E0 & E1
DestinationCode:      db $02                              ; 00FFD9               ; All of Europe
                   endif                        ;/ ENDIF  ; ++++++++++++++++++++ ;
                                                          ;                      ;
LicenseeCode:         db $01                              ; 00FFDA               ; Nintendo EAD
                                                          ;                      ;
                   if !_VER != 3                ;\   IF   ; ++++++++++++++++++++ ; J & U & E0
MaskROMVersion:       db $00                              ; 00FFDB               ; V 1.0
                   else                         ;<  ELSE  ; -------------------- ; E1
MaskROMVersion:       db $01                              ; 00FFDB               ; V 1.1
                   endif                        ;/ ENDIF  ; ++++++++++++++++++++ ;
                                                          ;                      ;
Checksum:             dw $0000,$FFFF                      ; 00FFDC               ; asar does this on its own
                                                          ;                      ;
                   if !_VER <= 1                ;\   IF   ; ++++++++++++++++++++ ; J & U
NativeVectors:        dw $FFFF                            ; 00FFE0               ;
                      dw $FFFF                            ; 00FFE2               ;
                      dw I_EMPTY                          ; 00FFE4               ;
                      dw $FFFF                            ; 00FFE6               ;
                      dw I_EMPTY                          ; 00FFE8               ;
                      dw I_NMI                            ; 00FFEA               ;
                      dw I_RESET                          ; 00FFEC               ;
                      dw I_IRQ                            ; 00FFEE               ;
EmulationVectors:     dw $FFFF                            ; 00FFF0               ;
                      dw $FFFF                            ; 00FFF2               ;
                      dw I_EMPTY                          ; 00FFF4               ;
                      dw I_EMPTY                          ; 00FFF6               ;
                      dw I_EMPTY                          ; 00FFF8               ;
                      dw I_EMPTY                          ; 00FFFA               ;
                      dw I_RESET                          ; 00FFFC               ;
                      dw I_EMPTY                          ; 00FFFE               ;
                   elseif !_VER == 2            ;< ELSEIF ; -------------------- ; E0
NativeVectors:        dw $0000                            ; 00FFE0               ;
                      dw $0001                            ; 00FFE2               ;
                      dw I_EMPTY                          ; 00FFE4               ;
                      dw I_RESET                          ; 00FFE6               ;
                      dw I_EMPTY                          ; 00FFE8               ;
                      dw I_NMI                            ; 00FFEA               ;
                      dw I_RESET                          ; 00FFEC               ;
                      dw I_IRQ                            ; 00FFEE               ;
EmulationVectors:     dw $0000                            ; 00FFF0               ;
                      dw $0102                            ; 00FFF2               ;
                      dw I_EMPTY                          ; 00FFF4               ;
                      dw I_EMPTY                          ; 00FFF6               ;
                      dw I_EMPTY                          ; 00FFF8               ;
                      dw I_EMPTY                          ; 00FFFA               ;
                      dw I_RESET                          ; 00FFFC               ;
                      dw I_EMPTY                          ; 00FFFE               ;
                   else                         ;<  ELSE  ; -------------------- ; E1
NativeVectors:        dw $0000                            ; 00FFE0               ;
                      dw $0400                            ; 00FFE2               ;
                      dw I_EMPTY                          ; 00FFE4               ;
                      dw $0000                            ; 00FFE6               ;
                      dw I_EMPTY                          ; 00FFE8               ;
                      dw I_NMI                            ; 00FFEA               ;
                      dw I_RESET                          ; 00FFEC               ;
                      dw I_IRQ                            ; 00FFEE               ;
EmulationVectors:     dw $0000                            ; 00FFF0               ;
                      dw $0000                            ; 00FFF2               ;
                      dw I_EMPTY                          ; 00FFF4               ;
                      dw I_EMPTY                          ; 00FFF6               ;
                      dw I_EMPTY                          ; 00FFF8               ;
                      dw I_EMPTY                          ; 00FFFA               ;
                      dw I_RESET                          ; 00FFFC               ;
                      dw I_EMPTY                          ; 00FFFE               ;
                   endif                        ;/ ENDIF  ; ++++++++++++++++++++ ;