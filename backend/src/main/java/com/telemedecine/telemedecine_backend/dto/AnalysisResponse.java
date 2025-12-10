package com.telemedecine.telemedecine_backend.dto;

import java.time.LocalDateTime;
import java.util.List;

public class AnalysisResponse {

    private Long id;
    private LocalDateTime date;
    private String symptoms;
    private List<String> categories;
    private String severity;
    private String diagnosis;
    private List<String> recommendations;
    private String imageUrl;

    public AnalysisResponse() {
    }

    public AnalysisResponse(Long id, LocalDateTime date, String symptoms, List<String> categories,
                            String severity, String diagnosis, List<String> recommendations, String imageUrl) {
        this.id = id;
        this.date = date;
        this.symptoms = symptoms;
        this.categories = categories;
        this.severity = severity;
        this.diagnosis = diagnosis;
        this.recommendations = recommendations;
        this.imageUrl = imageUrl;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public String getSymptoms() {
        return symptoms;
    }

    public void setSymptoms(String symptoms) {
        this.symptoms = symptoms;
    }

    public List<String> getCategories() {
        return categories;
    }

    public void setCategories(List<String> categories) {
        this.categories = categories;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public List<String> getRecommendations() {
        return recommendations;
    }

    public void setRecommendations(List<String> recommendations) {
        this.recommendations = recommendations;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
