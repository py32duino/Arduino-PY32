/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRWLxx
  #include "airwlxx_hal_subghz.c"
#endif
#pragma GCC diagnostic pop
