package io.ghassen.pockito.web;

/**
 * A downstream Pockito service or dependency could not be reached or timed out. Maps to
 * 503 so clients can distinguish "try again" from "your request was wrong".
 */
public class UpstreamUnavailableException extends DomainException {

    public UpstreamUnavailableException(String code, String message, Throwable cause) {
        super(code, message, cause);
    }
}
