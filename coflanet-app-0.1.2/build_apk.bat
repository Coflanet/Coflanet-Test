@echo off
set PATH=C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0;%PATH%
set FLUTTER_HOME=C:\flutter_windows_3.38.7-stable\flutter

cd /d C:\Users\Administrator\Desktop\proj\coflanet-app

echo ========================================
echo 1. Cleaning old build files...
echo ========================================
%FLUTTER_HOME%\bin\flutter.bat clean

if exist "android_distribution\coflanet-app-v1.0.apk" (
    del /f "android_distribution\coflanet-app-v1.0.apk"
    echo Old APK deleted.
)

echo ========================================
echo 2. Getting dependencies...
echo ========================================
%FLUTTER_HOME%\bin\flutter.bat pub get

echo ========================================
echo 3. Building Flutter APK (debug)...
echo ========================================
%FLUTTER_HOME%\bin\flutter.bat build apk --debug

if %ERRORLEVEL% EQU 0 (
    echo ========================================
    echo 4. Copying APK to android_distribution...
    echo ========================================
    if not exist "android_distribution" mkdir "android_distribution"
    copy /y "build\app\outputs\flutter-apk\app-debug.apk" "android_distribution\coflanet-app-v1.0.apk"
    echo ========================================
    echo BUILD SUCCESS!
    echo APK: android_distribution\coflanet-app-v1.0.apk
    echo ========================================
) else (
    echo ========================================
    echo BUILD FAILED! exit code: %ERRORLEVEL%
    echo ========================================
)

pause
