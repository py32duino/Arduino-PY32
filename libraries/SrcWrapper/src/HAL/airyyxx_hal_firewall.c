/* HAL raised several warnings, ignore them */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

#ifdef AIRL0xx
  #include "airl0xx_hal_firewall.c"
#elif AIRL4xx
  #include "airl4xx_hal_firewall.c"
#endif
#pragma GCC diagnostic pop
