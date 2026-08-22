package io.ghassen.pockito.core.identity;

/**
 * The caller's identity as asserted by Keycloak, extracted from the validated access
 * token. Core never authenticates anyone itself — it only reads what the token proves.
 *
 * @param subject the Keycloak {@code sub} claim; the stable link between an identity and
 *                a Pockito profile, and the only identifier we persist
 */
public record AuthenticatedUser(String subject, String email, String preferredUsername) {
}
