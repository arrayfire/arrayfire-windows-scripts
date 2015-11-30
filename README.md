Build ArrayFire on Windows
==========================
This repository contains sample batch scripts for building ArrayFire on Windows.

##Index
* [Source Requirements](#source-requirements)
* [Software Requirements](#software-requirements)
* [Using Scripts](#how-to-use-the-scripts)
* [Building ArrayFire](#building-arrayfire)
* [Using Intel MKL](#using-intel-mkl)

## Source Requirements
* [ArrayFire](https://github.com/arrayfire/arrayfire)
* [ArrayFire Windows Dependencies](http://ci.arrayfire.org/userContent/Windows/arrayfire_deps.zip). Includes pre-built:
    * FreeImage 3.16 (Under [FIPL v1.0](http://freeimage.sourceforge.net/freeimage-license.txt))
    * LAPACKE (Under [BSD 3-Clause](http://www.netlib.org/lapack/explore-html/d8/d65/lapacke_2_l_i_c_e_n_s_e_source.html))
    * FFTW 3.3.4 (Under [GNU GPL v2](http://www.fftw.org/fftw2_doc/fftw_8.html))
    * Boost 1.56 Header Files (Under [Boost Software License v1.0](http://www.boost.org/users/license.html))
    * GLEW (Under [Modified BSD](http://glew.sourceforge.net/glew.txt), [Mesa](http://glew.sourceforge.net/mesa.txt), [Khronos](http://glew.sourceforge.net/khronos.txt) Licenses)
    * GLFW (Under [zlip/png](http://www.glfw.org/license.html))
* Other requirements as stated in the ArrayFire repo (CUDA, OpenCL SDKs etc).
* ACML 6.1 (ifort64) is an alternate for FFTW. It can be downloaded from [here](http://developer.amd.com/tools-and-sdks/cpu-development/amd-core-math-library-acml/acml-downloads-resources/). Make sure you place it in the dependencies directory. The path should be `/dependencies_dir/acml/ifort64`.

## Software Requirements
* Visual Studio 2013 or newer
    * Community edition is free for Open Source projects
* GitHub for Windows preffered. Regular command prompt will also work.
* CMake

## How to use the scripts
#### common.bat
This file contains common macros. This is probably the only file that you will need to change. The variables are explained below.

#### Variables you will likely need to change
Variable (in common.bat)| Description
------------------------|------------------------
WORKSPACE           | Working directory
AF_DIR              | ArrayFire source code directory
DEPS_DIR            | Where the dependencies are extracted from the `arrayfire_deps.zip` file. Ideally workspace/dependencies
CPU, CUDA, OPENCL   | To select which backends to use, set them to ON. To deselect, set them to OFF
UNIFIED             | To select the unified backend, set it to ON. To deselect, set it to OFF
GRAPHICS            | Enable or disable building graphics. Default is off
TESTS               | ON to build tests, OFF to not build tests
EXAMPLES            | ON to build examples, OFF to not build examples

#### Variables you may want to change but do not need to
Variable (in common.bat)| Description
------------------------|------------------------
BUILD_DIR           | Build directory relative to AF_DIR
BUILD_TYPE          | Can be Release (Default), Debug, RelWithDebInfo, MinSizeRel
CUDA_COMPUTE_DETECT | If building on a remote machine which cannot run CUDA, set this to OFF. If OFF, atleast one CUDA_COMPUTE_* must be set to ON
CUDA_COMPUTE_(XY)   | Set these to ON for whichever computes should be added to compilation manually.
TESTS               | ON to build tests, OFF to not build tests
EXAMPLES            | ON to build examples, OFF to not build examples

#### Dependency Variables - Do not need to be changed
Variable (in common.bat)| Description
------------------------|------------------------
FREEIMAGE_TYPE          | Static or Dynamic library to be used. Optionally, can be set to OFF to disable FreeImage
CPU_FFT_TYPE            | FFT Library. Can be FFTW (default), ACML or MKL
CPU_BLAS_TYPE           | BLAS Library. Can be LAPACKE (default) or MKL (Optionally can be used with OpenBLAS)
FI_DIR                  | FreeImage directory. Default is set to be the one from the dependency directory
FFTW_DIR                | FFTW directory. Default is set to be the one from the dependency directory
ACML_DIR                | ACML directory. Download and place ACML here.
MKL_DIR                 | MKL directory. Create dependency/mkl/(include/lib/dll). See notes below.
LAPACKE_DIR             | LAPACKE directory. Default is set to be the one from the dependency directory
GLFW_DIR                | GLFW directory. Default is set to be the one from the dependency directory
GLEW_DIR                | GLEW directory. Default is set to be the one from the dependency directory
GLEWmx_STATIC           | Set to ON to use static library, off for dynamic library.

#### Variables you most likely will not need to change
These are system executables. As long as they are installed to the default paths, they should work fine.

Variable (in common.bat)| Description
------------------------|------------------------
THREADS                 | No. of logical processors to dedicate to parallel builds
GIT_EXE                 | Git executable
CMAKE                   | CMake executable
CMAKE_GENERATOR         | Visual Studio 2013 Win64 generator option
CTEST                   | ctest executable

#### rebuild_arrayfire.bat
* Builds a clean version of ArrayFire. Deletes the build directory, runs cmake, builds and installs (to AF_INSTALL_PATH) ArrayFire.
* Usage:
  * .\rebuild_arrayfire.bat : Reconfigures CMAKE and builds
  * .\rebuild_arrayfire.bat clean : Deletes BUILD_DIR, Reconfigures CMAKE and builds

#### build_arrayfire.bat
* Builds ArrayFire. This is not a clean build.
* Builds and installs ArrayFire to the install directory set in rebuild_arrayfire.bat

#### run_test.bat
* Runs one or more files from tests.
* Usage: .\run_test.bat expr CUDA=cuda_device OPENCL=cl_devlce
* All tests that match the expression expr are run on the device. Both are optional.
    * Pass . or _ as expr to run all tests.
    * To run all tests from one backend, pass cpu, cuda or opencl as expr
* The devices are optional. Not passing would make it device 0
* Example: .\run_test transpose CUDA=1 OPENCL=0
    * This will run all tests for transpose (cpu/cuda/opencl) on CUDA device 1 and OpenCL device 0.

#### run_single_test.bat
* Runs single test.
* Usage: .\run_single_test.bat test_backend CUDA=cuda_device OPENCL=cl_devlce
* The test name must be an exact match
* The devices are optional. Not passing would make it device 0
* Example: .\run_test transpose_cuda
    * This will run the transpose_cuda test only.

#### run_example.bat
* Runs files from examples.
* Usage: .\run_example.bat example_dir executable device
* executable must be name_backend.
* Device is optional (default 0)

#### build_clMath.bat
* ArrayFire uses clBLAS and clFFT as external builds. This script is not used.
* You can use this script to build clBLAS and clFFT externally.

## Building ArrayFire
The example below assume that C:\workspace is the working directory. That is, WORKSPACE=C:\workspace
* Clone ArrayFire into C:\workspace\arrayfire
  * AF_DIR is %WORKSPACE%/arrayfire
* Extract the arrayfire_deps.zip into C:\workspace. This should create:
    * C:\workspace\dependencies\\(freeimage, fftw, lapacke, boost)
* Copy the scripts from this repo into C:\workspace (optional)
* Using Git powershell (or any other command prompt) run rebuild_arrayfire.bat.
* This should build the CPU backend and install files to arrayfire/build/package.
```
# Using Git Shell
cd C:\workspace
git clone --recursive -b devel https://github.com/arrayfire/arrayfire.git arrayfire
git clone https://github.com/shehzan10/arrayfire-windows-scripts.git scripts
wget http://ci.arrayfire.org/userContent/arrayfire_deps.zip
unzip arrayfire_deps.zip
cp -r scripts\*.bat .\
.\rebuild_arrayfire.bat clean ## Use clean option when running first time or when doing a clean build
```
## Using Intel MKL
If you have Intel MKL available, you can use it to build ArrayFire. To setup MKL for ArrayFire, follow the steps:
* Create directory dependencies/mkl
* Create directories include, bin, lib in mkl
* Copy `fftw3.h, mkl_blas.h, mkl_cblas.h, mkl_lapacke.h, mkl_types.h` into mkl/include
* Copy `mkl_core_dll.lib, mkl_rt.lib` into mkl/lib
* Copy `mkl_core.dll, mkl_rt.dll, mkl_intel_thread.dll, mkl_rt.dll` into mkl/bin

This will allow you to use the default setup in the build scripts. You may choose not to copy these, but then will have to configure common.bat to set it up correctly.

## License
* The scripts are available unser ArrayFire's BSD 3-clause license.
* The pre-built dependencies shippied in arrayfire_deps.zip are licensed under
  their own licenses.
