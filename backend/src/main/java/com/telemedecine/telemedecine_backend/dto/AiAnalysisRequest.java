package com.telemedecine.telemedecine_backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

public class AiAnalysisRequest {
    
    private String symptoms;
    private List<String> categories;

    @JsonProperty("image_url")
    private String imageUrl;

    @JsonProperty("image_base64")
    private String imageBase64;

    public AiAnalysisRequest() {
    }

    public AiAnalysisRequest(String symptoms, List<String> categories) {
        this.symptoms = symptoms;
        this.categories = categories;
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getImageBase64() {
        return imageBase64;
    }

    public void setImageBase64(String imageBase64) {
        this.imageBase64 = imageBase64;
    }
}
