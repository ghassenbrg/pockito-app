package io.ghassen.pockito.core.storage;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * S3-compatible object storage configuration. Deliberately provider-neutral: the same
 * keys point at SeaweedFS in Kubernetes, MinIO locally, or a hosted S3 later.
 *
 * @param endpoint where the service itself reaches storage — inside the cluster this is a
 *     Kubernetes service DNS name that only resolves in-cluster.
 * @param publicEndpoint the origin a browser or phone uses for the same storage. Kept
 *     separate from {@code endpoint} because a SigV4 signature covers the {@code Host}
 *     header, so a pre-signed URL has to be signed for the host the client will actually
 *     request. Defaults to {@code endpoint} for single-network setups such as local
 *     development.
 */
@ConfigurationProperties(prefix = "pockito.storage")
public record ObjectStorageProperties(
        String endpoint,
        String publicEndpoint,
        String bucket,
        String accessKey,
        String secretKey,
        String region,
        Boolean pathStyleAccess,
        Duration presignedUrlValidity) {

    public ObjectStorageProperties {
        publicEndpoint = (publicEndpoint == null || publicEndpoint.isBlank()) ? endpoint : publicEndpoint;
        region = (region == null || region.isBlank()) ? "us-east-1" : region;
        pathStyleAccess = pathStyleAccess == null || pathStyleAccess;
        presignedUrlValidity = presignedUrlValidity == null ? Duration.ofMinutes(15) : presignedUrlValidity;
    }
}
