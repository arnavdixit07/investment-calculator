@echo off
setlocal enabledelayedexpansion

echo =========================================
echo    Investment Time Machine Setup Script   
echo =========================================

:: Check if Python 3 is installed
python --version 2>NUL
if %ERRORLEVEL% NEQ 0 (
    echo Error: Python is not installed or not in PATH.
    echo Please install Python 3.8 or higher and try again.
    pause
    exit /b 1
)

:: Check Python version
for /f "tokens=2" %%I in ('python --version 2^>^&1') do set PYTHON_VERSION=%%I
for /f "tokens=1,2 delims=." %%a in ("!PYTHON_VERSION!") do (
    set PYTHON_MAJOR=%%a
    set PYTHON_MINOR=%%b
)

if !PYTHON_MAJOR! LSS 3 (
    echo Warning: Python version !PYTHON_VERSION! detected.
    echo This program works best with Python 3.8 or higher.
    set /p CONTINUE=Continue anyway? (y/n): 
    if /i "!CONTINUE!" NEQ "y" (
        echo Setup cancelled.
        pause
        exit /b 0
    )
) else if !PYTHON_MAJOR! EQU 3 if !PYTHON_MINOR! LSS 8 (
    echo Warning: Python version !PYTHON_VERSION! detected.
    echo This program works best with Python 3.8 or higher.
    set /p CONTINUE=Continue anyway? (y/n): 
    if /i "!CONTINUE!" NEQ "y" (
        echo Setup cancelled.
        pause
        exit /b 0
    )
) else (
    echo Python !PYTHON_VERSION! detected. ✓
)

:: Create virtual environment if it doesn't exist
if not exist venv (
    echo.
    echo Creating virtual environment...
    python -m venv venv
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to create virtual environment.
        echo Please make sure you have the venv module installed.
        pause
        exit /b 1
    )
    echo Virtual environment created. ✓
) else (
    echo.
    echo Virtual environment already exists. ✓
)

:: Activate virtual environment
echo.
echo Activating virtual environment...
call venv\Scripts\activate.bat
if %ERRORLEVEL% NEQ 0 (
    echo Failed to activate virtual environment.
    pause
    exit /b 1
)
echo Virtual environment activated. ✓

:: Install dependencies
echo.
echo Installing dependencies...
echo This may take a few minutes, especially for the transformers and torch packages.
pip install -r requirements.txt
if %ERRORLEVEL% NEQ 0 (
    echo Failed to install dependencies.
    echo Please check your internet connection and try again.
    call venv\Scripts\deactivate.bat
    pause
    exit /b 1
)
echo Dependencies installed. ✓

:: Check for GPU
python -c "import torch; print('GPU_AVAILABLE' if torch.cuda.is_available() else 'GPU_NOT_AVAILABLE')" > temp.txt
set /p GPU_STATUS=<temp.txt
del temp.txt

if "!GPU_STATUS!"=="GPU_AVAILABLE" (
    echo.
    echo GPU detected! BLOOMZ model will use GPU acceleration. ✓
) else (
    echo.
    echo No GPU detected. The program will run on CPU, which may be slow.
    echo Consider using a system with a GPU for better performance.
)

:: Run the program
echo.
echo =========================================
echo    Running Investment Time Machine   
echo =========================================
python investment_calculator.py

:: Deactivate virtual environment
call venv\Scripts\deactivate.bat

pause