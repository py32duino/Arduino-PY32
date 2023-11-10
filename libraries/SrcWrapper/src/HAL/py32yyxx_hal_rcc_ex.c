/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRC0xx
  #include "py32c0xx_hal_rcc_ex.c"
#elif PY32F0xx
  #include "py32f0xx_hal_rcc_ex.c"
#elif AIR32F1xx
  #include "py32f1xx_hal_rcc_ex.c"
#elif AIRF2xx
  #include "py32f2xx_hal_rcc_ex.c"
#elif AIRF3xx
  #include "py32f3xx_hal_rcc_ex.c"
#elif AIRF4xx
  #include "py32f4xx_hal_rcc_ex.c"
#elif AIRF7xx
  #include "py32f7xx_hal_rcc_ex.c"
#elif AIRG0xx
  #include "py32g0xx_hal_rcc_ex.c"
#elif AIRG4xx
  #include "py32g4xx_hal_rcc_ex.c"
#elif AIRH7xx
  #include "py32h7xx_hal_rcc_ex.c"
#elif AIRL0xx
  #include "py32l0xx_hal_rcc_ex.c"
#elif AIRL1xx
  #include "py32l1xx_hal_rcc_ex.c"
#elif AIRL4xx
  #include "py32l4xx_hal_rcc_ex.c"
#elif AIRL5xx
  #include "py32l5xx_hal_rcc_ex.c"
#elif AIRMP1xx
  #include "py32mp1xx_hal_rcc_ex.c"
#elif AIRU5xx
  #include "py32u5xx_hal_rcc_ex.c"
#elif AIRWBxx
  #include "py32wbxx_hal_rcc_ex.c"
#elif AIRWLxx
  #include "py32wlxx_hal_rcc_ex.c"
#endif
#pragma GCC diagnostic pop
