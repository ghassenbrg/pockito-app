package io.ghassen.pockito.core.health;

import io.ghassen.pockito.core.storage.ObjectStorageProperties;
import io.ghassen.pockito.core.storage.ObjectStorageService;
import org.springframework.boot.health.contributor.Health;
import org.springframework.boot.health.contributor.HealthIndicator;
import org.springframework.stereotype.Component;

/**
 * Reports whether the configured bucket is reachable.
 *
 * <p>Part of the readiness group, not liveness: if SeaweedFS is briefly down, Core should
 * stop taking traffic but must not be restarted.
 */
@Component("objectStorage")
public class ObjectStorageHealthIndicator implements HealthIndicator {

    private final ObjectStorageService storage;
    private final ObjectStorageProperties properties;

    public ObjectStorageHealthIndicator(ObjectStorageService storage, ObjectStorageProperties properties) {
        this.storage = storage;
        this.properties = properties;
    }

    @Override
    public Health health() {
        boolean available = storage.isAvailable();
        var builder = available ? Health.up() : Health.down();
        // Endpoint and bucket are safe to expose; credentials deliberately are not.
        return builder
                .withDetail("endpoint", properties.endpoint())
                .withDetail("bucket", properties.bucket())
                .build();
    }
}
