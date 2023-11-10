/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "py32f1xx_hal_hcd.c"
#elif AIRF2xx
  #include "py32f2xx_hal_hcd.c"
#elif AIRF4xx
  #include "py32f4xx_hal_hcd.c"
#elif AIRF7xx
  #include "py32f7xx_hal_hcd.c"
#elif AIRG0xx
  #include "py32g0xx_hal_hcd.c"
#elif AIRH7xx
  #include "py32h7xx_hal_hcd.c"
#elif AIRL4xx
  #include "py32l4xx_hal_hcd.c"
#elif AIRU5xx
  #include "py32u5xx_hal_hcd.c"
#endif
#pragma GCC diagnostic pop
