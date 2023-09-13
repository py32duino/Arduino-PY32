/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF2xx
  #include "airf2xx_hal_dcmi_ex.c"
#elif AIRF4xx
  #include "airf4xx_hal_dcmi_ex.c"
#elif AIRF7xx
  #include "airf7xx_hal_dcmi_ex.c"
#endif
#pragma GCC diagnostic pop
