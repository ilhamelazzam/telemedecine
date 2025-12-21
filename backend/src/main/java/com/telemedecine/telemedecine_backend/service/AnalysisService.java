package com.telemedecine.telemedecine_backend.service;

import com.telemedecine.telemedecine_backend.dto.AiAnalysisRequest;
import com.telemedecine.telemedecine_backend.dto.AiAnalysisResponse;
import com.telemedecine.telemedecine_backend.dto.AnalysisRequest;
import com.telemedecine.telemedecine_backend.dto.AnalysisResponse;
import com.telemedecine.telemedecine_backend.model.Analysis;
import com.telemedecine.telemedecine_backend.model.Notification;
import com.telemedecine.telemedecine_backend.model.Patient;
import com.telemedecine.telemedecine_backend.model.SeverityLevel;
import com.telemedecine.telemedecine_backend.repository.AnalysisRepository;
import com.telemedecine.telemedecine_backend.repository.NotificationRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class AnalysisService {

    private static final Logger log = LoggerFactory.getLogger(AnalysisService.class);

    private static final List<String> HIGH_SEVERITY_KEYWORDS = List.of(
            "essoufflement", "douleur thoracique", "perte de conscience", "saignement",
            "convulsions", "respiration difficile", "chute incontrôlée", "palpitation");

    private static final List<String> MEDIUM_SEVERITY_KEYWORDS = List.of(
            "fièvre", "toux", "maux de tête", "fatigue", "douleur", "vomissement",
            "nausée", "douleurs musculaires");

    private final AnalysisRepository analysisRepository;
    private final NotificationRepository notificationRepository;
    private final RestTemplate restTemplate;

    @Value("${ai.service.url:http://localhost:5000}")
    private String aiServiceUrl;

    @Value("${ai.service.enabled:true}")
    private boolean aiServiceEnabled;

    public AnalysisService(AnalysisRepository analysisRepository, NotificationRepository notificationRepository, RestTemplate restTemplate) {
        this.analysisRepository = analysisRepository;
        this.notificationRepository = notificationRepository;
        this.restTemplate = restTemplate;
    }

    public Analysis createAnalysis(Patient patient, AnalysisRequest request) {
        Analysis analysis = new Analysis();
        analysis.setPatient(patient);
        analysis.setSymptoms(normalizeText(request.getSymptoms()));
        List<String> categories = safeList(request.getCategories());
        analysis.setCategories(new ArrayList<>(categories));
        analysis.setImageUrl(request.getImageUrl());
        analysis.setPerformedAt(LocalDateTime.now());

        // Try AI service first, fallback to rule-based if unavailable
        if (aiServiceEnabled) {
            try {
                AiAnalysisResponse aiResponse = callAiService(analysis.getSymptoms(), categories, request.getImageUrl());
                if (aiResponse != null) {
                    analysis.setSeverity(mapSeverityFromAi(aiResponse.getSeverity()));
                    analysis.setDiagnosis(aiResponse.getDiagnosis());
                    analysis.setRecommendations(new ArrayList<>(safeList(aiResponse.getRecommendations())));
                    log.info("AI analysis successful. Model used: {}", aiResponse.getModelUsed());
                } else {
                    applyFallbackAnalysis(analysis, categories);
                }
            } catch (Exception e) {
                log.warn("AI service unavailable, using fallback analysis: {}", e.getMessage());
                applyFallbackAnalysis(analysis, categories);
            }
        } else {
            applyFallbackAnalysis(analysis, categories);
        }

        Analysis savedAnalysis = analysisRepository.save(analysis);
        
        // Create notification for the analysis
        createAnalysisNotification(patient, savedAnalysis);
        
        return savedAnalysis;
    }
    
    private void createAnalysisNotification(Patient patient, Analysis analysis) {
        String title;
        String message;
        String type;
        
        switch (analysis.getSeverity()) {
            case HIGH:
                title = "⚠️ Analyse terminée - Attention requise";
                message = "Votre analyse révèle des symptômes nécessitant une attention médicale. Diagnostic: " + analysis.getDiagnosis();
                type = "WARNING";
                break;
            case MEDIUM:
                title = "📋 Analyse terminée";
                message = "Votre analyse est disponible. Diagnostic: " + analysis.getDiagnosis();
                type = "INFO";
                break;
            default:
                title = "✅ Analyse terminée";
                message = "Votre analyse est disponible. Diagnostic: " + analysis.getDiagnosis();
                type = "SUCCESS";
                break;
        }
        
        Notification notification = new Notification(patient, title, message, type);
        notificationRepository.save(notification);
    }

    private AiAnalysisResponse callAiService(String symptoms, List<String> categories, String imageUrl) {
        try {
            AiAnalysisRequest aiRequest = new AiAnalysisRequest(symptoms, categories);
            if (imageUrl != null && !imageUrl.isBlank()) {
                aiRequest.setImageUrl(imageUrl);
            }

            String endpoint = (imageUrl != null && !imageUrl.isBlank()) 
                ? aiServiceUrl + "/api/ai/analyze-image"
                : aiServiceUrl + "/api/ai/analyze-symptoms";

            ResponseEntity<AiAnalysisResponse> response = restTemplate.postForEntity(
                endpoint,
                aiRequest,
                AiAnalysisResponse.class
            );

            return response.getBody();
        } catch (Exception e) {
            log.error("Failed to call AI service at {}: {}", aiServiceUrl, e.getMessage());
            throw e;
        }
    }

    private void applyFallbackAnalysis(Analysis analysis, List<String> categories) {
        SeverityLevel severity = evaluateSeverity(analysis.getSymptoms(), categories);
        analysis.setSeverity(severity);
        analysis.setDiagnosis(determineDiagnosis(severity));
        analysis.setRecommendations(new ArrayList<>(recommendationsForSeverity(severity)));
        log.info("Using fallback rule-based analysis");
    }

    private SeverityLevel mapSeverityFromAi(String aiSeverity) {
        if (aiSeverity == null) {
            return SeverityLevel.LOW;
        }
        String normalized = aiSeverity.toUpperCase()
            .replace("É", "E")
            .replace("È", "E");
        
        return switch (normalized) {
            case "HIGH", "ELEVEE", "ELEVE", "URGENT", "SEVERE" -> SeverityLevel.HIGH;
            case "MEDIUM", "MOYENNE", "MODEREE", "MODERE" -> SeverityLevel.MEDIUM;
            case "LOW", "FAIBLE", "BAS" -> SeverityLevel.LOW;
            default -> SeverityLevel.LOW;
        };
    }

    public AnalysisResponse toResponse(Analysis analysis) {
        return new AnalysisResponse(
                analysis.getId(),
                analysis.getPerformedAt(),
                analysis.getSymptoms(),
                new ArrayList<>(safeList(analysis.getCategories())),
                analysis.getSeverity().getLabel(),
                analysis.getDiagnosis(),
                new ArrayList<>(safeList(analysis.getRecommendations())),
                analysis.getImageUrl()
        );
    }

    public List<AnalysisResponse> toResponseList(List<Analysis> analyses) {
        return analyses.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    private SeverityLevel evaluateSeverity(String symptoms, List<String> categories) {
        String combined = Stream.concat(
                        Stream.of(symptoms),
                        categories == null ? Stream.empty() : categories.stream())
                .filter(Objects::nonNull)
                .map(String::toLowerCase)
                .collect(Collectors.joining(" "));

        if (containsKeyword(combined, HIGH_SEVERITY_KEYWORDS)) {
            return SeverityLevel.HIGH;
        }
        if (containsKeyword(combined, MEDIUM_SEVERITY_KEYWORDS)) {
            return SeverityLevel.MEDIUM;
        }
        return SeverityLevel.LOW;
    }

    private boolean containsKeyword(String source, List<String> keywords) {
        if (source == null || source.isBlank()) {
            return false;
        }
        return keywords.stream().anyMatch(source::contains);
    }

    private String determineDiagnosis(SeverityLevel severity) {
        return switch (severity) {
            case HIGH -> "Les signes peuvent indiquer une situation urgente, consultez un médecin sans délai.";
            case MEDIUM -> "Symptômes modérés : surveillez l'évolution et restez hydraté.";
            default -> "Symptômes légers : reposez-vous et gardez un œil sur l'évolution.";
        };
    }

    private List<String> recommendationsForSeverity(SeverityLevel severity) {
        return switch (severity) {
            case HIGH -> List.of(
                    "Contactez un professionnel de santé ou rendez-vous aux urgences.",
                    "Ne prenez aucun risque, demandez une aide médicale urgente.",
                    "Notez l'évolution des signes et les médicaments déjà pris."
            );
            case MEDIUM -> List.of(
                    "Restez hydraté(e) et reposez-vous.",
                    "Surveillez votre température et prenez un antalgique si nécessaire.",
                    "Consultez si les symptômes persistent plus de 48 h ou s'aggravent."
            );
            default -> List.of(
                    "Repos suffisant (7 à 8 h de sommeil).",
                    "Hydratez-vous régulièrement.",
                    "Évitez le stress et les efforts physiques intenses."
            );
        };
    }

    private List<String> safeList(List<String> values) {
        if (values == null) {
            return List.of();
        }
        return values.stream()
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toList());
    }

    private String normalizeText(String text) {
        if (text == null) {
            return "";
        }
        return text.trim();
    }
}
