@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Petete TV - Compilar, crear EXE y publicar

cd /d "%~dp0"

for /F "delims=" %%E in ('echo prompt $E^| cmd') do set "ESC=%%E"
set "RESET=!ESC![0m"
set "CYAN=!ESC![96m"
set "GREEN=!ESC![92m"
set "YELLOW=!ESC![93m"
set "RED=!ESC![91m"
set "WHITE=!ESC![97m"

set "PROJECT=%~dp0src\PeteteTV\PeteteTV.csproj"
set "PUBLISH_DIR=%~dp0dist\windows\publish"
set "INSTALLER_DIR=%~dp0dist\windows\installer"
set "ISS=%~dp0installer\PETETE_TV_INSTALADOR.iss"
set "INFO_DIR=%~dp0.info"
set "LOG=%INFO_DIR%\COMPILAR_Y_PUBLICAR_ULTIMO.log"
set "RELEASE_REPO=NandyAstur/PeteteTV-Releases"

if not exist "%INFO_DIR%" mkdir "%INFO_DIR%" >nul 2>&1

echo !CYAN!==================================================!RESET!
echo !CYAN!  PETETE TV - WINDOWS RELEASE!RESET!
echo !CYAN!==================================================!RESET!
echo.

if not exist "%PROJECT%" (
    echo !YELLOW![PENDIENTE]!RESET! Todavia no existe:
    echo   %PROJECT%
    echo.
    echo El BAT queda preparado para el proyecto PC oficial.
    pause
    exit /b 2
)

where git.exe >nul 2>&1
if errorlevel 1 (
    echo !RED![ERROR]!RESET! No se encuentra Git.
    pause
    exit /b 1
)

where dotnet.exe >nul 2>&1
if errorlevel 1 (
    echo !RED![ERROR]!RESET! No se encuentra dotnet.exe.
    pause
    exit /b 1
)

for /f "delims=" %%S in ('git status --porcelain') do set "DIRTY=1"
if defined DIRTY (
    echo !RED![ERROR]!RESET! Hay cambios locales sin confirmar.
    echo No se generara una release desde un arbol sucio.
    git status --short
    pause
    exit /b 1
)

git fetch origin main >nul 2>&1
if errorlevel 1 (
    echo !RED![ERROR]!RESET! No se pudo consultar origin/main.
    pause
    exit /b 1
)

for /f "delims=" %%L in ('git rev-parse HEAD') do set "LOCAL_HEAD=%%L"
for /f "delims=" %%R in ('git rev-parse origin/main') do set "REMOTE_HEAD=%%R"
if /I not "!LOCAL_HEAD!"=="!REMOTE_HEAD!" (
    echo !RED![ERROR]!RESET! El main local no coincide con origin/main.
    echo Ejecuta PETETE_TV_ACTUALIZAR_GITHUB_A_LOCAL.bat antes de publicar.
    pause
    exit /b 1
)

if exist "%PUBLISH_DIR%" rmdir /s /q "%PUBLISH_DIR%"
if exist "%INSTALLER_DIR%" rmdir /s /q "%INSTALLER_DIR%"
mkdir "%PUBLISH_DIR%" >nul 2>&1
mkdir "%INSTALLER_DIR%" >nul 2>&1

(
  echo ==================================================
  echo PETETE TV - WINDOWS RELEASE
  echo Fecha: %date% %time%
  echo Commit: !LOCAL_HEAD!
  echo ==================================================
) > "%LOG%"

echo !YELLOW![1/4]!RESET! Restaurando...
dotnet restore "%PROJECT%" >> "%LOG%" 2>&1
if errorlevel 1 goto :fail

echo !YELLOW![2/4]!RESET! Publicando Windows x64 self-contained...
dotnet publish "%PROJECT%" -c Release -r win-x64 --self-contained true -o "%PUBLISH_DIR%" >> "%LOG%" 2>&1
if errorlevel 1 goto :fail

echo !GREEN![OK]!RESET! Compilacion Release creada.

if exist "%ISS%" (
    echo !YELLOW![3/4]!RESET! Creando instalador con Inno Setup...
    set "ISCC="
    if exist "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" set "ISCC=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
    if exist "%ProgramFiles%\Inno Setup 6\ISCC.exe" set "ISCC=%ProgramFiles%\Inno Setup 6\ISCC.exe"

    if not defined ISCC (
        echo !RED![ERROR]!RESET! Existe el .iss pero no se encontro Inno Setup 6.
        goto :fail
    )

    "!ISCC!" "%ISS%" >> "%LOG%" 2>&1
    if errorlevel 1 goto :fail
    echo !GREEN![OK]!RESET! Instalador creado.
) else (
    echo !YELLOW![3/4]!RESET! Instalador pendiente: aun no existe %ISS%
)

echo !YELLOW![4/4]!RESET! Publicacion online...
where gh.exe >nul 2>&1
if errorlevel 1 (
    echo !YELLOW![AVISO]!RESET! GitHub CLI no esta disponible.
    echo La compilacion local esta lista, pero no se publicara online.
    goto :done
)

gh repo view "%RELEASE_REPO%" >nul 2>&1
if errorlevel 1 (
    echo !YELLOW![AVISO]!RESET! El repositorio de descargas aun no existe o no es accesible:
    echo   %RELEASE_REPO%
    echo La compilacion local esta lista.
    goto :done
)

echo.
echo Para evitar publicar una version accidentalmente, la publicacion
echo definitiva se activara cuando definamos versionado e instalador.
echo Actualmente este BAT SOLO valida que el repositorio de releases exista.

:done
echo.
echo !GREEN![OK]!RESET! Proceso completado.
echo Binarios:
echo   %PUBLISH_DIR%
echo Registro:
echo   %LOG%
pause
exit /b 0

:fail
echo.
echo !RED![ERROR]!RESET! La compilacion/publicacion se ha detenido.
echo Registro:
echo   %LOG%
echo.
powershell.exe -NoProfile -Command "Get-Content -LiteralPath '%LOG%' -Tail 60" 2>nul
echo.
pause
exit /b 1
