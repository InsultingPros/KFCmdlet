# KF Commandlet

![GitHub all releases](https://img.shields.io/github/downloads/InsultingPros/KFCmdlet/total)

Allows **UCC.exe** to interact with **EditPackages**. No more killingfloor.ini editing and copy-pasting.

## Genaral info

* Based on [Eliot's snippet](https://wiki.beyondunreal.com/User:Eliot/EditPackagesCommandlet).
* [Commandlet](https://wiki.beyondunreal.com/Legacy:Commandlet) info.
* [UCC compiler](https://wiki.beyondunreal.com/Legacy:Compiling_With_UCC) keys.

## Usage

* To add your packages:

```cpp
ucc.exe KFCmdlet.Add Package_1,Package_2,etc
```

* To restore vanilla **EditPackages**:

```cpp
ucc.exe KFCmdlet.Clean
```

* Or use help commands of **UCC**.

Bat [example](Batch/compile.bat).
