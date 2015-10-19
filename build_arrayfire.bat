@echo off
setlocal EnableDelayedExpansion

call common.bat

SET OLDDIR=%CD%

cd %AF_DIR%\%BUILD_DIR%
%CMAKE% ..
REM Build
%CMAKE% --build .. --target ALL_BUILD --config %BUILD_TYPE% -- /v:m /clp:ErrorsOnly /m:%THREADS%
%CMAKE% --build .. --target INSTALL --config %BUILD_TYPE% -- /v:m /clp:ErrorsOnly /m:%THREADS%

cd %OLDDIR%
