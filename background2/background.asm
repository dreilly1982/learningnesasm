  .inesprg 1
  .ineschr 1
  .inesmap 0
  .inesmir 1

  .include "globals.asm"

  .bank 0
  .org $C000

  .include "init.asm"

Forever:
  JMP Forever

NMI:
  LDA #$00
  STA $2003
  LDA #$02
  STA $4014

  JSR ReadPads
  JSR MoveChar 
  JSR ppuCleanUp
  RTI

  .include "nes.asm"

MoveChar:
;  LDA buttons1
;  AND #BUTTON_UP
;  BEQ notUp
;  DEC $0200
;  DEC $0204
;  DEC $0208
;  DEC $020C
;notUp:
;  LDA buttons1
;  AND #BUTTON_DOWN
;  BEQ notDown
;  INC $0200
;  INC $0204
;  INC $0208
;  INC $020C
;notDown:
  LDA buttons1
  AND #BUTTON_LEFT
  BEQ notLeft
  DEC $0203
  DEC $0207
  DEC $020B
  DEC $020F
notLeft:
  LDA buttons1
  AND #BUTTON_RIGHT
  BEQ notRight
  INC $0203
  INC $0207
  INC $020B
  INC $020F
notRight:
  RTS

  .bank 1
  .org $E000
palette:
  .db $22,$29,$1A,$0F, $22,$36,$17,$0F, $22,$30,$21,$0F, $22,$27,$17,$0F
  .db $22,$16,$28,$18, $22,$02,$38,$3C, $22,$1C,$15,$14, $22,$02,$38,$3C

sprites:
  .db $BF,$32,$00,$70
  .db $C7,$34,$00,$70
  .db $BF,$33,$00,$78
  .db $C7,$35,$00,$78

background: .incbin "mario.nam"
attribute: .incbin "mario.atr"

  .org $FFFA
  .dw NMI
  .dw RESET
  .dw 0

  .bank 2
  .org $0000
  .incbin "mario.chr"
