/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF4xx
  #include "py32f4xx_hal_dsi.c"
#elif AIRF7xx
  #include "py32f7xx_hal_dsi.c"
#elif AIRH7xx
  #include "py32h7xx_hal_dsi.c"
#elif AIRL4xx
  #include "py32l4xx_hal_dsi.c"
#elif AIRU5xx
  #include "py32u5xx_hal_dsi.c"
#endif
#pragma GCC diagnostic pop
