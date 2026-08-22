package io.ghassen.pockito.core.storage;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * S3-compatible object storage configuration. Deliberately provider-neutral: the same
 * keys point at SeaweedFS in Kubernetes, MinIO locally, or a hosted S3 later.
 */
@ConfigurationProperties(prefix = "pockito.storage")
public record ObjectStorageProperties(
        String endpoint,
        String bucket,
        String accessKey,
        String secretKey,
        String region,
        Boolean pathStyleAccess,
        Duration presignedUrlValidity) {

    public ObjectStorageProperties {
        region = (region == null || region.isBlank()) ? "us-east-1" : region;
        pathStyleAccess = pathStyleAccess == null || pathStyleAccess;
        presignedUrlValidity = presignedUrlValidity == null ? Duration.ofMinutes(15) : presignedUrlValidity;
    }
}
