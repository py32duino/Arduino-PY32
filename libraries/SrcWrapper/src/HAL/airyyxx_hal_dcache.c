/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRU5xx
  #include "airu5xx_hal_dcache.c"
#endif
#pragma GCC diagnostic pop
