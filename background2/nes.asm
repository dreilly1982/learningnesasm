ppuCleanUp:
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001
  LDA #$00         ; tell the ppu there is no background scrolling
  STA $2005
  STA $2005
  RTS

vblankwait:  ; Wait for vblank, done twice to ensure PPU is ready
  BIT $2002
  BPL vblankwait
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
