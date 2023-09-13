/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF3xx
  #include "airf3xx_hal_hrtim.c"
#elif AIRG4xx
  #include "airg4xx_hal_hrtim.c"
#elif AIRH7xx
  #include "airh7xx_hal_hrtim.c"
#endif
#pragma GCC diagnostic pop
