/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL0xx
  #include "py32l0xx_hal_firewall.c"
#elif AIRL4xx
  #include "py32l4xx_hal_firewall.c"
#endif
#pragma GCC diagnostic pop
