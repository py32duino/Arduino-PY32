/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF2xx
  #include "airf2xx_hal_dcmi.c"
#elif AIRF4xx
  #include "airf4xx_hal_dcmi.c"
#elif AIRF7xx
  #include "airf7xx_hal_dcmi.c"
#elif AIRH7xx
  #include "airh7xx_hal_dcmi.c"
#elif AIRL4xx
  #include "airl4xx_hal_dcmi.c"
#elif AIRMP1xx
  #include "airmp1xx_hal_dcmi.c"
#elif AIRU5xx
  #include "airu5xx_hal_dcmi.c"
#endif
#pragma GCC diagnostic pop
