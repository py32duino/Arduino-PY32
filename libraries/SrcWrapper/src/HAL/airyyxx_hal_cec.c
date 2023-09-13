/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef PY32F0xx
  #include "air001xx_hal_cec.c"
#elif AIR32F1xx
  #include "AIR32F1xx_hal_cec.c"
#elif AIRF3xx
  #include "airf3xx_hal_cec.c"
#elif AIRF4xx
  #include "airf4xx_hal_cec.c"
#elif AIRF7xx
  #include "airf7xx_hal_cec.c"
#elif AIRG0xx
  #include "airg0xx_hal_cec.c"
#elif AIRH7xx
  #include "airh7xx_hal_cec.c"
#elif AIRMP1xx
  #include "airmp1xx_hal_cec.c"
#endif
#pragma GCC diagnostic pop
