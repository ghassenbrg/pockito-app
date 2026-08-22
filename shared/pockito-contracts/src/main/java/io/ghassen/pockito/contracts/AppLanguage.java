package io.ghassen.pockito.contracts;

/**
 * Languages Pockito ships translations for.
 *
 * <p>Adding a language means adding a constant here plus the matching bundles in the
 * webapp ({@code i18n/locales}) and mobile ({@code lib/l10n}) apps. Nothing else in the
 * backend is language-aware.
 */
public enum AppLanguage {
    EN("en"),
    JA("ja");

    private final String tag;

    AppLanguage(String tag) {
        this.tag = tag;
    }

    /** BCP-47 language tag as used by the clients. */
    public String tag() {
        return tag;
    }

    public static AppLanguage fromTag(String tag) {
        if (tag == null || tag.isBlank()) {
            return EN;
        }
        String primary = tag.split("[-_]")[0].toLowerCase();
        for (AppLanguage language : values()) {
            if (language.tag.equals(primary)) {
                return language;
            }
        }
        return EN;
    }
}
