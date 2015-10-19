@echo off
setlocal EnableDelayedExpansion

call common.bat

SET OLDDIR=%CD%

cd %AF_DIR%\%BUILD_DIR%
%CMAKE% ..
REM Build
%CMAKE% --build %AF_DIR%/%BUILD_DIR% --target ALL_BUILD --config %BUILD_TYPE% -- /v:m /clp:ShowCommandLine;Summary /m:%THREADS% /p:WarningLevel=1
%CMAKE% --build %AF_DIR%/%BUILD_DIR% --target INSTALL --config %BUILD_TYPE% -- /v:m /clp:ShowCommandLine;Summary /m:%THREADS% /p:WarningLevel=1

cd %OLDDIR%
