package io.ghassen.pockito.contracts;

import java.time.Instant;

/**
 * The Pockito-side profile of an authenticated user.
 *
 * <p>Identity fields ({@code subject}, {@code email}) originate from Keycloak and are
 * mirrored here for convenience; Keycloak remains their owner.
 */
public record ProfileResponse(
        String subject,
        String email,
        String displayName,
        String avatarUrl,
        boolean onboardingCompleted,
        Instant createdAt,
        Instant updatedAt) {
}
