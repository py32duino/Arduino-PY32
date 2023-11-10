/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL4xx
  #include "airl4xx_ll_pka.c"
#elif AIRL5xx
  #include "airl5xx_ll_pka.c"
#elif AIRU5xx
  #include "airu5xx_ll_pka.c"
#elif AIRWBxx
  #include "airwbxx_ll_pka.c"
#elif AIRWLxx
  #include "airwlxx_ll_pka.c"
#endif
#pragma GCC diagnostic pop
