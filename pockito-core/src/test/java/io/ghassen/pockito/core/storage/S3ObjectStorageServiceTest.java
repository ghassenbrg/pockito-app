package io.ghassen.pockito.core.storage;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Duration;
import org.junit.jupiter.api.Test;

/**
 * Pre-signing is a purely local computation, so these run without any storage backend.
 *
 * <p>What they guard is the split that broke avatars in the browser: the URL a client is
 * handed must name the public host, because the SigV4 signature is computed over it.
 */
class S3ObjectStorageServiceTest {

    private static final String INTERNAL = "http://pockito-seaweedfs-s3.pockito.svc.cluster.local:8333";
    private static final String PUBLIC = "https://files.pockito.ghassen.io";

    @Test
    void presignsAgainstThePublicEndpoint() {
        var service = new S3ObjectStorageService(properties(PUBLIC));

        String url = service.createPresignedUrl("avatars/abc/def.jpg", Duration.ofMinutes(15));

        assertThat(url).startsWith(PUBLIC + "/pockito/avatars/abc/def.jpg");
        assertThat(url).doesNotContain("svc.cluster.local");
        assertThat(url).contains("X-Amz-Signature=");
    }

    @Test
    void fallsBackToTheInternalEndpointWhenNoPublicOneIsConfigured() {
        var service = new S3ObjectStorageService(properties(null));

        String url = service.createPresignedUrl("avatars/abc/def.jpg", Duration.ofMinutes(15));

        assertThat(url).startsWith(INTERNAL + "/pockito/avatars/abc/def.jpg");
    }

    @Test
    void blankPublicEndpointIsTreatedAsAbsent() {
        assertThat(properties("   ").publicEndpoint()).isEqualTo(INTERNAL);
    }

    @Test
    void reusesOneUrlSoTheClientCanCacheTheObject() {
        var service = new S3ObjectStorageService(properties(PUBLIC));

        String first = service.createPresignedUrl("avatars/abc/def.jpg", Duration.ofHours(1));
        String second = service.createPresignedUrl("avatars/abc/def.jpg", Duration.ofHours(1));

        // Byte-identical, signature and all: an HTTP cache is keyed on the whole URL, so
        // anything less than exact equality is a fresh download.
        assertThat(second).isEqualTo(first);
    }

    @Test
    void signsEachObjectSeparately() {
        var service = new S3ObjectStorageService(properties(PUBLIC));

        String one = service.createPresignedUrl("avatars/abc/one.jpg", Duration.ofHours(1));
        String two = service.createPresignedUrl("avatars/abc/two.jpg", Duration.ofHours(1));

        assertThat(one).isNotEqualTo(two);
    }

    private static ObjectStorageProperties properties(String publicEndpoint) {
        return new ObjectStorageProperties(
                INTERNAL,
                publicEndpoint,
                "pockito",
                "key",
                "secret",
                "us-east-1",
                true,
                "private, max-age=31536000, immutable",
                Duration.ofHours(1));
    }
}
