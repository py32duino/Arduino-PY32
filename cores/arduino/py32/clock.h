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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __CLOCK_H
#define __CLOCK_H

/* Includes ------------------------------------------------------------------*/
#include "py32_def.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Exported types ------------------------------------------------------------*/
/* Clock source selection */
typedef enum {
  LSI_CLOCK,
  HSI_CLOCK,
  LSE_CLOCK,
  HSE_CLOCK
} sourceClock_t;

/* Exported constants --------------------------------------------------------*/
/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */
uint32_t getCurrentMillis(void);
uint32_t getCurrentMicros(void);

void configIPClock(void);
void enableClock(sourceClock_t source);
void configHSECapacitorTuning(void);

#ifdef __cplusplus
}
#endif

#endif /* __CLOCK_H */

/************************ (C) COPYRIGHT AirM2M *****END OF FILE****/
