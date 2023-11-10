/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef PY32F0xx
  #include "py32f0xx_ll_crs.c"
#elif AIRG0xx
  #include "airg0xx_ll_crs.c"
#elif AIRG4xx
  #include "airg4xx_ll_crs.c"
#elif AIRH7xx
  #include "airh7xx_ll_crs.c"
#elif AIRL0xx
  #include "airl0xx_ll_crs.c"
#elif AIRL4xx
  #include "airl4xx_ll_crs.c"
#elif AIRL5xx
  #include "airl5xx_ll_crs.c"
#elif AIRU5xx
  #include "airu5xx_ll_crs.c"
#elif AIRWBxx
  #include "airwbxx_ll_crs.c"
#endif
#pragma GCC diagnostic pop
