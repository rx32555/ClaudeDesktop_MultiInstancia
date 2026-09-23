@echo off
setlocal
rem ---------------------------------------------------------------------
rem  Lanzador / Launcher: Setup-ClaudeMulti.ps1
rem  Detecta idioma del sistema o configuracion guardada (es / en).
rem ---------------------------------------------------------------------

set "SYS_LANG=en"
for /f "tokens=3" %%a in ('reg query "HKCU\Control Panel\International" /v LocaleName 2^>nul') do (
    echo %%a | findstr /i "^es" >nul && set "SYS_LANG=es"
)
if exist "%APPDATA%\ClaudeMulti\config.json" (
    findstr /i "\"language\": *\"es\"" "%APPDATA%\ClaudeMulti\config.json" >nul 2>&1 && set "SYS_LANG=es"
    findstr /i "\"language\": *\"en\"" "%APPDATA%\ClaudeMulti\config.json" >nul 2>&1 && set "SYS_LANG=en"
)
echo %* | findstr /i "\-Language *es" >nul && set "SYS_LANG=es"
echo %* | findstr /i "\-Language *en" >nul && set "SYS_LANG=en"

if "%SYS_LANG%"=="es" (
    title Claude Desktop - Multi Instancia
) else (
    title Claude Desktop - Multi-Instance
)

set "PS1=%~dp0Setup-ClaudeMulti.ps1"

if not exist "%PS1%" (
    echo.
    if "%SYS_LANG%"=="es" (
        echo  [X] No se encontro Setup-ClaudeMulti.ps1 junto a este archivo.
        echo      Deja los dos archivos en la misma carpeta y vuelve a intentar.
    ) else (
        echo  [X] Could not find Setup-ClaudeMulti.ps1 next to this file.
        echo      Please keep both files in the same folder and try again.
    )
    echo.
    pause
    exit /b 1
)

echo.
if "%SYS_LANG%"=="es" (
    echo  Configurando / comprobando actualizaciones de Claude...
) else (
    echo  Configuring / checking for Claude updates...
)
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS1%" %*
set "SETUP_EXIT=%ERRORLEVEL%"

if errorlevel 1 (
    echo.
    if "%SYS_LANG%"=="es" (
        echo  [X] Termino con errores. Revisa los mensajes de arriba.
    ) else (
        echo  [X] Finished with errors. Check the messages above.
    )
)

echo.
pause
endlocal & exit /b %SETUP_EXIT%
