:: Obtaining Higher Elevation to Use Regedit
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

cls

@echo off
setlocal enabledelayedexpansion

:: Display a disclaimer
echo WARNING: This script can modify the Windows Registry. Use it at your own risk.
echo Before running this script, make sure to backup the Registry.
echo.
echo Menu will appear after 5 seconds...
ping -n 6 127.0.0.1 >nul

:MainMenu
cls

:: Check if the context menu option is currently enabled or disabled
reg query "HKEY_CLASSES_ROOT\Directory\Background\shell\CommandPrompt" >nul 2>&1
if %errorlevel% equ 0 (
    set option_status=enabled
) else (
    set option_status=disabled
)

:: Display the current status and ask the user what to do
echo The "Open Command Prompt here" option is currently %option_status%.
set /p "choice=Do you want to toggle it (enable/disable), or exit (E/D/X)? "

:: Process user's choice
if /i "%choice%"=="E" (
    :: Enable the context menu option
    reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\CommandPrompt" /ve /t REG_SZ /d "Open Command Prompt here" /f >nul 2>&1
    reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\CommandPrompt\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f >nul 2>&1
    echo The "Open Command Prompt here" option has been enabled.
    goto MainMenu
) else if /i "%choice%"=="D" (
    :: Disable the context menu option
    reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\CommandPrompt" /f >nul 2>&1
    echo The "Open Command Prompt here" option has been disabled.
    goto MainMenu
) else if /i "%choice%"=="X" (
    :: Exit the script
    exit /b
) else (
    echo Invalid choice. Please enter 'E' to enable, 'D' to disable, or 'X' to exit.
    goto MainMenu
)
