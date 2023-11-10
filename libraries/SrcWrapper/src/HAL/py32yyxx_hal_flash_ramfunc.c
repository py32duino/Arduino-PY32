/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRF4xx
  #include "py32f4xx_hal_flash_ramfunc.c"
#elif AIRG4xx
  #include "py32g4xx_hal_flash_ramfunc.c"
#elif AIRL0xx
  #include "py32l0xx_hal_flash_ramfunc.c"
#elif AIRL1xx
  #include "py32l1xx_hal_flash_ramfunc.c"
#elif AIRL4xx
  #include "py32l4xx_hal_flash_ramfunc.c"
#elif AIRL5xx
  #include "py32l5xx_hal_flash_ramfunc.c"
#endif
#pragma GCC diagnostic pop
