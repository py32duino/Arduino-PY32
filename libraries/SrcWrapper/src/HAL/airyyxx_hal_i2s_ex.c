/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF3xx
  #include "airf3xx_hal_i2s_ex.c"
#elif AIRF4xx
  #include "airf4xx_hal_i2s_ex.c"
#elif AIRH7xx
  #include "airh7xx_hal_i2s_ex.c"
#endif
#pragma GCC diagnostic pop
