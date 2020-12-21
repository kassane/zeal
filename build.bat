@echo off
setlocal enabledelayedexpansion

set BUILDCONF=Release
for %%x in (Release Debug RelWitdDebInfo) do (
    if "%1"=="%%x" set BUILDCONF=%1
)

set CLEAN_BUILD="false"
if "%1"=="clean" set CLEAN_BUILD="true"
if "%2"=="clean" set CLEAN_BUILD="true"

set BASEDIR=%~dp0
if %BASEDIR:~-1% geq "\" set BASEDIR=%BASEDIR:~0,-1%

set SRCDIR=%BASEDIR%

set BUILDDIR=%BASEDIR%\build.auto
@REM if exist "%BUILDDIR%" rd /s /q "%BUILDDIR%"
if not exist "%BUILDDIR%" mkdir "%BUILDDIR%"
if not exist "%BUILDDIR%" (echo could not create build directory %BUILDDIR% & goto error)

if not "%PROGRAMFILES(X86)%"=="" set PF86=%PROGRAMFILES(X86)%
if "%PF86%"=="" set PF86=%PROGRAMFILES%
if "%PF86%"=="" (echo PROGRAMFILES not set & goto error)

set QT5DIR=D:\Qt\Qt5.14.2\5.14.2\msvc2017_64
set QT_PLUGIN_PATH=%QT5DIR%\plugins
set QTWEBENGINEPROCESS_PATH=%QT5DIR%\bin\QtWebEngineProcess.exe
set PATH=%QT5DIR%\bin;%PATH%

call "%PF86%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

if exist "%PF86%\CMake\bin" set CMAKE_PATH=%PF86%\CMake\bin
if exist "%PROGRAMFILES%\CMake\bin" set CMAKE_PATH=%PROGRAMFILES%\CMake\bin
set PATH=CMAKE_PATH;%PATH%

set PATH=%PROGRAMFILES%\OpenSSL-Win64\bin;%PATH%

set CMAKEGEN=Visual Studio 16

PROMPT zeal_build$g
cd %BUILDDIR%

cmake -G "%CMAKEGEN%" ^
    -A x64 ^
    -D LibArchive_INCLUDE_DIR="%BASEDIR:\=/%/deps/libarchive/include" ^
    -D LibArchive_LIBRARY="%BASEDIR:\=/%/deps/libarchive/lib/archive.lib" ^
    -D SQLite_INCLUDE_DIR="%BASEDIR:\=/%/deps/sqlite" ^
    -D SQLite_LIBRARY="%BASEDIR:\=/%/deps/sqlite/sqlite3.lib" ^
    -D ZEAL_PORTABLE_BUILD=TRUE ^
    %SRCDIR:\=/%
if errorlevel 1 (echo cmake failed & goto error)

if not %CLEAN_BUILD%=="true" goto skipclean
echo CLEAN: %DATE% %TIME%
cmake --build %BUILDDIR% --target clean --config %BUILDCONF%
if errorlevel 1 (echo clean failed & goto error)

:skipclean
echo ALL_BUILD: %DATE% %TIME%
cmake --build %BUILDDIR% --config %BUILDCONF%
if errorlevel 1 cmake --build %BUILDDIR% --config %BUILDCONF%
if errorlevel 1 (echo build failed twice & goto error)

goto end

:error
echo BUILD ERROR %ERRORLEVEL%: %DATE% %TIME%
pause
exit /b 1

:end
echo FINISHED: %DATE% %TIME%

endlocal
