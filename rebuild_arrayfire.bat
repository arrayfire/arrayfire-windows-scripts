@echo off
setlocal EnableDelayedExpansion

call common.bat

SET OLDDIR=%CD%
cd %AF_DIR%

echo "Cloning submodules"
"%GIT_EXE%" submodule init
"%GIT_EXE%" submodule update

echo "Cleaning build directory"
REM Clean build space
rmdir /Q /S build
mkdir build
cd build

echo "Generating CMAKE"
REM Generate cmake
%CMAKE% .. %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="%BUILD_TYPE%" -DBUILD_CPU:STRING=OFF -DBUILD_CUDA:STRING=OFF -DBUILD_OPENCL:STRING=OFF -DBUILD_TEST:STRING=%TESTS% -DBUILD_GTEST:STRING=%TESTS% -DBUILD_EXAMPLES:STRING=%EXAMPLES% -DFREEIMAGE_FOUND:STRING=ON -DUSE_FREEIMAGE_STATIC:BOOL=ON -DFREEIMAGE_INCLUDE_PATH:STRING="%DEPS_DIR%/freeimage-3.17.0_x64" -DFREEIMAGE_STATIC_LIBRARY:STRING="%DEPS_DIR%/freeimage-3.17.0_x64/FreeImageLib.lib" -DFREEIMAGE_DYNAMIC_LIBRARY:STRING="%DEPS_DIR%/freeimage-3.17.0_x64/FreeImage.lib" -DGLEW_INCLUDE_DIR:STRING="%DEPS_DIR%/glew/include" -DGLEWmx_LIBRARY="%DEPS_DIR%/glew/lib/glew32mx.lib" -DGLFW_INCLUDE_DIR:STRING="%DEPS_DIR%/glfw/include" -DGLFW_LIBRARY="%DEPS_DIR%/glfw/lib-vc2013/glfw3.lib"

%CMAKE% .. -DCMAKE_INSTALL_PREFIX:STRING=%AF_INSTALL_PATH%
if "%CPU%"=="ON" (
    echo "Running CPU CMake Configuration"
    %CMAKE% .. %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="%BUILD_TYPE%" -DBUILD_CPU:STRING=ON -DFFTW_ROOT:STRING="%DEPS_DIR%/mkl" -DFFTW_LIBRARIES:STRING="%DEPS_DIR%/mkl/lib/mkl_core_dll.lib;%DEPS_DIR%/mkl/lib/mkl_rt.lib" -DFFTW_LIB:STRING="" -DFFTWF_LIB:STRING="" -DUSE_CPU_MKL:BOOL=ON -DCBLAS_INCLUDE_DIR:STRING="%DEPS_DIR%/mkl/include" -DCBLAS_cblas_LIBRARY:STRING="%DEPS_DIR%/mkl/lib/mkl_core_dll.lib" -DLAPACK_INCLUDE_DIR:STRING="%DEPS_DIR%/mkl/include" -DLAPACK_LIBRARIES:STRING="%DEPS_DIR%/mkl/lib/mkl_core_dll.lib;%DEPS_DIR%/mkl/lib/mkl_rt.lib"
)
if "%CUDA%"=="ON" (
    echo "Running CUDA CMake Configuration"
    if %CUDA_COMPUTE%=="" (
        %CMAKE% .. %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="%BUILD_TYPE%" -DBUILD_CUDA:STRING=ON -DBOOST_INCLUDEDIR:STRING="%DEPS_DIR%/boost_1_56_0"
    ) else (
        %CMAKE% .. %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="%BUILD_TYPE%" -DBUILD_CUDA:STRING=ON -DCUDA_COMPUTE_CAPABILITY:STRING=%CUDA_COMPUTE% -DBOOST_INCLUDEDIR:STRING="%DEPS_DIR%/boost_1_56_0"
    )
)
if "%OPENCL%"=="ON" (
    echo "Running OpenCL CMake Configuration"
     %CMAKE% .. %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="%BUILD_TYPE%" -DBUILD_OPENCL:STRING=ON -DBOOST_INCLUDEDIR:STRING="%DEPS_DIR%/boost_1_56_0" -DUSE_OPENCL_MKL:BOOL=ON -DLAPACK_INCLUDE_DIR:STRING="%DEPS_DIR%/mkl/include" -DLAPACK_LIBRARIES:STRING="%DEPS_DIR%/mkl/lib/mkl_core_dll.lib;%DEPS_DIR%/mkl/lib/mkl_rt.lib"
)
@echo off

echo "Running MSBuild"
REM Build
%MSBUILD% /p:Configuration=%BUILD_TYPE% ArrayFire.sln
%MSBUILD% /p:Configuration=%BUILD_TYPE% INSTALL.vcxproj

cd %OLDDIR%
