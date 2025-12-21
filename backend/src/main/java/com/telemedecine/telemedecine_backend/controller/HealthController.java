package com.telemedecine.telemedecine_backend.controller;

import com.telemedecine.telemedecine_backend.dto.HealthCheckResponse;
import com.telemedecine.telemedecine_backend.dto.HealthCheckResponse.ServiceHealth;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import javax.sql.DataSource;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/health")
public class HealthController {

    private static final Logger log = LoggerFactory.getLogger(HealthController.class);

    private final DataSource dataSource;
    private final RestTemplate restTemplate;

    @Value("${ai.service.url:http://localhost:5000}")
    private String aiServiceUrl;

    public HealthController(DataSource dataSource, RestTemplate restTemplate) {
        this.dataSource = dataSource;
        this.restTemplate = restTemplate;
    }

    @GetMapping
    public ResponseEntity<HealthCheckResponse> healthCheck() {
        Map<String, ServiceHealth> services = new HashMap<>();
        boolean allHealthy = true;

        // Check database
        ServiceHealth dbHealth = checkDatabase();
        services.put("database", dbHealth);
        if (!"healthy".equals(dbHealth.getStatus())) {
            allHealthy = false;
        }

        // Check AI service
        ServiceHealth aiHealth = checkAiService();
        services.put("ai_service", aiHealth);
        // AI service is optional, so we only degrade status if it's down
        boolean aiHealthy = "healthy".equals(aiHealth.getStatus());

        String overallStatus;
        if (!allHealthy) {
            overallStatus = "unhealthy";
        } else if (!aiHealthy) {
            overallStatus = "degraded";
        } else {
            overallStatus = "healthy";
        }

        HealthCheckResponse response = new HealthCheckResponse(overallStatus, services);

        HttpStatus httpStatus = switch (overallStatus) {
            case "unhealthy" -> HttpStatus.SERVICE_UNAVAILABLE;
            case "degraded" -> HttpStatus.OK; // Still operational
            default -> HttpStatus.OK;
        };

        return ResponseEntity.status(httpStatus).body(response);
    }

    private ServiceHealth checkDatabase() {
        try (Connection connection = dataSource.getConnection()) {
            if (connection.isValid(2)) {
                return new ServiceHealth("healthy", "Database connection successful");
            } else {
                return new ServiceHealth("unhealthy", "Database connection invalid");
            }
        } catch (Exception e) {
            log.error("Database health check failed", e);
            return new ServiceHealth("unhealthy", "Database error: " + e.getMessage());
        }
    }

    private ServiceHealth checkAiService() {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                aiServiceUrl + "/health",
                Map.class
            );
            
            if (response.getStatusCode().is2xxSuccessful()) {
                return new ServiceHealth("healthy", "AI service responding");
            } else {
                return new ServiceHealth("unhealthy", "AI service returned status: " + response.getStatusCode());
            }
        } catch (Exception e) {
            log.warn("AI service health check failed: {}", e.getMessage());
            return new ServiceHealth("unhealthy", "AI service unavailable: " + e.getMessage());
        }
    }
}
