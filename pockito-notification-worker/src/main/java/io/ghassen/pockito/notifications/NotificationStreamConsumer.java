package io.ghassen.pockito.notifications;

import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.connection.stream.MapRecord;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.stream.StreamListener;
import org.springframework.stereotype.Component;

/**
 * Handles one stream record.
 *
 * <p>The processing contract is: claim the event id, do the work, acknowledge. A failure
 * releases the claim and leaves the record unacknowledged, so it stays in the consumer
 * group's pending list and is retried. A malformed record is acknowledged and dropped —
 * retrying it forever would block nothing but would fill the logs.
 */
@Component
public class NotificationStreamConsumer implements StreamListener<String, MapRecord<String, String, String>> {

    private static final Logger log = LoggerFactory.getLogger(NotificationStreamConsumer.class);

    private final ProcessedEventRegistry processedEvents;
    private final PushDeliveryService pushDelivery;
    private final StringRedisTemplate redis;
    private final NotificationProperties properties;

    public NotificationStreamConsumer(
            ProcessedEventRegistry processedEvents,
            PushDeliveryService pushDelivery,
            StringRedisTemplate redis,
            NotificationProperties properties) {
        this.processedEvents = processedEvents;
        this.pushDelivery = pushDelivery;
        this.redis = redis;
        this.properties = properties;
    }

    @Override
    public void onMessage(MapRecord<String, String, String> record) {
        NotificationEnvelope event;
        try {
            event = NotificationEnvelope.from(Map.copyOf(record.getValue()));
        } catch (IllegalArgumentException e) {
            log.warn("Discarding malformed notification record {}: {}", record.getId(), e.getMessage());
            acknowledge(record);
            return;
        }

        if (!processedEvents.claim(event.eventId())) {
            log.debug("Skipping already-processed event {}", event.eventId());
            acknowledge(record);
            return;
        }

        try {
            pushDelivery.deliver(event);
            acknowledge(record);
        } catch (RuntimeException e) {
            // Leave the record pending and drop the claim so the retry is not deduplicated.
            processedEvents.release(event.eventId());
            log.error("Failed to deliver notification {} of type {}; it will be retried",
                    event.eventId(), event.type(), e);
        }
    }

    private void acknowledge(MapRecord<String, String, String> record) {
        redis.opsForStream().acknowledge(properties.consumerGroup(), record);
    }
}
