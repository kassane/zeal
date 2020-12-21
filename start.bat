@echo off

set BUILDCONF=Release
for %%x in (Release Debug RelWitdDebInfo) do (
    if "%1"=="%%x" set BUILDCONF=%1
)

set BASEDIR=%~dp0
if %BASEDIR:~-1% geq "\" set BASEDIR=%BASEDIR:~0,-1%
set DEPSDIR=%BASEDIR%\deps

set QT5DIR=D:\Qt\Qt5.14.2\5.14.2\msvc2017_64
set QT_PLUGIN_PATH=%QT5DIR%\plugins
set QTWEBENGINEPROCESS_PATH=%QT5DIR%\bin\QtWebEngineProcess.exe
if %BUILDCONF%==Debug set QTWEBENGINEPROCESS_PATH=%QT5DIR%\bin\QtWebEngineProcessd.exe
set PATH=%QT5DIR%\bin;%DEPSDIR%\bin;%DEPSDIR%\libarchive\bin;%DEPSDIR%\sqlite;%PATH%

cd /d "%BASEDIR%\build.auto\bin\%BUILDCONF%"

start /B zeal.exe %*
