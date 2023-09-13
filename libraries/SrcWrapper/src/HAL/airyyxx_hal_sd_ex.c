/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRH7xx
  #include "airh7xx_hal_sd_ex.c"
#elif AIRL4xx
  #include "airl4xx_hal_sd_ex.c"
#elif AIRL5xx
  #include "airl5xx_hal_sd_ex.c"
#elif AIRMP1xx
  #include "airmp1xx_hal_sd_ex.c"
#elif AIRU5xx
  #include "airu5xx_hal_sd_ex.c"
#endif
#pragma GCC diagnostic pop
