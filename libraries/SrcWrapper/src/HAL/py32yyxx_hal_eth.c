/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "py32f1xx_hal_eth.c"
#elif AIRF2xx
  #include "py32f2xx_hal_eth.c"
#elif AIRF4xx
  #include "Legacy/py32f4xx_hal_eth.c"
  #include "py32f4xx_hal_eth.c"
#elif AIRF7xx
  #include "Legacy/py32f7xx_hal_eth.c"
  #include "py32f7xx_hal_eth.c"
#elif AIRH7xx
  #include "Legacy/py32h7xx_hal_eth.c"
  #include "py32h7xx_hal_eth.c"
#endif
#pragma GCC diagnostic pop
