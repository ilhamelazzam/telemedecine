package com.telemedecine.telemedecine_backend.controller;

import com.telemedecine.telemedecine_backend.dto.LoginRequest;
import com.telemedecine.telemedecine_backend.dto.LoginResponse;
import com.telemedecine.telemedecine_backend.dto.RegisterPatientRequest;
import com.telemedecine.telemedecine_backend.model.Patient;
import com.telemedecine.telemedecine_backend.repository.PatientRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:3000") // pour ton futur frontend React
public class AuthController {

    private final PatientRepository patientRepository;

    public AuthController(PatientRepository patientRepository) {
        this.patientRepository = patientRepository;
    }

    // ========= Inscription patient =========
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterPatientRequest request) {

        // Vérifier si l'email existe déjà
        Optional<Patient> existing = patientRepository.findByEmail(request.getEmail());
        if (existing.isPresent()) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body("Cet email est déjà utilisé.");
        }

        // Créer le patient
        Patient patient = new Patient();
        patient.setFullName(request.getFullName());
        patient.setEmail(request.getEmail());
        patient.setPassword(request.getPassword()); // plus tard : hash avec BCrypt
        patient.setPhone(request.getPhone());
        patient.setAddress(request.getAddress());
        patient.setRegion(request.getRegion());

        Patient saved = patientRepository.save(patient);

        LoginResponse response = new LoginResponse(
                saved.getId(),
                saved.getFullName(),
                saved.getEmail(),
                "Inscription réussie"
        );

        return ResponseEntity.ok(response);
    }

    // ========= Connexion patient =========
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {

        Optional<Patient> existingOpt = patientRepository.findByEmail(request.getEmail());

        if (existingOpt.isEmpty()) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body("Email ou mot de passe incorrect.");
        }

        Patient existing = existingOpt.get();

        // Comparaison simple (plus tard : mot de passe hashé)
        if (!existing.getPassword().equals(request.getPassword())) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body("Email ou mot de passe incorrect.");
        }

        LoginResponse response = new LoginResponse(
                existing.getId(),
                existing.getFullName(),
                existing.getEmail(),
                "Connexion réussie"
        );

        return ResponseEntity.ok(response);
    }
}
