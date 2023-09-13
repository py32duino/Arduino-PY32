#include "PortNames.h"

GPIO_TypeDef *GPIOPort[MAX_NB_PORT] = {
  (GPIO_TypeDef *)GPIOA_BASE,
  (GPIO_TypeDef *)GPIOB_BASE
#if defined GPIOC_BASE
  , (GPIO_TypeDef *)GPIOC_BASE
#endif
#if defined GPIOD_BASE
  , (GPIO_TypeDef *)GPIOD_BASE
#endif
#if defined GPIOE_BASE
  , (GPIO_TypeDef *)GPIOE_BASE
#endif
#if defined GPIOF_BASE
  , (GPIO_TypeDef *)GPIOF_BASE
#endif
#if defined GPIOG_BASE
  , (GPIO_TypeDef *)GPIOG_BASE
#endif
#if defined GPIOH_BASE
  , (GPIO_TypeDef *)GPIOH_BASE
#endif
#if defined GPIOI_BASE
  , (GPIO_TypeDef *)GPIOI_BASE
#endif
#if defined GPIOJ_BASE
  , (GPIO_TypeDef *)GPIOJ_BASE
#endif
#if defined GPIOK_BASE
  , (GPIO_TypeDef *)GPIOK_BASE
#endif
#if defined GPIOZ_BASE
  , (GPIO_TypeDef *)GPIOZ_BASE
#endif
};

/* Enable GPIO clock and return GPIO base address */
GPIO_TypeDef *set_GPIO_Port_Clock(uint32_t port_idx)
{
  GPIO_TypeDef *gpioPort = 0;
  switch (port_idx) {
    case PortA:
      gpioPort = (GPIO_TypeDef *)GPIOA_BASE;
      __HAL_RCC_GPIOA_CLK_ENABLE();
      break;
    case PortB:
      gpioPort = (GPIO_TypeDef *)GPIOB_BASE;
      __HAL_RCC_GPIOB_CLK_ENABLE();
      break;
#if defined GPIOC_BASE
    case PortC:
      gpioPort = (GPIO_TypeDef *)GPIOC_BASE;
      __HAL_RCC_GPIOC_CLK_ENABLE();
      break;
#endif
#if defined GPIOD_BASE
    case PortD:
      gpioPort = (GPIO_TypeDef *)GPIOD_BASE;
      __HAL_RCC_GPIOD_CLK_ENABLE();
      break;
#endif
#if defined GPIOE_BASE
    case PortE:
      gpioPort = (GPIO_TypeDef *)GPIOE_BASE;
      __HAL_RCC_GPIOE_CLK_ENABLE();
      break;
#endif
#if defined GPIOF_BASE
    case PortF:
      gpioPort = (GPIO_TypeDef *)GPIOF_BASE;
      __HAL_RCC_GPIOF_CLK_ENABLE();
      break;
#endif
#if defined GPIOG_BASE
    case PortG:
#if defined(PWR_CR2_IOSV) || defined(PWR_SVMCR_IO2VMEN)
      // Enable VDDIO2 supply for 14 I/Os (Port G[15:2])
      HAL_PWREx_EnableVddIO2();
#endif
      gpioPort = (GPIO_TypeDef *)GPIOG_BASE;
      __HAL_RCC_GPIOG_CLK_ENABLE();
      break;
#endif
#if defined GPIOH_BASE
    case PortH:
      gpioPort = (GPIO_TypeDef *)GPIOH_BASE;
      __HAL_RCC_GPIOH_CLK_ENABLE();
      break;
#endif
#if defined GPIOI_BASE
    case PortI:
      gpioPort = (GPIO_TypeDef *)GPIOI_BASE;
      __HAL_RCC_GPIOI_CLK_ENABLE();
      break;
#endif
#if defined GPIOJ_BASE
    case PortJ:
      gpioPort = (GPIO_TypeDef *)GPIOJ_BASE;
      __HAL_RCC_GPIOJ_CLK_ENABLE();
      break;
#endif
#if defined GPIOK_BASE
    case PortK:
      gpioPort = (GPIO_TypeDef *)GPIOK_BASE;
      __HAL_RCC_GPIOK_CLK_ENABLE();
      break;
#endif
#if defined GPIOZ_BASE
    case PortZ:
      gpioPort = (GPIO_TypeDef *)GPIOZ_BASE;
      __HAL_RCC_GPIOZ_CLK_ENABLE();
      break;
#endif
    default:
      // wrong port number
      //TBD: error management
      gpioPort = 0;
      break;
  }
  return gpioPort;
}
