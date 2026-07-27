@echo off
chcp 65001 >nul
echo Ładowanie...
title Menadzer Hasel
setlocal EnableDelayedExpansion
set "ALPHABET=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

for /f "delims=" %%A in ('powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/szubixyt-dev/latwymenadzer/refs/heads/main/key.txt' -UseBasicParsing | Select-Object -ExpandProperty Content"') do set "CIPHER=%%A"
if not exist "C:\Users\%username%\passwords.txt" type nul > "C:\Users\%username%\passwords.txt"

:menu
cls
echo =============================
echo      MENADZER HASEL
echo =============================
echo.
echo 1. Dodaj haslo
echo 2. Wyswietl wszystkie hasla
echo 3. Usun login
echo 4. Wyjdz
echo.
set /p wybor=Wybierz opcje: 

if "%wybor%"=="1" goto dodaj
if "%wybor%"=="2" goto pokaz
if "%wybor%"=="3" goto usun
if "%wybor%"=="4" exit

goto menu

:dodaj
cls
echo ===== Dodawanie hasla =====
echo.

set /p USLUGA=Podaj nazwe uslugi:
set /p LOGIN=Podaj login:
set /p HASLO=Podaj haslo (lub wpisz chce_losowe_haslo):

if /i "!HASLO!"=="chce_losowe_haslo" (
    for /f "delims=" %%A in ('powershell -NoProfile -Command "$chars='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'; -join (1..16 | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })"') do set "HASLO=%%A"

    echo Wygenerowane haslo: !HASLO!
)
set /p EMAIL=Podaj email:
set /p TELEFON=Podaj numer telefonu:

set "ALPHABET=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

rem Pobieranie klucza szyfrujacego z GitHuba
for /f "delims=" %%A in ('powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/szubixyt-dev/latwymenadzer/refs/heads/main/key.txt' -UseBasicParsing | Select-Object -ExpandProperty Content"') do set "CIPHER=%%A"

rem Szyfrowanie uslugi
for /f "delims=" %%A in ('powershell -NoProfile -Command "$a='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';$c='%CIPHER%';$s='%USLUGA%';$r='';foreach($x in $s.ToCharArray()){ $i=$a.IndexOf($x); if($i -ge 0){$r+=$c[$i]}else{$r+=$x} };$r"') do set "EU=%%A"

rem Szyfrowanie loginu
for /f "delims=" %%A in ('powershell -NoProfile -Command "$a='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';$c='%CIPHER%';$s='%LOGIN%';$r='';foreach($x in $s.ToCharArray()){ $i=$a.IndexOf($x); if($i -ge 0){$r+=$c[$i]}else{$r+=$x} };$r"') do set "EL=%%A"

rem Szyfrowanie hasla
for /f "delims=" %%A in ('powershell -NoProfile -Command "$a='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';$c='%CIPHER%';$s='%HASLO%';$r='';foreach($x in $s.ToCharArray()){ $i=$a.IndexOf($x); if($i -ge 0){$r+=$c[$i]}else{$r+=$x} };$r"') do set "EH=%%A"

rem Szyfrowanie emaila
for /f "delims=" %%A in ('powershell -NoProfile -Command "$a='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';$c='%CIPHER%';$s='%EMAIL%';$r='';foreach($x in $s.ToCharArray()){ $i=$a.IndexOf($x); if($i -ge 0){$r+=$c[$i]}else{$r+=$x} };$r"') do set "EE=%%A"

rem Szyfrowanie telefonu
for /f "delims=" %%A in ('powershell -NoProfile -Command "$a='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';$c='%CIPHER%';$s='%TELEFON%';$r='';foreach($x in $s.ToCharArray()){ $i=$a.IndexOf($x); if($i -ge 0){$r+=$c[$i]}else{$r+=$x} };$r"') do set "ET=%%A"

rem Sprawdzenie wynikow

rem Zapis do pliku
echo %EU%^|%EL%^|%EH%^|%EE%^|%ET%>>"C:\Users\%username%\passwords.txt"

echo Zapisano!
pause
goto menu

:pokaz
cls
echo ===== Zapisane uslugi =====
echo.

set "LICZNIK=0"

for /f "usebackq tokens=1,2,3,4,5 delims=|" %%A in ("C:\Users\%USERNAME%\passwords.txt") do (
    for /f "delims=" %%B in ('powershell -NoProfile -Command "$a='%ALPHABET%';$c='%CIPHER%';$s='%%A';$r='';foreach($x in $s.ToCharArray()){ $i=$c.IndexOf($x); if($i -ge 0){$r+=$a[$i]}else{$r+=$x}};$r"') do (

        set "ISTNIEJE=0"

        for /l %%i in (1,1,!LICZNIK!) do (
            if "!USLUGA%%i!"=="%%B" set "ISTNIEJE=1"
        )

        if "!ISTNIEJE!"=="0" (
            set /a LICZNIK+=1
            echo !LICZNIK!. %%B
            set "USLUGA!LICZNIK!=%%B"
        )
    )
)

echo.
set /p WYBOR=Wybierz usluge:

set "WYBRANA=!USLUGA%WYBOR%!"

echo.
echo ===== Hasla dla !WYBRANA! =====
echo.

for /f "usebackq tokens=1,2,3,4,5 delims=|" %%A in (C:\Users\%username%\passwords.txt) do (

    for /f "delims=" %%U in ('powershell -NoProfile -Command "$a='%ALPHABET%';$c='%CIPHER%';$s='%%A';$r='';foreach($x in $s.ToCharArray()){ $i=$c.IndexOf($x); if($i -ge 0){$r+=$a[$i]}else{$r+=$x}};$r"') do (

        if "%%U"=="!WYBRANA!" (

            for /f "delims=" %%L in ('powershell -NoProfile -Command "$a='%ALPHABET%';$c='%CIPHER%';$s='%%B';$r='';foreach($x in $s.ToCharArray()){ $i=$c.IndexOf($x); if($i -ge 0){$r+=$a[$i]}else{$r+=$x}};$r"') do set "LOGIN_SHOW=%%L"

            for /f "delims=" %%H in ('powershell -NoProfile -Command "$a='%ALPHABET%';$c='%CIPHER%';$s='%%C';$r='';foreach($x in $s.ToCharArray()){ $i=$c.IndexOf($x); if($i -ge 0){$r+=$a[$i]}else{$r+=$x}};$r"') do set "HASLO_SHOW=%%H"
			
			for /f "delims=" %%E in ('powershell -NoProfile -Command "$a='%ALPHABET%';$c='%CIPHER%';$s='%%D';$r='';foreach($x in $s.ToCharArray()){ $i=$c.IndexOf($x); if($i -ge 0){$r+=$a[$i]}else{$r+=$x}};$r"') do set "EMAIL_SHOW=%%E"

			for /f "delims=" %%T in ('powershell -NoProfile -Command "$a='%ALPHABET%';$c='%CIPHER%';$s='%%E';$r='';foreach($x in $s.ToCharArray()){ $i=$c.IndexOf($x); if($i -ge 0){$r+=$a[$i]}else{$r+=$x}};$r"') do set "TELEFON_SHOW=%%T"
			
            echo Login: !LOGIN_SHOW!
            echo Haslo: !HASLO_SHOW!
            echo Email: !EMAIL_SHOW!
            echo Telefon: !TELEFON_SHOW!
            echo ------------------
        )
    )
)

pause
goto menu

:usun
cls
echo ===== Usuwanie hasla =====
echo.

set "LICZNIK=0"

for /f "usebackq tokens=1 delims=|" %%A in (C:\Users\%username%\passwords.txt) do (
    for /f "delims=" %%B in ('powershell -NoProfile -Command "$a='%ALPHABET%';$c='%CIPHER%';$s='%%A';$r='';foreach($x in $s.ToCharArray()){ $i=$c.IndexOf($x); if($i -ge 0){$r+=$a[$i]}else{$r+=$x}};$r"') do (

        set "DUPLIKAT=0"

        for /l %%N in (1,1,!LICZNIK!) do (
            if "!USLUGA%%N!"=="%%B" set "DUPLIKAT=1"
        )

        if "!DUPLIKAT!"=="0" (
            set /a LICZNIK+=1
            echo !LICZNIK!. %%B
            set "USLUGA!LICZNIK!=%%B"
        )
    )
)

echo.
set /p WYBOR=Wybierz usluge:

set "WYBRANA_USLUGA=!USLUGA%WYBOR%!"

cls
echo ===== Loginy =====
echo.

set "LICZNIK=0"

for /f "usebackq tokens=1,2,3 delims=|" %%A in (C:\Users\%username%\passwords.txt) do (

    for /f "delims=" %%U in ('powershell -NoProfile -Command "$a='%ALPHABET%';$c='%CIPHER%';$s='%%A';$r='';foreach($x in $s.ToCharArray()){ $i=$c.IndexOf($x);if($i -ge 0){$r+=$a[$i]}else{$r+=$x}};$r"') do (

        if "%%U"=="!WYBRANA_USLUGA!" (

            for /f "delims=" %%L in ('powershell -NoProfile -Command "$a='%ALPHABET%';$c='%CIPHER%';$s='%%B';$r='';foreach($x in $s.ToCharArray()){ $i=$c.IndexOf($x);if($i -ge 0){$r+=$a[$i]}else{$r+=$x}};$r"') do (

                set /a LICZNIK+=1
                echo !LICZNIK!. %%L
                set "LOGIN!LICZNIK!=%%L"
            )
        )
    )
)
echo.
set /p WYBOR_LOGIN=Wybierz login do usuniecia:

set "USUN_LOGIN=!LOGIN%WYBOR_LOGIN%!"

set "DEL_USLUGA=%WYBRANA_USLUGA%"
set "DEL_LOGIN=%USUN_LOGIN%"

del usun.ps1 2>nul

echo $a="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789">usun.ps1
echo $c=$env:CIPHER>>usun.ps1
echo $u=$env:DEL_USLUGA>>usun.ps1
echo $l=$env:DEL_LOGIN>>usun.ps1
echo function Decrypt($s^) {>>usun.ps1
echo $r="" >>usun.ps1
echo foreach($x in $s.ToCharArray()^) {>>usun.ps1
echo $i=$c.IndexOf($x)>>usun.ps1
echo if($i -ge 0^) {$r+=$a[$i]} else {$r+=$x}>>usun.ps1
echo }>>usun.ps1
echo return $r>>usun.ps1
echo }>>usun.ps1
echo $out=@()>>usun.ps1
echo foreach($line in Get-Content "C:\Users\%username%\passwords.txt"^) {>>usun.ps1
echo $p=$line.Split("|")>>usun.ps1
echo if((Decrypt $p[0]) -ne $u -or (Decrypt $p[1]) -ne $l^) {$out += $line}>>usun.ps1
echo }>>usun.ps1
echo $out ^| Set-Content "C:\Users\%username%\passwords.txt">>usun.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File ".\usun.ps1"

del usun.ps1

echo.
echo Usunieto!
pause
goto menu