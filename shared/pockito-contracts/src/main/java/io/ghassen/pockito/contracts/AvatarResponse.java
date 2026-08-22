package io.ghassen.pockito.contracts;

/**
 * Where a stored avatar lives. {@code url} is a short-lived pre-signed URL the client can
 * load directly; {@code objectKey} is the stable object-storage key behind it.
 */
public record AvatarResponse(String objectKey, String url, String contentType, long sizeBytes) {
}
