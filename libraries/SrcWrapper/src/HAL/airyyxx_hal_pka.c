/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL4xx
  #include "airl4xx_hal_pka.c"
#elif AIRL5xx
  #include "airl5xx_hal_pka.c"
#elif AIRU5xx
  #include "airu5xx_hal_pka.c"
#elif AIRWBxx
  #include "airwbxx_hal_pka.c"
#elif AIRWLxx
  #include "airwlxx_hal_pka.c"
#endif
#pragma GCC diagnostic pop
