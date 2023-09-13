/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRH7xx
  #include "airh7xx_hal_otfdec.c"
#elif AIRL5xx
  #include "airl5xx_hal_otfdec.c"
#elif AIRU5xx
  #include "airu5xx_hal_otfdec.c"
#endif
#pragma GCC diagnostic pop
