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
echo [INFO] Enter the path of the folder you want to copy files from:
set /p src=
if not exist "%src%\" (
    echo [ERROR] Path not found. Please enter a valid path.
    goto inputSrc
)

:inputDest
echo.
echo [INFO] Enter the path of the folder where you want to paste files to:
set /p dest=
if not exist "%dest%\" (
    echo [ERROR] Path not found. Please enter a valid path.
    goto inputDest
)

echo.
echo [INFO] Enter the name for the new folder where files will be paste:
set /p newFolderName=

echo.
echo [INFO] Enter the file types to copy (like .txt, .pdf), separated by commas. Leave blank to copy all file types:
set /p fileExtensions=

echo.
echo [INFO] Starting the file copy process. Please wait...
echo.

set /a fileCount=0
set startTime=%time%

setlocal enabledelayedexpansion
if not defined fileExtensions (
    for /r "%src%" %%f in (*) do (
        set "relPath=%%~dpf"
        set "relPath=!relPath:%src%=!"
        echo Copying file: !relPath!%%~nxf
        xcopy "%%f" "%dest%\%newFolderName%\" /Q /Y /I
        set /a fileCount+=1
    )
) else (
    set "fileExtensions=%fileExtensions: =%"
    for %%a in (%fileExtensions%) do (
        for /r "%src%" %%f in (*%%a) do (
            set "relPath=%%~dpf"
            set "relPath=!relPath:%src%=!"
            echo Copying file: !relPath!%%~nxf
            xcopy "%%f" "%dest%\%newFolderName%\" /Q /Y /I
            set /a fileCount+=1
        )
    )
)
endlocal & set /a fileCount=%fileCount%

set endTime=%time%
set /a hours=1%endTime:~0,2%-1%startTime:~0,2%
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