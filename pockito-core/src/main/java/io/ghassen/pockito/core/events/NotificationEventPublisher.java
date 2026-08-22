package io.ghassen.pockito.core.events;

import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.connection.stream.MapRecord;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

/**
 * Publishes domain events onto a Redis Stream for the notification worker to consume.
 *
 * <p>Publishing is best-effort by design: a Redis outage must not fail the user-facing
 * operation that triggered the event. Failures are logged, not propagated.
 */
@Component
public class NotificationEventPublisher {

    private static final Logger log = LoggerFactory.getLogger(NotificationEventPublisher.class);

    private final StringRedisTemplate redis;
    private final String streamKey;

    public NotificationEventPublisher(
            StringRedisTemplate redis,
            @Value("${pockito.notifications.stream:pockito.notifications}") String streamKey) {
        this.redis = redis;
        this.streamKey = streamKey;
    }

    public void publish(NotificationEvent event) {
        Map<String, String> body = new HashMap<>(event.attributes());
        body.put("eventId", event.eventId());
        body.put("type", event.type());
        body.put("subject", event.subject());
        body.put("occurredAt", event.occurredAt().toString());
        try {
            redis.opsForStream().add(MapRecord.create(streamKey, body));
            log.debug("Published {} for subject {} to stream {}", event.type(), event.subject(), streamKey);
        } catch (RuntimeException e) {
            log.warn("Could not publish notification event {} to stream {}: {}",
                    event.type(), streamKey, e.toString());
        }
    }
}
