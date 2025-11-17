package com.telemedecine.telemedecine_backend.repository;

import com.telemedecine.telemedecine_backend.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PatientRepository extends JpaRepository<Patient, Long> {
}
