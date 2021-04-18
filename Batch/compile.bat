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

ucc.exe KFCmdlet.Add %mut%
ucc.exe MakeCommandlet -EXPORTCACHE
ucc.exe KFCmdlet.Clean
ucc.exe DumpIntCommandlet %mut%.u

del steam_appid.txt
pause