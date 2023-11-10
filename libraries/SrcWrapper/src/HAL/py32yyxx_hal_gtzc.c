/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL5xx
  #include "py32l5xx_hal_gtzc.c"
#elif AIRU5xx
  #include "py32u5xx_hal_gtzc.c"
#elif AIRWLxx
  #include "py32wlxx_hal_gtzc.c"
#endif
#pragma GCC diagnostic pop
