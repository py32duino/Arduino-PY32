/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF7xx
  #include "py32f7xx_hal_mdios.c"
#elif AIRH7xx
  #include "py32h7xx_hal_mdios.c"
#elif AIRMP1xx
  #include "py32mp1xx_hal_mdios.c"
#endif
#pragma GCC diagnostic pop
