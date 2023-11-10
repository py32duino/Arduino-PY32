/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL4xx
  #include "py32l4xx_hal_pka.c"
#elif AIRL5xx
  #include "py32l5xx_hal_pka.c"
#elif AIRU5xx
  #include "py32u5xx_hal_pka.c"
#elif AIRWBxx
  #include "py32wbxx_hal_pka.c"
#elif AIRWLxx
  #include "py32wlxx_hal_pka.c"
#endif
#pragma GCC diagnostic pop
