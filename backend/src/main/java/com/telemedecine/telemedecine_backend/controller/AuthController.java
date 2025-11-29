package com.telemedecine.telemedecine_backend.controller;

import com.telemedecine.telemedecine_backend.dto.LoginRequest;
import com.telemedecine.telemedecine_backend.dto.LoginResponse;
import com.telemedecine.telemedecine_backend.dto.RegisterPatientRequest;
import com.telemedecine.telemedecine_backend.dto.ResetRequest;
import com.telemedecine.telemedecine_backend.dto.VerifyCodeRequest;
import com.telemedecine.telemedecine_backend.dto.ResetPasswordRequest;
import com.telemedecine.telemedecine_backend.model.Patient;
import com.telemedecine.telemedecine_backend.repository.PatientRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:5173"}) // pour ton futur frontend React (dev)
public class AuthController {

    private static final Logger log = LoggerFactory.getLogger(AuthController.class);

    private final PatientRepository patientRepository;
    private final JavaMailSender mailSender;

    @Value("${app.mail.from:no-reply@telemedecine.local}")
    private String fromEmail;

    public AuthController(PatientRepository patientRepository, JavaMailSender mailSender) {
        this.patientRepository = patientRepository;
        this.mailSender = mailSender;
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

    // ========= Demande de reset (envoie code) =========
    @PostMapping("/reset-request")
    public ResponseEntity<?> resetRequest(@RequestBody ResetRequest request) {
        Optional<Patient> patientOpt = patientRepository.findByEmail(request.getEmail());
        if (patientOpt.isEmpty()) {
            // Ne pas révéler si l'email existe en prod — ici on renvoie erreur pour le dev
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Email introuvable.");
        }

        Patient patient = patientOpt.get();
        // Générer un code 6 chiffres
        String code = String.format("%06d", new Random().nextInt(1_000_000));
        patient.setResetCode(code);
        patient.setResetCodeExpiry(LocalDateTime.now().plusMinutes(15));
        patientRepository.save(patient);

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(patient.getEmail());
            message.setFrom(fromEmail);
            message.setSubject("Code de réinitialisation - TeleMedecine");
            message.setText("Votre code de réinitialisation est : " + code + "\nIl expire dans 15 minutes.");
            mailSender.send(message);
        } catch (MailException e) {
            log.error("Impossible d'envoyer le code à {}", patient.getEmail(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Impossible d'envoyer le code. Réessaie plus tard.");
        }

        return ResponseEntity.ok("Code envoyé à " + patient.getEmail());
    }

    // ========= Vérifier le code =========
    @PostMapping("/verify-code")
    public ResponseEntity<?> verifyCode(@RequestBody VerifyCodeRequest request) {
        Optional<Patient> patientOpt = patientRepository.findByEmail(request.getEmail());
        if (patientOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Email introuvable.");
        }
        Patient patient = patientOpt.get();
        if (patient.getResetCode() == null || !patient.getResetCode().equals(request.getCode())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Code invalide.");
        }
        if (patient.getResetCodeExpiry() == null || patient.getResetCodeExpiry().isBefore(LocalDateTime.now())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Code expiré.");
        }
        return ResponseEntity.ok("Code valide");
    }

    // ========= Reset password avec code =========
    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody ResetPasswordRequest request) {
        Optional<Patient> patientOpt = patientRepository.findByEmail(request.getEmail());
        if (patientOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Email introuvable.");
        }
        Patient patient = patientOpt.get();
        if (patient.getResetCode() == null || !patient.getResetCode().equals(request.getCode())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Code invalide.");
        }
        if (patient.getResetCodeExpiry() == null || patient.getResetCodeExpiry().isBefore(LocalDateTime.now())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Code expiré.");
        }

        // Mettre à jour le mot de passe
        patient.setPassword(request.getNewPassword()); // plus tard: hash
        // Effacer le code
        patient.setResetCode(null);
        patient.setResetCodeExpiry(null);
        patientRepository.save(patient);

        return ResponseEntity.ok("Mot de passe réinitialisé");
    }
}
