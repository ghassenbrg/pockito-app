package io.ghassen.pockito.core.health;

import io.ghassen.pockito.core.ai.DifyClient;
import org.springframework.boot.health.contributor.Health;
import org.springframework.boot.health.contributor.HealthIndicator;
import org.springframework.stereotype.Component;

/**
 * Reports Dify connectivity for operators.
 *
 * <p>Deliberately excluded from both the liveness and readiness groups: Pockito's
 * foundation works without AI, so Dify being down must not take Core out of rotation.
 */
@Component("dify")
public class DifyHealthIndicator implements HealthIndicator {

    private final DifyClient dify;

    public DifyHealthIndicator(DifyClient dify) {
        this.dify = dify;
    }

    @Override
    public Health health() {
        if (!dify.isEnabled()) {
            return Health.up().withDetail("state", "disabled").build();
        }
        return dify.ping()
                ? Health.up().withDetail("state", "reachable").build()
                : Health.down().withDetail("state", "unreachable").build();
    }
}
