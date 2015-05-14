@echo off
setlocal EnableDelayedExpansion

call common.bat

SET OLDDIR=%CD%
cd %AF_DIR%

if "%1"=="" (
	REM DO NOTHING
) else (
	REM CLEAN BUILD
	echo "Cloning submodules"
	"%GIT_EXE%" submodule init
	"%GIT_EXE%" submodule update

	echo "Cleaning build directory"
	REM Clean build space
	rmdir /Q /S build
	mkdir build
)

cd build

echo "Generating CMAKE"
REM Generate cmake
%CMAKE% .. %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="%BUILD_TYPE%" -DBUILD_CPU:STRING=OFF -DBUILD_CUDA:STRING=OFF -DBUILD_OPENCL:STRING=OFF -DBUILD_TEST:STRING=%TESTS% -DBUILD_GTEST:STRING=%TESTS% -DBUILD_EXAMPLES:STRING=%EXAMPLES% %FREEIMAGE_OPTIONS% %GRAPHICS_OPTIONS%

%CMAKE% .. -DCMAKE_INSTALL_PREFIX:STRING=%AF_INSTALL_PATH%
if "%CPU%"=="ON" (
    echo "Running CPU CMake Configuration"
    %CMAKE% .. %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="%BUILD_TYPE%" -DBUILD_CPU:STRING=ON %FFT_OPTIONS% %BLAS_OPTIONS% %LAPACK_OPTIONS%
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
     %CMAKE% .. %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="%BUILD_TYPE%" -DBUILD_OPENCL:STRING=ON -DBOOST_INCLUDEDIR:STRING="%DEPS_DIR%/boost_1_56_0" %LAPACK_OPTIONS%
)
@echo off

echo "Running MSBuild"
REM Build
%MSBUILD% /p:Configuration=%BUILD_TYPE% ArrayFire.sln
%MSBUILD% /p:Configuration=%BUILD_TYPE% INSTALL.vcxproj

cd %OLDDIR%
