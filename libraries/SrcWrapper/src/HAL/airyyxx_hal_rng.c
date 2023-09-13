/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF2xx
  #include "airf2xx_hal_rng.c"
#elif AIRF4xx
  #include "airf4xx_hal_rng.c"
#elif AIRF7xx
  #include "airf7xx_hal_rng.c"
#elif AIRG0xx
  #include "airg0xx_hal_rng.c"
#elif AIRG4xx
  #include "airg4xx_hal_rng.c"
#elif AIRH7xx
  #include "airh7xx_hal_rng.c"
#elif AIRL0xx
  #include "airl0xx_hal_rng.c"
#elif AIRL4xx
  #include "airl4xx_hal_rng.c"
#elif AIRL5xx
  #include "airl5xx_hal_rng.c"
#elif AIRMP1xx
  #include "airmp1xx_hal_rng.c"
#elif AIRU5xx
  #include "airu5xx_hal_rng.c"
#elif AIRWBxx
  #include "airwbxx_hal_rng.c"
#elif AIRWLxx
  #include "airwlxx_hal_rng.c"
#endif
#pragma GCC diagnostic pop
