/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF3xx
  #include "airf3xx_ll_opamp.c"
#elif AIRG4xx
  #include "airg4xx_ll_opamp.c"
#elif AIRH7xx
  #include "airh7xx_ll_opamp.c"
#elif AIRL1xx
  #include "airl1xx_ll_opamp.c"
#elif AIRL4xx
  #include "airl4xx_ll_opamp.c"
#elif AIRL5xx
  #include "airl5xx_ll_opamp.c"
#elif AIRU5xx
  #include "airu5xx_ll_opamp.c"
#endif
#pragma GCC diagnostic pop
