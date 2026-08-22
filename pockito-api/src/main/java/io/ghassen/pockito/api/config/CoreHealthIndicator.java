package io.ghassen.pockito.api.config;

import io.ghassen.pockito.coreclient.CoreClient;
import org.springframework.boot.health.contributor.Health;
import org.springframework.boot.health.contributor.HealthIndicator;
import org.springframework.stereotype.Component;

/**
 * Reports whether Pockito Core answers.
 *
 * <p>In the readiness group only: the API is useless without Core, so it should stop
 * taking traffic — but restarting the API would not fix a Core outage, so liveness is
 * unaffected.
 */
@Component("core")
public class CoreHealthIndicator implements HealthIndicator {

    private final CoreClient core;

    public CoreHealthIndicator(CoreClient core) {
        this.core = core;
    }

    @Override
    public Health health() {
        return core.isReachable() ? Health.up().build() : Health.down().build();
    }
}
