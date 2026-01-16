@echo off
setlocal
pushd %~dp0
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\daily-log.ps1"
popd
endlocal
