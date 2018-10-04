  .inesprg 1
  .ineschr 1
  .inesmap 0
  .inesmir 1

  .rsset $0000
addrlo    .rs 1
addrhigh  .rs 1
buttons1  .rs 1
buttons2  .rs 1

JOYPAD1 = $4016
JOYPAD2 = $4017

BUTTON_A      = %10000000
BUTTON_B      = %01000000
BUTTON_SELECT = %00100000
BUTTON_START  = %00010000
BUTTON_UP     = %00001000
BUTTON_DOWN   = %00000100
BUTTON_LEFT   = %00000010
BUTTON_RIGHT  = $00000001

  .bank 0
  .org $C000

RESET:
  SEI
  CLD
  LDX #$40
  STX $4017
  LDX #$FF
  TXS
  INX
  STX $2000
  STX $2001
  STX $4010

  JSR vblankwait

clrmem:
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0200, x
  INX
  BNE clrmem

  JSR vblankwait

LoadPalettes:
  LDA $2002
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006
  LDX #$00
LoadPalettesLoop:
  LDA palette, x
  STA $2007
  INX
  CPX #$20
  BNE LoadPalettesLoop

LoadSprites:
  LDX #$00
LoadSpritesLoop:
  LDA sprites, x
  STA $0200,x
  INX
  CPX #$10
  BNE LoadSpritesLoop

LoadBackground:
  LDX #0
  LDA #$20
  STA $2006
  STX $2006
  LDA #LOW(background)
  STA addrlo
  LDA #HIGH(background)
  STA addrhigh
  LDX #4
  LDY #0
LoadBackgroundLoop:
  LDA [addrlo], y
  STA $2007
  INY
  BNE LoadBackgroundLoop
  INC addrhigh
  DEX
  BNE LoadBackgroundLoop

LoadAttribute:
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$C0
  STA $2006
  LDX #$00
LoadAttributeLoop:
  LDA attribute, x
  STA $2007
  INX
  CPX #$10
  BNE LoadAttributeLoop

  LDA #%10010000
  STA $2000

  LDA #%00011110
  STA $2001

Forever:
  JMP Forever

NMI:
  LDA #$00
  STA $2003
  LDA #$02
  STA $4014

  LDA #%10010000
  STA $2000
  LDA #%00011110
  STA $2001
  LDA #$00
  STA $2005
  STA $2005
  JSR ReadPads
  JSR MoveChar 
  RTI

vblankwait:
  BIT $2002
  BPL vblankwait
  RTS

MoveChar:
  LDA buttons1
  AND #BUTTON_UP
  BEQ notUp
  DEC $0200
  DEC $0204
  DEC $0208
  DEC $020C
notUp:
  LDA buttons1
  AND #BUTTON_DOWN
  BEQ notDown
  INC $0200
  INC $0204
  INC $0208
  INC $020C
notDown:
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

ReadPads:
  LDA #$01
  STA JOYPAD1
  STA buttons2
  LSR A
  STA JOYPAD1
ReadPadsLoop:
  LDA JOYPAD1
  AND #$03
  CMP #$01
  ROL buttons1
  LDA JOYPAD2
  AND #$03
  CMP #$01
  ROL buttons2
  BCC ReadPadsLoop
  RTS

  .bank 1
  .org $E000
palette:
  .db $22,$29,$1A,$0F, $22,$36,$17,$0F, $22,$30,$21,$0F, $22,$27,$17,$0F
  .db $22,$16,$28,$18, $22,$02,$38,$3C, $22,$1C,$15,$14, $22,$02,$38,$3C

sprites:
  .db $80,$32,$00,$80
  .db $80,$33,$00,$88
  .db $88,$34,$00,$80
  .db $88,$35,$00,$88

background: .incbin "mario.nam"
attribute: .incbin "mario.atr"

  .org $FFFA
  .dw NMI
  .dw RESET
  .dw 0

  .bank 2
  .org $0000
  .incbin "mario.chr"
