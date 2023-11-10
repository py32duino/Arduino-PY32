/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF4xx
  #include "airf4xx_ll_dma2d.c"
#elif AIRF7xx
  #include "airf7xx_ll_dma2d.c"
#elif AIRH7xx
  #include "airh7xx_ll_dma2d.c"
#elif AIRL4xx
  #include "airl4xx_ll_dma2d.c"
#elif AIRU5xx
  #include "airu5xx_ll_dma2d.c"
#endif
#pragma GCC diagnostic pop
