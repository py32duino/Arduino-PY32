/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "py32f1xx_hal_pccard.c"
#elif AIRF2xx
  #include "py32f2xx_hal_pccard.c"
#elif AIRF3xx
  #include "py32f3xx_hal_pccard.c"
#elif AIRF4xx
  #include "py32f4xx_hal_pccard.c"
#endif
#pragma GCC diagnostic pop
