package io.ghassen.pockito.contracts;

public record PreferencesResponse(
        AppLanguage language,
        AppTheme theme,
        String defaultCurrency) {
}
