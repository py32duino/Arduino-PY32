/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRH7xx
  #include "airh7xx_ll_delayblock.c"
#elif AIRMP1xx
  #include "airmp1xx_ll_delayblock.c"
#endif
#pragma GCC diagnostic pop
