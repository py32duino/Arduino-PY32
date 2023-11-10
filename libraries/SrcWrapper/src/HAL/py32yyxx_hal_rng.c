/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF2xx
  #include "py32f2xx_hal_rng.c"
#elif AIRF4xx
  #include "py32f4xx_hal_rng.c"
#elif AIRF7xx
  #include "py32f7xx_hal_rng.c"
#elif AIRG0xx
  #include "py32g0xx_hal_rng.c"
#elif AIRG4xx
  #include "py32g4xx_hal_rng.c"
#elif AIRH7xx
  #include "py32h7xx_hal_rng.c"
#elif AIRL0xx
  #include "py32l0xx_hal_rng.c"
#elif AIRL4xx
  #include "py32l4xx_hal_rng.c"
#elif AIRL5xx
  #include "py32l5xx_hal_rng.c"
#elif AIRMP1xx
  #include "py32mp1xx_hal_rng.c"
#elif AIRU5xx
  #include "py32u5xx_hal_rng.c"
#elif AIRWBxx
  #include "py32wbxx_hal_rng.c"
#elif AIRWLxx
  #include "py32wlxx_hal_rng.c"
#endif
#pragma GCC diagnostic pop
