/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF4xx
  #include "airf4xx_hal_qspi.c"
#elif AIRF7xx
  #include "airf7xx_hal_qspi.c"
#elif AIRG4xx
  #include "airg4xx_hal_qspi.c"
#elif AIRH7xx
  #include "airh7xx_hal_qspi.c"
#elif AIRL4xx
  #include "airl4xx_hal_qspi.c"
#elif AIRMP1xx
  #include "airmp1xx_hal_qspi.c"
#elif AIRWBxx
  #include "airwbxx_hal_qspi.c"
#endif
#pragma GCC diagnostic pop
