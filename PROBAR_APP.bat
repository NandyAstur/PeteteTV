@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Petete TV - Probar app

cd /d "%~dp0"

for /F "delims=" %%E in ('echo prompt $E^| cmd') do set "ESC=%%E"
set "RESET=!ESC![0m"
set "CYAN=!ESC![96m"
set "GREEN=!ESC![92m"
set "YELLOW=!ESC![93m"
set "RED=!ESC![91m"
set "WHITE=!ESC![97m"

set "PROJECT=%~dp0src\PeteteTV\PeteteTV.csproj"
set "INFO_DIR=%~dp0.info"
set "LOG=%INFO_DIR%\PROBAR_APP_ULTIMO.log"

if not exist "%INFO_DIR%" mkdir "%INFO_DIR%" >nul 2>&1

echo !CYAN!==================================================!RESET!
echo !CYAN!  PETETE TV - PRUEBA LOCAL!RESET!
echo !CYAN!==================================================!RESET!
echo.

if not exist "%PROJECT%" (
    echo !YELLOW![PENDIENTE]!RESET! Aun no existe el proyecto PC:
    echo   %PROJECT%
    echo.
    echo Este BAT ya queda preparado para la estructura oficial.
    echo En cuanto creemos el proyecto PC comenzara a funcionar sin cambios.
    pause
    exit /b 2
)

where dotnet.exe >nul 2>&1
if errorlevel 1 (
    echo !RED![ERROR]!RESET! No se encuentra dotnet.exe.
    echo Instala el SDK .NET requerido por Petete TV.
    pause
    exit /b 1
)

(
  echo ==================================================
  echo PETETE TV - PRUEBA LOCAL
  echo Fecha: %date% %time%
  echo Proyecto: %PROJECT%
  echo ==================================================
) > "%LOG%"

echo !YELLOW![1/3]!RESET! Restaurando dependencias...
dotnet restore "%PROJECT%" >> "%LOG%" 2>&1
if errorlevel 1 goto :fail

echo !YELLOW![2/3]!RESET! Compilando Debug...
dotnet build "%PROJECT%" -c Debug --no-restore >> "%LOG%" 2>&1
if errorlevel 1 goto :fail

echo !YELLOW![3/3]!RESET! Iniciando Petete TV...
dotnet run --project "%PROJECT%" -c Debug --no-build --no-restore >> "%LOG%" 2>&1
if errorlevel 1 goto :fail

echo.
echo !GREEN![OK]!RESET! Petete TV termino sin comunicar errores.
exit /b 0

:fail
echo.
echo !RED![ERROR]!RESET! La prueba ha fallado.
echo Registro:
echo   %LOG%
echo.
powershell.exe -NoProfile -Command "Get-Content -LiteralPath '%LOG%' -Tail 50" 2>nul
echo.
pause
exit /b 1
