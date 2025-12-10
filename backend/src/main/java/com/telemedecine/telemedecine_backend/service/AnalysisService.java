package com.telemedecine.telemedecine_backend.service;

import com.telemedecine.telemedecine_backend.dto.AnalysisRequest;
import com.telemedecine.telemedecine_backend.dto.AnalysisResponse;
import com.telemedecine.telemedecine_backend.model.Analysis;
import com.telemedecine.telemedecine_backend.model.Patient;
import com.telemedecine.telemedecine_backend.model.SeverityLevel;
import com.telemedecine.telemedecine_backend.repository.AnalysisRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class AnalysisService {

    private static final List<String> HIGH_SEVERITY_KEYWORDS = List.of(
            "essoufflement", "douleur thoracique", "perte de conscience", "saignement",
            "convulsions", "respiration difficile", "chute incontrôlée", "palpitation");

    private static final List<String> MEDIUM_SEVERITY_KEYWORDS = List.of(
            "fièvre", "toux", "maux de tête", "fatigue", "douleur", "vomissement",
            "nausée", "douleurs musculaires");

    private final AnalysisRepository analysisRepository;

    public AnalysisService(AnalysisRepository analysisRepository) {
        this.analysisRepository = analysisRepository;
    }

    public Analysis createAnalysis(Patient patient, AnalysisRequest request) {
        Analysis analysis = new Analysis();
        analysis.setPatient(patient);
        analysis.setSymptoms(normalizeText(request.getSymptoms()));
        List<String> categories = safeList(request.getCategories());
        analysis.setCategories(new ArrayList<>(categories));

        SeverityLevel severity = evaluateSeverity(analysis.getSymptoms(), categories);
        analysis.setSeverity(severity);
        analysis.setDiagnosis(determineDiagnosis(severity));
        analysis.setRecommendations(new ArrayList<>(recommendationsForSeverity(severity)));
        analysis.setImageUrl(request.getImageUrl());
        analysis.setPerformedAt(LocalDateTime.now());

        return analysisRepository.save(analysis);
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
