@echo off
setlocal EnableDelayedExpansion

call common.bat

SET OLDDIR=%CD%

cd %AF_DIR%\build

SET PATH=%PATH%;%PATH_EXT%;

if "%2"=="" (
    SET DEVICE=0
) ELSE (
    SET DEVICE=%2
)

set AF_OPENCL_DEFAULT_DEVICE=%DEVICE%
set CTEST_OUTPUT_ON_FAILURE=ON

if "%1"=="" (
    %CTEST% -C Release
) ELSE (
    %CTEST% -C Release -R %1
)

cd %OLDDIR%
