# Bank Management System - PowerShell Launcher
$ErrorActionPreference = "Continue"

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "          BANK MANAGEMENT SYSTEM - LAUNCHER        " -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Locate Java
$javaExe = $null

if (Get-Command java -ErrorAction SilentlyContinue) {
    $javaExe = "java"
} elseif ($env:JAVA_HOME -and (Test-Path "$env:JAVA_HOME\bin\java.exe")) {
    $javaExe = "$env:JAVA_HOME\bin\java.exe"
} else {
    $candidates = @(
        (Get-ChildItem "C:\Program Files\Java\jdk*" -ErrorAction SilentlyContinue),
        (Get-ChildItem "C:\Program Files\Eclipse Adoptium\jdk*" -ErrorAction SilentlyContinue),
        (Get-ChildItem "C:\Program Files\JetBrains\IntelliJ IDEA*\jbr" -ErrorAction SilentlyContinue),
        (Get-ChildItem "C:\Program Files\Apache NetBeans\jdk" -ErrorAction SilentlyContinue),
        (Get-ChildItem "$env:USERPROFILE\Downloads\jdk*" -ErrorAction SilentlyContinue)
    )
    foreach ($cand in $candidates) {
        if ($cand -and (Test-Path "$($cand.FullName)\bin\java.exe")) {
            $javaExe = "$($cand.FullName)\bin\java.exe"
            break
        }
    }
}

if (-not $javaExe) {
    Write-Host "[ERROR] Java was not found on your system." -ForegroundColor Red
    Write-Host "Please install JDK 17+ or set JAVA_HOME." -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] Using Java: $javaExe" -ForegroundColor Green

# 2. Check for .env file
if (-not (Test-Path ".env") -and (Test-Path ".env.example")) {
    Copy-Item ".env.example" ".env"
    Write-Host "[INFO] Created .env from .env.example. Adjust DB_PASSWORD if needed." -ForegroundColor Yellow
}

# 3. Classpath
$mysqlJar = "$env:USERPROFILE\.m2\repository\com\mysql\mysql-connector-j\8.4.0\mysql-connector-j-8.4.0.jar"
$calJar = "$env:USERPROFILE\.m2\repository\com\toedter\jcalendar\1.4\jcalendar-1.4.jar"
$cp = "target\classes;$mysqlJar;$calJar"

# 4. Check compilation
if (-not (Test-Path "target\classes\bank\management\system\Login.class")) {
    Write-Host "[INFO] Classes not compiled yet. Running maven compile..." -ForegroundColor Yellow
    mvn compile
}

Write-Host "[INFO] Launching Bank Management System..." -ForegroundColor Green
& $javaExe -cp $cp bank.management.system.Login
