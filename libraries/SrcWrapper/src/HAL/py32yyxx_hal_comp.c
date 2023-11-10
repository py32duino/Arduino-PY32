/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef PY32F0xx
  #include "py32f0xx_hal_comp.c"
#elif AIRF3xx
  #include "py32f3xx_hal_comp.c"
#elif AIRG0xx
  #include "py32g0xx_hal_comp.c"
#elif AIRG4xx
  #include "py32g4xx_hal_comp.c"
#elif AIRH7xx
  #include "py32h7xx_hal_comp.c"
#elif AIRL0xx
  #include "py32l0xx_hal_comp.c"
#elif AIRL1xx
  #include "py32l1xx_hal_comp.c"
#elif AIRL4xx
  #include "py32l4xx_hal_comp.c"
#elif AIRL5xx
  #include "py32l5xx_hal_comp.c"
#elif AIRU5xx
  #include "py32u5xx_hal_comp.c"
#elif AIRWBxx
  #include "py32wbxx_hal_comp.c"
#elif AIRWLxx
  #include "py32wlxx_hal_comp.c"
#endif
#pragma GCC diagnostic pop
