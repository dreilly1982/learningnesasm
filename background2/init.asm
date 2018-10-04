RESET:
  SEI        ; disable IRQs
  CLD        ; disable decimal mode
  LDX #$40
  STX $4017  ; disable APU frame IRQ
  LDX #$FF
  TXS        ; Set up stack
  INX
  STX $2000  ; disable NMI
  STX $2001  ; disable rendering
  STX $4010  ; disable DMC IRQs

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

  JSR ppuCleanUp
