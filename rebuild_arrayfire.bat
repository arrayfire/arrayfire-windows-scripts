@echo off
setlocal EnableDelayedExpansion

call common.bat

SET OLDDIR=%CD%
cd %AF_DIR%

echo "Cloning submodules"
"%GIT_EXE%" submodule init
"%GIT_EXE%" submodule update
"%GIT_EXE%" submodule foreach git pull origin master

echo "Cleaning build directory"
REM Clean build space
rmdir /Q /S build
mkdir build
cd build

echo "Generating CMAKE"
REM Generate cmake

%CMAKE% .. %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="Release" -DBUILD_CPU:STRING=OFF -DBUILD_CUDA:STRING=OFF -DBUILD_OPENCL:STRING=OFF -DBUILD_TEST:STRING=%TESTS% -DBUILD_GTEST:STRING=%TESTS% -DBUILD_EXAMPLES:STRING=%EXAMPLES% -DFREEIMAGE_FOUND:STRING=ON -DFREEIMAGE_INCLUDE_PATH:STRING="%DEPS_DIR%/freeimage-3.16.0_x64" -DFREEIMAGE_LIBRARY:STRING="%DEPS_DIR%/freeimage-3.16.0_x64/FreeImage.lib" -DGLEW_INCLUDE_DIR:STRING="%DEPS_DIR%/glew/include" -DGLEWmx_LIBRARY="%DEPS_DIR%/glew/lib/glew32mx.lib" -DGLFW_INCLUDE_DIR:STRING="%DEPS_DIR%/glfw/include" -DGLFW_LIBRARY="%DEPS_DIR%/glfw/lib-vc2013/glfw3.lib"

%CMAKE% .. -DCMAKE_INSTALL_PREFIX:STRING=%AF_INSTALL_PATH%

if "%CPU%"=="ON" (
    echo "Running CPU CMake Configuration"
    %CMAKE% .. -DBUILD_CPU:STRING=ON -DFFTW_ROOT:STRING="%DEPS_DIR%/fftw-3.3.4" -DFFTW_INCLUDE_DIR:STRING="%DEPS_DIR%/fftw-3.3.4" -DFFTW_LIB:STRING="%DEPS_DIR%/fftw-3.3.4/libfftw3-3.lib" -DFFTWF_LIB:STRING="%DEPS_DIR%/fftw-3.3.4/libfftw3f-3.lib" -DFFTWL_LIB:STRING="%DEPS_DIR%/fftw-3.3.4/libfftw3l-3.lib" -DCBLAS_cblas_INCLUDE:STRING="%DEPS_DIR%/OpenBLAS/package/include" -DCBLAS_cblas_LIBRARY:STRING="%DEPS_DIR%/OpenBLAS/package/lib/libopenblas.lib" -DCBLAS_cblas_atlas_INCLUDE:STRING="%DEPS_DIR%/OpenBLAS/package/include"
)
if "%CUDA%"=="ON" (
    echo "Running CUDA CMake Configuration"
    if %CUDA_COMPUTE%=="" (
        %CMAKE% .. -DBUILD_CUDA:STRING=ON -DBOOST_INCLUDEDIR:STRING="%DEPS_DIR%/boost_1_56_0"
    ) else (
        %CMAKE% .. -DBUILD_CUDA:STRING=ON -DCUDA_COMPUTE_CAPABILITY:STRING=%CUDA_COMPUTE% -DBOOST_INCLUDEDIR:STRING="%DEPS_DIR%/boost_1_56_0"
    )
)
if "%OPENCL%"=="ON" (
    echo "Running OpenCL CMake Configuration"
    %CMAKE% .. -DBUILD_OPENCL:STRING=ON -DBOOST_INCLUDEDIR:STRING="%DEPS_DIR%/boost_1_56_0"
)
@echo off

echo "Running MSBuild"
REM Build
%MSBUILD% /p:Configuration=Release ArrayFire.sln
%MSBUILD% /p:Configuration=Release INSTALL.vcxproj

cd %OLDDIR%
