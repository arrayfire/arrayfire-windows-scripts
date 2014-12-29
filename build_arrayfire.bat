@echo off
setlocal EnableDelayedExpansion

call common.bat

SET OLDDIR=%CD%

cd %AF_DIR%\build
%CMAKE% ..
REM Build
%MSBUILD% /p:Configuration=Release ArrayFire.sln
%MSBUILD% /p:Configuration=Release INSTALL.vcxproj

cd %OLDDIR%
