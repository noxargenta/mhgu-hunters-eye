# MHGU Hunter’s Eye

Startup patch for Monster Hunter Generations Ultimate 1.4.0, intended to keep large monsters marked on the map and automatically display the map in Yuzu.

**Status: v0.1.0 — confirmed working in-game by the maintainer (2026-11-07).** Static checks validate patch structure, byte order, and intended offsets. The exact emulator version and detailed test matrix have not been recorded; other configurations remain untested. This is a conversion of existing community cheat instructions to an ExeFS patch, not newly reverse-engineered game logic. It does not add species-specific monster portraits.

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
3. Download and extract `MHGU-Hunters-Eye-v0.1.0.zip` from the [latest release](https://github.com/noxargenta/mhgu-hunters-eye/releases/latest), then copy its `MHGU-MapReveal-ExeFS` folder into that directory (from source, use `mod/MHGU-MapReveal-ExeFS`).
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

`offset_shift 0x100` accounts for the NSO header, following the IPSwitch layout used by the existing resolution patch. The maintainer reports that this startup patch works in-game; the reason for any difference from runtime cheat writes has not been independently established. Original instruction bytes have not been independently checked against a dumped game executable.

Run the static consistency check in PowerShell:

```powershell
./Verify-Patch.ps1
```

## 中文说明

本项目目标是在 Yuzu 中常驻标记大型怪物位置，并自动显示地图。采用原版标记，不提供怪物头像。

**当前发行版为 v0.1.0，维护者已于 2026-11-07 确认游戏内实测可用。** 具体模拟器版本及完整测试矩阵尚未记录，其他配置仍未验证。 本项目将社区已有金手指修改转换成启动时加载的 ExeFS 补丁，并非重新开发了整套怪物追踪系统。

安装：停止游戏 → 右键游戏打开 MOD 目录 → 从 [最新 Release](https://github.com/noxargenta/mhgu-hunters-eye/releases/latest) 下载并解压 ZIP，放入其中的 `MHGU-MapReveal-ExeFS` 文件夹（源码中位于 `mod` 下） → 属性中启用 → 暂时停用同功能金手指及 MapAssist → 重启进入狩猎任务。

测试时不使用染色球或千里眼药，检查怪物是否出现于地图，以及换区后标记是否更新。无效时请在 Issues 提供模拟器版本、游戏版本和相关加载日志。卸载只需移除本 MOD 文件夹并重启。

## Build a release

This is a text-based ExeFS patch; no binary compilation or game files are required. Run in PowerShell:

```powershell
./Build-Release.ps1
```

The script runs static validation and writes `dist/MHGU-Hunters-Eye-v0.1.0.zip` and `dist/SHA256SUMS.txt`. The ZIP includes the installable mod folder, README, changelog, and license. Compare the downloaded ZIP with `SHA256SUMS.txt` using `Get-FileHash -Algorithm SHA256`.

See [CHANGELOG.md](CHANGELOG.md) for release history. Static validation does not replace gameplay testing.

## Credits and license

Patch addresses and instruction words come from [RTHKKona/MHGU-Modding — Cheat Codes](https://github.com/RTHKKona/MHGU-Modding/wiki/Cheat-Codes), entries “Mark Boss” and “Auto Display Map”. That page lists their original authors as unknown. The upstream repository uses the MIT license; its copyright notice is retained in `LICENSE`.

Packaging, documentation, and loader-format adaptation: noxargenta. Distributed under MIT. Unaffiliated with Capcom, Nintendo, or Yuzu.