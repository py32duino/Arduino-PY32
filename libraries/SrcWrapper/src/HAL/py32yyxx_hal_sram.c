/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIR32F1xx
  #include "py32f1xx_hal_sram.c"
#elif AIRF2xx
  #include "py32f2xx_hal_sram.c"
#elif AIRF3xx
  #include "py32f3xx_hal_sram.c"
#elif AIRF4xx
  #include "py32f4xx_hal_sram.c"
#elif AIRF7xx
  #include "py32f7xx_hal_sram.c"
#elif AIRG4xx
  #include "py32g4xx_hal_sram.c"
#elif AIRH7xx
  #include "py32h7xx_hal_sram.c"
#elif AIRL1xx
  #include "py32l1xx_hal_sram.c"
#elif AIRL4xx
  #include "py32l4xx_hal_sram.c"
#elif AIRL5xx
  #include "py32l5xx_hal_sram.c"
#elif AIRMP1xx
  #include "py32mp1xx_hal_sram.c"
#elif AIRU5xx
  #include "py32u5xx_hal_sram.c"
#endif
#pragma GCC diagnostic pop
