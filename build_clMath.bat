@echo off
setlocal EnableDelayedExpansion

call common.bat

if "%1"=="clBLAS" (
    SET LIBRARY=clBLAS
) else if "%1"=="clFFT" (
    SET LIBRARY=clFFT
) else (
    goto error
)

SET OLDDIR=%CD%

cd %CD%\%1
%GIT_EXE% pull

echo "Cleaning build directory"
REM Clean build space
rmdir /Q /S build
mkdir build
cd build

echo "Generating CMAKE"
REM Generate cmake
REM %CMAKE% ../src %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="Release" -DBUILD_TEST:STRING=OFF -DCMAKE_INSTALL_PREFIX:STRING="package"
%CMAKE% ../src %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="%BUILD_TYPE%" -DBUILD_TEST:STRING=OFF -DBUILD_EXAMPLES:STRING=ON -DCMAKE_INSTALL_PREFIX:STRING="%BUILD_TYPE%" -DBUILD_SHARED_LIBS:BOOL=ON

echo "Running MSBuild"
%CMAKE% ../src --build --target ALL_BUILD --config Release -- /v:m /clp:ErrorsOnly /m:%THREADS%
%CMAKE% ../src --build --target INSTALL --config Release -- /v:m /clp:ErrorsOnly /m:%THREADS%

cd %OLDDIR%
goto end

:error
echo "Usage: .\build_clMath.bat <clBLAS/clFFT>"
goto end

:end
echo "Done"
