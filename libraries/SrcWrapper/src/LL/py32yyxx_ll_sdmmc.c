/* LL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "AIR32F1xx_ll_sdmmc.c"
#elif AIRF2xx
  #include "airf2xx_ll_sdmmc.c"
#elif AIRF4xx
  #include "airf4xx_ll_sdmmc.c"
#elif AIRF7xx
  #include "airf7xx_ll_sdmmc.c"
#elif AIRH7xx
  #include "airh7xx_ll_sdmmc.c"
#elif AIRL1xx
  #include "airl1xx_ll_sdmmc.c"
#elif AIRL4xx
  #include "airl4xx_ll_sdmmc.c"
#elif AIRL5xx
  #include "airl5xx_ll_sdmmc.c"
#elif AIRMP1xx
  #include "airmp1xx_ll_sdmmc.c"
#elif AIRU5xx
  #include "airu5xx_ll_sdmmc.c"
#endif
#pragma GCC diagnostic pop
