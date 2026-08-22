package io.ghassen.pockito.coreclient;

import io.ghassen.pockito.contracts.ApiErrorResponse;
import io.ghassen.pockito.contracts.AvatarResponse;
import io.ghassen.pockito.contracts.BootstrapResponse;
import io.ghassen.pockito.contracts.CompleteOnboardingRequest;
import io.ghassen.pockito.contracts.PreferencesResponse;
import io.ghassen.pockito.contracts.ProfileResponse;
import io.ghassen.pockito.contracts.UpdatePreferencesRequest;
import io.ghassen.pockito.contracts.UpdateProfileRequest;
import io.ghassen.pockito.web.CorrelationId;
import io.ghassen.pockito.web.InvalidInputException;
import io.ghassen.pockito.web.ResourceNotFoundException;
import io.ghassen.pockito.web.UpstreamUnavailableException;
import tools.jackson.databind.ObjectMapper;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;

/**
 * The only way API talks to Core.
 *
 * <p>Two things happen on every call: the end user's access token is relayed so Core can
 * verify the identity itself, and the correlation id is propagated so one user action is
 * traceable across both services.
 *
 * <p>Core's errors already use the shared {@link ApiErrorResponse} shape, so they are
 * translated back into the matching exception rather than re-wrapped — a validation
 * failure in Core still reaches the client as a 400 with its original code.
 */
@Component
public class CoreClient {

    private final RestClient restClient;
    private final AccessTokenSupplier accessTokens;
    private final ObjectMapper objectMapper;

    public CoreClient(
            CoreClientProperties properties,
            RestClient.Builder builder,
            AccessTokenSupplier accessTokens,
            ObjectMapper objectMapper) {
        this.accessTokens = accessTokens;
        this.objectMapper = objectMapper;
        var factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout((int) properties.connectTimeout().toMillis());
        factory.setReadTimeout((int) properties.readTimeout().toMillis());
        this.restClient = builder.clone()
                .baseUrl(properties.baseUrl())
                .requestFactory(factory)
                .build();
    }

    public BootstrapResponse bootstrap() {
        return get("/internal/v1/bootstrap", BootstrapResponse.class);
    }

    public ProfileResponse profile() {
        return get("/internal/v1/profile", ProfileResponse.class);
    }

    public ProfileResponse updateProfile(UpdateProfileRequest request) {
        return put("/internal/v1/profile", request, ProfileResponse.class);
    }

    public PreferencesResponse preferences() {
        return get("/internal/v1/profile/preferences", PreferencesResponse.class);
    }

    public PreferencesResponse updatePreferences(UpdatePreferencesRequest request) {
        return put("/internal/v1/profile/preferences", request, PreferencesResponse.class);
    }

    public BootstrapResponse completeOnboarding(CompleteOnboardingRequest request) {
        return exchange(() -> restClient.post()
                .uri("/internal/v1/onboarding/complete")
                .headers(this::applyForwardedHeaders)
                .contentType(MediaType.APPLICATION_JSON)
                .body(request)
                .retrieve()
                .onStatus(HttpStatusCode::isError, this::translate)
                .body(BootstrapResponse.class));
    }

    public AvatarResponse uploadAvatar(byte[] content, String contentType) {
        return exchange(() -> restClient.post()
                .uri("/internal/v1/profile/avatar")
                .headers(this::applyForwardedHeaders)
                .contentType(MediaType.parseMediaType(contentType))
                .body(content)
                .retrieve()
                .onStatus(HttpStatusCode::isError, this::translate)
                .body(AvatarResponse.class));
    }

    public byte[] avatarBytes() {
        return exchange(() -> restClient.get()
                .uri("/internal/v1/profile/avatar")
                .headers(this::applyForwardedHeaders)
                .retrieve()
                .onStatus(HttpStatusCode::isError, this::translate)
                .body(byte[].class));
    }

    public void deleteAvatar() {
        exchange(() -> restClient.delete()
                .uri("/internal/v1/profile/avatar")
                .headers(this::applyForwardedHeaders)
                .retrieve()
                .onStatus(HttpStatusCode::isError, this::translate)
                .toBodilessEntity());
    }

    /** Cheap reachability check used by the readiness probe. */
    public boolean isReachable() {
        try {
            restClient.get().uri("/actuator/health/readiness").retrieve().toBodilessEntity();
            return true;
        } catch (RuntimeException e) {
            return false;
        }
    }

    private <T> T get(String uri, Class<T> type) {
        return exchange(() -> restClient.get()
                .uri(uri)
                .headers(this::applyForwardedHeaders)
                .retrieve()
                .onStatus(HttpStatusCode::isError, this::translate)
                .body(type));
    }

    private <T> T put(String uri, Object body, Class<T> type) {
        return exchange(() -> restClient.put()
                .uri(uri)
                .headers(this::applyForwardedHeaders)
                .contentType(MediaType.APPLICATION_JSON)
                .body(body)
                .retrieve()
                .onStatus(HttpStatusCode::isError, this::translate)
                .body(type));
    }

    private void applyForwardedHeaders(HttpHeaders headers) {
        headers.setBearerAuth(accessTokens.currentTokenValue());
        headers.set(CorrelationId.HEADER, CorrelationId.current());
    }

    /**
     * Converts transport failures into a 503 rather than letting them surface as a 500:
     * "Core is unreachable" is an operational condition clients can retry, not a bug in
     * the request.
     */
    private <T> T exchange(java.util.function.Supplier<T> call) {
        try {
            return call.get();
        } catch (ResourceAccessException e) {
            throw new UpstreamUnavailableException("core.unreachable", "Pockito Core is not reachable", e);
        }
    }

    /** Re-raises Core's error with its original code so it is not flattened into a 500. */
    private void translate(
            org.springframework.http.HttpRequest request,
            org.springframework.http.client.ClientHttpResponse response) throws java.io.IOException {
        HttpStatusCode status = response.getStatusCode();
        ApiErrorResponse error = readError(response);
        String code = error != null ? error.code() : "core.error";
        String message = error != null ? error.message() : "Pockito Core rejected the request";

        if (status.value() == 404) {
            throw new ResourceNotFoundException(code, message);
        }
        if (status.value() == 400 || status.value() == 422) {
            throw new InvalidInputException(code, message);
        }
        if (status.value() == 401 || status.value() == 403) {
            throw new org.springframework.security.access.AccessDeniedException(message);
        }
        throw new UpstreamUnavailableException(code, message, null);
    }

    private ApiErrorResponse readError(org.springframework.http.client.ClientHttpResponse response) {
        try (var body = response.getBody()) {
            byte[] bytes = body.readAllBytes();
            if (bytes.length == 0) {
                return null;
            }
            return objectMapper.readValue(bytes, ApiErrorResponse.class);
        } catch (Exception e) {
            return null;
        }
    }
}
