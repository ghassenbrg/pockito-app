package io.ghassen.pockito.core.storage;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.function.Supplier;

/**
 * Hands back the same pre-signed URL for the same object for a while, instead of a freshly
 * signed one on every response.
 *
 * <p>This exists to make client caching possible at all. A pre-signed URL carries
 * {@code X-Amz-Date} and {@code X-Amz-Signature}, and an HTTP cache is keyed on the full
 * URL including its query string. Signing per response therefore minted a cache key the
 * browser had never seen every single time, so every page load re-downloaded bytes it
 * already held. Reusing one URL for a window makes that key stable for the window.
 *
 * <p>The window is half the URL's validity, so a URL handed out at the very end of it still
 * has half its life left to actually be fetched with.
 *
 * <p>Deliberately in-memory rather than shared through Redis. A miss costs exactly one
 * extra download of one object, which is not worth a network round-trip on every response
 * to avoid — so a restart, or a second replica holding a different entry, is fine.
 */
class PresignedUrlCache {

    /** Bounds the map. Entries are one per stored object in active use, so this is ample. */
    private static final int MAX_ENTRIES = 10_000;

    private record CachedUrl(String url, Instant reusableUntil) {}

    private final Clock clock;
    private final Map<String, CachedUrl> entries;

    PresignedUrlCache(Clock clock) {
        this.clock = clock;
        // Access-ordered so the cap evicts what has gone unused rather than what merely
        // happens to be oldest. Synchronized because it is shared across request threads.
        this.entries = java.util.Collections.synchronizedMap(
                new LinkedHashMap<>(256, 0.75f, true) {
                    @Override
                    protected boolean removeEldestEntry(Map.Entry<String, CachedUrl> eldest) {
                        return size() > MAX_ENTRIES;
                    }
                });
    }

    /**
     * The cached URL for {@code key}, or a newly signed one when there is nothing reusable.
     *
     * @param reuseWindow how long a freshly signed URL may be handed out again
     * @param sign produces a new URL; called only on a miss
     */
    String get(String key, Duration reuseWindow, Supplier<String> sign) {
        Instant now = clock.instant();
        CachedUrl cached = entries.get(key);
        if (cached != null && now.isBefore(cached.reusableUntil())) {
            return cached.url();
        }
        // Signing is a local computation, so a race here costs two signatures and no I/O.
        // Locking the whole map around it would be the more expensive mistake.
        String url = sign.get();
        entries.put(key, new CachedUrl(url, now.plus(reuseWindow)));
        return url;
    }

    /** Drops the entry for an object that has been replaced or deleted. */
    void evict(String key) {
        entries.remove(key);
    }
}
