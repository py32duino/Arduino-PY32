/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRMP1xx
  #include "airmp1xx_hal_ipcc.c"
#elif AIRWBxx
  #include "airwbxx_hal_ipcc.c"
#elif AIRWLxx
  #include "airwlxx_hal_ipcc.c"
#endif
#pragma GCC diagnostic pop
