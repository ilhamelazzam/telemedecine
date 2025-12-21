package com.telemedecine.telemedecine_backend.dto;

import java.time.LocalDateTime;
import java.util.Map;

public class HealthCheckResponse {
    
    private String status; // "healthy", "degraded", "unhealthy"
    private LocalDateTime timestamp;
    private Map<String, ServiceHealth> services;

    public HealthCheckResponse() {
        this.timestamp = LocalDateTime.now();
    }

    public HealthCheckResponse(String status, Map<String, ServiceHealth> services) {
        this.status = status;
        this.services = services;
        this.timestamp = LocalDateTime.now();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public Map<String, ServiceHealth> getServices() {
        return services;
    }

    public void setServices(Map<String, ServiceHealth> services) {
        this.services = services;
    }

    public static class ServiceHealth {
        private String status;
        private String message;

        public ServiceHealth() {
        }

        public ServiceHealth(String status, String message) {
            this.status = status;
            this.message = message;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}
