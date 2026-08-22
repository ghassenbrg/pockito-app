package io.ghassen.pockito.core.ai;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Connection settings for the shared Dify instance already running in the cluster.
 *
 * <p>{@code baseUrl} points at the in-cluster service, not the public hostname, so AI
 * traffic never leaves the cluster.
 */
@ConfigurationProperties(prefix = "pockito.dify")
public record DifyProperties(
        boolean enabled,
        String baseUrl,
        String apiKey,
        Duration connectTimeout,
        Duration readTimeout) {

    public DifyProperties {
        connectTimeout = connectTimeout == null ? Duration.ofSeconds(3) : connectTimeout;
        readTimeout = readTimeout == null ? Duration.ofSeconds(15) : readTimeout;
    }
}
