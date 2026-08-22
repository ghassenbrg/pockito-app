package io.ghassen.pockito.web;

/** The request was well-formed but its content is not acceptable. Maps to 400. */
public class InvalidInputException extends DomainException {

    public InvalidInputException(String code, String message) {
        super(code, message);
    }
}
