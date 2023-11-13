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
#if defined (PY32F003x4) || defined(PY32F003x6) || defined (PY32F003x8)
#include "pins_arduino.h"

/**
 * @brief  System Clock Configuration
 * @param  None
 * @retval None
 */
WEAK void SystemClock_Config(void)
{
    RCC_OscInitTypeDef RCC_OscInitStruct = {};
    RCC_ClkInitTypeDef RCC_ClkInitStruct = {};

#ifdef PY32F0xx_LSC_LSI
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_LSI;
    RCC_OscInitStruct.LSIState = RCC_LSI_ON;

#elif PY32F0xx_LSC_LSE
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_LSE;
    RCC_OscInitStruct.LSEState = RCC_LSE_ON;
    RCC_OscInitStruct.LSEDriver = RCC_LSEDRIVE_MEDIUM;

#elif PY32F0xx_LSC_NONE
    RCC_OscInitStruct.LSIState = RCC_LSI_OFF;
    RCC_OscInitStruct.LSEState = RCC_LSE_OFF;
#endif

#if defined(PY32F0xx_HSI_4M_HCLK_4M)
#ifdef HSI_VALUE
#undef HSI_VALUE
#endif
#define HSI_VALUE 4000000U
    /* 振荡器配置 */
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;                         /* 开启HSI */
    RCC_OscInitStruct.HSIDiv = RCC_HSI_DIV1;                         /* HSI 1分频 */
    RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_4MHz; /* 配置HSI时钟4MHz */
    RCC_OscInitStruct.HSEState = RCC_HSE_OFF;                        /* 关闭HSE */
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_OFF;                    /* 关闭PLL */
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_NONE;            /*不选择时钟源*/
    /* 配置振荡器 */
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* 时钟源配置 */
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1; /* 选择配置时钟 HCLK,SYSCLK,PCLK1 */
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;                                         /* 选择HSI作为系统时钟 */
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;                                             /* AHB时钟 1分频 */
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;                                              /* APB时钟 1分频 */
    /* 配置时钟源 */
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
    {
        Error_Handler();
    }
#elif defined(PY32F0xx_HSI_8M_HCLK_8M)
#ifdef HSI_VALUE
#undef HSI_VALUE
#endif
#define HSI_VALUE 8000000U
    /* 振荡器配置 */
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;                         /* 开启HSI */
    RCC_OscInitStruct.HSIDiv = RCC_HSI_DIV1;                         /* HSI 1分频 */
    RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_8MHz; /* 配置HSI时钟8MHz */
    RCC_OscInitStruct.HSEState = RCC_HSE_OFF;                        /* 关闭HSE */
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_OFF;                    /* 关闭PLL */
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_NONE;            /*不选择时钟源*/
    /* 配置振荡器 */
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* 时钟源配置 */
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1; /* 选择配置时钟 HCLK,SYSCLK,PCLK1 */
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;                                         /* 选择HSI作为系统时钟 */
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;                                             /* AHB时钟 1分频 */
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;                                              /* APB时钟 1分频 */
    /* 配置时钟源 */
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
    {
        Error_Handler();
    }

#elif defined(PY32F0xx_HSI_16M_HCLK_16M)
#ifdef HSI_VALUE
#undef HSI_VALUE
#endif
#define HSI_VALUE 16000000U
    /* 振荡器配置 */
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;                          /* 开启HSI */
    RCC_OscInitStruct.HSIDiv = RCC_HSI_DIV1;                          /* HSI 1分频 */
    RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_16MHz; /* 配置HSI时钟16MHz */
    RCC_OscInitStruct.HSEState = RCC_HSE_OFF;                         /* 关闭HSE */
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_OFF;                     /* 关闭PLL */
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_NONE;             /*不选择时钟源*/
    /* 配置振荡器 */
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* 时钟源配置 */
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1; /* 选择配置时钟 HCLK,SYSCLK,PCLK1 */
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;                                         /* 选择HSI作为系统时钟 */
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;                                             /* AHB时钟 1分频 */
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;                                              /* APB时钟 1分频 */
    /* 配置时钟源 */
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
    {
        Error_Handler();
    }

#elif defined(PY32F0xx_HSI_22_12M_HCLK_22_12M)
#ifdef HSI_VALUE
#undef HSI_VALUE
#endif
#define HSI_VALUE 22120000U
    /* 振荡器配置 */
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;                             /* 开启HSI */
    RCC_OscInitStruct.HSIDiv = RCC_HSI_DIV1;                             /* HSI 1分频 */
    RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_22p12MHz; /* 配置HSI时钟22.12MHz */
    RCC_OscInitStruct.HSEState = RCC_HSE_OFF;                            /* 关闭HSE */
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_OFF;                        /* 关闭PLL */
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_NONE;                /*不选择时钟源*/
    /* 配置振荡器 */
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* 时钟源配置 */
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1; /* 选择配置时钟 HCLK,SYSCLK,PCLK1 */
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;                                         /* 选择HSI作为系统时钟 */
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;                                             /* AHB时钟 1分频 */
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;                                              /* APB时钟 1分频 */
    /* 配置时钟源 */
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
    {
        Error_Handler();
    }

#elif defined(PY32F0xx_HSI_24M_HCLK_24M)
#ifdef HSI_VALUE
#undef HSI_VALUE
#endif
#define HSI_VALUE 24000000U
    /* 振荡器配置 */
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;                          /* 开启HSI */
    RCC_OscInitStruct.HSIDiv = RCC_HSI_DIV1;                          /* HSI 1分频 */
    RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_24MHz; /* 配置HSI时钟24MHz */
    RCC_OscInitStruct.HSEState = RCC_HSE_OFF;                         /* 关闭HSE */
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_OFF;                     /* 关闭PLL */
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_NONE;             /*不选择时钟源*/
    /* 配置振荡器 */
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* 时钟源配置 */
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1; /* 选择配置时钟 HCLK,SYSCLK,PCLK1 */
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;                                         /* 选择HSI作为系统时钟 */
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;                                             /* AHB时钟 1分频 */
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;                                              /* APB时钟 1分频 */
    /* 配置时钟源 */
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
    {
        Error_Handler();
    }

#elif defined(PY32F0xx_HSE_8M_HCLK_8M)
#ifdef HSE_VALUE
#undef HSE_VALUE
#endif
#define HSE_VALUE 8000000U
    /* 振荡器配置 */
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_HSE; /* 选择RCC振荡器为HSE */
    RCC_OscInitStruct.HSIState = RCC_HSI_OFF;                   /* 开启HSI */
    /* RCC_OscInitStruct.HSIDiv = RCC_HSI_DIV4; */              /* 4分频 */
    // RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_24MHz;                       /* 配置HSI输出时钟为8MHz */
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;              /* 开启HSE */
    RCC_OscInitStruct.HSEFreq = RCC_HSE_8_16MHz;          /* HSE晶振工作频率16M~32M */
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_OFF;         /* 关闭PLL */
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_NONE; /* 不选择PLL源 */
    /* 配置振荡器 */
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* 时钟源配置 */
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1; /* 选择配置时钟 HCLK,SYSCLK,PCLK1 */
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSE;                                         /* 选择HSE作为系统时钟 */
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;                                             /* AHB时钟 1分频 */
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;                                              /* APB时钟 1分频 */
    /* 配置时钟源 */
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
    {
        Error_Handler();
    }

#elif defined(PY32F0xx_HSE_16M_HCLK_16M)
#ifdef HSE_VALUE
#undef HSE_VALUE
#endif
#define HSE_VALUE 16000000U
    /* 振荡器配置 */
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_HSE; /* 选择RCC振荡器为HSE */
    RCC_OscInitStruct.HSIState = RCC_HSI_OFF;                   /* 开启HSI */
    /* RCC_OscInitStruct.HSIDiv = RCC_HSI_DIV4; */              /* 4分频 */
    // RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_24MHz;                       /* 配置HSI输出时钟为8MHz */
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;              /* 开启HSE */
    RCC_OscInitStruct.HSEFreq = RCC_HSE_8_16MHz;          /* HSE晶振工作频率16M~32M */
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_OFF;         /* 关闭PLL */
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_NONE; /* 不选择PLL源 */
    /* 配置振荡器 */
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* 时钟源配置 */
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1; /* 选择配置时钟 HCLK,SYSCLK,PCLK1 */
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSE;                                         /* 选择HSE作为系统时钟 */
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;                                             /* AHB时钟 1分频 */
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;                                              /* APB时钟 1分频 */
    /* 配置时钟源 */
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
    {
        Error_Handler();
    }

#elif defined(PY32F0xx_HSE_24M_HCLK_24M)
#ifdef HSE_VALUE
#undef HSE_VALUE
#endif
#define HSE_VALUE 24000000U
    /* 振荡器配置 */
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_HSE; /* 选择RCC振荡器为HSE */
    RCC_OscInitStruct.HSIState = RCC_HSI_OFF;
    /* RCC_OscInitStruct.HSIDiv = RCC_HSI_DIV4; */ /* 4分频 */
    // RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_24MHz;                       /* 配置HSI输出时钟为8MHz */
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;              /* 开启HSE */
    RCC_OscInitStruct.HSEFreq = RCC_HSE_16_32MHz;         /* HSE晶振工作频率16M~32M */
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_OFF;         /* 关闭PLL */
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_NONE; /* 不选择PLL源 */
    /* 配置振荡器 */
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* 时钟源配置 */
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1; /* 选择配置时钟 HCLK,SYSCLK,PCLK1 */
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSE;                                         /* 选择HSE作为系统时钟 */
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;                                             /* AHB时钟 1分频 */
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;                                              /* APB时钟 1分频 */
    /* 配置时钟源 */
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
    {
        Error_Handler();
    }

#elif defined(PY32F0xx_HSE_32M_HCLK_32M)
#ifdef HSE_VALUE
#undef HSE_VALUE
#endif
#define HSE_VALUE 32000000U
    /* 振荡器配置 */
    RCC_OscInitStruct.OscillatorType |= RCC_OSCILLATORTYPE_HSE; /* 选择RCC振荡器为HSE */
    RCC_OscInitStruct.HSIState = RCC_HSI_OFF;
    /* RCC_OscInitStruct.HSIDiv = RCC_HSI_DIV4; */ /* 4分频 */
    // RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_24MHz;                       /* 配置HSI输出时钟为8MHz */
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;              /* 开启HSE */
    RCC_OscInitStruct.HSEFreq = RCC_HSE_16_32MHz;         /* HSE晶振工作频率16M~32M */
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_OFF;         /* 关闭PLL */
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_NONE; /* 不选择PLL源 */
    /* 配置振荡器 */
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* 时钟源配置 */
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1; /* 选择配置时钟 HCLK,SYSCLK,PCLK1 */
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSE;                                         /* 选择HSE作为系统时钟 */
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;                                             /* AHB时钟 1分频 */
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;                                              /* APB时钟 1分频 */
    /* 配置时钟源 */
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
    {
        Error_Handler();
    }

#endif
}

#endif /* ARDUINO_GENERIC_* */
