package io.ghassen.pockito.notifications;

import java.util.Map;

/**
 * A stream record decoded into the fields the worker cares about.
 *
 * @param eventId the publisher-assigned id used for de-duplication; distinct from the
 *                Redis record id, which changes on redelivery to another consumer
 */
public record NotificationEnvelope(String eventId, String type, String subject, Map<String, String> attributes) {

    public static NotificationEnvelope from(Map<String, String> body) {
        String eventId = body.get("eventId");
        String type = body.get("type");
        String subject = body.get("subject");
        if (eventId == null || type == null || subject == null) {
            throw new IllegalArgumentException("Stream record is missing eventId, type or subject");
        }
        Map<String, String> attributes = new java.util.HashMap<>(body);
        attributes.keySet().removeAll(java.util.Set.of("eventId", "type", "subject", "occurredAt"));
        return new NotificationEnvelope(eventId, type, subject, Map.copyOf(attributes));
    }
}
