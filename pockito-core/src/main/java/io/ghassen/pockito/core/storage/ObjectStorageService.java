package io.ghassen.pockito.core.storage;

import java.time.Duration;
import java.util.Optional;

/**
 * Provider-neutral object storage.
 *
 * <p>The only implementation today talks the S3 API to SeaweedFS, but nothing above this
 * interface knows that. Swapping in Ceph RGW, AWS S3 or R2 is a configuration change plus
 * a different {@link ObjectStorageService} bean — no domain code moves.
 */
public interface ObjectStorageService {

    StoredObject putObject(String key, byte[] content, String contentType);

    Optional<byte[]> getObject(String key);

    void deleteObject(String key);

    /**
     * A time-limited URL that lets a client fetch the object directly, so avatar bytes do
     * not have to be proxied through the API on every page load.
     */
    String createPresignedUrl(String key, Duration validity);

    /** Cheap round-trip used by the readiness probe. */
    boolean isAvailable();
}
