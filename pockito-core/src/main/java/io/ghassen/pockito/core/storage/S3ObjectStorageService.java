package io.ghassen.pockito.core.storage;

import java.net.URI;
import java.time.Duration;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.s3.model.CreateBucketRequest;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.HeadBucketRequest;
import software.amazon.awssdk.services.s3.model.NoSuchBucketException;
import software.amazon.awssdk.services.s3.model.NoSuchKeyException;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.GetObjectPresignRequest;

/**
 * S3-API implementation of {@link ObjectStorageService}, currently pointed at SeaweedFS.
 *
 * <p>Uses path-style addressing by default because SeaweedFS (like MinIO) does not serve
 * virtual-host-style bucket subdomains.
 *
 * <p>Reads and writes go to {@code endpoint}; pre-signed URLs are signed for
 * {@code publicEndpoint}, because the client redeeming one is outside the cluster.
 */
@Service
public class S3ObjectStorageService implements ObjectStorageService {

    private static final Logger log = LoggerFactory.getLogger(S3ObjectStorageService.class);

    private final S3Client client;
    private final S3Presigner presigner;
    private final ObjectStorageProperties properties;

    public S3ObjectStorageService(ObjectStorageProperties properties) {
        this.properties = properties;
        var credentials = StaticCredentialsProvider.create(
                AwsBasicCredentials.create(properties.accessKey(), properties.secretKey()));
        var serviceConfiguration = S3Configuration.builder()
                .pathStyleAccessEnabled(properties.pathStyleAccess())
                .chunkedEncodingEnabled(false)
                .build();

        this.client = S3Client.builder()
                .endpointOverride(URI.create(properties.endpoint()))
                .credentialsProvider(credentials)
                .region(Region.of(properties.region()))
                .serviceConfiguration(serviceConfiguration)
                .build();
        // Signed for the public origin, not the one Core dials: a SigV4 signature covers the
        // Host header, so a URL signed for the in-cluster service name is rejected the moment
        // a browser requests it through the ingress under its public name.
        this.presigner = S3Presigner.builder()
                .endpointOverride(URI.create(properties.publicEndpoint()))
                .credentialsProvider(credentials)
                .region(Region.of(properties.region()))
                .serviceConfiguration(serviceConfiguration)
                .build();
    }

    /**
     * Creates the configured bucket if it is missing. SeaweedFS starts with no buckets, so
     * a fresh volume would otherwise fail the first upload.
     */
    public void ensureBucketExists() {
        try {
            client.headBucket(HeadBucketRequest.builder().bucket(properties.bucket()).build());
        } catch (NoSuchBucketException e) {
            log.info("Creating object storage bucket '{}'", properties.bucket());
            client.createBucket(CreateBucketRequest.builder().bucket(properties.bucket()).build());
        } catch (S3Exception e) {
            if (e.statusCode() == 404) {
                log.info("Creating object storage bucket '{}'", properties.bucket());
                client.createBucket(CreateBucketRequest.builder().bucket(properties.bucket()).build());
            } else {
                throw new ObjectStorageException("Could not verify bucket " + properties.bucket(), e);
            }
        }
    }

    @Override
    public StoredObject putObject(String key, byte[] content, String contentType) {
        try {
            client.putObject(
                    PutObjectRequest.builder()
                            .bucket(properties.bucket())
                            .key(key)
                            .contentType(contentType)
                            .contentLength((long) content.length)
                            .build(),
                    RequestBody.fromBytes(content));
            return new StoredObject(key, contentType, content.length);
        } catch (S3Exception e) {
            throw new ObjectStorageException("Failed to store object " + key, e);
        }
    }

    @Override
    public Optional<byte[]> getObject(String key) {
        try {
            ResponseBytes<GetObjectResponse> response = client.getObjectAsBytes(
                    GetObjectRequest.builder().bucket(properties.bucket()).key(key).build());
            return Optional.of(response.asByteArray());
        } catch (NoSuchKeyException e) {
            return Optional.empty();
        } catch (S3Exception e) {
            if (e.statusCode() == 404) {
                return Optional.empty();
            }
            throw new ObjectStorageException("Failed to read object " + key, e);
        }
    }

    @Override
    public void deleteObject(String key) {
        try {
            client.deleteObject(DeleteObjectRequest.builder().bucket(properties.bucket()).key(key).build());
        } catch (S3Exception e) {
            throw new ObjectStorageException("Failed to delete object " + key, e);
        }
    }

    @Override
    public String createPresignedUrl(String key, Duration validity) {
        var presigned = presigner.presignGetObject(GetObjectPresignRequest.builder()
                .signatureDuration(validity)
                .getObjectRequest(GetObjectRequest.builder()
                        .bucket(properties.bucket())
                        .key(key)
                        .build())
                .build());
        return presigned.url().toExternalForm();
    }

    @Override
    public boolean isAvailable() {
        try {
            client.headBucket(HeadBucketRequest.builder().bucket(properties.bucket()).build());
            return true;
        } catch (RuntimeException e) {
            log.debug("Object storage availability check failed", e);
            return false;
        }
    }
}
