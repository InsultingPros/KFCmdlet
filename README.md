# KF Commandlet

![GitHub all releases](https://img.shields.io/github/downloads/InsultingPros/KFCmdlet/total)

Testing!

## Genaral info

* Based on [Eliot's snippet](https://wiki.beyondunreal.com/User:Eliot/EditPackagesCommandlet).
* [Commandlet](https://wiki.beyondunreal.com/Legacy:Commandlet)
* [UCC compiler](https://wiki.beyondunreal.com/Legacy:Compiling_With_UCC)

## Usage

```cpp
@echo off
set mut=ChatIcon
title Compiling %mut%
cd..
cd System
echo ----------------------------------------------------
echo Deleting compiled files of %mut%
echo ----------------------------------------------------
del %mut%.u
del %mut%.ucl
del %mut%.int
echo ----------------------------------------------------
echo Compiling!
echo ----------------------------------------------------
ucc.exe KFCmdlet.KFCmdlet 1 %mut%
ucc.exe MakeCommandlet -EXPORTCACHE
ucc.exe KFCmdlet.KFCmdlet 0 %mut%
ucc.exe DumpIntCommandlet %mut%.u
pause
```
