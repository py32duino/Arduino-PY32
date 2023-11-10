/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "py32f1xx_hal_gpio_ex.c"
#endif
#pragma GCC diagnostic pop
