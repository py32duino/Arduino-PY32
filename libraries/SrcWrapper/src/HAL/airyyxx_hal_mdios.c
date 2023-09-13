/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF7xx
  #include "airf7xx_hal_mdios.c"
#elif AIRH7xx
  #include "airh7xx_hal_mdios.c"
#elif AIRMP1xx
  #include "airmp1xx_hal_mdios.c"
#endif
#pragma GCC diagnostic pop
