@echo off
set PATH=C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0;%PATH%
set FLUTTER_HOME=C:\flutter_windows_3.38.7-stable\flutter

cd /d C:\Users\Administrator\Desktop\proj\coflanet-app

echo ========================================
echo Building Flutter APK (debug)
echo ========================================

%FLUTTER_HOME%\bin\flutter.bat build apk --debug

echo ========================================
echo Build finished with exit code: %ERRORLEVEL%
echo ========================================

pause
