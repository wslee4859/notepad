@echo off
echo . 당직 클러스터 점검 실행중...

pushd "%~dp0"
Powershell.exe -executionpolicy remotesigned -File DBFailOverClusterNodeOwnerChk.ps1

pause