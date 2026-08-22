package io.ghassen.pockito.mcp.config;

import io.ghassen.pockito.coreclient.CoreClient;
import org.springframework.boot.health.contributor.Health;
import org.springframework.boot.health.contributor.HealthIndicator;
import org.springframework.stereotype.Component;

/** Reports whether Pockito Core answers. Readiness only — restarting MCP cannot fix Core. */
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
