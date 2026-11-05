# MHGU Hunter’s Eye · 猎人之眼

Experimental startup patch for Monster Hunter Generations Ultimate 1.4.0, intended to keep large monsters marked on the map and automatically display the map in Yuzu.

**Status: v0.1.0-alpha — NOT verified in-game.** Patch structure, byte order, and intended offsets have been checked. Successful loading and gameplay behavior remain unverified. This is a conversion of existing community cheat instructions to an ExeFS patch, not newly reverse-engineered game logic. It does not add species-specific monster portraits.

## Compatibility

- Game: Monster Hunter Generations Ultimate 1.4.0
- Title ID: `0100770008DD8000`
- Main Build ID: `FB08F1D20FD1204FE7070672777F869B`
- Intended loader: Yuzu IPSwitch (`.pchtxt`) ExeFS patch loader
- No Forge or KatLib dependency
- Other versions and emulators are untested.

## Installation

1. Stop the game.
2. In Yuzu, right-click the game and open its mod data location.
3. Copy `mod/MHGU-MapReveal-ExeFS` into that directory.
4. Enable `MHGU-MapReveal-ExeFS` in game Properties.
5. Disable the old Mark Boss / Mark position / Auto Display Map cheats and MapAssist for an isolated test.
6. Restart the game and enter a normal large-monster hunting quest.

Expected layout:

```text
0100770008DD8000/
└── MHGU-MapReveal-ExeFS/
    └── exefs/
        └── MapReveal-1.4.0.pchtxt
```

To uninstall, remove that mod folder and restart. The package contains no game binaries or assets and does not edit save files.

## Testing and reporting

Without paintballs or Psychoserum, check whether large monsters appear on the map and whether their markers follow area changes. If needed, toggle map views once. Record your emulator version, game version, other enabled mods, and observed behavior.

Yuzu logs should mention `MapReveal-1.4.0.pchtxt` and writes at file offsets `0x0061CD94` and `0x0061BBD0`. Log confirmation alone does not prove in-game success. Redact personal paths before posting logs.

## Implementation

| Main-relative address | ARM instruction word | Little-endian bytes | Purpose from upstream |
|---|---|---|---|
| `0x0061CC94` | `E3A00001` (`MOV R0, #1`) | `01 00 A0 E3` | Mark Boss |
| `0x0061BAD0` | `E1A00000` (`MOV R0, R0`) | `00 00 A0 E1` | Automatically Display Map |

`offset_shift 0x100` accounts for the NSO header, following the IPSwitch layout used by the existing resolution patch. Applying changes before execution may avoid limitations of runtime cheat writes; this hypothesis is not yet confirmed. Original instruction bytes have not been independently checked against a dumped game executable.

Run the static consistency check in PowerShell:

```powershell
./Verify-Patch.ps1
```

## 中文说明

本项目名为「猎人之眼」，目标是在 Yuzu 中常驻标记大型怪物位置，并自动显示地图。采用原版标记，不提供怪物头像。

**目前是实验版，尚未完成游戏内验证，不能保证生效。** 本项目将社区已有金手指修改转换成启动时加载的 ExeFS 补丁，并非重新开发了整套怪物追踪系统。

安装：停止游戏 → 右键游戏打开 MOD 目录 → 放入 `mod` 下的 `MHGU-MapReveal-ExeFS` 文件夹 → 属性中启用 → 暂时停用同功能金手指及 MapAssist → 重启进入狩猎任务。

测试时不使用染色球或千里眼药，检查怪物是否出现于地图，以及换区后标记是否更新。无效时请在 Issues 提供模拟器版本、游戏版本和相关加载日志。卸载只需移除本 MOD 文件夹并重启。

## Credits and license

Patch addresses and instruction words come from [RTHKKona/MHGU-Modding — Cheat Codes](https://github.com/RTHKKona/MHGU-Modding/wiki/Cheat-Codes), entries “Mark Boss” and “Auto Display Map”. That page lists their original authors as unknown. The upstream repository uses the MIT license; its copyright notice is retained in `LICENSE`.

Packaging, documentation, and loader-format adaptation: noxargenta. Distributed under MIT. Unaffiliated with Capcom, Nintendo, or Yuzu.