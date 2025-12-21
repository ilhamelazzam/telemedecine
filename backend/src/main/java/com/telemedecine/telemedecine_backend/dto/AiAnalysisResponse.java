package com.telemedecine.telemedecine_backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

public class AiAnalysisResponse {
    
    private String diagnosis;
    private String severity;
    private Double confidence;
    private List<String> recommendations;

    @JsonProperty("model_used")
    private String modelUsed;

    @JsonProperty("image_diagnosis")
    private String imageDiagnosis;

    @JsonProperty("image_confidence")
    private Double imageConfidence;

    public AiAnalysisResponse() {
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public Double getConfidence() {
        return confidence;
    }

    public void setConfidence(Double confidence) {
        this.confidence = confidence;
    }

    public List<String> getRecommendations() {
        return recommendations;
    }

    public void setRecommendations(List<String> recommendations) {
        this.recommendations = recommendations;
    }

    public String getModelUsed() {
        return modelUsed;
    }

    public void setModelUsed(String modelUsed) {
        this.modelUsed = modelUsed;
    }

    public String getImageDiagnosis() {
        return imageDiagnosis;
    }

    public void setImageDiagnosis(String imageDiagnosis) {
        this.imageDiagnosis = imageDiagnosis;
    }

    public Double getImageConfidence() {
        return imageConfidence;
    }

    public void setImageConfidence(Double imageConfidence) {
        this.imageConfidence = imageConfidence;
    }
}
