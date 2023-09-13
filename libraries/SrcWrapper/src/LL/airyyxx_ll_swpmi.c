/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRH7xx
  #include "airh7xx_ll_swpmi.c"
#elif AIRL4xx
  #include "airl4xx_ll_swpmi.c"
#endif
#pragma GCC diagnostic pop
