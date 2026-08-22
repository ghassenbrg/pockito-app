package io.ghassen.pockito.contracts;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.time.Instant;
import java.util.List;

/**
 * The single error shape every Pockito HTTP surface returns.
 *
 * <p>{@code code} is a stable machine-readable token clients may branch on;
 * {@code message} is human-readable but not localised — clients translate from
 * {@code code}. {@code correlationId} matches the {@code X-Correlation-Id} response
 * header so a user-reported failure can be found in the logs.
 */
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public record ApiErrorResponse(
        int status,
        String code,
        String message,
        String correlationId,
        Instant timestamp,
        List<FieldViolation> violations) {

    public record FieldViolation(String field, String message) {
    }

    public static ApiErrorResponse of(int status, String code, String message, String correlationId) {
        return new ApiErrorResponse(status, code, message, correlationId, Instant.now(), List.of());
    }
}
