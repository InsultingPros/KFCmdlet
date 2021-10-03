#################################################################################
#                            VARIABLES (DO NOT TOUCH)
#################################################################################
[string] $settingsFile = "CompileSettings.ini"
[string] $LineSeparator = "######################################################"
[byte] $bError = 0
[string] $UPackage = ""

[string] $compiledMutator = ""
[string] $dir_Compile = ""
[string] $dir_Client = ""
[string] $dir_Server = ""

[string] $Packages = ""
[string] $saveToClient = ""
[string] $saveToServer = ""
[string] $createINT = ""


#################################################################################
#                                FUNCTIONS
#################################################################################

# stop right here
function stopMe
{
  Read-Host -Prompt "Press any key to continue..."
}


# run config checker at first and break if not found
function config_Check
{
  if (-not(Test-path $settingsFile -PathType leaf))
  {
    Write-Output "Script can't find ini-file with settings: $settingsFile"
    stopMe
  }
}


# get config reference
function config_Get($fileName, $oneSection)
{
  $config = Get-Content ($fileName)    
  $cfg = @{}
  $sec = $cfg
  $section = ''

  foreach ($line in $config)
  {
    $line = $line.Trim()
    if ($line.startswith('['))
    {
      $section = $line.replace('[','').replace(']','')
      if ($oneSection -eq '*')
      {
        $cfg.Add($section,@{})
        $sec = $cfg.$section
      }   
      continue
    }       
    if ($null -ne $oneSection -and $section -ne $oneSection -and $oneSection -ne '*')
      {continue}
    $k = $line.IndexOf('=')
    if ($line -eq '' -or $k -lt 1 -or $line[0] -in '[','#')
      {continue}
    $sec.Add($line.Substring(0,$k), $line.Substring($k+1))
  }
  return $cfg
}


# get and assign global variables
function set_Variables
{
  $cfg_global = config_Get -fileName $settingsFile -oneSection "Global"

  $script:compiledMutator = $cfg_global.compiledMutator
  $script:dir_Compile = $cfg_global.dir_Compile
  $script:dir_Client = $cfg_global.dir_Client
  $script:dir_Server = $cfg_global.dir_Server

  $script:UPackage = Join-Path -Path $dir_Compile -ChildPath "\System\$compiledMutator"

  $cfg_pkg = config_Get -fileName $settingsFile -oneSection $compiledMutator

  $script:Packages = $cfg_pkg.Packages
  $script:saveToClient = $cfg_pkg.saveToClient
  $script:saveToServer = $cfg_pkg.saveToServer
  $script:createINT = $cfg_pkg.createINT
}


# delete files before compilation start, since UCC is ghei
function DeleteOldFiles
{
  if (Test-Path $UPackage".u")
  {
    Write-Output "Deleting old $compiledMutator.u file!"
    Remove-Item $UPackage".u"
  }
  else
  {
    Write-Output "No redunant files found to delete!"
  }
}


# finally compile something!
function compilation
{
  Write-Output $LineSeparator
  Write-Output ""
  Write-Output "COMPILING: $compiledMutator"
  Write-Output ""
  Write-Output $LineSeparator

  # get the ucc.exe pointer
  [string] $UCC = Join-Path -Path $dir_Compile -ChildPath "\System\UCC.exe"
  [string] $garbage = Join-Path -Path $dir_Compile -ChildPath "\System\steam_appid.txt"

  # add all requires package names
  & $UCC "KFCmdlet.Add" $Packages
  # compile u file
  & $UCC "MakeCommandlet" "-EXPORTCACHE"
  # reset killingfloor.ini `EditPackages`
  & $UCC "KFCmdlet.Clean"
  # optionally create `int` file
  if ($createINT -eq $true)
  {
    Write-Output "Creating INT file!"
    & $UCC "DumpIntCommandlet" $compiledMutator".u"
  }

  # delete this motherfucker
  Remove-Item $garbage
}


# check if our compilation was successfull
function compilation_CheckResult
{
  $str = Select-String -Path $dir_Compile"\System\StdOut.log" -Pattern "Compile aborted"

  if ($null -ne $str)
  {
    Write-Output $LineSeparator
    Write-Output "ERRORS FOUND! TERMINATING."
    $script:bError = 1
  }
}


# Copying files to client and/or server derictories
function MoveFiles
{
  if ($bError -eq 1)
  {
    return
  }

  if ($saveToServer -eq $true)
  {
    Write-Output $LineSeparator
    Write-Output "COPYING FILES TO SERVER FOLDER"
    Write-Output ""
    Copy-Item -path "$UPackage.*" -Destination "$dir_Server\System\"
  }

  if ($saveToClient -eq $true)
  {
    # in case our compile dir is the same as client dir, do nothing
    if ($dir_Compile -eq $dir_Client)
    {
      Write-Output $LineSeparator
      Write-Output "COMPILE and CLIENT DIRECTORIES ARE THE SAME! NOT MOVING THE FILES."
      Write-Output ""
      return
    }

    Write-Output $LineSeparator
    Write-Output "COPYING FILES TO CLIENT FOLDER"
    Write-Output ""
    Copy-Item -path "$UPackage.*" -Destination "$dir_Client\System\"
  }
}


#################################################################################
#                              FUNCTION CALLS
#################################################################################

config_Check
set_Variables
DeleteOldFiles
compilation
compilation_CheckResult
MoveFiles
stopMe
