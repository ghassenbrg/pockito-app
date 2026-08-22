package io.ghassen.pockito.coreclient;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * How to reach Pockito Core. {@code baseUrl} is a Kubernetes service name, never a pod IP.
 */
@ConfigurationProperties(prefix = "pockito.core")
public record CoreClientProperties(String baseUrl, Duration connectTimeout, Duration readTimeout) {

    public CoreClientProperties {
        connectTimeout = connectTimeout == null ? Duration.ofSeconds(2) : connectTimeout;
        readTimeout = readTimeout == null ? Duration.ofSeconds(10) : readTimeout;
    }
}
