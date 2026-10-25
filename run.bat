@echo off
setlocal enabledelayedexpansion
title Bank Management System

echo ===================================================
echo           BANK MANAGEMENT SYSTEM - LAUNCHER
echo ===================================================
echo.

:: 1. Locate Java
set "JAVA_EXE="

where java >nul 2>nul
if %errorlevel% equ 0 (
    set "JAVA_EXE=java"
)

if not defined JAVA_EXE (
    if defined JAVA_HOME (
        if exist "%JAVA_HOME%\bin\java.exe" set "JAVA_EXE=%JAVA_HOME%\bin\java.exe"
    )
)

if not defined JAVA_EXE (
    for /d %%D in ("C:\Program Files\Java\jdk*") do (
        if exist "%%D\bin\java.exe" set "JAVA_EXE=%%D\bin\java.exe"
    )
)
if not defined JAVA_EXE (
    for /d %%D in ("C:\Program Files\Eclipse Adoptium\jdk*") do (
        if exist "%%D\bin\java.exe" set "JAVA_EXE=%%D\bin\java.exe"
    )
)
if not defined JAVA_EXE (
    for /d %%D in ("C:\Program Files\JetBrains\IntelliJ IDEA*\jbr") do (
        if exist "%%D\bin\java.exe" set "JAVA_EXE=%%D\bin\java.exe"
    )
)
if not defined JAVA_EXE (
    if exist "C:\Program Files\Apache NetBeans\jdk\bin\java.exe" (
        set "JAVA_EXE=C:\Program Files\Apache NetBeans\jdk\bin\java.exe"
    )
)
if not defined JAVA_EXE (
    for /d %%D in ("%USERPROFILE%\Downloads\jdk*") do (
        if exist "%%D\bin\java.exe" set "JAVA_EXE=%%D\bin\java.exe"
    )
)

if not defined JAVA_EXE (
    echo [ERROR] Java was not found on your system.
    echo Please install JDK 17 or higher from https://adoptium.net or add Java to your PATH.
    pause
    exit /b 1
)

echo [OK] Using Java: "%JAVA_EXE%"

:: 2. Check for .env file
if not exist ".env" (
    if exist ".env.example" (
        echo [INFO] Creating .env from .env.example...
        copy ".env.example" ".env" >nul
        echo [INFO] Created .env file. Update DB_PASSWORD if needed.
    )
)

:: 3. Construct Classpath
set "JAR_MYSQL=%USERPROFILE%\.m2\repository\com\mysql\mysql-connector-j\8.4.0\mysql-connector-j-8.4.0.jar"
set "JAR_CALENDAR=%USERPROFILE%\.m2\repository\com\toedter\jcalendar\1.4\jcalendar-1.4.jar"
set "CP=target\classes;%JAR_MYSQL%;%JAR_CALENDAR%"

if not exist "target\classes\bank\management\system\Login.class" (
    echo [INFO] Compiled classes not found. Attempting to build with Maven...
    where mvn >nul 2>nul
    if %errorlevel% equ 0 (
        call mvn compile
    ) else (
        echo [ERROR] Maven not found. Please install Maven or open in IntelliJ IDEA/NetBeans.
        pause
        exit /b 1
    )
)

echo [INFO] Launching Bank Management System...
echo.
"%JAVA_EXE%" -cp "%CP%" bank.management.system.Login

if %errorlevel% neq 0 (
    echo.
    echo [NOTICE] Application closed.
    pause
)
