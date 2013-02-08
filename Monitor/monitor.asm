org 0x0000

; Cold reset - set up stack, interrupts, and variables.

  ld sp, stack
  ld hl, 0
  ld (ticks), hl
  im 1
  ei
  call clear
  xor a
  ld (lastkey), a
  inc a
  ld (echo), a
  jr monitor

; Interrupt routine.

  ds 0x0038 - $

  push af
  push hl
  ld hl, (ticks)
  inc hl
  ld (ticks), hl
  pop hl
  pop af
  ei
  ret

; Monitor main loop.

monitor:

; Display prompt if needed.

  ld a, (echo)
  or a
  jr z, monitor1
  ld a, 0x0d
  call putchar
  ld a, '>'
  call putchar
monitor1:

; Get command and jump to appropriate handler.

  call getchar_echo
  cp 0x20
  jr z, monitor1
  cp 0x0d
  jr z, monitor
  and 0xdf
  cp 'E'
  jr z, do_echo
  cp 'D'
  jr z, do_dump
  cp 'L'
  jr z, do_load
  cp 'J'
  jp z, do_jump
  ld a, '?'
  call putchar
  jr monitor

; Set echo mode.

do_echo:
  call gethex
  ld a, h
  or l
  jr z, do_echo1
  ld a, 1
do_echo1:
  ld (echo), a
  jr monitor

; Dump contents of memory.

do_dump:
  call gethex
  push hl
  call gethex
  ld b, h
  ld c, l
  pop hl
  ld a, b
  or c
  jr z, monitor
  push bc
  push hl

do_dump1:
  ; Print address.
  pop hl
  push hl
  ld a, h
  call puthex
  pop hl
  push hl
  ld a, l
  call puthex
  ld a, ':'
  call putchar
do_dump2:
  ; Print contents.
  ld a, ' '
  call putchar
  pop hl
  push hl
  ld a,(hl)
  call puthex
  pop hl
  pop bc
  inc hl
  dec bc
  ld a, b
  or c
  jr z, do_dump3
  push bc
  push hl
  ld a, l
  and 0x7
  jr nz, do_dump2
  ld a, 0x0d
  call putchar
  jr do_dump1

do_dump3:
  ld a, 0x0d
  call putchar
  jp monitor

; Load contents of memory from keyboard.

do_load:
  call gethex
  push hl
  call gethex
  ld b, h
  ld c, l
  pop hl
  ld a, b
  or c
  jp z, monitor

do_load1:
  push bc
  push hl
  call gethex
  ld a, l
  pop hl
  pop bc
  ld (hl), a
  inc hl
  dec bc
  ld a, b
  or c
  jp z, monitor
  jr do_load1

; Jump to location in memory.

do_jump:
  call gethex
  ld bc, monitor
  push bc
  jp (hl)

; Display hexadecimal byte in A.

puthex:
  push af
  rra
  rra
  rra
  rra
  call puthex_digit
  pop af
puthex_digit:
  and 0x0f
  add 0x30
  cp 0x3a
  jr c, putchar
  add 0x07
  jr putchar

; Read hexadecimal word from keyboard into HL.

gethex:
  ld hl, 0
  push hl
  call getchar_echo
  pop hl
  cp 0x20
  jr z, gethex
  cp 0x0d
  jr z, gethex

gethex_loop:
  cp 0x30
  jr c, gethex_error
  cp 0x3a
  jr c, gethex1
  and 0xdf
  sub 7
  cp 0x40
  jr nc, gethex_error

gethex1:
  rla
  rla
  rla
  rla
  ld b, 4
gethex_shift:
  rla
  rl l
  rl h
  djnz gethex_shift
  push hl
  call getchar_echo
  pop hl
  cp 0x0d
  ret z
  cp 0x20
  ret z
  jr gethex_loop

gethex_error:
  ld a, '?'
  call putchar
  jr gethex

; Display character in A register and advance cursor position.

putchar:
  cp 0x0d
  jr z, newline
  call drawchar
  ld a, (column)
  inc a
  ld (column), a
  cp 0x20
  ret nz

newline:
  xor a
  ld (column), a
  ld a, (row)
  inc a
  ld (row), a
  cp 0x18
  ret nz
  ld a, 0x17
  ld (row), a

scroll:
  ld hl, screen + 0x100
  ld de, screen
  ld bc, screensize - 0x100
  ldir
  ld hl, screen + 0x1700
  ld de, screen + 0x1701
  ld bc, 0xff
  ld (hl), 0x00
  ldir
  ret

; Draw character in A register at current cursor position.

drawchar:
  ld hl, (column)
  ld de, screen
  add hl, de
  ex de, hl
  ld l, a
  ld h, 0
  add hl, hl
  add hl, hl
  add hl, hl
  ld bc, font - 0x100
  add hl, bc
drawchar1:
  ld a, (hl)
  inc hl
  ld (de), a
  ld a, e
  add a, 0x20
  ret c
  ld e, a
  jr drawchar1

; Display or erase cursor at current position.

cursor:
  ld hl, (column)
  ld de, screen
  add hl, de
cursor1:
  ld a, (hl)
  cpl
  ld (hl), a
  ld a, l
  add a, 0x20
  ret c
  ld l, a
  jr cursor1

; Clear the screen and set position to top left.

clear:
  ld hl, 0
  ld (column), hl
  ld de, screen + 1
  ld hl, screen
  ld bc, screensize - 1
  ld (hl), 0
  ldir
  ret

; Get a character from keyboard and display it if echo is enabled.

getchar_echo:
  ld a, (echo)
  or a
  jr z, getchar_echo1
  call cursor
getchar_echo1:
  call getchar
  push af
  ld a, (echo)
  or a
  jr z, getchar_echo2
  call cursor
  pop af
  push af
  call putchar
getchar_echo2:
  pop af
  ret

; Wait for a key to be pressed and return it in A register.

getchar:
  ld a, (lastkey)
  ld b, a
getchar1:
  in a, (0xfe)
  cp b
  jr z, getchar1
getchar2:
  or a
  jr nz, getchar3
  in a, (0xfe)
  jr getchar2
getchar3:
  ld (lastkey), a
  ret

font:
  incbin 'font.bin'

; DATA

org 0xe800 - 6

stack:
lastkey:    ds 1
echo:       ds 1
ticks:      ds 2
column:     ds 1
row:        ds 1
screen:     equ $
screensize: equ 0x1800
