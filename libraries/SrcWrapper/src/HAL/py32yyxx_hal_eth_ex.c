/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRH7xx
  #include "Legacy/py32h7xx_hal_eth_ex.c"
  #include "py32h7xx_hal_eth_ex.c"
#endif
#pragma GCC diagnostic pop
