incsrc "hardware_registers.asm"

; scratch ram
; used for many various purposes
!0 = $7E0000
!1 = $7E0001
!2 = $7E0002
!3 = $7E0003
!4 = $7E0004
!5 = $7E0005
!6 = $7E0006
!7 = $7E0007
!8 = $7E0008
!9 = $7E0009
!A = $7E000A
!B = $7E000B
!C = $7E000C
!D = $7E000D
!E = $7E000E
!F = $7E000F

; non-zero during game loop
; set to zero after game loop
; must be non-zero to start game loop
; set to non-zero at end of V-blank
; 1 byte
!Lag = $7E0010

; frame counter
; increments for every frame of execution
; not incremented during lag frames
; 1 byte
!Frame = $7E0013

; brightness
; value used by V-blank to exit F-blank
; #$00-#$0F
; 1 byte
!Brightness = $7E0DAE