/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "AIR32F1xx_hal_eth.c"
#elif AIRF2xx
  #include "airf2xx_hal_eth.c"
#elif AIRF4xx
  #include "Legacy/airf4xx_hal_eth.c"
  #include "airf4xx_hal_eth.c"
#elif AIRF7xx
  #include "Legacy/airf7xx_hal_eth.c"
  #include "airf7xx_hal_eth.c"
#elif AIRH7xx
  #include "Legacy/airh7xx_hal_eth.c"
  #include "airh7xx_hal_eth.c"
#endif
#pragma GCC diagnostic pop
