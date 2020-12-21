@echo off
setlocal enabledelayedexpansion

set BUILDCONF=Release
for %%x in (Release Debug RelWitdDebInfo) do (
    if "%1"=="%%x" set BUILDCONF=%1
)

set BASEDIR=%~dp0
if %BASEDIR:~-1% geq "\" set BASEDIR=%BASEDIR:~0,-1%

:: Set up environments
set QT5DIR=D:\Qt\Qt5.14.2\5.14.2\msvc2017_64
set BUILDDIR=%BASEDIR%\build.auto
set DISTDIR=%BASEDIR%\dist
set DEPSDIR=%BASEDIR%\deps

if not exist "%QT5DIR%" (echo Qt5 directory not found && goto error)

:: Clean distribution directory
if exist "%DISTDIR%" rd /s /q "%DISTDIR%"
mkdir "%DISTDIR%"
mkdir "%DISTDIR%\imageformats"
mkdir "%DISTDIR%\platforms"
mkdir "%DISTDIR%\resources"
mkdir "%DISTDIR%\styles"
mkdir "%DISTDIR%\translations"

xcopy "%BUILDDIR%\bin\%BUILDCONF%\zeal.exe" "%DISTDIR%"
xcopy "%DEPSDIR%\bin" /E "%DISTDIR%"
xcopy "%DEPSDIR%\libarchive\bin\archive.dll" "%DISTDIR%"
xcopy "%DEPSDIR%\sqlite\sqlite3.dll" "%DISTDIR%"


xcopy "%QT5DIR%\resources\icudtl.dat" "%DISTDIR%\resources"
xcopy "%QT5DIR%\resources\qtwebengine_devtools_resources.pak" "%DISTDIR%\resources"
xcopy "%QT5DIR%\resources\qtwebengine_resources.pak" "%DISTDIR%\resources"
xcopy "%QT5DIR%\resources\qtwebengine_resources_100p.pak" "%DISTDIR%\resources"
xcopy "%QT5DIR%\resources\qtwebengine_resources_200p.pak" "%DISTDIR%\resources"

xcopy "%QT5DIR%\translations\qtwebengine_locales" /E /I "%DISTDIR%\translations\qtwebengine_locales"

if %BUILDCONF%=="Debug" goto debug
if %BUILDCONF%=="RelWithDebInfo" goto debug

:release
xcopy "%QT5DIR%\bin\Qt5Concurrent.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Core.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Gui.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Network.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Positioning.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5PrintSupport.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Qml.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5QmlModels.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Quick.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5QuickWidgets.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5SerialPort.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Svg.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5WebChannel.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5WebEngineCore.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5WebEngineWidgets.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Widgets.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\QtWebEngineProcess.exe" "%DISTDIR%"

xcopy "%QT5DIR%\plugins\imageformats\qgif.dll" "%DISTDIR%\imageformats"
xcopy "%QT5DIR%\plugins\imageformats\qico.dll" "%DISTDIR%\imageformats"
xcopy "%QT5DIR%\plugins\imageformats\qjpeg.dll" "%DISTDIR%\imageformats"

xcopy "%QT5DIR%\plugins\platforms\qwindows.dll" "%DISTDIR%\platforms"

xcopy "%QT5DIR%\plugins\styles\qwindowsvistastyle.dll" "%DISTDIR%\styles"
goto end

:debug
xcopy "%QT5DIR%\bin\Qt5Concurrentd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Cored.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Guid.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Networkd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Positioningd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5PrintSupportd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Qmld.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5QmlModelsd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Quickd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5QuickWidgetsd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5SerialPortd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Svgd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5WebChanneld.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5WebEngineCored.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5WebEngineWidgetsd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\Qt5Widgetsd.dll" "%DISTDIR%"
xcopy "%QT5DIR%\bin\QtWebEngineProcessd.exe" "%DISTDIR%"

xcopy "%QT5DIR%\plugins\imageformats\qgifd.dll" "%DISTDIR%\imageformats"
xcopy "%QT5DIR%\plugins\imageformats\qicod.dll" "%DISTDIR%\imageformats"
xcopy "%QT5DIR%\plugins\imageformats\qjpegd.dll" "%DISTDIR%\imageformats"

xcopy "%QT5DIR%\plugins\platforms\qwindowsd.dll" "%DISTDIR%\platforms"

xcopy "%QT5DIR%\plugins\styles\qwindowsvistastyled.dll" "%DISTDIR%\styles"
if %BUILDCONF%=="RelWithDebInfo" goto release

goto end

:error
echo ERROR %ERRORLEVEL%: %DATE% %TIME%
pause
exit /b 1

:end
echo FINISHED: %DATE% %TIME%

endlocal
