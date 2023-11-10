/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef PY32F0xx
  #include "py32f0xx_hal_cec.c"
#elif AIR32F1xx
  #include "py32f1xx_hal_cec.c"
#elif AIRF3xx
  #include "py32f3xx_hal_cec.c"
#elif AIRF4xx
  #include "py32f4xx_hal_cec.c"
#elif AIRF7xx
  #include "py32f7xx_hal_cec.c"
#elif AIRG0xx
  #include "py32g0xx_hal_cec.c"
#elif AIRH7xx
  #include "py32h7xx_hal_cec.c"
#elif AIRMP1xx
  #include "py32mp1xx_hal_cec.c"
#endif
#pragma GCC diagnostic pop
