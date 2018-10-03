  .inesprg 1
  .ineschr 1
  .inesmap 0
  .inesmir 1

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

vblankwait1:
  BIT $2002
  BPL vblankwait1

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

vblankwait2:
  BIT $2002
  BPL vblankwait2

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

  LDA #%10000000
  STA $2000

  LDA #%00010000
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

ReadA:
  LDA $4016
  AND #%00000001
  BEQ ReadADone
ReadADone:

ReadB:
  LDA $4016
  AND #%00000001
  BEQ ReadBDone
ReadBDone:

ReadSelect:
  LDA $4016
  AND #%00000001
  BEQ ReadSelectDone
ReadSelectDone:

ReadStart:
  LDA $4016
  AND #%00000001
  BEQ ReadStartDone
ReadStartDone:

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
  RTI

  .bank 1
  .org $E000
palette:
  .db $0F,$15,$16,$17,$0F,$35,$36,$37,$0F,$39,$3A,$3B,$0F,$3D,$3E,$0F
  .db $0F,$06,$28,$08,$0F,$02,$38,$3C,$0F,$1C,$15,$14,$0F,$02,$38,$3C

sprites:
  .db $80,$32,$00,$80
  .db $80,$33,$00,$88
  .db $88,$34,$00,$80
  .db $88,$35,$00,$88

  .org $FFFA
  .dw NMI
  .dw RESET
  .dw 0

  .bank 2
  .org $0000
  .incbin "mario.chr"
