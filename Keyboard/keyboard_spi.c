// Phoenix keyboard controller based on ATtiny85 and SPI communication.

#define F_CPU 8000000UL

#include <stdbool.h>
#include <stdint.h>

#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <util/delay.h>

#define KBD_READY PB0
#define KBD_DATA PB1
#define KBD_CLOCK PB2

#define PS2_CLOCK PB3
#define PS2_DATA PB4

// Is an SPI transfer in progress?
volatile bool busy = false;

// Map scan code to ASCII, for non-shift and shift each.
uint8_t table[] PROGMEM = {
#include "table.c"
};

// Called when SPI transfer is complete. Resets busy flag and PB0.
ISR(USI_OVF_vect) {
  PORTB &= ~_BV(KBD_READY);
  USISR |= _BV(USIOIF);
  busy = false;
}

static void send(uint8_t byte) {
  // Discard character if another transfer is in progress.
  if (busy)
    return;
  busy = true;              // Prevent clobbering while transfer is in progress.
  USIDR = byte;             // SPI data register.
  USISR = _BV(USIOIF);      // Clear SPI overflow flag.
  PORTB |= _BV(KBD_READY);  // Tell Z80 character is ready.
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

  DDRB = _BV(KBD_DATA) | _BV(KBD_READY);

  // Enable SPI overflow interrupt and set SPI mode with slave clocking.
  USICR = _BV(USIOIE) | _BV(USIWM0) | _BV(USICS1);
  sei();

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
      if (!release) {
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
