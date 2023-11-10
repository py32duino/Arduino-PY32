/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRU5xx
  #include "py32u5xx_hal_mdf.c"
#endif
#pragma GCC diagnostic pop
