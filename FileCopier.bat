@echo off

echo.
echo    *****************************
echo    *                           *
echo    *      Github@LiF-Lee       *
echo    *                           *
echo    *****************************

:begin

:inputSrc
echo.
echo [INFO] Enter the path of the folder you want to copy files from
if not "%src%"=="" (
    echo [INFO] Leave blank to use the previous path: %src%
)
set /p "src=Path: "
if "%src%" == "" (
    echo [ERROR] Please enter a valid path.
    goto inputSrc
)
if not exist "%src%\" (
    echo [ERROR] Path not found. Please enter a valid path.
    goto inputSrc
)

:inputDest
echo.
echo [INFO] Enter the path of the folder where you want to paste files to
if not "%dest%"=="" (
    echo [INFO] Leave blank to use the previous path: %dest%
) else (
    echo [INFO] Leave blank to use the current path: %CD%
)
if "%dest%"=="" (
    set "dest=%CD%"
)
set /p "dest=Path: "
if not exist "%dest%\" (
    echo [ERROR] Path not found. Please enter a valid path.
    goto inputDest
)

echo.
echo [INFO] Enter the name for the new folder where files will be paste
echo [INFO] Leave blank if you do not want to create a new folder
set /p "newFolderName=New Folder Name: "

echo.
echo [INFO] Enter the file name pattern to copy (like *.pdf, sample*.pptx)
echo [INFO] Leave blank to copy all files
set "fileNamePattern="
set /p "fileNamePattern=File Name Pattern: "

echo.
echo [INFO] Starting the file copy process. Please wait...
echo.

set /a fileCount=0
set startTime=%time%

setlocal enabledelayedexpansion
if "%fileNamePattern%"=="" (
    for /r "%src%" %%f in (*) do (
        set "relPath=%%~dpf"
        set "relPath=!relPath:%src%=!"
        echo Copying file: !relPath!%%~nxf
        xcopy "%%f" "%dest%\%newFolderName%\" /Q /Y /I
        set /a fileCount+=1
    )
) else (
    for /r "%src%" %%f in (%fileNamePattern%) do (
        set "relPath=%%~dpf"
        set "relPath=!relPath:%src%=!"
        echo Copying file: !relPath!%%~nxf
        xcopy "%%f" "%dest%\%newFolderName%\" /Q /Y /I
        set /a fileCount+=1
    )
)
endlocal & set /a fileCount=%fileCount%

set endTime=%time%

set startHr=%startTime:~0,1%
set endHr=%endTime:~0,1%

if "%startHr%"=="0" (set /a startHour=%startTime:~1,1%) else (set /a startHour=%startTime:~0,2%)
if "%endHr%"=="0" (set /a endHour=%endTime:~1,1%) else (set /a endHour=%endTime:~0,2%)

set /a hours=%endHour%-%startHour%
set /a mins=1%endTime:~3,2%-1%startTime:~3,2%
set /a secs=1%endTime:~6,2%-1%startTime:~6,2%
if %secs% lss 0 set /a secs+=60 & set /a mins-=1
if %mins% lss 0 set /a mins+=60 & set /a hours-=1

echo.
echo [INFO] File copying is complete!
echo [INFO] Total files copied: %fileCount%
echo [INFO] Time taken: %hours% hours %mins% minutes %secs% seconds

echo.
echo [INFO] Do you want to copy more files? (Y/N)
set /p restart=
if /i "%restart%"=="Y" goto begin
if /i "%restart%"=="y" goto begin