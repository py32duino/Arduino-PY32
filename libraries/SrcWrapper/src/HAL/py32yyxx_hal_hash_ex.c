/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF4xx
  #include "py32f4xx_hal_hash_ex.c"
#elif AIRF7xx
  #include "py32f7xx_hal_hash_ex.c"
#elif AIRH7xx
  #include "py32h7xx_hal_hash_ex.c"
#elif AIRL4xx
  #include "py32l4xx_hal_hash_ex.c"
#elif AIRL5xx
  #include "py32l5xx_hal_hash_ex.c"
#elif AIRMP1xx
  #include "py32mp1xx_hal_hash_ex.c"
#elif AIRU5xx
  #include "py32u5xx_hal_hash_ex.c"
#endif
#pragma GCC diagnostic pop
