@echo off
set BUILD_PATH=%1
set BUILD_SOURCE_PATH=%2
set BOARD_PLATFORM_PATH=%3

if not exist "%BUILD_PATH%\sketch" mkdir "%BUILD_PATH%\sketch"
if not exist "%BUILD_SOURCE_PATH%\build_opt.h" (
  echo -e "-fmacro-prefix-map=\"%BOARD_PLATFORM_PATH:\=\\%\"=." > "%BUILD_PATH%\sketch\build.opt"
) else (
  copy "%BUILD_SOURCE_PATH%\build_opt.h" "%BUILD_PATH%\sketch\build.opt"
  echo -e "-fmacro-prefix-map=\"%BOARD_PLATFORM_PATH:\=\\%\"=." >> "%BUILD_PATH%\sketch\build.opt"
)
echo #include ^<SrcWrapper.h^> > "%BUILD_PATH%\sketch\SrcWrapper.cpp"
