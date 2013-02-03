// Phoenix keyboard controller based on ATtiny85 + 74HC595.

#define F_CPU 8000000UL

#include <stdbool.h>
#include <stdint.h>

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <util/delay.h>

#define PS2_CLOCK PB3
#define PS2_DATA PB4
#define SR_CLOCK PB2
#define SR_DATA PB1
#define SR_LATCH PB0

// Map scan code to ASCII, for non-shift and shift each.
uint8_t table[] PROGMEM = {
#include "table.c"
};

static void send(uint8_t byte) {
  for (uint8_t i = 0; i < 8; ++i) {
    if (byte & 0x80) {
      PORTB |= _BV(SR_DATA);
    } else {
      PORTB &= ~_BV(SR_DATA);
    }
    PORTB |= _BV(SR_CLOCK);
    PORTB &= ~_BV(SR_CLOCK);
    byte <<= 1;
  }
  PORTB |= _BV(SR_LATCH);
  PORTB &= ~_BV(SR_LATCH);
}

static uint8_t receive() {
  uint8_t bits = 0;  // Number of bits received in buffer.
  uint8_t byte = 0;  // Buffer.
  uint8_t t = 0;     // Used for timeout.

  for (;;) {
    // Wait for falling edge of PS/2 clock.
    for (t = 255; t > 0; t--) {
      if (bit_is_clear(PINB, PS2_CLOCK))
        break;
    }
    if (t == 0) {
      // Timeout, clear buffer.
      bits = 0;
      continue;
    }

    // Read bit.
    byte >>= 1;
    if (bit_is_set(PINB, PS2_DATA))
      byte |= 0x80;
    bits += 1;

    // Wait for rising edge of PS/2 clock.
    for (t = 255; t > 0; t--) {
      if (bit_is_set(PINB, PB3))
        break;
    }
    if (t == 0) {
      // Timeout, clear buffer.
      bits = 0;
      continue;
    }

    // Start bit + eight data bits read: return.
    if (bits == 9) {
      return byte;
      // Note: next 2 bits will be garbage, but we should deal with that OK.
    }
  }
}

int main() {
  bool release = false;  // Key being released?
  bool shift = false;    // Shift held down?
  bool ctrl = false;     // CTRL held down?
  bool alt = false;      // ALT held down?
  bool caps = false;     // CAPS LOCK active?

  DDRB = _BV(SR_CLOCK) | _BV(SR_DATA) | _BV(SR_LATCH);

  for (;;) {
    // Receive scan code.
    uint8_t c = receive();

    if (c == 0xe0) {
      // Ignore extended scan codes.
    } else if (c == 0xf0) {
      // A key was released (next scan code).
      release = true;
    } else if (c == 0x12) {
      // Shift pressed or released.
      shift = !release;
      release = false;
    } else if (c == 0x14) {
      // CTRL pressed or released.
      ctrl = !release;
      release = false;
    } else if (c == 0x11 || c == 0x1f) {
      // ALT prssed or released.
      alt = !release;
      release = false;
    } else if (c == 0x58) {
      // CAPS LOCK pressed or released.
      if (!release) {
        caps = !caps;
      }
      release = false;
    } else {
      if (release) {
        // Key released.
        send(0x00);
      } else {
        // Key pressed.
        uint8_t ascii_char = pgm_read_byte(table + 2*c + shift);
        if (caps && ascii_char >= 'a' && ascii_char <= 'z') {
          // CAPS LOCK active: convert to upper case.
          ascii_char &= ~0x20;
        }
        if (ctrl) {
          // CTRL active: map onto 0x00..0x1f;
          ascii_char &= 0x1f;
        }
        if (alt && ascii_char != 0) {
          // ALT active: map onto 0x80..0xff;
          ascii_char |= 0x80;
        }
        send(ascii_char);
      }
      release = false;
    }
  }
}
