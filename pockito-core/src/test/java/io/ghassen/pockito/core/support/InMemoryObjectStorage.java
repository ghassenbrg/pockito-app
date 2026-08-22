package io.ghassen.pockito.core.support;

import io.ghassen.pockito.core.storage.ObjectStorageService;
import io.ghassen.pockito.core.storage.StoredObject;
import java.time.Duration;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 * A real implementation of the storage port, backed by a map.
 *
 * <p>Using the port rather than mocking it means the avatar tests exercise the actual
 * service logic — key generation, replacement of a previous object, deletion — instead of
 * asserting on mock interactions.
 */
public class InMemoryObjectStorage implements ObjectStorageService {

    private final Map<String, byte[]> objects = new ConcurrentHashMap<>();
    private final Map<String, String> contentTypes = new ConcurrentHashMap<>();

    @Override
    public StoredObject putObject(String key, byte[] content, String contentType) {
        objects.put(key, content.clone());
        contentTypes.put(key, contentType);
        return new StoredObject(key, contentType, content.length);
    }

    @Override
    public Optional<byte[]> getObject(String key) {
        return Optional.ofNullable(objects.get(key)).map(byte[]::clone);
    }

    @Override
    public void deleteObject(String key) {
        objects.remove(key);
        contentTypes.remove(key);
    }

    @Override
    public String createPresignedUrl(String key, Duration validity) {
        return "https://storage.test/" + key + "?expires=" + validity.toSeconds();
    }

    @Override
    public boolean isAvailable() {
        return true;
    }

    public int objectCount() {
        return objects.size();
    }

    public boolean contains(String key) {
        return objects.containsKey(key);
    }
}
