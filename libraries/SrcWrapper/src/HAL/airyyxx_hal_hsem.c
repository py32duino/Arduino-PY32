/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRH7xx
  #include "airh7xx_hal_hsem.c"
#elif AIRMP1xx
  #include "airmp1xx_hal_hsem.c"
#elif AIRWBxx
  #include "airwbxx_hal_hsem.c"
#elif AIRWLxx
  #include "airwlxx_hal_hsem.c"
#endif
#pragma GCC diagnostic pop
