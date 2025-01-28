@echo off

:: Determine system architecture and download appropriate Python installer
set "ARCH=x86_64"
if "%PROCESSOR_ARCHITECTURE%"=="x86" set "ARCH=x86"
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "ARCH=amd64"
if "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "ARCH=arm64"
if "%PROCESSOR_ARCHITECTURE%"=="ARM" set "ARCH=armv7"

:: Prompt to install Python if not installed
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Python is not installed.
    set /p installPython="Would you like to install Python? (Y/N): "
    if /i !installPython! EQU Y (
        echo Downloading and installing Python for architecture: %ARCH%...
        if "%ARCH%"=="amd64" powershell -Command "Start-Process -Wait -Verb RunAs powershell 'Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe -OutFile python-installer.exe; Start-Process -Wait .\\python-installer.exe /quiet InstallAllUsers=1 PrependPath=1'"
        if "%ARCH%"=="x86" powershell -Command "Start-Process -Wait -Verb RunAs powershell 'Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.11.5/python-3.11.5.exe -OutFile python-installer.exe; Start-Process -Wait .\\python-installer.exe /quiet InstallAllUsers=1 PrependPath=1'"
        if "%ARCH%"=="arm64" powershell -Command "Start-Process -Wait -Verb RunAs powershell 'Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.11.5/python-3.11.5-arm64.exe -OutFile python-installer.exe; Start-Process -Wait .\\python-installer.exe /quiet InstallAllUsers=1 PrependPath=1'"
        if "%ARCH%"=="armv7" echo "No official Python installer available for ARMv7. Please install manually."
        del python-installer.exe
        echo Python successfully installed.
    ) else (
        echo Python installation skipped. Please install Python manually.
        exit /b
    )
)

:: Check if pip exists
python -m pip --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Pip is not installed. Installing pip...
    python -m ensurepip --default-pip >nul 2>&1
    python -m pip install --upgrade pip >nul 2>&1
    echo Pip successfully installed.
)

:: Prompt to install virtualenv if venv is not available
python -m venv --help >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo The venv module is not available.
    set /p installVenv="Would you like to install virtualenv? (Y/N): "
    if /i !installVenv! EQU Y (
        echo Installing virtualenv...
        python -m pip install virtualenv >nul 2>&1
        echo Virtualenv installed.
    ) else (
        echo Virtualenv installation skipped. Please install it manually if required.
        exit /b
    )
)

:: Check if the virtual environment already exists
if exist venv_genshin-autopy (
    echo The virtual environment venv_genshin-autopy already exists.
    goto CHECK_REQUIREMENTS
) else (
    echo Creating the virtual environment venv_genshin-autopy...
    python -m venv venv_genshin-autopy
    echo Virtual environment created.
)

:CHECK_REQUIREMENTS
:: Activate the virtual environment
call venv_genshin-autopy\Scripts\activate.bat

:: Check if requirements.txt exists
if not exist requirements.txt (
    echo requirements.txt is missing. Please ensure it is in the current directory.
    goto END
)

:: Install requirements
pip install -r requirements.txt
if %ERRORLEVEL% EQU 0 (
    echo All requirements from requirements.txt have been successfully installed.
) else (
    echo An error occurred while installing packages from requirements.txt.
)

:: Execute the main Python script
if exist __main__.py (
    echo Running the main Python script...
    python __main__.py
) else (
    echo __main__.py is missing. Please ensure it is in the current directory.
)

:END
:: Deactivate the virtual environment
call venv_genshin-autopy\Scripts\deactivate.bat
pause