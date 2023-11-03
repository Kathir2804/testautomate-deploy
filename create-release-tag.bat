@echo off

REM Prompt the user for the type of version increase
set /p release_type=Enter the version increase type (major, minor, or patch): 

REM Read the current version from pubspec.yaml
for /f "tokens=2" %%i in ('findstr /c:"version:" pubspec.yaml') do set current_version=%%i

REM Split the version into major, minor, patch, and build components
for /f "tokens=1-4 delims=.+" %%i in ("%current_version%") do (
  set major=%%i
  set minor=%%j
  set patch=%%k
  set build=%%l
)

REM Increment the version based on the user's input
if "%release_type%"=="major" (
  set /a major+=1
  set minor=0
  set patch=0
  set /a build+=1
) else if "%release_type%"=="minor" (
  set /a minor+=1
  set patch=0
  set /a build+=1
) else if "%release_type%"=="patch" (
  set /a patch+=1
  set /a build+=1
)

REM Create the new version with the build number
set new_version=%major%.%minor%.%patch%+%build%

REM Create the tag version 
set new_tag=%major%.%minor%.%patch%

REM Print the newly created tag to the terminal
echo version   %new_version%
echo tag   %new_tag%

set /p Update=Update tvesrion in pubspec.yaml? (y/n):
set /p push=Can i push the Updated code in git ? (y/n):

if "%Update%"=="y" (
  if "%push%"=="y" (
    git add .
    git commit -m "Update version to %new_version%"
    git push
    set done=true
  )
) else (
  echo "First Update the code"
  set done=false
)
echo %done%
set /p git_tag=Tag the commit with a version (y/n):
set /p push=Push the newly created tag to Git? (y/n):
if "%done%"=="true" (
  echo flutter pub version %new_version%
  if "%git_tag%"=="y" (
    echo git tag -a "v%new_tag%" -m "Version %new_tag%"
    git tag -a "v%new_tag%" -m "Version %new_tag%"
  )
  if "%push%"=="y" (
    echo git push origin "v%new_tag%"
    git push origin "v%new_tag%"
  )
)
