/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF4xx
  #include "airf4xx_ll_lptim.c"
#elif AIRF7xx
  #include "airf7xx_ll_lptim.c"
#elif AIRG0xx
  #include "airg0xx_ll_lptim.c"
#elif AIRG4xx
  #include "airg4xx_ll_lptim.c"
#elif AIRH7xx
  #include "airh7xx_ll_lptim.c"
#elif AIRL0xx
  #include "airl0xx_ll_lptim.c"
#elif AIRL4xx
  #include "airl4xx_ll_lptim.c"
#elif AIRL5xx
  #include "airl5xx_ll_lptim.c"
#elif AIRMP1xx
  #include "airmp1xx_ll_lptim.c"
#elif AIRU5xx
  #include "airu5xx_ll_lptim.c"
#elif AIRWBxx
  #include "airwbxx_ll_lptim.c"
#elif AIRWLxx
  #include "airwlxx_ll_lptim.c"
#endif
#pragma GCC diagnostic pop
