@echo off
:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running with Administrator privileges.
) else (
    echo [ERROR] Please run this script as an Administrator!
    pause
    exit /b
)

echo Applying ms-gamebar and ms-gamingoverlay registry fixes...

:: Fix for ms-gamebar protocol
reg add "HKCR\ms-gamebar" /f /ve /d "URL:ms-gamebar"
reg add "HKCR\ms-gamebar" /f /v "URL Protocol" /d " "
reg add "HKCR\ms-gamebar" /f /v "NoOpenWith" /d " "
reg add "HKCR\ms-gamebar\shell\open\command" /f /ve /d "%SystemRoot%\System32\systray.exe"

:: Fix for ms-gamebarservices protocol
reg add "HKCR\ms-gamebarservices" /f /ve /d "URL:ms-gamebarservices"
reg add "HKCR\ms-gamebarservices" /f /v "URL Protocol" /d " "
reg add "HKCR\ms-gamebarservices" /f /v "NoOpenWith" /d " "
reg add "HKCR\ms-gamebarservices\shell\open\command" /f /ve /d "%SystemRoot%\System32\systray.exe"

:: Fix for ms-gamingoverlay protocol
reg add "HKCR\ms-gamingoverlay" /f /ve /d "URL:ms-gamingoverlay"
reg add "HKCR\ms-gamingoverlay" /f /v "URL Protocol" /d " "
reg add "HKCR\ms-gamingoverlay" /f /v "NoOpenWith" /d " "
reg add "HKCR\ms-gamingoverlay\shell\open\command" /f /ve /d "%SystemRoot%\System32\systray.exe"

:: Disable Game DVR features (Ankh's suggestion)
echo Disabling GameDVR and App Capture...
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /f /t REG_DWORD /v "AppCaptureEnabled" /d 0
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /f /t REG_DWORD /v "GameDVR_Enabled" /d 0

echo.
echo All fixes applied successfully! 
echo You may need to restart your computer for changes to take full effect.
pause
