/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRH7xx
  #include "py32h7xx_hal_mmc_ex.c"
#elif AIRL4xx
  #include "py32l4xx_hal_mmc_ex.c"
#elif AIRL5xx
  #include "py32l5xx_hal_mmc_ex.c"
#elif AIRU5xx
  #include "py32u5xx_hal_mmc_ex.c"
#endif
#pragma GCC diagnostic pop
