/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef PY32F0xx
  #include "air001xx_hal_tsc.c"
#elif AIRF3xx
  #include "airf3xx_hal_tsc.c"
#elif AIRL0xx
  #include "airl0xx_hal_tsc.c"
#elif AIRL4xx
  #include "airl4xx_hal_tsc.c"
#elif AIRL5xx
  #include "airl5xx_hal_tsc.c"
#elif AIRU5xx
  #include "airu5xx_hal_tsc.c"
#elif AIRWBxx
  #include "airwbxx_hal_tsc.c"
#endif
#pragma GCC diagnostic pop
