/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRG4xx
  #include "py32g4xx_hal_fmac.c"
#elif AIRH7xx
  #include "py32h7xx_hal_fmac.c"
#elif AIRU5xx
  #include "py32u5xx_hal_fmac.c"
#endif
#pragma GCC diagnostic pop
