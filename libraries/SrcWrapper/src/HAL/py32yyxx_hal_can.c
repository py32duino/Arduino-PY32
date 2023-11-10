/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef PY32F0xx
  #include "Legacy/py32f0xx_hal_can.c"
  #include "py32f0xx_hal_can.c"
#elif AIR32F1xx
  #include "Legacy/py32f1xx_hal_can.c"
  #include "py32f1xx_hal_can.c"
#elif AIRF2xx
  #include "Legacy/py32f2xx_hal_can.c"
  #include "py32f2xx_hal_can.c"
#elif AIRF3xx
  #include "Legacy/py32f3xx_hal_can.c"
  #include "py32f3xx_hal_can.c"
#elif AIRF4xx
  #include "Legacy/py32f4xx_hal_can.c"
  #include "py32f4xx_hal_can.c"
#elif AIRF7xx
  #include "Legacy/py32f7xx_hal_can.c"
  #include "py32f7xx_hal_can.c"
#elif AIRL4xx
  #include "Legacy/py32l4xx_hal_can.c"
  #include "py32l4xx_hal_can.c"
#endif
#pragma GCC diagnostic pop
