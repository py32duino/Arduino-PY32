#ifndef _PY32_DEF_
#define _PY32_DEF_


/**
 * @brief AIR core version number
 */
#define AIR_CORE_VERSION_MAJOR    (0x02U) /*!< [31:24] major version */
#define AIR_CORE_VERSION_MINOR    (0x05U) /*!< [23:16] minor version */
#define AIR_CORE_VERSION_PATCH    (0x00U) /*!< [15:8]  patch version */
/*
 * Extra label for development:
 * 0: official release
 * [1-9]: release candidate
 * F[0-9]: development
 */
#define AIR_CORE_VERSION_EXTRA    (0xF0U) /*!< [7:0]  extra version */
#define AIR_CORE_VERSION          ((AIR_CORE_VERSION_MAJOR << 24U)\
                                        |(AIR_CORE_VERSION_MINOR << 16U)\
                                        |(AIR_CORE_VERSION_PATCH << 8U )\
                                        |(AIR_CORE_VERSION_EXTRA))

#define USE_HAL_DRIVER

#if defined(PY32F0xx)
  #include "py32f0xx.h"
#else
  #error "AIRYYxx chip series is not defined in boards.txt."
#endif

#ifndef F_CPU
  #define F_CPU SystemCoreClock
#endif

// Here define some compatibility
#ifndef ADC1
  #define ADC1 ADC
#endif
#ifndef CAN1
  #define CAN1 CAN
#endif
#ifndef DAC1
  #define DAC1 DAC
#endif

#ifdef USB_OTG_FS
  #if !defined(__HAL_RCC_USB_OTG_FS_CLK_DISABLE) && defined(__HAL_RCC_USB_CLK_DISABLE)
    #define __HAL_RCC_USB_OTG_FS_CLK_DISABLE __HAL_RCC_USB_CLK_DISABLE
  #endif
  #if !defined(__HAL_RCC_USB_OTG_FS_CLK_ENABLE) && defined(__HAL_RCC_USB_CLK_ENABLE)
    #define __HAL_RCC_USB_OTG_FS_CLK_ENABLE __HAL_RCC_USB_CLK_ENABLE
  #endif
#endif

/* AIRG0xx defined USB_DRD_FS */
#if !defined(USB) && defined(USB_DRD_FS)
  #define USB USB_DRD_FS
  #define PinMap_USB PinMap_USB_DRD_FS
#endif

/**
 * Some mcu have single AF and thus only AF mode should be configured.
 * No AFRL/AFRG registers exists so they should not be configured.
 * In that case the AF does not exists so defining the linked AF
 * to 0x7F (max value of the AFNUM i.e. PY32_PIN_AFNUM_MASK)
 * See GitHub issue #1798.
 */
#if defined(PY32F0xx) && !defined(GPIO_AF0_TIM3)
  #define GPIO_AF0_TIM3 PY32_PIN_AFNUM_MASK
#endif

/**
 * Libc porting layers
 */
#if defined (  __GNUC__  ) /* GCC CS3 */
  #define WEAK __attribute__ ((weak))
#endif

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

// weaked functions declaration
void SystemClock_Config(void);

#if defined(NDEBUG)
#if !defined(_Error_Handler)
#define _Error_Handler(str, value) \
  while (1) {\
  }
#endif
#if !defined(Error_Handler)
#define Error_Handler() \
  while (1) {\
  }
#endif
#else
void _Error_Handler(const char *, int);

#define Error_Handler() _Error_Handler(__FILE__, __LINE__)
#endif

#ifdef __cplusplus
} // extern "C"
#endif // __cplusplus

#endif //_PY32_DEF_
