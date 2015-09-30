REM DIRECTORIES
REM USE DOUBLE QUOTES IF PATHS INCLUDE SPACES
SET WORKSPACE=C:/workspace
SET AF_DIR=%WORKSPACE%/arrayfire
REM AF_INSTALL_PATH is where ArrayFire files are installed.
REM AF_INSTALL_PATH can be relative path from AF_DIR/build or absolute path
SET AF_INSTALL_PATH="package"
SET DEPS_DIR=%WORKSPACE%/dependencies
REM Relative to AF_DIR
SET BUILD_DIR=build
REM BUILD_TYPE can be Release, Debug, RelWithDebInfo, MinSizeRel
SET BUILD_TYPE=Release

REM ARRAYFIRE BUILD OPTIONS
REM SELECT WHICH BACKENDS TO BUILD BY SETTING THEM TO ON
SET CPU=ON
SET CUDA=OFF
SET OPENCL=OFF
SET UNIFIED=OFF
SET GRAPHICS=OFF

REM Set CUDA_COMPUTE_DETECT to OFF to disable auto detection.
REM If no CUDA computes are detected (for example when running on a remote machine)
REM it will default to 20, 30, 50, unless at least one of CUDA_COMPUTE_XY (below) are set to ON
SET CUDA_COMPUTE_DETECT=ON

REM Set these to ON for adding a architecture while compiling.
REM If CUDA_COMPUTE_DETECT is turned on, the detected computes will be enabled automatically and override any OFF computes.
SET CUDA_COMPUTE_20=OFF
SET CUDA_COMPUTE_30=OFF
SET CUDA_COMPUTE_35=OFF
SET CUDA_COMPUTE_50=OFF
SET CUDA_COMPUTE_52=OFF

REM TOGGLE EXAMPLES AND TESTS
SET EXAMPLES=ON
SET TESTS=ON

REM FREEIMAGE_TYPE can be OFF, STATIC, DYNAMIC
SET FREEIMAGE_TYPE=STATIC

REM CPU_FFT_TYPE can be FFTW, ACML, MKL
REM Note: ACML 6.1 has known failure issues
SET CPU_FFT_TYPE=FFTW

REM CPU_BLAS_TYPE can be LAPACKE, MKL
REM Ideally, BLAS_TYPE and LAPACK_TYPE should be the same
SET CPU_BLAS_TYPE=LAPACKE

REM CPU_LAPACK_TYPE can be LAPACKE, MKL
SET CPU_LAPACK_TYPE=LAPACKE

REM GLEWmx_STATIC can be ON or OFF
SET GLEWmx_STATIC=OFF

REM PATH SETTING TO RUN EXECUTABLES
SET FI_DIR=%DEPS_DIR%/freeimage-3.17.0_x64
SET FFTW_DIR=%DEPS_DIR%/fftw-3.3.4
SET ACML_DIR=%DEPS_DIR%/acml/ifort64
SET MKL_DIR=%DEPS_DIR%/mkl
SET LAPACKE_DIR=%DEPS_DIR%/lapacke
SET GLEW_DIR=%DEPS_DIR%/glew
SET GLFW_DIR=%DEPS_DIR%/glfw

SET PATH_EXT=%AF_DIR%\%BUILD_DIR%\package\lib;

REM FREEIMAGE
SET FREEIMAGE_OPTIONS=
if "%FREEIMAGE_TYPE%"=="DYNAMIC" (
    SET FREEIMAGE_OPTIONS=-DFREEIMAGE_FOUND:STRING=ON -DUSE_FREEIMAGE_STATIC:BOOL=OFF -DFREEIMAGE_INCLUDE_PATH:STRING="%FI_DIR%" -DFREEIMAGE_STATIC_LIBRARY:STRING="%FI_DIR%/FreeImageLib.lib" -DFREEIMAGE_DYNAMIC_LIBRARY:STRING="%FI_DIR%/FreeImage.lib"
    SET PATH_EXT=%PATH_EXT%%FI_DIR%;
) else ( REM STATIC
    SET FREEIMAGE_OPTIONS=-DFREEIMAGE_FOUND:STRING=ON -DUSE_FREEIMAGE_STATIC:BOOL=ON -DFREEIMAGE_INCLUDE_PATH:STRING="%FI_DIR%" -DFREEIMAGE_STATIC_LIBRARY:STRING="%FI_DIR%/FreeImageLib.lib" -DFREEIMAGE_DYNAMIC_LIBRARY:STRING="%FI_DIR%/FreeImage.lib"
)

REM FFT
SET FFT_OPTIONS=
if "%CPU_FFT_TYPE%"=="FFTW" (
    SET FFT_OPTIONS=-DFFTW_ROOT:STRING="%FFTW_DIR%" -DFFTW_LIB:STRING="%FFTW_DIR%/libfftw3-3.lib" -DFFTWF_LIB:STRING="%FFTW_DIR%/libfftw3f-3.lib" -DFFTWL_LIB:STRING="%FFTW_DIR%/libfftw3l-3.lib"
    SET PATH_EXT=%PATH_EXT%%FFTW_DIR%;
) else (
    if "%CPU_FFT_TYPE%"=="ACML" (
        REM SET ACML PATH HERE
        SET FFT_OPTIONS=-DFFTW_ROOT:STRING="%ACML_DIR%" -DFFTW_LIBRARIES:STRING="%ACML_DIR%/lib/acml_fftw.lib" -DFFTW_LIB:STRING="" -DFFTWF_LIB:STRING=""
        SET PATH_EXT=%PATH_EXT%%ACML_DIR%\lib;
    ) else (
        REM SET MKL PATH HERE
        SET FFT_OPTIONS=-DFFTW_ROOT:STRING="%MKL_DIR%" -DFFTW_LIBRARIES:STRING="%MKL_DIR%/lib/mkl_rt.lib" -DFFTW_LIB:STRING="" -DFFTWF_LIB:STRING=""
        SET PATH_EXT=%PATH_EXT%%MKL_DIR%\bin;
    )
)

SET BLAS_OPTIONS=
if "%CPU_BLAS_TYPE%"=="LAPACKE" (
    REM SET LAPACKE PATH HERE
    SET BLAS_OPTIONS=-DUSE_CPU_F77_BLAS:BOOL=ON -DCBLAS_INCLUDE_DIR:STRING="%LAPACKE_DIR%/include" -DCBLAS_cblas_LIBRARY:STRING="%LAPACKE_DIR%/lib/libblas.lib"
    SET PATH_EXT=%PATH_EXT%%LAPACKE_DIR%\bin;
) else (
    REM SET MKL PATH HERE
    SET BLAS_OPTIONS=-DUSE_CPU_MKL:BOOL=ON -DUSE_OPENCL_MKL:BOOL=ON -DCBLAS_INCLUDE_DIR:STRING="%MKL_DIR%/include" -DCBLAS_cblas_LIBRARY:STRING="%MKL_DIR%/lib/mkl_rt.lib"
    SET PATH_EXT=%PATH_EXT%%MKL_DIR%\bin;
)

SET LAPACK_OPTIONS=
if "%CPU_LAPACK_TYPE%"=="LAPACKE" (
    REM SET LAPACKE PATH HERE
    SET LAPACK_OPTIONS=-DLAPACKE_ROOT:STRING="%LAPACKE_DIR%"
    REM SET LAPACK_OPTIONS=-DLAPACK_INCLUDE_DIR:STRING="%LAPACKE_DIR%/include" -DLAPACKE_LIB:STRING="%LAPACKE_DIR%/lib/liblapacke.lib" -DLAPACK_LIB:STRING="%LAPACKE_DIR%/lib/liblapack.lib"
    SET PATH_EXT=%PATH_EXT%%LAPACKE_DIR%\bin;
) else (
    REM SET MKL PATH HERE
    SET LAPACK_OPTIONS=-DUSE_CPU_MKL:BOOL=ON -DUSE_OPENCL_MKL:BOOL=ON -DLAPACKE_INCLUDES:STRING="%MKL_DIR%/include" -DLAPACKE_LIB:STRING="%MKL_DIR%/lib/mkl_rt.lib;" -DLAPACK_LIB:STRING="%MKL_DIR%/lib/mkl_rt.lib"
    SET PATH_EXT=%PATH_EXT%%MKL_DIR%\bin;
)

SET GRAPHICS_OPTIONS=
if "%GRAPHICS%"=="ON" (
    SET GRAPHICS_OPTIONS=-DBUILD_GRAPHICS:BOOL=ON -DGLEW_ROOT_DIR="%GLEW_DIR%" -DUSE_GLEWmx_STATIC:BOOL=%GLEWmx_STATIC% -DGLEW_INCLUDE_DIR:STRING="%GLEW_DIR%/include" -DGLEW_LIBRARY="%GLEW_DIR%/lib/glew32.lib" -DGLEWmxd_LIBRARY="%GLEW_DIR%/lib/glew32mx.lib" -DGLEWmxs_LIBRARY="%GLEW_DIR%/lib/glew32mxs.lib" -DGLFW_ROOT_DIR="%GLFW_DIR%" -DGLFW_INCLUDE_DIR:STRING="%GLFW_DIR%/include" -DGLFW_LIBRARY="%GLFW_DIR%/lib/glfw3.lib"
    SET PATH_EXT=%PATH_EXT%%DEPS_DIR%\glew\lib;%DEPS_DIR%\glfw\lib;
) else (
    SET GRAPHICS_OPTIONS=-DBUILD_GRAPHICS:BOOL=OFF
)

if "%CUDA%"=="ON" (
    SET PATH_EXT=%PATH_EXT%%CUDA_PATH%\bin;%CUDA_PATH%\nvvm\bin;
)

REM TOOLS CONFIGURATION
SET THREADS=8
SET MSBUILD="C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe" /m:%THREADS%
SET GIT_EXE="git.exe"
SET CMAKE="C:\Program Files (x86)\CMake\bin\cmake"
SET CMAKE_GENERATOR=-G "Visual Studio 12 2013 Win64"
SET CTEST="C:\Program Files (x86)\CMake\bin\ctest.exe" --force-new-ctest-process --output-on-failure
