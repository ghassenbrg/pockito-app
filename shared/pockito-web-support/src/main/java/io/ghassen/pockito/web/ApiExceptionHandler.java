package io.ghassen.pockito.web;

import io.ghassen.pockito.contracts.ApiErrorResponse;
import jakarta.validation.ConstraintViolationException;
import java.time.Instant;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.NoHandlerFoundException;

/**
 * Turns every failure into the one {@link ApiErrorResponse} shape.
 *
 * <p>Two rules matter here: clients always get a stable {@code code} to branch on, and raw
 * exception text never reaches them — unexpected failures are logged in full and reported
 * as an opaque 500.
 */
@RestControllerAdvice
public class ApiExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(ApiExceptionHandler.class);

    @ExceptionHandler(InvalidInputException.class)
    public ResponseEntity<ApiErrorResponse> handleInvalidInput(InvalidInputException e) {
        return build(HttpStatus.BAD_REQUEST, e.getCode(), e.getMessage(), List.of());
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleNotFound(ResourceNotFoundException e) {
        return build(HttpStatus.NOT_FOUND, e.getCode(), e.getMessage(), List.of());
    }

    @ExceptionHandler(UpstreamUnavailableException.class)
    public ResponseEntity<ApiErrorResponse> handleUpstream(UpstreamUnavailableException e) {
        log.warn("Upstream unavailable [{}]: {}", e.getCode(), e.getMessage(), e);
        return build(HttpStatus.SERVICE_UNAVAILABLE, e.getCode(), e.getMessage(), List.of());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleBeanValidation(MethodArgumentNotValidException e) {
        List<ApiErrorResponse.FieldViolation> violations = e.getBindingResult().getFieldErrors().stream()
                .map(error -> new ApiErrorResponse.FieldViolation(error.getField(), error.getDefaultMessage()))
                .toList();
        return build(HttpStatus.BAD_REQUEST, "validation.failed", "Request validation failed", violations);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ApiErrorResponse> handleConstraintViolation(ConstraintViolationException e) {
        List<ApiErrorResponse.FieldViolation> violations = e.getConstraintViolations().stream()
                .map(violation -> new ApiErrorResponse.FieldViolation(
                        violation.getPropertyPath().toString(), violation.getMessage()))
                .toList();
        return build(HttpStatus.BAD_REQUEST, "validation.failed", "Request validation failed", violations);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiErrorResponse> handleUnreadableBody(HttpMessageNotReadableException e) {
        return build(HttpStatus.BAD_REQUEST, "request.malformed", "Request body could not be read", List.of());
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<ApiErrorResponse> handleUploadTooLarge(MaxUploadSizeExceededException e) {
        return build(HttpStatus.PAYLOAD_TOO_LARGE, "upload.too_large", "Uploaded file is too large", List.of());
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiErrorResponse> handleAccessDenied(AccessDeniedException e) {
        return build(HttpStatus.FORBIDDEN, "access.denied", "You are not allowed to perform this action", List.of());
    }

    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleNoHandler(NoHandlerFoundException e) {
        return build(HttpStatus.NOT_FOUND, "route.not_found", "No such endpoint", List.of());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiErrorResponse> handleUnexpected(Exception e) {
        log.error("Unhandled failure [correlationId={}]", CorrelationId.current(), e);
        return build(HttpStatus.INTERNAL_SERVER_ERROR, "internal.error", "Something went wrong", List.of());
    }

    private static ResponseEntity<ApiErrorResponse> build(
            HttpStatus status, String code, String message, List<ApiErrorResponse.FieldViolation> violations) {
        String correlationId = CorrelationId.current();
        var body = new ApiErrorResponse(
                status.value(), code, message, correlationId, Instant.now(), violations);
        return ResponseEntity.status(status)
                .header(CorrelationId.HEADER, correlationId)
                .body(body);
    }
}
