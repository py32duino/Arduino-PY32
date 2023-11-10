/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRG0xx
  #include "airg0xx_ll_ucpd.c"
#elif AIRG4xx
  #include "airg4xx_ll_ucpd.c"
#elif AIRL5xx
  #include "airl5xx_ll_ucpd.c"
#elif AIRU5xx
  #include "airu5xx_ll_ucpd.c"
#endif
#pragma GCC diagnostic pop
