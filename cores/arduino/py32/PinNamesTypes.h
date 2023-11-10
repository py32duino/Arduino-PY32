/*
 *******************************************************************************
 * Copyright (c) 2023, AirM2M
 * All rights reserved.
 *
 * This software component is licensed by AirM2M under BSD 3-Clause license,
 * the "License"; You may not use this file except in compliance with the
 * License. You may obtain a copy of the License at:
 *                        opensource.org/licenses/BSD-3-Clause
 *
 *******************************************************************************
 */
#ifndef _PINNAMESTYPES_H
#define _PINNAMESTYPES_H

#ifdef __cplusplus
extern "C" {
#endif

/*  PY32 PIN data as used in pin_function is coded on 32 bits as below
 *   [2:0]  Function (like in MODER reg) : Input / Output / Alt / Analog
 *     [3]  Output Push-Pull / Open Drain (as in OTYPER reg)
 *   [5:4]  as in PUPDR reg: No Pull, Pull-up, Pull-Down
 *   [7:6]  Reserved for speed config (as in OSPEEDR), but not used yet
 *  [14:8]  Alternate Num (as in AFRL/AFRG reg)
 * [19:15]  Channel (Analog/Timer specific)
 *    [20]  Inverted (Analog/Timer specific)
 *    [21]  Analog ADC control - Only valid for specific families
 *    [22]  Analog channel bank B - Only valid for specific families
 * [32:23]  Reserved
 */

#define PY32_PIN_FUNCTION_MASK 0x07
#define PY32_PIN_FUNCTION_SHIFT 0
#define PY32_PIN_FUNCTION_BITS (PY32_PIN_FUNCTION_MASK << PY32_PIN_FUNCTION_SHIFT)

#define PY32_PIN_OD_MASK 0x01
#define PY32_PIN_OD_SHIFT 3
#define PY32_PIN_OD_BITS (PY32_PIN_OD_MASK << PY32_PIN_OD_SHIFT)

#define PY32_PIN_PUPD_MASK 0x03
#define PY32_PIN_PUPD_SHIFT 4
#define PY32_PIN_PUPD_BITS (PY32_PIN_PUPD_MASK << PY32_PIN_PUPD_SHIFT)

#define PY32_PIN_SPEED_MASK 0x03
#define PY32_PIN_SPEED_SHIFT 6
#define PY32_PIN_SPEED_BITS (PY32_PIN_SPEED_MASK << PY32_PIN_SPEED_SHIFT)

#define PY32_PIN_AFNUM_MASK 0x7F
#define PY32_PIN_AFNUM_SHIFT 8
#define PY32_PIN_AFNUM_BITS (PY32_PIN_AFNUM_MASK << PY32_PIN_AFNUM_SHIFT)

#define PY32_PIN_CHAN_MASK 0x1F
#define PY32_PIN_CHAN_SHIFT 15
#define PY32_PIN_CHANNEL_BIT (PY32_PIN_CHAN_MASK << PY32_PIN_CHAN_SHIFT)

#define PY32_PIN_INV_MASK 0x01
#define PY32_PIN_INV_SHIFT 20
#define PY32_PIN_INV_BIT (PY32_PIN_INV_MASK << PY32_PIN_INV_SHIFT)

#define PY32_PIN_AN_CTRL_MASK 0x01
#define PY32_PIN_AN_CTRL_SHIFT 21
#define PY32_PIN_ANALOG_CONTROL_BIT (PY32_PIN_AN_CTRL_MASK << PY32_PIN_AN_CTRL_SHIFT)

#define PY32_PIN_AN_CHAN_BANK_B_MASK 0x01
#define PY32_PIN_AN_CHAN_BANK_B_SHIFT 22
#define PY32_PIN_ANALOG_CHAN_BANK_B_BIT (PY32_PIN_AN_CHAN_BANK_B_MASK << PY32_PIN_AN_CHAN_BANK_B_SHIFT)

#define PY32_PIN_FUNCTION(X)               (((X) >> PY32_PIN_FUNCTION_SHIFT) & PY32_PIN_FUNCTION_MASK)
#define PY32_PIN_OD(X)                     (((X) >> PY32_PIN_OD_SHIFT) & PY32_PIN_OD_MASK)
#define PY32_PIN_PUPD(X)                   (((X) >> PY32_PIN_PUPD_SHIFT) & PY32_PIN_PUPD_MASK)
#define PY32_PIN_SPEED(X)                  (((X) >> PY32_PIN_SPEED_SHIFT) & PY32_PIN_SPEED_MASK)
#define PY32_PIN_AFNUM(X)                  (((X) >> PY32_PIN_AFNUM_SHIFT) & PY32_PIN_AFNUM_MASK)
#define PY32_PIN_CHANNEL(X)                (((X) >> PY32_PIN_CHAN_SHIFT) & PY32_PIN_CHAN_MASK)
#define PY32_PIN_INVERTED(X)               (((X) >> PY32_PIN_INV_SHIFT) & PY32_PIN_INV_MASK)
#define PY32_PIN_ANALOG_CONTROL(X)         (((X) >> PY32_PIN_AN_CTRL_SHIFT) & PY32_PIN_AN_CTRL_MASK)
#define PY32_PIN_ANALOG_CHANNEL_BANK_B(X)  (((X) >> PY32_PIN_AN_CHAN_BANK_B_SHIFT) & PY32_PIN_AN_CHAN_BANK_B_MASK)
#define PY32_PIN_MODE(X)                   ((PY32_PIN_OD((X)) << 4) | \
                                           (PY32_PIN_FUNCTION((X)) & (~PY32_PIN_OD_BITS)))

#define PY32_PIN_DEFINE(FUNC_OD, PUPD, AFNUM)  ((int)(FUNC_OD) |\
                          ((PUPD  & PY32_PIN_PUPD_MASK) << PY32_PIN_PUPD_SHIFT) |\
                          ((AFNUM & PY32_PIN_AFNUM_MASK) << PY32_PIN_AFNUM_SHIFT))

#define PY32_PIN_DEFINE_EXT(FUNC_OD, PUPD, AFNUM, CHAN, INV) \
                                            ((int)(FUNC_OD) |\
                       ((PUPD   & PY32_PIN_PUPD_MASK) << PY32_PIN_PUPD_SHIFT) |\
                       ((AFNUM  & PY32_PIN_AFNUM_MASK) << PY32_PIN_AFNUM_SHIFT) |\
                       ((CHAN   & PY32_PIN_CHAN_MASK) << PY32_PIN_CHAN_SHIFT) |\
                       ((INV    & PY32_PIN_INV_MASK) << PY32_PIN_INV_SHIFT))

/*
 * MACROS to support the legacy definition of PIN formats
 * The PY32_MODE_ defines contain the function and the Push-pull/OpenDrain
 * configuration (legacy inheritance).
 */
#define PY32_PIN_DATA(FUNC_OD, PUPD, AFNUM) \
            PY32_PIN_DEFINE(FUNC_OD, PUPD, AFNUM)
#define PY32_PIN_DATA_EXT(FUNC_OD, PUPD, AFNUM, CHANNEL, INVERTED) \
            PY32_PIN_DEFINE_EXT(FUNC_OD, PUPD, AFNUM, CHANNEL, INVERTED)

typedef enum {
  PY32_PIN_INPUT = 0,
  PY32_PIN_OUTPUT = 1,
  PY32_PIN_ALTERNATE = 2,
  PY32_PIN_ANALOG = 3,
} AirPinFunction;

#define PY32_MODE_INPUT                      (PY32_PIN_INPUT)
#define PY32_MODE_OUTPUT_PP                  (PY32_PIN_OUTPUT)
#define PY32_MODE_OUTPUT_OD                  (PY32_PIN_OUTPUT | PY32_PIN_OD_BITS)
#define PY32_MODE_AF_PP                      (PY32_PIN_ALTERNATE)
#define PY32_MODE_AF_OD                      (PY32_PIN_ALTERNATE | PY32_PIN_OD_BITS)
#define PY32_MODE_ANALOG                     (PY32_PIN_ANALOG)
#define PY32_MODE_ANALOG_ADC_CONTROL         (PY32_PIN_ANALOG | PY32_PIN_ANALOG_CONTROL_BIT)
#define PY32_MODE_ANALOG_ADC_CHANNEL_BANK_B  (PY32_PIN_ANALOG | PY32_PIN_ANALOG_CHAN_BANK_B_BIT)

// High nibble = port number (FirstPort <= PortName <= LastPort)
// Low nibble  = pin number
#define PY32_PORT(X) (((uint32_t)(X) >> 4) & 0xF)
#define PY32_PIN(X)  ((uint32_t)(X) & 0xF)
// Check PinName is valid: FirstPort <= PortName <= LastPort
// As FirstPort is equal to 0 and PY32_PORT cast as an unsigned
// (PY32_PORT(X) >= FirstPort)  is always true
//#define PY32_VALID_PINNAME(X) ((PY32_PORT(X) >= FirstPort) && (PY32_PORT(X) <= LastPort))
#define PY32_VALID_PINNAME(X) (PY32_PORT(X) <= LastPort)

#define PY32_GPIO_PIN(X) ((uint16_t)(1<<PY32_PIN(X)))

#ifdef __cplusplus
}
#endif

#endif

