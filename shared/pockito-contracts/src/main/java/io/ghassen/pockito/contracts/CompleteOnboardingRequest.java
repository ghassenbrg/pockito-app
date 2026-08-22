package io.ghassen.pockito.contracts;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * Submitted once, at the end of the onboarding flow. Carries the same fields the
 * individual profile/preferences endpoints accept so a client can complete onboarding in
 * a single call rather than three.
 */
public record CompleteOnboardingRequest(
        @NotBlank
        @Size(min = 1, max = 80)
        String displayName,
        @NotNull
        @Valid
        UpdatePreferencesRequest preferences) {
}
