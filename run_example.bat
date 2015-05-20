@echo off
setlocal EnableDelayedExpansion

call common.bat

if "%1"=="" goto error
if "%2"=="" goto error

SET OLDDIR=%CD%

cd %AF_DIR%\%BUILD_DIR%
SET PATH=%PATH%;%PATH_EXT%;

if "%3"=="" (
    SET DEVICE=0
) ELSE (
    SET DEVICE=%3
)

examples\%1\%BUILD_TYPE%\%2.exe %DEVICE%

cd %OLDDIR%
goto end

:error
echo "Pass example filename"
echo "Usage: .\run_example.bat <example_dir> <executable> <device - optional>"
echo "Exmaple: .\run_example.bat helloworld helloworld_cuda"
goto end

:end
echo "Done"
