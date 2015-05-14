@echo off
setlocal EnableDelayedExpansion

call common.bat

SET OLDDIR=%CD%

cd %AF_DIR%\%BUILD_DIR%
%CMAKE% ..
REM Build
%MSBUILD% /p:Configuration=%BUILD_TYPE% ArrayFire.sln
%MSBUILD% /p:Configuration=%BUILD_TYPE% INSTALL.vcxproj

cd %OLDDIR%
