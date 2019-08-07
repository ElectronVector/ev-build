@echo off

REM Get a unique image name based on the name of this folder.
set container_name=%cd%
set container_name=%container_name::=%
set container_name=%container_name:\=_%

set args=%*

REM An easy way to force the image to be built.
if /I "%1"=="--build" (
    docker build -t %container_name% .
    REM Shift the arguments because we just consumed one.
    for /f "tokens=1,* delims= " %%a in ("%*") do set args=%%b
    shift
)

REM Build the image if it doesn't exist.
docker image ls | findstr "\<%container_name%\>" >nul
if "%ERRORLEVEL%" NEQ "0" (
    docker build -t %container_name% .
)

REM Open a terminal into the container.
if /I "%1"=="--term" (
    docker run --mount type=bind,source="%cd%",target=/app -it %container_name% bash
    goto end
)

REM Run the provided command in the environment.
docker run --mount type=bind,source="%cd%",target=/app %container_name% %args%

:end