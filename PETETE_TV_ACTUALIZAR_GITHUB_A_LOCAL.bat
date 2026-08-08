@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Petete TV - Actualizar local

set "LOCAL_DIR=T:\AT WORK\SCRIPTS\PeteteTV"
set "REPO_URL=https://github.com/NandyAstur/PeteteTV.git"
set "BRANCH=main"

for /F "delims=" %%E in ('echo prompt $E^| cmd') do set "ESC=%%E"
set "RESET=!ESC![0m"
set "CYAN=!ESC![96m"
set "GREEN=!ESC![92m"
set "YELLOW=!ESC![93m"
set "RED=!ESC![91m"
set "WHITE=!ESC![97m"

echo !CYAN!==================================================!RESET!
echo !CYAN!  PETETE TV - ACTUALIZAR GITHUB A LOCAL!RESET!
echo !CYAN!==================================================!RESET!
echo.
echo Destino:
echo   !WHITE!%LOCAL_DIR%!RESET!
echo.

where git.exe >nul 2>&1
if errorlevel 1 (
    echo !RED![ERROR]!RESET! No se encuentra Git para Windows.
    echo Instala Git o revisa el PATH.
    pause
    exit /b 1
)

if not exist "%LOCAL_DIR%" (
    echo !YELLOW![1/2]!RESET! Creando copia local desde GitHub...
    git clone --branch "%BRANCH%" "%REPO_URL%" "%LOCAL_DIR%"
    if errorlevel 1 goto :fail
    goto :success
)

if exist "%LOCAL_DIR%\.git" goto :update_existing

for /f %%A in ('dir /a /b "%LOCAL_DIR%" 2^>nul ^| find /c /v ""') do set "ITEMS=%%A"
if not defined ITEMS set "ITEMS=0"

if "%ITEMS%"=="0" (
    echo !YELLOW![1/2]!RESET! La carpeta existe pero esta vacia. Clonando...
    git clone --branch "%BRANCH%" "%REPO_URL%" "%LOCAL_DIR%"
    if errorlevel 1 goto :fail
    goto :success
)

echo !RED![ERROR]!RESET! La carpeta existe, contiene archivos y no es un repositorio Git.
echo No se borrara ni sobrescribira nada:
echo   %LOCAL_DIR%
echo.
echo Mueve o renombra esa carpeta y vuelve a ejecutar este BAT.
pause
exit /b 1

:update_existing
cd /d "%LOCAL_DIR%" || goto :fail

for /f "delims=" %%B in ('git branch --show-current 2^>nul') do set "CURRENT_BRANCH=%%B"
if /I not "!CURRENT_BRANCH!"=="%BRANCH%" (
    echo !RED![ERROR]!RESET! La rama actual es "!CURRENT_BRANCH!".
    echo Cambia manualmente a "%BRANCH%" antes de actualizar.
    pause
    exit /b 1
)

for /f "delims=" %%S in ('git status --porcelain') do set "DIRTY=1"
if defined DIRTY (
    echo !RED![ERROR]!RESET! Hay cambios locales pendientes.
    echo No se actualizara para evitar perder trabajo.
    echo.
    git status --short
    pause
    exit /b 1
)

if not exist ".info" mkdir ".info" >nul 2>&1
set "LOG=%LOCAL_DIR%\.info\ACTUALIZAR_LOCAL_ULTIMO.log"

(
  echo ==================================================
  echo PETETE TV - ACTUALIZAR LOCAL
  echo Fecha: %date% %time%
  echo ==================================================
) > "%LOG%"

echo !YELLOW![1/2]!RESET! Consultando GitHub...
git fetch origin "%BRANCH%" >> "%LOG%" 2>&1
if errorlevel 1 goto :fail_log

echo !YELLOW![2/2]!RESET! Aplicando actualizacion segura...
git pull --ff-only origin "%BRANCH%" >> "%LOG%" 2>&1
if errorlevel 1 goto :fail_log

for /f "delims=" %%H in ('git rev-parse --short HEAD') do set "HEAD=%%H"

:success
echo.
echo !GREEN![OK]!RESET! Petete TV esta actualizado.
echo Carpeta:
echo   %LOCAL_DIR%
if defined HEAD echo Commit: !HEAD!
echo.
pause
exit /b 0

:fail_log
echo.
echo !RED![ERROR]!RESET! No se pudo actualizar.
echo Registro:
echo   %LOG%
start "" notepad.exe "%LOG%"
pause
exit /b 1

:fail
echo.
echo !RED![ERROR]!RESET! No se pudo preparar la copia local.
pause
exit /b 1
