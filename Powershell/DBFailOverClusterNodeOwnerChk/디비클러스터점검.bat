@echo off
echo . ���� Ŭ������ ���� ������...

pushd "%~dp0"
Powershell.exe -executionpolicy remotesigned -File DBFailOverClusterNodeOwnerChk.ps1

pause