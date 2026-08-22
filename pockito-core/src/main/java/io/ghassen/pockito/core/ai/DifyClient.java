package io.ghassen.pockito.core.ai;

import io.ghassen.pockito.web.UpstreamUnavailableException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

/**
 * Thin abstraction over the shared Dify deployment.
 *
 * <p>This phase deliberately stops at configuration, connectivity and a health probe — no
 * workflow calls yet. Everything AI-related in Pockito goes through this type, so adding
 * workflows later does not spread Dify knowledge through the domain.
 */
@Component
public class DifyClient {

    private static final Logger log = LoggerFactory.getLogger(DifyClient.class);

    private final DifyProperties properties;
    private final RestClient restClient;

    public DifyClient(DifyProperties properties, RestClient.Builder builder) {
        this.properties = properties;
        this.restClient = properties.enabled()
                ? builder.clone()
                        .baseUrl(properties.baseUrl())
                        .requestFactory(requestFactory(properties))
                        .defaultHeader(HttpHeaders.AUTHORIZATION, bearer(properties.apiKey()))
                        .build()
                : null;
    }

    /**
     * Bounded timeouts matter more here than anywhere else in Core: a hung AI call must not
     * pin a request thread indefinitely.
     */
    private static SimpleClientHttpRequestFactory requestFactory(DifyProperties properties) {
        var factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout((int) properties.connectTimeout().toMillis());
        factory.setReadTimeout((int) properties.readTimeout().toMillis());
        return factory;
    }

    private static String bearer(String apiKey) {
        return "Bearer " + (apiKey == null ? "" : apiKey);
    }

    public boolean isEnabled() {
        return properties.enabled();
    }

    /**
     * Round-trips Dify's unauthenticated health endpoint.
     *
     * @return {@code true} if Dify answered; {@code false} if it is disabled or unreachable
     */
    public boolean ping() {
        if (restClient == null) {
            return false;
        }
        try {
            restClient.get().uri("/health").retrieve().toBodilessEntity();
            return true;
        } catch (RestClientException e) {
            log.debug("Dify health check failed: {}", e.toString());
            return false;
        }
    }

    /**
     * Fails loudly rather than silently degrading, for callers that genuinely need Dify.
     * Nothing calls this yet; it exists so future AI features have one correct entry point.
     */
    public void requireAvailable() {
        if (!isEnabled()) {
            throw new UpstreamUnavailableException("dify.disabled", "Dify integration is disabled", null);
        }
        if (!ping()) {
            throw new UpstreamUnavailableException("dify.unreachable", "Dify is not reachable", null);
        }
    }
}
