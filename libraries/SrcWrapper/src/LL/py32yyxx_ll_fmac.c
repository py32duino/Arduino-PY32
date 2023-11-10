/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRG4xx
  #include "airg4xx_ll_fmac.c"
#elif AIRH7xx
  #include "airh7xx_ll_fmac.c"
#elif AIRU5xx
  #include "airu5xx_ll_fmac.c"
#endif
#pragma GCC diagnostic pop
