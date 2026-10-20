@echo off
title AI Vision Gripper - Environment Setup
echo ========================================================
echo   AI Vision Teleoperated Gripper - Environment Setup
echo ========================================================
echo.
echo Checking Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH!
    echo Please install Python 3.10+ from python.org and check "Add to PATH".
    pause
    exit /b 1
)

echo [OK] Python detected!
echo.
echo Installing required dependencies from requirements.txt...
python -m pip install --upgrade pip
python -m pip install -r "%~dp0python\requirements.txt"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies.
    pause
    exit /b 1
)

echo.
echo [Setup Complete] Everything is ready!
echo You can now run 'run_teleop.bat' to start the application.
echo.
pause
