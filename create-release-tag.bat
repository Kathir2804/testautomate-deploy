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

REM Create a Git tag
echo tag -a "v%new_version%" -m "Version %new_version%"

REM Print the newly created tag to the terminal
echo v%new_version%
echo v%new_tag%

set /p Update=Update tag in pubspec.yaml? (y/n):
set /p push=Can i push the Updated code in git ? (y/n):
echo Update is %Update%

if "%Update%"=="y" (
  git add .
  git commit -m "Update version to %new_version%"
  git push
)
@REM  else if "%Update%"=="Y" (
@REM   git add .
@REM   git commit -m "Update version to %new_version%"
@REM   git push
@REM )

@REM set /p git_tag=Tag the commit with a version (y/n)||(Y/N):
@REM if /i "%git_tag%"=="y" (
@REM   git tag -a "v%new_version%" -m "Version %new_version%"
@REM )

@REM set /p push=Push the newly created tag to Git? (y/n)||(Y/N):
@REM if /i "%push%"=="y" (
@REM   git push origin "v%new_version%"
@REM )