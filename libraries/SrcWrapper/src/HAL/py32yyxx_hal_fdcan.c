/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRG0xx
  #include "py32g0xx_hal_fdcan.c"
#elif AIRG4xx
  #include "py32g4xx_hal_fdcan.c"
#elif AIRH7xx
  #include "py32h7xx_hal_fdcan.c"
#elif AIRL5xx
  #include "py32l5xx_hal_fdcan.c"
#elif AIRMP1xx
  #include "py32mp1xx_hal_fdcan.c"
#elif AIRU5xx
  #include "py32u5xx_hal_fdcan.c"
#endif
#pragma GCC diagnostic pop
