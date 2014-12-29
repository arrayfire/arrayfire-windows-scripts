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

cd %WORKSPACE%\%1
%GIT_EXE% pull

echo "Cleaning build directory"
REM Clean build space
rmdir /Q /S build
mkdir build
cd build

echo "Generating CMAKE"
REM Generate cmake
%CMAKE% ../src %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="Release" -DBUILD_TEST:STRING=OFF -DCMAKE_INSTALL_PREFIX:STRING="package"

echo "Running MSBuild"
%MSBUILD% /p:Configuration=Release %1.sln
%MSBUILD% /p:Configuration=Release INSTALL.vcxproj

cd %OLDDIR%
goto end

:error
echo "Usage: .\build_clMath.bat <clBLAS/clFFT>"
goto end

:end
echo "Done"
