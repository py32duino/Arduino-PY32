/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL5xx
  #include "airl5xx_hal_icache.c"
#elif AIRU5xx
  #include "airu5xx_hal_icache.c"
#endif
#pragma GCC diagnostic pop
