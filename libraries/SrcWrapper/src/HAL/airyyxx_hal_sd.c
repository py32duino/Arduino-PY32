/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "AIR32F1xx_hal_sd.c"
#elif AIRF2xx
  #include "airf2xx_hal_sd.c"
#elif AIRF4xx
  #include "airf4xx_hal_sd.c"
#elif AIRF7xx
  #include "airf7xx_hal_sd.c"
#elif AIRH7xx
  #include "airh7xx_hal_sd.c"
#elif AIRL1xx
  #include "airl1xx_hal_sd.c"
#elif AIRL4xx
  #include "airl4xx_hal_sd.c"
#elif AIRL5xx
  #include "airl5xx_hal_sd.c"
#elif AIRMP1xx
  #include "airmp1xx_hal_sd.c"
#elif AIRU5xx
  #include "airu5xx_hal_sd.c"
#endif
#pragma GCC diagnostic pop
