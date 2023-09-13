/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF4xx
  #include "airf4xx_hal_flash_ramfunc.c"
#elif AIRG4xx
  #include "airg4xx_hal_flash_ramfunc.c"
#elif AIRL0xx
  #include "airl0xx_hal_flash_ramfunc.c"
#elif AIRL1xx
  #include "airl1xx_hal_flash_ramfunc.c"
#elif AIRL4xx
  #include "airl4xx_hal_flash_ramfunc.c"
#elif AIRL5xx
  #include "airl5xx_hal_flash_ramfunc.c"
#endif
#pragma GCC diagnostic pop
