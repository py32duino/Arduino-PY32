/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF3xx
  #include "airf3xx_ll_fmc.c"
#elif AIRF4xx
  #include "airf4xx_ll_fmc.c"
#elif AIRF7xx
  #include "airf7xx_ll_fmc.c"
#elif AIRG4xx
  #include "airg4xx_ll_fmc.c"
#elif AIRH7xx
  #include "airh7xx_ll_fmc.c"
#elif AIRL4xx
  #include "airl4xx_ll_fmc.c"
#elif AIRL5xx
  #include "airl5xx_ll_fmc.c"
#elif AIRMP1xx
  #include "airmp1xx_ll_fmc.c"
#elif AIRU5xx
  #include "airu5xx_ll_fmc.c"
#endif
#pragma GCC diagnostic pop
