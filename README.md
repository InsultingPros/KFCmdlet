# KFCmdlet

Testing!

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
ucc.exe EditPackagesCommandlet 1 %1%
ucc.exe MakeCommandlet -EXPORTCACHE
ucc.exe EditPackagesCommandlet 0 %1%
ucc.exe DumpIntCommandlet %1%.u
pause
```

## Credits

Based on: <https://wiki.beyondunreal.com/User:Eliot/EditPackagesCommandlet>
