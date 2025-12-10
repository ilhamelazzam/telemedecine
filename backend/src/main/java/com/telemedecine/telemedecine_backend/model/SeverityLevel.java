package com.telemedecine.telemedecine_backend.model;

import java.util.Locale;

public enum SeverityLevel {
    LOW,
    MEDIUM,
    HIGH;

    public String getLabel() {
        return name().toLowerCase(Locale.ROOT);
    }
}
