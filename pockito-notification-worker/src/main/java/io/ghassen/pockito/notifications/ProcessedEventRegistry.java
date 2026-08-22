package io.ghassen.pockito.notifications;

import java.util.concurrent.TimeUnit;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

/**
 * Remembers which events have already been handled.
 *
 * <p>Redis Streams give at-least-once delivery, so a redelivered event must not produce a
 * second push. {@code SET key value NX EX ttl} makes the check-and-claim atomic, which
 * matters because several worker replicas can see the same event after a consumer crash.
 */
@Component
public class ProcessedEventRegistry {

    private static final String KEY_PREFIX = "pockito:notifications:processed:";

    private final StringRedisTemplate redis;
    private final NotificationProperties properties;

    public ProcessedEventRegistry(StringRedisTemplate redis, NotificationProperties properties) {
        this.redis = redis;
        this.properties = properties;
    }

    /**
     * @return {@code true} if this call claimed the event, {@code false} if it was already
     *         processed and should be skipped
     */
    public boolean claim(String eventId) {
        Boolean claimed = redis.opsForValue().setIfAbsent(
                KEY_PREFIX + eventId, "1", properties.dedupeTtl().toSeconds(), TimeUnit.SECONDS);
        return Boolean.TRUE.equals(claimed);
    }

    /**
     * Releases a claim so a genuinely failed event can be retried on redelivery rather than
     * being silently swallowed by the de-duplication window.
     */
    public void release(String eventId) {
        redis.delete(KEY_PREFIX + eventId);
    }
}
