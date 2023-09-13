/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "AIR32F1xx_hal_pccard.c"
#elif AIRF2xx
  #include "airf2xx_hal_pccard.c"
#elif AIRF3xx
  #include "airf3xx_hal_pccard.c"
#elif AIRF4xx
  #include "airf4xx_hal_pccard.c"
#endif
#pragma GCC diagnostic pop
