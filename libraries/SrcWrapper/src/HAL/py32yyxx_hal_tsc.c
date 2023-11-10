/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef PY32F0xx
  #include "py32f0xx_hal_tsc.c"
#elif AIRF3xx
  #include "py32f3xx_hal_tsc.c"
#elif AIRL0xx
  #include "py32l0xx_hal_tsc.c"
#elif AIRL4xx
  #include "py32l4xx_hal_tsc.c"
#elif AIRL5xx
  #include "py32l5xx_hal_tsc.c"
#elif AIRU5xx
  #include "py32u5xx_hal_tsc.c"
#elif AIRWBxx
  #include "py32wbxx_hal_tsc.c"
#endif
#pragma GCC diagnostic pop
