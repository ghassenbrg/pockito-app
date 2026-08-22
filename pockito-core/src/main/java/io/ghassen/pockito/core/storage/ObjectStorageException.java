package io.ghassen.pockito.core.storage;

/** Thrown when object storage is unreachable or rejects an operation. */
public class ObjectStorageException extends RuntimeException {

    public ObjectStorageException(String message, Throwable cause) {
        super(message, cause);
    }

    public ObjectStorageException(String message) {
        super(message);
    }
}
