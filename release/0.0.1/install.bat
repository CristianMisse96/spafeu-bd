@echo off

echo ======================================
echo Instalando Base de Datos SPAFEU
echo ======================================

chcp 65001 > nul

psql -U postgres -d spafeu_db --encoding=UTF8 -f 01_types.sql
if errorlevel 1 goto error

psql -U postgres -d spafeu_db --encoding=UTF8 -f 02_schema.sql
if errorlevel 1 goto error

psql -U postgres -d spafeu_db --encoding=UTF8 -f 03_import.sql
if errorlevel 1 goto error

echo.
echo Instalacion completada correctamente.
pause
exit /b 0

:error
echo.
echo Ocurrio un error durante la instalacion.
pause
exit /b 1