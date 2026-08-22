package io.ghassen.pockito.core.storage;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.concurrent.atomic.AtomicInteger;
import org.junit.jupiter.api.Test;

/**
 * The window behaviour, driven by a clock the test controls rather than by sleeping.
 */
class PresignedUrlCacheTest {

    private static final Duration WINDOW = Duration.ofMinutes(30);

    /** A clock the test moves by hand. */
    private static final class MovableClock extends Clock {
        private Instant now = Instant.parse("2026-08-22T10:00:00Z");

        void advance(Duration by) {
            now = now.plus(by);
        }

        @Override
        public Instant instant() {
            return now;
        }

        @Override
        public ZoneOffset getZone() {
            return ZoneOffset.UTC;
        }

        @Override
        public Clock withZone(java.time.ZoneId zone) {
            return this;
        }
    }

    @Test
    void signsOncePerWindow() {
        var clock = new MovableClock();
        var cache = new PresignedUrlCache(clock);
        var signatures = new AtomicInteger();

        String first = cache.get("k", WINDOW, () -> "url-" + signatures.incrementAndGet());
        clock.advance(Duration.ofMinutes(29));
        String second = cache.get("k", WINDOW, () -> "url-" + signatures.incrementAndGet());

        assertThat(second).isEqualTo(first);
        assertThat(signatures).hasValue(1);
    }

    @Test
    void signsAgainOnceTheWindowHasPassed() {
        var clock = new MovableClock();
        var cache = new PresignedUrlCache(clock);
        var signatures = new AtomicInteger();

        cache.get("k", WINDOW, () -> "url-" + signatures.incrementAndGet());
        clock.advance(Duration.ofMinutes(31));
        String after = cache.get("k", WINDOW, () -> "url-" + signatures.incrementAndGet());

        assertThat(after).isEqualTo("url-2");
        assertThat(signatures).hasValue(2);
    }

    @Test
    void keepsObjectsApart() {
        var cache = new PresignedUrlCache(new MovableClock());

        assertThat(cache.get("a", WINDOW, () -> "url-a")).isEqualTo("url-a");
        assertThat(cache.get("b", WINDOW, () -> "url-b")).isEqualTo("url-b");
    }

    /**
     * A deleted object's key must not keep answering from the cache — the next upload
     * writes a different key, but a re-created one would otherwise serve a stale URL.
     */
    @Test
    void evictionForcesAFreshSignature() {
        var cache = new PresignedUrlCache(new MovableClock());
        var signatures = new AtomicInteger();

        cache.get("k", WINDOW, () -> "url-" + signatures.incrementAndGet());
        cache.evict("k");
        String after = cache.get("k", WINDOW, () -> "url-" + signatures.incrementAndGet());

        assertThat(after).isEqualTo("url-2");
    }
}
