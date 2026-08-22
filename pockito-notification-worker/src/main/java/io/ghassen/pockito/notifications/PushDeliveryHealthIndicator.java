package io.ghassen.pockito.notifications;

import org.springframework.boot.health.contributor.Health;
import org.springframework.boot.health.contributor.HealthIndicator;
import org.springframework.stereotype.Component;

/**
 * Reports whether a real push provider is configured.
 *
 * <p>Reported as UP either way — the worker functions correctly without one — but the
 * detail makes an unconfigured deployment visible instead of silently swallowing pushes.
 */
@Component("pushDelivery")
public class PushDeliveryHealthIndicator implements HealthIndicator {

    private final PushDeliveryService pushDelivery;
    private final NotificationProperties properties;

    public PushDeliveryHealthIndicator(PushDeliveryService pushDelivery, NotificationProperties properties) {
        this.pushDelivery = pushDelivery;
        this.properties = properties;
    }

    @Override
    public Health health() {
        return Health.up()
                .withDetail("provider", properties.push().provider())
                .withDetail("configured", pushDelivery.isConfigured())
                .build();
    }
}
