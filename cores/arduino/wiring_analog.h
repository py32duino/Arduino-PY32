/*
  Copyright (c) 2011 Arduino.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#ifndef _WIRING_ANALOG_
#define _WIRING_ANALOG_

#if defined(PY32F0xx) || defined(AIR32F1xx)
/* Analog read resolution */
#define LL_ADC_RESOLUTION LL_ADC_RESOLUTION_12B
#define ADC_RANGE 4096
#endif

#if defined(AIR32F1xx)
#define VTEMP     1430
#define AVG_SLOPE 4300
#define VREFINT   1200
#endif

#if defined(AIR32C0xx)
#define CALX_TEMP 30
#else
#define CALX_TEMP 25
#endif

#ifdef __cplusplus
extern "C" {
#endif

/*
 * \brief SAM3 products have only one reference for ADC
 * This is kept only for compatibility with existing AVR based API.
 */
typedef enum _eAnalogReference {
  AR_DEFAULT,
} eAnalogReference ;

/*
 * \brief Configures the reference voltage used for analog input (i.e. the value used as the top of the input range).
 * This function is kept only for compatibility with existing AVR based API.
 *
 * \param ulMmode Should be set to AR_DEFAULT.
 */
extern void analogReference(eAnalogReference ulMode) ;

/*
 * \brief Writes an analog value (PWM wave) to a pin.
 *
 * \param ulPin
 * \param ulValue
 */
extern void analogWrite(uint32_t ulPin, uint32_t ulValue) ;

/*
 * \brief Reads the value from the specified analog pin.
 *
 * \param ulPin
 *
 * \return Read value from selected pin, if no error.
 */
extern uint32_t analogRead(uint32_t ulPin) ;

/**
 * @brief Read the value from the specified analog pin in millivolts.
 * 
 * @param ulPin 
 * @return uint32_t 
 */
extern uint32_t analogReadMillivolts(uint32_t ulPin);

/**
 * @brief Read the value from the specified analog pin in volts.
 * 
 * @return int32_t 
 */
extern int32_t analogReadVref();

/**
 * @brief Read the value from the specified analog pin in volts.
 * 
 * @param VRef 
 * @return int32_t 
 */
extern int32_t analogReadTempSensor();

/**
 * @brief Read the value from the specified analog pin in volts.
 * 
 * @param VRef 
 * @param pin 
 * @return int32_t 
 */
extern int32_t analogReadVoltage(int32_t VRef, uint32_t pin);

/*
 * \brief Set the resolution of analogRead return values. Default is 10 bits (range from 0 to 1023).
 *
 * \param res
 */
extern void analogReadResolution(int res);

/*
 * \brief Set the resolution of analogWrite parameters. Default is 8 bits (range from 0 to 255).
 *
 * \param res
 */
extern void analogWriteResolution(int res);

/*
 * \brief Set the frequency of analogWrite. Default is PWM_FREQUENCY (1000) in Hertz.
 *
 * \param freq
 */
extern void analogWriteFrequency(uint32_t freq);


extern void analogOutputInit(void) ;

#ifdef __cplusplus
}
#endif

#endif /* _WIRING_ANALOG_ */
