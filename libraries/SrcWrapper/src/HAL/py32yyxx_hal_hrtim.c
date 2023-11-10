/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF3xx
  #include "py32f3xx_hal_hrtim.c"
#elif AIRG4xx
  #include "py32g4xx_hal_hrtim.c"
#elif AIRH7xx
  #include "py32h7xx_hal_hrtim.c"
#endif
#pragma GCC diagnostic pop
