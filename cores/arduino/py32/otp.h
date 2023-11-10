/*
 *******************************************************************************
 * Copyright (c) 2023, AirM2M
 * All rights reserved.
 *
 * This software component is licensed by ST under BSD 3-Clause license,
 * the "License"; You may not use this file except in compliance with the
 * License. You may obtain a copy of the License at:
 *                        opensource.org/licenses/BSD-3-Clause
 *
 *******************************************************************************
 */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __OTP_H
#define __OTP_H

#include "py32_def.h"

#ifdef OTP_AREA_BASE
#ifdef __cplusplus
extern "C" {
#endif

/* Exported functions --------------------------------------------------------*/

/**
 * @brief This API return the address (64 bits aligned) of the ID parameter in the OTP
 *        It returns the first ID declaration found from the higher address down to the base address
 *        The user shall fill the OTP from the base address to the top of the OTP so that the more recent
 *        declaration is returned by the API
 *        The OTP manager handles only 64 bits parameter
 *        | Id    | Parameter |
 *        | 8bits | 58bits    |
 *        | MSB   |  LSB      |
 *
 * @param  id: ID of the parameter to read from OTP
 * @retval Address of the ID in the OTP - returns 0 when no ID found
 */
uint8_t *OTP_Read(uint8_t id);

#ifdef __cplusplus
}
#endif
#endif /* OTP_AREA_BASE */
#endif /*__OTP_H */

/************************ (C) COPYRIGHT AirM2M *****END OF FILE****/
