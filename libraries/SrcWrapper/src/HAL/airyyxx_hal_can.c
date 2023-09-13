/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef PY32F0xx
  #include "Legacy/air001xx_hal_can.c"
  #include "air001xx_hal_can.c"
#elif AIR32F1xx
  #include "Legacy/AIR32F1xx_hal_can.c"
  #include "AIR32F1xx_hal_can.c"
#elif AIRF2xx
  #include "Legacy/airf2xx_hal_can.c"
  #include "airf2xx_hal_can.c"
#elif AIRF3xx
  #include "Legacy/airf3xx_hal_can.c"
  #include "airf3xx_hal_can.c"
#elif AIRF4xx
  #include "Legacy/airf4xx_hal_can.c"
  #include "airf4xx_hal_can.c"
#elif AIRF7xx
  #include "Legacy/airf7xx_hal_can.c"
  #include "airf7xx_hal_can.c"
#elif AIRL4xx
  #include "Legacy/airl4xx_hal_can.c"
  #include "airl4xx_hal_can.c"
#endif
#pragma GCC diagnostic pop
