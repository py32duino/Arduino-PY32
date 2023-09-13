/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL0xx
  #include "airl0xx_hal_lcd.c"
#elif AIRL1xx
  #include "airl1xx_hal_lcd.c"
#elif AIRL4xx
  #include "airl4xx_hal_lcd.c"
#elif AIRWBxx
  #include "airwbxx_hal_lcd.c"
#endif
#pragma GCC diagnostic pop
