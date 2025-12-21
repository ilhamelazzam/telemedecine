package com.telemedecine.telemedecine_backend.controller;

import com.telemedecine.telemedecine_backend.dto.NotificationResponse;
import com.telemedecine.telemedecine_backend.model.Notification;
import com.telemedecine.telemedecine_backend.model.Patient;
import com.telemedecine.telemedecine_backend.repository.NotificationRepository;
import com.telemedecine.telemedecine_backend.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private PatientRepository patientRepository;

    @GetMapping
    public ResponseEntity<?> getNotifications(@RequestHeader("Authorization") String authHeader) {
        try {
            String token = authHeader.replace("Bearer ", "");
            Patient patient = patientRepository.findByAuthToken(token).orElse(null);

            if (patient == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Utilisateur non authentifié");
                return ResponseEntity.status(401).body(error);
            }

            List<Notification> notifications = notificationRepository.findByPatientOrderByCreatedAtDesc(patient);
            List<NotificationResponse> response = notifications.stream()
                    .map(NotificationResponse::new)
                    .collect(Collectors.toList());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors de la récupération des notifications");
            return ResponseEntity.status(500).body(error);
        }
    }

    @PutMapping("/{id}/read")
    public ResponseEntity<?> markAsRead(
            @RequestHeader("Authorization") String authHeader,
            @PathVariable Long id) {
        try {
            String token = authHeader.replace("Bearer ", "");
            Patient patient = patientRepository.findByAuthToken(token).orElse(null);

            if (patient == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Utilisateur non authentifié");
                return ResponseEntity.status(401).body(error);
            }

            Notification notification = notificationRepository.findById(id).orElse(null);
            if (notification == null || !notification.getPatient().getId().equals(patient.getId())) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Notification non trouvée");
                return ResponseEntity.status(404).body(error);
            }

            notification.setRead(true);
            notificationRepository.save(notification);

            Map<String, String> response = new HashMap<>();
            response.put("message", "Notification marquée comme lue");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors de la mise à jour de la notification");
            return ResponseEntity.status(500).body(error);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteNotification(
            @RequestHeader("Authorization") String authHeader,
            @PathVariable Long id) {
        try {
            String token = authHeader.replace("Bearer ", "");
            Patient patient = patientRepository.findByAuthToken(token).orElse(null);

            if (patient == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Utilisateur non authentifié");
                return ResponseEntity.status(401).body(error);
            }

            Notification notification = notificationRepository.findById(id).orElse(null);
            if (notification == null || !notification.getPatient().getId().equals(patient.getId())) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Notification non trouvée");
                return ResponseEntity.status(404).body(error);
            }

            notificationRepository.delete(notification);

            Map<String, String> response = new HashMap<>();
            response.put("message", "Notification supprimée");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors de la suppression de la notification");
            return ResponseEntity.status(500).body(error);
        }
    }

    @GetMapping("/unread-count")
    public ResponseEntity<?> getUnreadCount(@RequestHeader("Authorization") String authHeader) {
        try {
            String token = authHeader.replace("Bearer ", "");
            Patient patient = patientRepository.findByAuthToken(token).orElse(null);

            if (patient == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Utilisateur non authentifié");
                return ResponseEntity.status(401).body(error);
            }

            long count = notificationRepository.countByPatientAndIsReadFalse(patient);
            Map<String, Long> response = new HashMap<>();
            response.put("count", count);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors du comptage des notifications");
            return ResponseEntity.status(500).body(error);
        }
    }
}
