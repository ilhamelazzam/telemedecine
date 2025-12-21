package com.telemedecine.telemedecine_backend.repository;

import com.telemedecine.telemedecine_backend.model.Notification;
import com.telemedecine.telemedecine_backend.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByPatientOrderByCreatedAtDesc(Patient patient);
    long countByPatientAndIsReadFalse(Patient patient);
}
