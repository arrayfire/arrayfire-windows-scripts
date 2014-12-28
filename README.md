Build ArrayFire on Windows
==========================

This repository contains sample batch scripts for building ArrayFire on Windows.

## Source Requirements
* [ArrayFire](https://github.com/arrayfire/arrayfire)
* [ArrayFire Windows Dependencies](https://drive.google.com/file/d/0ByGyhTmHFow9OHhEcGZJcmZnc3M/view?usp=sharing). Includes pre-built:
    * clBLAS, clFFT
    * FreeImage 3.16
    * OpenBLAS
    * Boost 1.56 Header Files
* Other requirements as stated in the ArrayFire repo (CUDA, OpenCL SDKs etc).

## Software Requirements
* Visual Studio 2013 or newer
    * Community edition is free for Open Source projects
* GitHub for Windows preffered. Regular command prompt will also work.
* SilkSVN or other Subversion tool
* CMake >= 3.0

## How to use the scripts
The script files assume all softwares are installed in their default
locations and that C:\workspace is the workspace for building ArrayFire.

Checkout the branch which has the permutation of the backends you wish to
build.

In all scripts, change the C:\workspace path to your build path.

### clean_build_arrayfire.bat
* Builds a clean version of ArrayFire. Deletes the build directory, runs cmake, builds and installs (to build/package) ArrayFire.
* Set THREADS to number of logical processors to dedicate to the build.
* Set GIT_EXE to the git executable.

### quick_build_arrayfire.bat
* Rebuilds ArrayFire. This is not a clean build.
* Builds and installs ArrayFire to the install direcoty set in clean_build_arrayfire.bat

### run_test.bat
* Runs files from tests.
* Usage: .\run_test.bat expr device
* All tests that match the expression are run on the device. Both are
  optional.
  * Not passing expr runs all tests and not passing device runs it on the device 0.

### run_example.bat
* Runs files from examples.
* Usage: .\run_example.bat executable device
* executable must be name_backend.
* Device is optional (default 0)

## Building ArrayFire
The scripts assume that C:\workspace is the working directory.
* Clone arrayfire and Boost.Compute (only if building OpenCL)
    * C:\workspace\arrayfire is the ArrayFire source code
* Extract the arrayfire_deps.zip into C:\workspace. This should create:
    * C:\workspace\clBLAS
    * C:\workspace\clBLAS
    * C:\workspace\dependencies
* Copy the scripts from the appropriate branch into C:\workspace
* Using Git shell (or any other command prompt) run clean_build_arrayfire.bat.

## License
* The scripts are available unser ArrayFire's BSD 3-clause license.
* The pre-built dependencies shippied in arrayfire_deps.zip are licensed under
  their own licenses.
