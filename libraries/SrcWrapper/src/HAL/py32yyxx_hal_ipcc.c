/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRMP1xx
  #include "py32mp1xx_hal_ipcc.c"
#elif AIRWBxx
  #include "py32wbxx_hal_ipcc.c"
#elif AIRWLxx
  #include "py32wlxx_hal_ipcc.c"
#endif
#pragma GCC diagnostic pop
