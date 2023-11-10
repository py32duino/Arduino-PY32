/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL5xx
  #include "airl5xx_ll_icache.c"
#elif AIRU5xx
  #include "airu5xx_ll_icache.c"
#endif
#pragma GCC diagnostic pop
