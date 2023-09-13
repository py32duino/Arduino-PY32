/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "AIR32F1xx_hal_nor.c"
#elif AIRF2xx
  #include "airf2xx_hal_nor.c"
#elif AIRF3xx
  #include "airf3xx_hal_nor.c"
#elif AIRF4xx
  #include "airf4xx_hal_nor.c"
#elif AIRF7xx
  #include "airf7xx_hal_nor.c"
#elif AIRG4xx
  #include "airg4xx_hal_nor.c"
#elif AIRH7xx
  #include "airh7xx_hal_nor.c"
#elif AIRL1xx
  #include "airl1xx_hal_nor.c"
#elif AIRL4xx
  #include "airl4xx_hal_nor.c"
#elif AIRL5xx
  #include "airl5xx_hal_nor.c"
#elif AIRU5xx
  #include "airu5xx_hal_nor.c"
#endif
#pragma GCC diagnostic pop
