/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRG4xx
  #include "airg4xx_hal_fmac.c"
#elif AIRH7xx
  #include "airh7xx_hal_fmac.c"
#elif AIRU5xx
  #include "airu5xx_hal_fmac.c"
#endif
#pragma GCC diagnostic pop
