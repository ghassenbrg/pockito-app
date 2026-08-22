package io.ghassen.pockito.core.storage;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * S3-compatible object storage configuration. Deliberately provider-neutral: the same
 * keys point at SeaweedFS in Kubernetes, MinIO locally, or a hosted S3 later.
 *
 * @param endpoint where the service itself reaches storage — inside the cluster this is a
 *     Kubernetes service DNS name that only resolves in-cluster.
 * @param objectCacheControl the {@code Cache-Control} written onto every stored object.
 *     Safe to make long-lived because keys are never reused: every upload writes a new key
 *     and the old object is deleted, so the bytes at a given key never change.
 * @param presignedUrlValidity how long a pre-signed URL works for. It is also the ceiling
 *     on client caching — a URL is reused for half of it, and a client can only cache what
 *     it can address, so a shorter validity means more re-downloads and a narrower window
 *     for a leaked URL. That trade is the reason this is configuration and not a constant.
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
        String objectCacheControl,
        Duration presignedUrlValidity) {

    public ObjectStorageProperties {
        publicEndpoint = (publicEndpoint == null || publicEndpoint.isBlank()) ? endpoint : publicEndpoint;
        region = (region == null || region.isBlank()) ? "us-east-1" : region;
        pathStyleAccess = pathStyleAccess == null || pathStyleAccess;
        // "private" rather than "public": the bytes belong to one user, so only their own
        // browser should hold a copy, never a shared proxy.
        objectCacheControl = (objectCacheControl == null || objectCacheControl.isBlank())
                ? "private, max-age=31536000, immutable"
                : objectCacheControl;
        presignedUrlValidity = presignedUrlValidity == null ? Duration.ofHours(1) : presignedUrlValidity;
    }
}
