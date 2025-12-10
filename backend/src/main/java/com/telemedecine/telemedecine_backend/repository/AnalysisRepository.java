package com.telemedecine.telemedecine_backend.repository;

import com.telemedecine.telemedecine_backend.model.Analysis;
import com.telemedecine.telemedecine_backend.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AnalysisRepository extends JpaRepository<Analysis, Long> {
    List<Analysis> findByPatientOrderByPerformedAtDesc(Patient patient);

    Optional<Analysis> findByIdAndPatient(Long id, Patient patient);
}
