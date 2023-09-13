/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF4xx
  #include "airf4xx_hal_sdram.c"
#elif AIRF7xx
  #include "airf7xx_hal_sdram.c"
#elif AIRH7xx
  #include "airh7xx_hal_sdram.c"
#endif
#pragma GCC diagnostic pop
