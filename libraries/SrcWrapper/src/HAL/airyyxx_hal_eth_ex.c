/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRH7xx
  #include "Legacy/airh7xx_hal_eth_ex.c"
  #include "airh7xx_hal_eth_ex.c"
#endif
#pragma GCC diagnostic pop
