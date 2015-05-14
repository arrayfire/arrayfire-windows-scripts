@echo off
setlocal EnableDelayedExpansion

call common.bat

SET OLDDIR=%CD%

cd %AF_DIR%\%BUILD_DIR%

SET PATH=%PATH%;%PATH_EXT%;

set ARGC=1
for %%x in (%*) do SET /A ARGC+=1

if %ARGC% EQU 1 goto error
if "%1"=="" goto error

if "%AF_CUDA_DEFAULT_DEVICE%"=="" SET AF_CUDA_DEFAULT_DEVICE=-1
if "%AF_OPENCL_DEFAULT_DEVICE%"=="" SET AF_OPENCL_DEFAULT_DEVICE=-1

if %ARGC% EQU 2 goto default

if %ARGC% GEQ 4 (
    if "%2"=="CUDA" (
        SET AF_CUDA_DEFAULT_DEVICE=%3
    )
    if "%2"=="OPENCL" (
        SET AF_OPENCL_DEFAULT_DEVICE=%3
    )
)
if %ARGC% GEQ 6 (
echo 2
    REM IF BOTH ARE CUDA or BOTH ARE OPENCL
    if %2==%4 goto error
    if "%4"=="CUDA" (
        SET AF_CUDA_DEFAULT_DEVICE=%5
    )
    if "%4"=="OPENCL" (
        SET AF_OPENCL_DEFAULT_DEVICE=%5
    )
)

:default
if %AF_CUDA_DEFAULT_DEVICE% LSS 0 (
    SET AF_CUDA_DEFAULT_DEVICE=0
)
if %AF_OPENCL_DEFAULT_DEVICE% LSS 0 (
    SET AF_OPENCL_DEFAULT_DEVICE=0
)

.\test\%BUILD_TYPE%\%1

cd %OLDDIR%
goto end

:error
echo "Usage: .\run_single_test.bat <test_backend> CUDA=<id> OPENCL=<id>"
echo "CUDA and OpenCL Device ID is optional"

:end
