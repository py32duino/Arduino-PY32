/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF7xx
  #include "airf7xx_hal_jpeg.c"
#elif AIRH7xx
  #include "airh7xx_hal_jpeg.c"
#endif
#pragma GCC diagnostic pop
