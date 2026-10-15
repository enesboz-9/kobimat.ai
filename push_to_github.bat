@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

REM ==========================================================
REM  Kobimat - GitHub otomatik push
REM  Kullanim:  push_to_github.bat
REM             push_to_github.bat "commit mesajin"
REM  Bu dosyayi proje klasorunun kokune koy.
REM ==========================================================

set "REPO_URL=https://github.com/enesboz-9/kobimat.ai.git"
set "BRANCH=main"

cd /d "%~dp0"

where git >nul 2>&1
if errorlevel 1 (
    echo [HATA] Git bulunamadi. https://git-scm.com adresinden kur.
    pause
    exit /b 1
)

if not exist ".git" (
    echo [BILGI] Git deposu olusturuluyor...
    git init
    git branch -M %BRANCH%
)

git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin %REPO_URL%
) else (
    git remote set-url origin %REPO_URL%
)

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH:mm"') do set "STAMP=%%i"
set "MSG=%~1"
if "%MSG%"=="" set "MSG=Otomatik guncelleme !STAMP!"

echo [BILGI] Degisiklikler ekleniyor...
git add -A

git diff --cached --quiet
if errorlevel 1 (
    git commit -m "!MSG!"
    if errorlevel 1 (
        echo [HATA] Commit basarisiz.
        pause
        exit /b 1
    )
) else (
    echo [BILGI] Commit edilecek yeni degisiklik yok.
)

git ls-remote --exit-code --heads origin %BRANCH% >nul 2>&1
if not errorlevel 1 (
    echo [BILGI] Uzak depodaki degisiklikler cekiliyor...
    git pull --rebase origin %BRANCH%
    if errorlevel 1 (
        echo [HATA] Pull/rebase basarisiz. Cakismalari elle coz, sonra tekrar calistir.
        pause
        exit /b 1
    )
)

echo [BILGI] GitHub'a gonderiliyor...
git push -u origin %BRANCH%
if errorlevel 1 (
    echo [HATA] Push basarisiz. Giris bilgilerini ve depo erisimini kontrol et.
    pause
    exit /b 1
)

echo.
echo [TAMAM] Push basarili: %REPO_URL% (%BRANCH%)
pause
endlocal
