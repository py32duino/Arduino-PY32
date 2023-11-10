/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF4xx
  #include "airf4xx_hal_dfsdm.c"
#elif AIRF7xx
  #include "airf7xx_hal_dfsdm.c"
#elif AIRH7xx
  #include "airh7xx_hal_dfsdm.c"
#elif AIRL4xx
  #include "airl4xx_hal_dfsdm.c"
#elif AIRL5xx
  #include "airl5xx_hal_dfsdm.c"
#elif AIRMP1xx
  #include "airmp1xx_hal_dfsdm.c"
#endif
#pragma GCC diagnostic pop
