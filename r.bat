@echo off
SETLOCAL

for /f "delims=" %%F in ('dir sketch* /b /d') DO ( set old_dir_name=%%F& goto :exit_for1 )

:exit_for1

if [%old_dir_name%]==[] goto :endtheprogram

echo Found [%old_dir_name%]

set /p new_dir_name=rename to: 

set jr=%Date:~9,4%
set mnd=%Date:~6,2%
set dg=%Date:~3,2%

CALL :RenameDir "%old_dir_name%" "p%jr%%mnd%%dg%_%new_dir_name: =_%"

goto :endtheprogram

:RenameDir

set dirname_from=%~1
set dirname_to=%~2

echo ren %dirname_from% %dirname_to%
ren %dirname_from% %dirname_to%

echo ren %dirname_to%\%dirname_from%.pde %dirname_to%.pde
ren %dirname_to%\%dirname_from%.pde %dirname_to%.pde

exit /b 0


:endtheprogram

echo thank you for using the rename program!