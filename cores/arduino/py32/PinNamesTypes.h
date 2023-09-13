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

/*  AIR PIN data as used in pin_function is coded on 32 bits as below
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

#define AIR_PIN_FUNCTION_MASK 0x07
#define AIR_PIN_FUNCTION_SHIFT 0
#define AIR_PIN_FUNCTION_BITS (AIR_PIN_FUNCTION_MASK << AIR_PIN_FUNCTION_SHIFT)

#define AIR_PIN_OD_MASK 0x01
#define AIR_PIN_OD_SHIFT 3
#define AIR_PIN_OD_BITS (AIR_PIN_OD_MASK << AIR_PIN_OD_SHIFT)

#define AIR_PIN_PUPD_MASK 0x03
#define AIR_PIN_PUPD_SHIFT 4
#define AIR_PIN_PUPD_BITS (AIR_PIN_PUPD_MASK << AIR_PIN_PUPD_SHIFT)

#define AIR_PIN_SPEED_MASK 0x03
#define AIR_PIN_SPEED_SHIFT 6
#define AIR_PIN_SPEED_BITS (AIR_PIN_SPEED_MASK << AIR_PIN_SPEED_SHIFT)

#define AIR_PIN_AFNUM_MASK 0x7F
#define AIR_PIN_AFNUM_SHIFT 8
#define AIR_PIN_AFNUM_BITS (AIR_PIN_AFNUM_MASK << AIR_PIN_AFNUM_SHIFT)

#define AIR_PIN_CHAN_MASK 0x1F
#define AIR_PIN_CHAN_SHIFT 15
#define AIR_PIN_CHANNEL_BIT (AIR_PIN_CHAN_MASK << AIR_PIN_CHAN_SHIFT)

#define AIR_PIN_INV_MASK 0x01
#define AIR_PIN_INV_SHIFT 20
#define AIR_PIN_INV_BIT (AIR_PIN_INV_MASK << AIR_PIN_INV_SHIFT)

#define AIR_PIN_AN_CTRL_MASK 0x01
#define AIR_PIN_AN_CTRL_SHIFT 21
#define AIR_PIN_ANALOG_CONTROL_BIT (AIR_PIN_AN_CTRL_MASK << AIR_PIN_AN_CTRL_SHIFT)

#define AIR_PIN_AN_CHAN_BANK_B_MASK 0x01
#define AIR_PIN_AN_CHAN_BANK_B_SHIFT 22
#define AIR_PIN_ANALOG_CHAN_BANK_B_BIT (AIR_PIN_AN_CHAN_BANK_B_MASK << AIR_PIN_AN_CHAN_BANK_B_SHIFT)

#define AIR_PIN_FUNCTION(X)               (((X) >> AIR_PIN_FUNCTION_SHIFT) & AIR_PIN_FUNCTION_MASK)
#define AIR_PIN_OD(X)                     (((X) >> AIR_PIN_OD_SHIFT) & AIR_PIN_OD_MASK)
#define AIR_PIN_PUPD(X)                   (((X) >> AIR_PIN_PUPD_SHIFT) & AIR_PIN_PUPD_MASK)
#define AIR_PIN_SPEED(X)                  (((X) >> AIR_PIN_SPEED_SHIFT) & AIR_PIN_SPEED_MASK)
#define AIR_PIN_AFNUM(X)                  (((X) >> AIR_PIN_AFNUM_SHIFT) & AIR_PIN_AFNUM_MASK)
#define AIR_PIN_CHANNEL(X)                (((X) >> AIR_PIN_CHAN_SHIFT) & AIR_PIN_CHAN_MASK)
#define AIR_PIN_INVERTED(X)               (((X) >> AIR_PIN_INV_SHIFT) & AIR_PIN_INV_MASK)
#define AIR_PIN_ANALOG_CONTROL(X)         (((X) >> AIR_PIN_AN_CTRL_SHIFT) & AIR_PIN_AN_CTRL_MASK)
#define AIR_PIN_ANALOG_CHANNEL_BANK_B(X)  (((X) >> AIR_PIN_AN_CHAN_BANK_B_SHIFT) & AIR_PIN_AN_CHAN_BANK_B_MASK)
#define AIR_PIN_MODE(X)                   ((AIR_PIN_OD((X)) << 4) | \
                                           (AIR_PIN_FUNCTION((X)) & (~AIR_PIN_OD_BITS)))

#define AIR_PIN_DEFINE(FUNC_OD, PUPD, AFNUM)  ((int)(FUNC_OD) |\
                          ((PUPD  & AIR_PIN_PUPD_MASK) << AIR_PIN_PUPD_SHIFT) |\
                          ((AFNUM & AIR_PIN_AFNUM_MASK) << AIR_PIN_AFNUM_SHIFT))

#define AIR_PIN_DEFINE_EXT(FUNC_OD, PUPD, AFNUM, CHAN, INV) \
                                            ((int)(FUNC_OD) |\
                       ((PUPD   & AIR_PIN_PUPD_MASK) << AIR_PIN_PUPD_SHIFT) |\
                       ((AFNUM  & AIR_PIN_AFNUM_MASK) << AIR_PIN_AFNUM_SHIFT) |\
                       ((CHAN   & AIR_PIN_CHAN_MASK) << AIR_PIN_CHAN_SHIFT) |\
                       ((INV    & AIR_PIN_INV_MASK) << AIR_PIN_INV_SHIFT))

/*
 * MACROS to support the legacy definition of PIN formats
 * The AIR_MODE_ defines contain the function and the Push-pull/OpenDrain
 * configuration (legacy inheritance).
 */
#define AIR_PIN_DATA(FUNC_OD, PUPD, AFNUM) \
            AIR_PIN_DEFINE(FUNC_OD, PUPD, AFNUM)
#define AIR_PIN_DATA_EXT(FUNC_OD, PUPD, AFNUM, CHANNEL, INVERTED) \
            AIR_PIN_DEFINE_EXT(FUNC_OD, PUPD, AFNUM, CHANNEL, INVERTED)

typedef enum {
  AIR_PIN_INPUT = 0,
  AIR_PIN_OUTPUT = 1,
  AIR_PIN_ALTERNATE = 2,
  AIR_PIN_ANALOG = 3,
} AirPinFunction;

#define AIR_MODE_INPUT                      (AIR_PIN_INPUT)
#define AIR_MODE_OUTPUT_PP                  (AIR_PIN_OUTPUT)
#define AIR_MODE_OUTPUT_OD                  (AIR_PIN_OUTPUT | AIR_PIN_OD_BITS)
#define AIR_MODE_AF_PP                      (AIR_PIN_ALTERNATE)
#define AIR_MODE_AF_OD                      (AIR_PIN_ALTERNATE | AIR_PIN_OD_BITS)
#define AIR_MODE_ANALOG                     (AIR_PIN_ANALOG)
#define AIR_MODE_ANALOG_ADC_CONTROL         (AIR_PIN_ANALOG | AIR_PIN_ANALOG_CONTROL_BIT)
#define AIR_MODE_ANALOG_ADC_CHANNEL_BANK_B  (AIR_PIN_ANALOG | AIR_PIN_ANALOG_CHAN_BANK_B_BIT)

// High nibble = port number (FirstPort <= PortName <= LastPort)
// Low nibble  = pin number
#define AIR_PORT(X) (((uint32_t)(X) >> 4) & 0xF)
#define AIR_PIN(X)  ((uint32_t)(X) & 0xF)
// Check PinName is valid: FirstPort <= PortName <= LastPort
// As FirstPort is equal to 0 and AIR_PORT cast as an unsigned
// (AIR_PORT(X) >= FirstPort)  is always true
//#define AIR_VALID_PINNAME(X) ((AIR_PORT(X) >= FirstPort) && (AIR_PORT(X) <= LastPort))
#define AIR_VALID_PINNAME(X) (AIR_PORT(X) <= LastPort)

#define AIR_GPIO_PIN(X) ((uint16_t)(1<<AIR_PIN(X)))

#ifdef __cplusplus
}
#endif

#endif

