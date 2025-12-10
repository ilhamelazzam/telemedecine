package com.telemedecine.telemedecine_backend.controller;

import com.telemedecine.telemedecine_backend.dto.AnalysisRequest;
import com.telemedecine.telemedecine_backend.dto.AnalysisResponse;
import com.telemedecine.telemedecine_backend.model.Analysis;
import com.telemedecine.telemedecine_backend.model.Patient;
import com.telemedecine.telemedecine_backend.repository.AnalysisRepository;
import com.telemedecine.telemedecine_backend.service.AnalysisService;
import com.telemedecine.telemedecine_backend.service.AuthService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/analysis")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:5173"})
public class AnalysisController {

    private final AuthService authService;
    private final AnalysisRepository analysisRepository;
    private final AnalysisService analysisService;

    public AnalysisController(AuthService authService,
                              AnalysisRepository analysisRepository,
                              AnalysisService analysisService) {
        this.authService = authService;
        this.analysisRepository = analysisRepository;
        this.analysisService = analysisService;
    }

    @PostMapping
    public ResponseEntity<?> submitAnalysis(@RequestHeader(value = "Authorization", required = false) String authorization,
                                            @RequestBody AnalysisRequest request) {
        Optional<Patient> patientOpt = resolvePatient(authorization);
        if (patientOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token invalide ou manquant.");
        }

        Analysis saved = analysisService.createAnalysis(patientOpt.get(), request);
        AnalysisResponse response = analysisService.toResponse(saved);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/history")
    public ResponseEntity<?> history(@RequestHeader(value = "Authorization", required = false) String authorization) {
        Optional<Patient> patientOpt = resolvePatient(authorization);
        if (patientOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token invalide ou manquant.");
        }

        List<Analysis> history = analysisRepository.findByPatientOrderByPerformedAtDesc(patientOpt.get());
        return ResponseEntity.ok(analysisService.toResponseList(history));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getById(@RequestHeader(value = "Authorization", required = false) String authorization,
                                     @PathVariable Long id) {
        Optional<Patient> patientOpt = resolvePatient(authorization);
        if (patientOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token invalide ou manquant.");
        }

        Optional<Analysis> analysisOpt = analysisRepository.findByIdAndPatient(id, patientOpt.get());
        if (analysisOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Analyse introuvable.");
        }

        return ResponseEntity.ok(analysisService.toResponse(analysisOpt.get()));
    }

    private Optional<Patient> resolvePatient(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            return Optional.empty();
        }
        String token = authorizationHeader.substring("Bearer ".length()).trim();
        return authService.findByToken(token);
    }
}
