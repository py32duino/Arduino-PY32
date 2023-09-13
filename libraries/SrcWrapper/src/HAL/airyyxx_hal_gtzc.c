/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL5xx
  #include "airl5xx_hal_gtzc.c"
#elif AIRU5xx
  #include "airu5xx_hal_gtzc.c"
#elif AIRWLxx
  #include "airwlxx_hal_gtzc.c"
#endif
#pragma GCC diagnostic pop
