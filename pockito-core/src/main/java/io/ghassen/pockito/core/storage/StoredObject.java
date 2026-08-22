package io.ghassen.pockito.core.storage;

/** Metadata for an object that lives in object storage. */
public record StoredObject(String key, String contentType, long sizeBytes) {
}
