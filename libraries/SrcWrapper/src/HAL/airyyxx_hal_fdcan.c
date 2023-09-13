/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRG0xx
  #include "airg0xx_hal_fdcan.c"
#elif AIRG4xx
  #include "airg4xx_hal_fdcan.c"
#elif AIRH7xx
  #include "airh7xx_hal_fdcan.c"
#elif AIRL5xx
  #include "airl5xx_hal_fdcan.c"
#elif AIRMP1xx
  #include "airmp1xx_hal_fdcan.c"
#elif AIRU5xx
  #include "airu5xx_hal_fdcan.c"
#endif
#pragma GCC diagnostic pop
