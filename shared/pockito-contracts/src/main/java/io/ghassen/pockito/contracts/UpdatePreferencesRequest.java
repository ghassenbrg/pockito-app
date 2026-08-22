package io.ghassen.pockito.contracts;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public record UpdatePreferencesRequest(
        @NotNull
        AppLanguage language,
        @NotNull
        AppTheme theme,
        @NotNull
        @Pattern(regexp = "[A-Z]{3}", message = "must be a 3-letter ISO 4217 code")
        String defaultCurrency) {
}
