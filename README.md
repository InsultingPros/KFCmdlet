# KF Commandlet

[![GitHub all releases](https://img.shields.io/github/downloads/InsultingPros/KFCmdlet/total)](https://github.com/InsultingPros/KFCmdlet/releases)

> **Note** Better try [**KFCompileTool**](https://github.com/InsultingPros/KFCompileTool) python script to avoid cmd.exe / powershell hell. And it has superior automation.

Allows **UCC.exe** to directly interact with **EditPackages** lines. No more killingfloor.ini editing and copy-pasting.

- Based on [Eliot](https://github.com/EliotVU)'s [MakeCommandletUtils](https://github.com/EliotVU/UnrealScript-MakeCommandletUtils).
- [Commandlet](https://wiki.beyondunreal.com/Legacy:Commandlet) info.
- [UCC compiler](https://wiki.beyondunreal.com/Legacy:Compiling_With_UCC) keys.

## Usage

Download `KFCmdlet.u` from release tab and drop to your `System` directory, near **UCC**.

### CLI

To add your packages:

```ini
ucc.exe KFCmdlet.Add Package_1,Package_2,etc
```

To restore vanilla **EditPackages**:

```ini
ucc.exe KFCmdlet.Clean
```

Or use help commands of **UCC**.

### Batch Files

- Download your desired [CMD](Files/CMD) / [PowerShell](Files/PowerShell) batch files with `CompileSettings.ini`.
- Fill your game / server / compile directories in `CompileSettings.ini` and enjoy.
