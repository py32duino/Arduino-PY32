#include "py32_def.h"
#include "core_debug.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
  * @brief  This function is executed in case of error occurrence.
  * @param  None
  * @retval None
  */
#if !defined(NDEBUG)
WEAK void _Error_Handler(const char *msg, int val)
{
  /* User can add his own implementation to report the HAL error return state */
  core_debug("Error: %s (%i)\n", msg, val);
  while (1) {
  }
}
#endif

#ifdef __cplusplus
}
#endif
