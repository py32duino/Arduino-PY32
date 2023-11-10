/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL0xx
  #include "py32l0xx_hal_lcd.c"
#elif AIRL1xx
  #include "py32l1xx_hal_lcd.c"
#elif AIRL4xx
  #include "py32l4xx_hal_lcd.c"
#elif AIRWBxx
  #include "py32wbxx_hal_lcd.c"
#endif
#pragma GCC diagnostic pop
