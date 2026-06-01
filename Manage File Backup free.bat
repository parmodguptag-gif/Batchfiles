@echo off
setlocal enabledelayedexpansion

:setup_path
cls
echo ===========================================
echo FILE BACKUP UTILITY - PARMOD KUMAR GUPTA
echo ===========================================
echo.
set /p "work_dir=Enter the folder path to organize (Press Enter for current folder): "

:: Remove accidental quotes from the path
set "work_dir=!work_dir:"=!"

:: If user just pressed Enter, use the current directory
if "!work_dir!"=="" (
    set "work_dir=%cd%"
)

:: Verify if the provided path actually exists
if not exist "!work_dir!\" (
    echo.
    echo [ERROR] The specified path does not exist. Please try again.
    pause
    goto setup_path
)

:: Change the active directory to the specified path
cd /d "!work_dir!"

:menu
cls
echo ===========================================
echo FILE BACKUP UTILITY
echo Current Location: %cd%
echo ===========================================
echo 1. Move Excel Files (.xlsx, .xls, .xlsm)
echo 2. Move PDF Files (.pdf)
echo 3. Move Word Files (.docx, .doc)
echo 4. Move Other Files (All other types)
echo 5. Exit
echo ===========================================
echo.

:: Using CHOICE command for strict, error-free user input
choice /C 12345 /N /M "Enter your choice (1, 2, 3, 4, or 5): "
set "choice=%errorlevel%"

if "%choice%"=="1" (
    set "ext_list=xlsx xls xlsm"
    set "target_dir=Excel_Backup"
    goto process
)
if "%choice%"=="2" (
    set "ext_list=pdf"
    set "target_dir=PDF_Backup"
    goto process
)
if "%choice%"=="3" (
    set "ext_list=docx doc"
    set "target_dir=Word_Backup"
    goto process
)
if "%choice%"=="4" (
    set "target_dir=Other_Backup"
    goto process_other
)
if "%choice%"=="5" (
    goto exit_script
)

:process
set "found_files=0"

:: Quickly check if any matching files exist (ignoring folders natively)
for %%e in (%ext_list%) do (
    for /f "delims=" %%f in ('dir /b /a-d "*.%%e" 2^>nul') do (
        set "found_files=1"
    )
)

if "%found_files%"=="0" (
    echo.
    echo [ERROR] No matching files found for your selection in this folder.
    pause
    goto menu
)

if not exist "%target_dir%" mkdir "%target_dir%"

echo.
for %%e in (%ext_list%) do (
    for /f "delims=" %%f in ('dir /b /a-d "*.%%e" 2^>nul') do (
        echo Moving file: "%%f"
        move "%%f" "%target_dir%\" >nul
    )
)
goto end_success

:process_other
set "found_other=0"

:: Check for files that do not match the defined extensions
for /f "delims=" %%f in ('dir /b /a-d * 2^>nul') do (
    if /i not "%%~f"=="%~nx0" (
        set "is_doc=0"
        for %%x in (.xlsx .xls .xlsm .pdf .docx .doc) do (
            if /i "%%~xf"=="%%x" set "is_doc=1"
        )
        if "!is_doc!"=="0" set "found_other=1"
    )
)

if "%found_other%"=="0" (
    echo.
    echo [ERROR] No other file types found to move.
    pause
    goto menu
)

if not exist "%target_dir%" mkdir "%target_dir%"

echo.
for /f "delims=" %%f in ('dir /b /a-d * 2^>nul') do (
    if /i not "%%~f"=="%~nx0" (
        set "is_doc=0"
        for %%x in (.xlsx .xls .xlsm .pdf .docx .doc) do (
            if /i "%%~xf"=="%%x" set "is_doc=1"
        )
        if "!is_doc!"=="0" (
            echo Moving file: "%%f"
            move "%%f" "%target_dir%\" >nul
        )
    )
)
goto end_success

:end_success
echo.
echo [SUCCESS] Operation completed successfully.
pause
goto menu

:exit_script
exit