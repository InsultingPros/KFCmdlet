@setlocal enableextensions enabledelayedexpansion
@echo off
set settingsFile=CompileSettings.ini
::set area=[%~2]
::set key=%~3
set bError=0

set compiledMutator=YourShitMut
set serverDir=C:\KF Dedicated Server
set clientDir=C:\Program Files (x86)\Steam\steamapps\common\KillingFloor
set compileDir=C:\Program Files (x86)\Steam\steamapps\common\KillingFloor
set Packages=FALLBACK_PACKAGES
set saveToClient=true
set saveToServer=false
set needToCopyUcl=false

if not exist "%settingsFile%" (
  echo Script can't find ini-file with settings: "%settingsFile%"
  goto quitProgram
)

::=================================
::Parsing global settings
::=================================

set bReadGlobalSettings=0
for /f "usebackq delims=" %%a in ("!settingsFile!") do (
    set inputString=%%a
  if "!inputString:~0,1!"=="[" if !bReadGlobalSettings!==1 (
    goto GlobalSettingsParsed
    ) else if "!inputString:~0,8!"=="[Global]" (
    set bReadGlobalSettings=1
    )

  if !bReadGlobalSettings!==1 (

    for /f "tokens=1,2 delims==" %%b in ("!inputString!") do (

            set currentKey=%%b
            set currentValue=%%c

      if "!currentKey!" == "compiledMutator" (
        set compiledMutator=!currentValue!
      )
      if "!currentKey!" == "clientDir" (
        set clientDir=!currentValue!
      )
      if "!currentKey!" == "serverDir" (
        set serverDir=!currentValue!
      )
      if "!currentKey!" == "compileDir" (
        set compileDir=!currentValue!
      )
        )
    )
)
:GlobalSettingsParsed

::=================================
::Checking for errors
::=================================

if "%compiledMutator%"=="" (
  echo ERROR^^! Empty property: %settingsFile% -^> [Global] -^> compiledMutator
  set bError=1
)
if "%clientDir%"=="" (
  echo ERROR^^! Empty property: %settingsFile% -^> [Global] -^> clientDir
  set bError=1
)
if "%serverDir%"=="" (
  echo ERROR^^! Empty property: %settingsFile% -^> [Global] -^> serverDir
  set bError=1
)
if "%compileDir%"=="" (
  echo ERROR^^! Empty property: %settingsFile% -^> [Global] -^> compileDir
  set bError=1
)
if %bError%==1 goto quitProgram


::=================================
::Parsing mutator settings
::=================================

set bReadMutatorSettings=0

for /f "usebackq delims=" %%a in ("!settingsFile!") do (
    set inputString=%%a
  if "!inputString:~0,1!"=="[" if !bReadMutatorSettings!==1 (
    goto MutatorSettingsParsed
    ) else if "!inputString!"=="[%compiledMutator%]" (
    set bReadMutatorSettings=1
    )

  if !bReadMutatorSettings!==1 (
    for /f "tokens=1,2 delims==" %%b in ("!inputString!") do (

            set currentKey=%%b
            set currentValue=%%c

      if "!currentKey!" == "Packages" (
        set Packages=!currentValue!
      )
      if "!currentKey!" == "saveToClient" (
        set saveToClient=!currentValue!
      )
      if "!currentKey!" == "saveToServer" (
        set saveToServer=!currentValue!
      )
      if "!currentKey!" == "needToCopyUcl" (
        set needToCopyUcl=!currentValue!
      )
        )
    )
)
:MutatorSettingsParsed

::=================================
::Checking for errors
::=================================

if /I "%saveToClient%"=="True" if not exist "%clientDir%" (
  echo ERROR^^! Client directory doesnt exists: "%clientDir%"
  set bError=1
)
if /I "%saveToServer%"=="True" if not exist "%serverDir%" (
  echo ERROR^^! Server directory doesnt exists: "%serverDir%"
  set bError=1
)
if not exist "%compileDir%" (
  echo ERROR^^! Compile directory doesnt exists: "%compileDir%"
  set bError=1
)
if "%Packages%"=="" (
  echo ERROR^^! Packages section is not filled!
  set bError=1
)
if %bError%==1 goto quitProgram

echo ######################################################
echo.
echo COMPILING: %compiledMutator%
echo.
echo ######################################################

::Delete existing mutator files
if exist "%compileDir%\System\%compiledMutator%.u" ^
del "%compileDir%\System\%compiledMutator%.u"

::Compiling
rem old! "%compileDir%/System/UCC" make ini="%iniFile%"

rem a hacky hack, but well it works... without cd it was passing whole dir string to KFCmdlet
cd "%compileDir%/System/"

UCC.exe KFCmdlet.Add %Packages%
UCC.exe MakeCommandlet -EXPORTCACHE
UCC.exe KFCmdlet.Clean
UCC.exe DumpIntCommandlet %compiledMutator%.u

rem set it back
cd %compileDir%

:: delete this motherfucker!
del "%compileDir%\System\steam_appid.txt"

::Copy log and then parse it to know if compilation was successful
if not exist "%compileDir%\System\StdOut.log" (
  echo ERROR^^! Can't access: "%compileDir%\System\StdOut.log"
  goto quitProgram
)
copy "%compileDir%\System\StdOut.log" "." > NUL

for /f "usebackq delims=" %%a in (StdOut.log) do (
    set inputString=%%a
  if "!inputString:~0,29!"=="Mutator exported successfully" (
    echo ######################################################
    goto CompiledSuccessfully
    )
)

::in case compiling was unsuccessful
echo ######################################################
echo There were errors during compilation. No files will be copied.
goto quitProgram

:CompiledSuccessfully

::=================================
::Copying files to client and/or server derictories
::=================================

if /I "%saveToClient%"=="True" (
  echo COPYING TO CLIENT FOLDER
  echo.
  echo ^>%compiledMutator%.u
  copy "%compileDir%\System\%compiledMutator%.u" "%clientDir%\System\"
  echo.

  if /I "%needToCopyUcl%"=="True" (
    echo ^>%compiledMutator%.ucl
    copy "%compileDir%\System\%compiledMutator%.ucl" "%clientDir%\System\"
    echo.
  )
)

if /I "%saveToServer%"=="True" (
  echo ######################################################
  echo COPYING TO SERVER FOLDER
  echo.
  echo ^>%compiledMutator%.u
  copy "%compileDir%\System\%compiledMutator%.u" "%serverDir%\System\"
  echo.
  if /I "%needToCopyUcl%"=="True" (
    echo ^>%compiledMutator%.ucl
    copy "%compileDir%\System\%compiledMutator%.ucl" "%serverDir%\System\"
    echo.
  )

)

endlocal
:quitProgram
pause
exit /b