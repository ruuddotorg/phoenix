#include <avr/io.h>

busrq = _BV(PB0)
interrupt = _BV(PB2)
sync = _BV(PB3)
load = _BV(PB4)
clock = _BV(PB5)

	.text
.global	main

main:
        ldi r24, busrq | interrupt | sync | load | clock
        out _SFR_IO_ADDR(DDRB), r24
        ldi r24, busrq | interrupt | sync | load
        out _SFR_IO_ADDR(PORTB), r24
	ldi r24, sync
        mov r2, r24
        ldi r24, load
        mov r3, r24
        ldi r24, clock
        mov r4, r24
        ldi r24, busrq
        mov r5, r24
        ldi r24, interrupt
        mov r6, r24

// MAIN LOOP: 1 FRAME, 2 FIELDS

loop:
        rcall vsync

        // second half of a line, 572 cycles without transition
        ldi r24, 190
        1: dec r24
        brne 1b
        nop
        nop

        rcall field
        rcall vsync
        rcall field

        // first half of a line (85 cycles low, 487 cycles high)
        nop
        nop
        nop
        out _SFR_IO_ADDR(PINB), r2
        ldi r24, 28
        1: dec r24
        brne 1b

        out _SFR_IO_ADDR(PINB), r2
	ldi r24, 160
	1: dec r24
	brne 1b

        nop
        rjmp loop

// VSYNC SIGNAL

vsync:
        out _SFR_IO_ADDR(PINB), r2
        out _SFR_IO_ADDR(PINB), r6

        ldi r30, 0
        ldi r31, 40

        ldi r24, 12
	1: dec r24
	brne 1b
        nop

        out _SFR_IO_ADDR(PINB), r2

        ldi r24, 18
        1: dec r24
        brne 1b

        ldi r24, 157
        out _SFR_IO_ADDR(PINB), r6

        1: dec r24
        brne 1b
        nop

        rcall short
        rcall short
        rcall short
        rcall short
        rcall short
        rcall long
        rcall long
        rcall long
        rcall long
        rcall long
        rcall long
        rcall short
        rcall short
        rcall short
        rcall short
        rcall short
        rjmp short

// SHORT VSYNC PULSE
// 41 cycles low, 531-3 cycles high (to account for next rcall)

short:
	out _SFR_IO_ADDR(PINB), r2
	ldi r24, 13
	1: dec r24
	brne 1b
        nop

        out _SFR_IO_ADDR(PINB), r2
        ldi r24, 174
        1: dec r24
        brne 1b
        nop
        ret

// LONG VSYNC PULSE
// 487 cycles low, 85-3 cycles high (to account for next rcall)

long:
	out _SFR_IO_ADDR(PINB), r2
	ldi r24, 162
	1: dec r24
	brne 1b

        out _SFR_IO_ADDR(PINB), r2
        ldi r24, 25
        1: dec r24
        brne 1b
        nop
        nop
        ret

// FIELD CONSISTING OF 253 SCAN LINES

field:
	out _SFR_IO_ADDR(PINB), r2
	ldi r24, 27
        rcall blank1
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall line
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        rcall blank
        nop
        rjmp blank

// BLANK SCANLINE
// 85 cycles low, 1059-3 cycles high (to account for next rcall)

blank:
	out _SFR_IO_ADDR(PINB), r2
	ldi r24, 28
blank1:
	1: dec r24
	brne 1b

        out _SFR_IO_ADDR(PINB), r2
        ldi r24, 0
        1: dec r24
        brne 1b
        ldi r24, 94
        1: dec r24
        brne 1b
        nop
        ret

// SCAN LINE WITH DATA
// sync: 85 cycles low, 1059-3 cycles high (to account for next rcall)
// data starts 175 cycles after sync goes high 

line:
	out _SFR_IO_ADDR(PINB), r2
	ldi r24, 28
	1: dec r24
	brne 1b

        out _SFR_IO_ADDR(PINB), r2
        ldi r24, 47
        1: dec r24
        brne 1b

        out _SFR_IO_ADDR(PINB), r5
        ldi r24, 8
        1: dec r24
        brne 1b

        nop
        ldi r24, 0xFF
        sbis _SFR_IO_ADDR(PINB), 1
        out _SFR_IO_ADDR(DDRC), r24
        sbis _SFR_IO_ADDR(PINB), 1
        out _SFR_IO_ADDR(DDRD), r24
        out _SFR_IO_ADDR(PORTC), r31
        out _SFR_IO_ADDR(PORTD), r30

        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        inc r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PORTD), r30
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r3
        out _SFR_IO_ADDR(PINB), r3
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop
        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4
        nop

        out _SFR_IO_ADDR(PINB), r4
        out _SFR_IO_ADDR(PINB), r4

        out _SFR_IO_ADDR(PORTD), r1
        out _SFR_IO_ADDR(PORTC), r1
        out _SFR_IO_ADDR(DDRD), r1
        out _SFR_IO_ADDR(DDRC), r1
        out _SFR_IO_ADDR(PINB), r5

        adiw r30, 1

        ldi r24, 33
        1: dec r24
        brne 1b
        nop
        ret
