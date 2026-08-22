package io.ghassen.pockito.web;

/**
 * Base type for failures that carry a stable, client-facing error code. Anything that is
 * not a {@code DomainException} is treated as a bug and reported as a generic 500 with no
 * internal detail leaked.
 */
public abstract class DomainException extends RuntimeException {

    private final String code;

    protected DomainException(String code, String message) {
        super(message);
        this.code = code;
    }

    protected DomainException(String code, String message, Throwable cause) {
        super(message, cause);
        this.code = code;
    }

    public String getCode() {
        return code;
    }
}
