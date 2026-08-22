package io.ghassen.pockito.contracts;

import java.util.List;

/**
 * Everything a client needs on start-up: who it is talking to, that user's profile and
 * preferences, and whether onboarding still has to run.
 *
 * <p>Both the mobile app and the webapp initialise from this single response so the two
 * clients cannot drift apart.
 */
public record BootstrapResponse(
        ProfileResponse profile,
        PreferencesResponse preferences,
        boolean onboardingRequired,
        List<String> supportedLanguages,
        List<String> supportedCurrencies) {
}
