#if defined(CORE_CALLBACK)
#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "core_callback.h"

// List of callback to call
static void (*callbackList[CALLBACK_LIST_SIZE])(void);

/**
  * @brief  Adds a callback pointer
  * @param  func: callback pointer
  * @retval None
  */
void registerCoreCallback(void (*func)(void))
{
  if (func == NULL) {
    return;
  }

  for (uint8_t i = 0; i < CALLBACK_LIST_SIZE; i++) {
    if (callbackList[i] == NULL) {
      callbackList[i] = func;
      break;
    }
  }
}

/**
  * @brief  Removes a callback pointer
  * @param  func: callback pointer
  * @retval None
  */
void unregisterCoreCallback(void (*func)(void))
{
  if (func == NULL) {
    return;
  }

  for (uint8_t i = 0; i < CALLBACK_LIST_SIZE; i++) {
    if (callbackList[i] == func) {
      callbackList[i] = NULL;
      break;
    }
  }
}

/**
  * @brief  Calls callback of the list. There is no priority. First added first
  *         called. This function must be called only in main() function loop.
  * @param  None
  * @retval None
  */
void CoreCallback(void)
{
  for (uint8_t i = 0; i < CALLBACK_LIST_SIZE; i++) {
    if (callbackList[i] != NULL) {
      callbackList[i]();
    }
  }
}

#ifdef __cplusplus
}
#endif
#endif // CORE_CALLBACK
