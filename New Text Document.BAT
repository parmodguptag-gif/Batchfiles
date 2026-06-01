@echo off
setlocal enabledelayedexpansion

echo ===========================================
echo GITHUB AUTO-UPLOAD UTILITY
echo ===========================================
echo.

:: 1. Apne folder ka path yahan daalein
set "repo_path=D:\batch files github"
cd /d "%repo_path%"

:: 2. Check karte hain ki folder mein koi changes hain ya nahi
echo Checking for changes...
git status -s >nul
if %errorlevel% neq 0 (
    echo [ERROR] Yeh ek Git repository nahi hai.
    pause
    exit
)

:: 3. Saari modified/new files ko add karna
echo Adding files to Git...
git add .

:: 4. Current date aur time ke sath commit message banana
set "commit_msg=Auto-backup on %date% at %time%"
echo Committing changes: "%commit_msg%"
git commit -m "%commit_msg%"

:: 5. GitHub par push (upload) karna
echo Pushing files to GitHub...
git push origin main

:: Note: Agar aapki main branch ka naam 'master' hai, toh upar 'main' ki jagah 'master' likhein.

echo.
echo [SUCCESS] Saari files successfully GitHub par upload ho gayi hain!
pause