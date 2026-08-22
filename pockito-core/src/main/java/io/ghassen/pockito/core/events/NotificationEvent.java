package io.ghassen.pockito.core.events;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;

/**
 * An event Core hands to the notification pipeline.
 *
 * <p>{@code eventId} exists so the worker can process at-least-once delivery safely: a
 * redelivered event carries the same id and is skipped.
 *
 * @param type      dotted event name, e.g. {@code profile.onboarding.completed}
 * @param subject   the Keycloak subject the notification concerns
 * @param attributes free-form, string-valued payload; must never carry secrets or tokens
 */
public record NotificationEvent(
        String eventId,
        String type,
        String subject,
        Instant occurredAt,
        Map<String, String> attributes) {

    public static NotificationEvent of(String type, String subject, Map<String, String> attributes) {
        return new NotificationEvent(
                UUID.randomUUID().toString(), type, subject, Instant.now(), Map.copyOf(attributes));
    }
}
