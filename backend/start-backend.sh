#!/bin/bash
# Spring Boot Backend Startup Script for Linux/Mac
# Set your actual credentials below before running

# ===== REQUIRED: Set your Aiven database password =====
export AIVEN_DB_PASSWORD="your_actual_aiven_password_here"

# ===== REQUIRED: Set your Gmail credentials for password reset emails =====
export MAIL_USERNAME="your_email@gmail.com"
export MAIL_PASSWORD="your_gmail_app_password_here"
export MAIL_FROM="no-reply@telemedecine.local"

# ===== OPTIONAL: AI Service Configuration (defaults already set) =====
export AI_SERVICE_URL="http://localhost:5000"
export AI_SERVICE_ENABLED="true"

echo "========================================"
echo "Starting Telemedecine Backend"
echo "========================================"
echo ""
echo "Database: telemedecine-ilhamitai346-ef84j.aivencloud.com:13029"
echo "AI Service: $AI_SERVICE_URL"
echo "Mail From: $MAIL_FROM"
echo ""
echo "IMPORTANT: Make sure you've set the environment variables above!"
echo ""
echo "========================================"

# Start Spring Boot
./mvnw spring-boot:run
