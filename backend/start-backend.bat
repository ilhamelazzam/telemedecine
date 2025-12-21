@echo off
REM Spring Boot Backend Startup Script for Windows
REM Set your actual credentials below before running

REM ===== REQUIRED: Set your Aiven database password =====
set AIVEN_DB_PASSWORD=your_actual_aiven_password_here

REM ===== REQUIRED: Set your Gmail credentials for password reset emails =====
set MAIL_USERNAME=your_email@gmail.com
set MAIL_PASSWORD=your_gmail_app_password_here
set MAIL_FROM=no-reply@telemedecine.local

REM ===== OPTIONAL: AI Service Configuration (defaults already set) =====
set AI_SERVICE_URL=http://localhost:5000
set AI_SERVICE_ENABLED=true

echo ========================================
echo Starting Telemedecine Backend
echo ========================================
echo.
echo Database: telemedecine-ilhamitai346-ef84j.aivencloud.com:13029
echo AI Service: %AI_SERVICE_URL%
echo Mail From: %MAIL_FROM%
echo.
echo IMPORTANT: Make sure you've set the environment variables above!
echo.
echo ========================================

REM Start Spring Boot
mvnw.cmd spring-boot:run

pause
