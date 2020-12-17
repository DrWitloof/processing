@echo off
SETLOCAL

IF "%~1" == "" exit

 

CALL :RenameDir sketch123 p2020_dit_is_een_test
EXIT /B %ERRORLEVEL%


:RenameDir

set dirname_from=%~1
set dirname_to=%2

echo ren %dirname_from% %dirname_to%
ren %dirname_from% %dirname_to%

echo ren %dirname_to%\%dirname_from%.pde %dirname_to%.pde
ren %dirname_to%\%dirname_from%.pde %dirname_to%.pde

exit /b 0