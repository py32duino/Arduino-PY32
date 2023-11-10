/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF3xx
  #include "py32f3xx_hal_i2s_ex.c"
#elif AIRF4xx
  #include "py32f4xx_hal_i2s_ex.c"
#elif AIRH7xx
  #include "py32h7xx_hal_i2s_ex.c"
#endif
#pragma GCC diagnostic pop
