@echo off
setlocal EnableDelayedExpansion

call common.bat

if "%1"=="" goto error

SET OLDDIR=%CD%

cd %AF_DIR%\build
SET PATH=%PATH%;%PATH_EXT%;

if "%2"=="" (
    SET DEVICE=0
) ELSE (
    SET DEVICE=%2
)

examples\Release\%1.exe %DEVICE%

cd %OLDDIR%
goto end

:error
echo "Pass example filename"
echo "Usage: .\run_example.bat <executable> <device - optional>"
echo "Exmaple: .\run_example.bat helloworld_cuda"
goto end

:end
echo "Done"
