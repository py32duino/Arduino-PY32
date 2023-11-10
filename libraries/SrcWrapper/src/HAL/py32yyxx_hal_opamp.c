/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF3xx
  #include "py32f3xx_hal_opamp.c"
#elif AIRG4xx
  #include "py32g4xx_hal_opamp.c"
#elif AIRH7xx
  #include "py32h7xx_hal_opamp.c"
#elif AIRL1xx
  #include "py32l1xx_hal_opamp.c"
#elif AIRL4xx
  #include "py32l4xx_hal_opamp.c"
#elif AIRL5xx
  #include "py32l5xx_hal_opamp.c"
#elif AIRU5xx
  #include "py32u5xx_hal_opamp.c"
#endif
#pragma GCC diagnostic pop
