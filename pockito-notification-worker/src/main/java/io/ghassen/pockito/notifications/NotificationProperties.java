package io.ghassen.pockito.notifications;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Stream and delivery settings.
 *
 * @param stream         Redis Stream key Core publishes to
 * @param consumerGroup  shared group name; every replica joins it so each event is
 *                       delivered to exactly one worker
 * @param consumerName   per-replica identity, defaulted from the pod name in Kubernetes
 * @param dedupeTtl      how long a processed event id is remembered, bounding the window
 *                       in which a redelivery is recognised as a duplicate
 */
@ConfigurationProperties(prefix = "pockito.notifications")
public record NotificationProperties(
        String stream,
        String consumerGroup,
        String consumerName,
        Duration dedupeTtl,
        Duration pollTimeout,
        Push push) {

    public NotificationProperties {
        stream = blankTo(stream, "pockito.notifications");
        consumerGroup = blankTo(consumerGroup, "pockito-notification-worker");
        consumerName = blankTo(consumerName, "worker-" + java.util.UUID.randomUUID());
        dedupeTtl = dedupeTtl == null ? Duration.ofHours(24) : dedupeTtl;
        pollTimeout = pollTimeout == null ? Duration.ofSeconds(2) : pollTimeout;
        push = push == null ? new Push(null, null) : push;
    }

    private static String blankTo(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }

    /**
     * Push provider configuration. Present and wired, but no credentials are shipped: until
     * a real FCM service account is configured, delivery is recorded rather than sent.
     */
    public record Push(String provider, String credentialsPath) {

        public Push {
            provider = blankTo(provider, "none");
        }

        public boolean isConfigured() {
            return !"none".equalsIgnoreCase(provider) && credentialsPath != null && !credentialsPath.isBlank();
        }
    }
}
