package io.ghassen.pockito.web;

/** The addressed resource does not exist for this caller. Maps to 404. */
public class ResourceNotFoundException extends DomainException {

    public ResourceNotFoundException(String code, String message) {
        super(code, message);
    }
}
