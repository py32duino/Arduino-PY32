#ifndef __PY32F0xx_HAL_CONF_H
#define __PY32F0xx_HAL_CONF_H

#include "variant.h"

/* PY32F0xx specific HAL configuration options. */
#if __has_include("hal_conf_custom.h")
#include "hal_conf_custom.h"
#else
#if __has_include("hal_conf_extra.h")
#include "hal_conf_extra.h"
#endif
#include "py32f0xx_hal_conf_default.h"
#endif

#endif /* __PY32F0xx_HAL_CONF_H */
