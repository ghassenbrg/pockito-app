package io.ghassen.pockito.core.storage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

/**
 * Creates the avatar bucket once the application is up.
 *
 * <p>Runs after startup rather than during it, and swallows failures, so Core still starts
 * when object storage is temporarily unavailable — the readiness probe reports the problem
 * and the next upload retries.
 */
@Component
public class ObjectStorageBootstrap {

    private static final Logger log = LoggerFactory.getLogger(ObjectStorageBootstrap.class);

    private final S3ObjectStorageService storage;

    public ObjectStorageBootstrap(S3ObjectStorageService storage) {
        this.storage = storage;
    }

    @EventListener(ApplicationReadyEvent.class)
    public void ensureBucket() {
        try {
            storage.ensureBucketExists();
        } catch (RuntimeException e) {
            log.warn("Could not prepare the object storage bucket at startup: {}", e.toString());
        }
    }
}
