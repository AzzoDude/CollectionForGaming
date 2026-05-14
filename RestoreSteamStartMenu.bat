@echo off
setlocal enabledelayedexpansion

:: --- 1. SET PATHS ---
set "STEAM_START_MENU=C:\Users\Azzo\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam"
set "STEAM_ROOT=C:\Program Files (x86)\Steam"
set "COMMON_DIR=%STEAM_ROOT%\steamapps\common"

echo [1] Verifying Paths...
if not exist "%STEAM_START_MENU%" mkdir "%STEAM_START_MENU%"
if not exist "%COMMON_DIR%" goto :Error_NoSteam

echo [OK] Steam folders found.
echo.
echo [2] Restoring Shortcuts with Icons...
echo ----------------------------------------------------

:: --- 2. MAIN LOOP ---
for /f "delims=" %%G in ('dir /b /ad "%COMMON_DIR%"') do (
    set "SKIP=0"
    if "%%G"=="Steamworks Shared" set SKIP=1
    if "%%G"=="Steam Controller Configs" set SKIP=1
    
    if !SKIP!==0 (
        call :ProcessGame "%%G"
    )
)

echo.
echo Scan Complete. Check your Start Menu!
pause
exit /b

:: --- 3. SUBROUTINES ---

:ProcessGame
set "FOLDER_NAME=%~1"
set "FOUND_ID=Unknown"
set "GAME_PATH=%COMMON_DIR%\%FOLDER_NAME%"

:: Find the AppID from manifest
pushd "%STEAM_ROOT%\steamapps"
for %%M in (appmanifest_*.acf) do (
    findstr /i /c:"\"installdir\"" "%%M" | findstr /i /c:"%FOLDER_NAME%" >nul
    if !errorlevel! == 0 (
        set "FILE_NAME=%%~nM"
        set "FOUND_ID=!FILE_NAME:appmanifest_=!"
        goto :FoundID
    )
)
:FoundID
popd

if "%FOUND_ID%"=="Unknown" goto :eof

:: --- ICON LOGIC ---
:: We call a separate routine to find the EXE to avoid the "unexpected" error
set "ICON_PATH="
call :FindExe "!GAME_PATH!"

echo [+] Restoring: %FOLDER_NAME%

:: Create the .url file
(
    echo [InternetShortcut]
    echo URL=steam://rungameid/%FOUND_ID%
    if defined ICON_PATH (
        echo IconFile=!ICON_PATH!
        echo IconIndex=0
    )
) > "%STEAM_START_MENU%\%FOLDER_NAME%.url"
goto :eof

:FindExe
:: Search for the largest EXE in the directory tree
:: Using 'dir /s' to look in subfolders as well (common for some games)
for /f "delims=" %%E in ('dir /b /s /os "%~1\*.exe" 2^>nul') do (
    set "ICON_PATH=%%E"
)
goto :eof

:Error_NoSteam
echo [!] ERROR: Could not find Steam path.
pause
exit /b