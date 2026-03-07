@echo off
set PATH=C:\Windows\System32\WindowsPowerShell\v1.0;%PATH%
set FLUTTER_HOME=C:\flutter_windows_3.38.7-stable\flutter
cd /d C:\Users\Administrator\Desktop\proj\coflanet-app
%FLUTTER_HOME%\bin\flutter.bat %*
