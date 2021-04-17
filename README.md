# KF Commandlet

Testing!

## Genaral info

* Based on [Eliot's snippet](https://wiki.beyondunreal.com/User:Eliot/EditPackagesCommandlet).
* [Commandlet](https://wiki.beyondunreal.com/Legacy:Commandlet)
* [UCC compiler](https://wiki.beyondunreal.com/Legacy:Compiling_With_UCC)

## Usage

```cpp
@echo off
title Compiling %1%
cd..
cd System
echo ----------------------------------------------------
echo Deleting compiled files of %1%
echo ----------------------------------------------------
del %1%.u
del %1%.ucl
del %1%.int
echo ----------------------------------------------------
echo Compiling!
echo ----------------------------------------------------
ucc.exe KFCmdlet.KFCmdlet 1 %1%
ucc.exe MakeCommandlet -EXPORTCACHE
ucc.exe KFCmdlet.KFCmdlet 0 %1%
ucc.exe DumpIntCommandlet %1%.u
pause
```
