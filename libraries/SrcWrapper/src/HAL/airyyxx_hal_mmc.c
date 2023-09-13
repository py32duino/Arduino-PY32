/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "AIR32F1xx_hal_mmc.c"
#elif AIRF2xx
  #include "airf2xx_hal_mmc.c"
#elif AIRF4xx
  #include "airf4xx_hal_mmc.c"
#elif AIRF7xx
  #include "airf7xx_hal_mmc.c"
#elif AIRH7xx
  #include "airh7xx_hal_mmc.c"
#elif AIRL4xx
  #include "airl4xx_hal_mmc.c"
#elif AIRL5xx
  #include "airl5xx_hal_mmc.c"
#elif AIRU5xx
  #include "airu5xx_hal_mmc.c"
#endif
#pragma GCC diagnostic pop
