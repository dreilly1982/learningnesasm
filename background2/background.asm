  .inesprg 1
  .ineschr 1
  .inesmap 0
  .inesmir 1

  .rsset $0000
buttons1  .rs 1

  .bank 0
  .org $C000
vblankwait:
  BIT $2002
  BPL vblankwait
  RTS

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

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016
  
  LDA $4016
  LDA $4016
  LDA $4016
  LDA $4016

ReadUp:
  LDA $4016
  AND #%00000001
  BEQ ReadUpDone
  LDA $0200
  SEC
  SBC #$01
  STA $0200
  LDA $0204
  SEC
  SBC #$01
  STA $0204
  LDA $0208
  SEC
  SBC #$01
  STA $0208
  LDA $020C
  SEC
  SBC #$01
  STA $020C
ReadUpDone:

ReadDown:
  LDA $4016
  AND #%00000001
  BEQ ReadDownDone
  LDA $0200
  CLC
  ADC #$01
  STA $0200
  LDA $0204
  CLC
  ADC #$01
  STA $0204
  LDA $0208
  CLC
  ADC #$01
  STA $0208
  LDA $020C
  CLC
  ADC #$01
  STA $020C
ReadDownDone:

ReadLeft:
  LDA $4016
  AND #%00000001
  BEQ ReadLeftDone
  LDA $0203
  SEC
  SBC #$01
  STA $0203
  LDA $0207
  SEC
  SBC #$01
  STA $0207
  LDA $020B
  SEC
  SBC #$01
  STA $020B
  LDA $020F
  SEC
  SBC #$01
  STA $020F
ReadLeftDone:

ReadRight:
  LDA $4016
  AND #%00000001
  BEQ ReadRightDone
  LDA $0203
  CLC
  ADC #$01
  STA $0203
  LDA $0207
  CLC
  ADC #$01
  STA $0207
  LDA $020B
  CLC
  ADC #$01
  STA $020B
  LDA $020F
  CLC
  ADC #$01
  STA $020F
ReadRightDone:

  LDA #%10010000
  STA $2000
  LDA #%00011110
  STA $2001
  LDA #$00
  STA $2005
  STA $2005
  RTI

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
addrlo:  .db 0
addrhigh: .db 0
