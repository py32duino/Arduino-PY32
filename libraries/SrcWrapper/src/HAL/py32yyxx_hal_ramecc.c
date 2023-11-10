/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRH7xx
  #include "py32h7xx_hal_ramecc.c"
#endif
#pragma GCC diagnostic pop
