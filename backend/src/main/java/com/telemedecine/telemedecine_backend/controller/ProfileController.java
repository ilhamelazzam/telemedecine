package com.telemedecine.telemedecine_backend.controller;

import com.telemedecine.telemedecine_backend.dto.ProfileResponse;
import com.telemedecine.telemedecine_backend.dto.UpdateProfileRequest;
import com.telemedecine.telemedecine_backend.model.Patient;
import com.telemedecine.telemedecine_backend.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/profile")
public class ProfileController {

    @Autowired
    private PatientRepository patientRepository;

    @GetMapping
    public ResponseEntity<?> getProfile(@RequestHeader("Authorization") String authHeader) {
        try {
            String token = authHeader.replace("Bearer ", "");
            Patient patient = patientRepository.findByAuthToken(token).orElse(null);

            if (patient == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Utilisateur non authentifié");
                return ResponseEntity.status(401).body(error);
            }

            return ResponseEntity.ok(new ProfileResponse(patient));
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors de la récupération du profil");
            return ResponseEntity.status(500).body(error);
        }
    }

    @PutMapping
    public ResponseEntity<?> updateProfile(
            @RequestHeader("Authorization") String authHeader,
            @RequestBody UpdateProfileRequest request) {
        try {
            String token = authHeader.replace("Bearer ", "");
            Patient patient = patientRepository.findByAuthToken(token).orElse(null);

            if (patient == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Utilisateur non authentifié");
                return ResponseEntity.status(401).body(error);
            }

            // Update fields
            if (request.getFirstName() != null) {
                patient.setFirstName(request.getFirstName());
            }
            if (request.getLastName() != null) {
                patient.setLastName(request.getLastName());
            }
            if (request.getPhone() != null) {
                patient.setPhone(request.getPhone());
            }
            if (request.getAddress() != null) {
                patient.setAddress(request.getAddress());
            }
            if (request.getRegion() != null) {
                patient.setRegion(request.getRegion());
            }

            patientRepository.save(patient);

            return ResponseEntity.ok(new ProfileResponse(patient));
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors de la mise à jour du profil");
            return ResponseEntity.status(500).body(error);
        }
    }
}
