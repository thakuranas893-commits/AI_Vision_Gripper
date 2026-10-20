@echo off
title AI Vision Teleoperated Gripper
echo =======================================================
echo   Starting AI Vision Teleoperated Gripper Pipeline
echo =======================================================
cd /d "%~dp0\python"
python ai_vision_teleop.py
pause
