# Upstream Baseline

记录日期：2026-07-03。

## STM32duino reference

Arduino-PY32 以本地 STM32duino 仓库作为架构参考：

- 路径：`/Users/halfsweet/Documents/py32duino/Arduino_Core_STM32`
- HEAD：`5bfc2a7fbc12ab331f54b7b4ec14b775b1a80abc` (`Merge pull request #3000 from Aymane-ST/prod/I3C`)

当前参考/继承的层：

- `cores/arduino`：Arduino core 入口与通用 core 结构。
- `libraries`：随 core 发布的 Arduino 库布局；其中 `libraries/SrcWrapper` 承担 Arduino 层到底层 HAL/CMSIS 的封装。
- `system`：CMSIS、启动文件、系统配置和厂商驱动组织方式。
- `variants`：芯片/板级变体目录，包含引脚、时钟、链接脚本和变体声明。
- `platform.txt`：Arduino platform build recipe。
- `boards.txt`：board id、menu、pnum、容量和 variant 映射。

## PY32 driver sources

PY32 驱动资料来源为 OpenPuya / 普冉公开资料；当前仓库通过 py32duino 维护的 submodule 固定版本。

当前本地 submodule 基线：

| Path | Remote | Commit | Subject |
| --- | --- | --- | --- |
| `system/Arduino-PY32F0xx-Drivers` | `https://github.com/py32duino/Arduino-PY32F0xx-Drivers.git` | `02e4ea32bf4cf3e094d9e679ec284e94ddf4fae0` | `update: 更新HAL库` |
| `system/Arduino-PY32F0xx-Drivers/PY32F0xx_HAL_Driver` | `https://github.com/py32duino/PY32F0xx_HAL_Driver.git` | `787e816f1081e9bdccf98952d8dbe1a76fa9caa8` | `fix: 修复一些HAL库问题` |
