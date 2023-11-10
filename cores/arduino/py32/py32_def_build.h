#ifndef _AIR_DEF_BUILD_
#define _AIR_DEF_BUILD_

#if !defined(CMSIS_STARTUP_FILE) && !defined(CUSTOM_STARTUP_FILE)
#if defined(PY32F030x3) || defined(PY32F030x4) || defined(PY32F030x6) || defined(PY32F030x7) || defined(PY32F030x8) || defined(PY32F030xx)
#include "startup_py32f030.s"
#elif defined(PY32F003x4) || defined(PY32F003x6) || defined(PY32F003x8)
#include "startup_py32f003.s"
#elif defined(PY32F002Ax5)
#include "startup_py32f002a.s"
#else
#error UNKNOWN CHIP
#endif
#else
#warning "No CMSIS startup file defined, custom one should be used"
#endif /* !CMSIS_STARTUP_FILE && !CUSTOM_STARTUP_FILE */
#endif /* _AIR_DEF_BUILD_ */
