package io.ghassen.pockito.notifications;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * The delivery implementation used until a push provider is configured.
 *
 * <p>It records what would have been sent rather than pretending to send it. This is
 * deliberate: a fake "delivered" result would make an unconfigured deployment look healthy.
 * {@link #isConfigured()} reports the truth, and the health endpoint surfaces it.
 */
@Service
public class RecordingPushDeliveryService implements PushDeliveryService {

    private static final Logger log = LoggerFactory.getLogger(RecordingPushDeliveryService.class);

    private final NotificationProperties properties;

    public RecordingPushDeliveryService(NotificationProperties properties) {
        this.properties = properties;
    }

    @Override
    public void deliver(NotificationEnvelope event) {
        // Subject is a Keycloak UUID, not personal data; attributes never carry secrets.
        log.info("Notification ready for delivery: type={} subject={} attributes={} (no push provider configured)",
                event.type(), event.subject(), event.attributes());
    }

    @Override
    public boolean isConfigured() {
        return properties.push().isConfigured();
    }
}
