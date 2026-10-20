@echo off
title Camera Selector and Preview
echo =======================================================
echo   Scanning & Previewing Connected Cameras
echo =======================================================
cd /d "%~dp0\python"
python camera_selector.py
pause
