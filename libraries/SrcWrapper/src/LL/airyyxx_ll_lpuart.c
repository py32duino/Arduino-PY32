/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRG0xx
  #include "airg0xx_ll_lpuart.c"
#elif AIRG4xx
  #include "airg4xx_ll_lpuart.c"
#elif AIRH7xx
  #include "airh7xx_ll_lpuart.c"
#elif AIRL0xx
  #include "airl0xx_ll_lpuart.c"
#elif AIRL4xx
  #include "airl4xx_ll_lpuart.c"
#elif AIRL5xx
  #include "airl5xx_ll_lpuart.c"
#elif AIRU5xx
  #include "airu5xx_ll_lpuart.c"
#elif AIRWBxx
  #include "airwbxx_ll_lpuart.c"
#elif AIRWLxx
  #include "airwlxx_ll_lpuart.c"
#endif
#pragma GCC diagnostic pop
