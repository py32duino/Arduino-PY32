/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef PY32F0xx
  #include "air001xx_hal_comp.c"
#elif AIRF3xx
  #include "airf3xx_hal_comp.c"
#elif AIRG0xx
  #include "airg0xx_hal_comp.c"
#elif AIRG4xx
  #include "airg4xx_hal_comp.c"
#elif AIRH7xx
  #include "airh7xx_hal_comp.c"
#elif AIRL0xx
  #include "airl0xx_hal_comp.c"
#elif AIRL1xx
  #include "airl1xx_hal_comp.c"
#elif AIRL4xx
  #include "airl4xx_hal_comp.c"
#elif AIRL5xx
  #include "airl5xx_hal_comp.c"
#elif AIRU5xx
  #include "airu5xx_hal_comp.c"
#elif AIRWBxx
  #include "airwbxx_hal_comp.c"
#elif AIRWLxx
  #include "airwlxx_hal_comp.c"
#endif
#pragma GCC diagnostic pop
