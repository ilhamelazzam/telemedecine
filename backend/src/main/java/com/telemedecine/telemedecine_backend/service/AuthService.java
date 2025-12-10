package com.telemedecine.telemedecine_backend.service;

import com.telemedecine.telemedecine_backend.dto.LoginRequest;
import com.telemedecine.telemedecine_backend.dto.RegisterPatientRequest;
import com.telemedecine.telemedecine_backend.model.Patient;
import com.telemedecine.telemedecine_backend.repository.PatientRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.Locale;
import java.util.Optional;
import java.util.UUID;

@Service
public class AuthService {

    private final PatientRepository patientRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(PatientRepository patientRepository, PasswordEncoder passwordEncoder) {
        this.patientRepository = patientRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public Patient register(RegisterPatientRequest request) {
        var email = normalizeEmail(request.getEmail());

        if (patientRepository.findByEmail(email).isPresent()) {
            throw new IllegalArgumentException("Cet email est déjà utilisé.");
        }
        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new IllegalArgumentException("Mot de passe requis.");
        }

        var names = splitName(request);

        Patient patient = new Patient();
        patient.setFirstName(names.firstName());
        patient.setLastName(names.lastName());
        patient.setEmail(email);
        patient.setPassword(passwordEncoder.encode(request.getPassword()));
        patient.setPhone(request.getPhone());
        patient.setAddress(request.getAddress());
        patient.setRegion(request.getRegion());
        patient.setAuthToken(generateToken());
        patient.setResetCode(null);
        patient.setResetCodeExpiry(null);

        return patientRepository.save(patient);
    }

    @Transactional
    public Patient login(LoginRequest request) {
        var email = normalizeEmail(request.getEmail());

        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new IllegalArgumentException("Mot de passe requis.");
        }

        Patient patient = patientRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Email ou mot de passe incorrect."));

        if (!passwordEncoder.matches(request.getPassword(), patient.getPassword())) {
            throw new IllegalArgumentException("Email ou mot de passe incorrect.");
        }

        patient.setAuthToken(generateToken());

        return patientRepository.save(patient);
    }

    @Transactional
    public Patient updatePassword(Patient patient, String newPassword) {
        if (newPassword == null || newPassword.isBlank()) {
            throw new IllegalArgumentException("Mot de passe requis.");
        }
        patient.setPassword(passwordEncoder.encode(newPassword));
        patient.setAuthToken(generateToken());
        patient.setResetCode(null);
        patient.setResetCodeExpiry(null);
        return patientRepository.save(patient);
    }

    public Optional<Patient> findByToken(String token) {
        if (token == null) {
            return Optional.empty();
        }
        return patientRepository.findByAuthToken(token);
    }

    public Optional<Patient> findByEmail(String email) {
        if (email == null || email.isBlank()) {
            return Optional.empty();
        }
        return patientRepository.findByEmail(normalizeEmail(email));
    }

    private String normalizeEmail(String email) {
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("Email est requis.");
        }
        return email.trim().toLowerCase(Locale.ROOT);
    }

    private NameParts splitName(RegisterPatientRequest request) {
        String firstName = request.getFirstName();
        String lastName = request.getLastName();

        if (firstName != null && !firstName.isBlank() && lastName != null && !lastName.isBlank()) {
            return new NameParts(firstName.trim(), lastName.trim());
        }

        String fullName = request.getFullName();
        if (fullName == null || fullName.isBlank()) {
            return new NameParts("Utilisateur", "Telemedecine");
        }

        String[] parts = fullName.trim().split("\\s+");
        if (parts.length == 1) {
            return new NameParts(parts[0], "");
        }

        String first = parts[0];
        String last = String.join(" ", Arrays.copyOfRange(parts, 1, parts.length));

        return new NameParts(first, last);
    }

    private String generateToken() {
        return UUID.randomUUID().toString();
    }

    private record NameParts(String firstName, String lastName) {
    }
}
