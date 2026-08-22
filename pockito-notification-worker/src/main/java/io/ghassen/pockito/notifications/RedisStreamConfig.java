package io.ghassen.pockito.notifications;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.stream.Consumer;
import org.springframework.data.redis.connection.stream.MapRecord;
import org.springframework.data.redis.connection.stream.ReadOffset;
import org.springframework.data.redis.connection.stream.StreamOffset;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.stream.StreamMessageListenerContainer;

/**
 * Wires the Redis Streams consumer group.
 *
 * <p>Reading through a consumer group (rather than plain {@code XREAD}) is what makes
 * horizontal scaling and redelivery-after-crash work: each event goes to exactly one
 * replica, and unacknowledged events stay pending until someone handles them.
 */
@Configuration
public class RedisStreamConfig {

    private static final Logger log = LoggerFactory.getLogger(RedisStreamConfig.class);

    @Bean
    StreamMessageListenerContainer<String, MapRecord<String, String, String>> streamListenerContainer(
            RedisConnectionFactory connectionFactory,
            StringRedisTemplate redis,
            NotificationStreamConsumer consumer,
            NotificationProperties properties) {

        ensureConsumerGroup(redis, properties);

        var options = StreamMessageListenerContainer
                .StreamMessageListenerContainerOptions.builder()
                .pollTimeout(properties.pollTimeout())
                .build();

        var container = StreamMessageListenerContainer.create(connectionFactory, options);
        container.receive(
                Consumer.from(properties.consumerGroup(), properties.consumerName()),
                // lastConsumed() delivers this consumer's pending entries first, then new ones.
                StreamOffset.create(properties.stream(), ReadOffset.lastConsumed()),
                consumer);
        container.start();
        log.info("Consuming Redis stream '{}' as group '{}' consumer '{}'",
                properties.stream(), properties.consumerGroup(), properties.consumerName());
        return container;
    }

    /**
     * Creates the stream and its group if they do not exist yet. {@code MKSTREAM} covers the
     * ordinary case where the worker starts before Core has ever published anything.
     */
    private void ensureConsumerGroup(StringRedisTemplate redis, NotificationProperties properties) {
        try {
            redis.opsForStream().createGroup(properties.stream(), ReadOffset.from("0"), properties.consumerGroup());
            log.info("Created consumer group '{}' on stream '{}'", properties.consumerGroup(), properties.stream());
        } catch (RuntimeException e) {
            // BUSYGROUP: another replica already created it. Anything else is worth seeing.
            if (e.getMessage() != null && e.getMessage().contains("BUSYGROUP")) {
                log.debug("Consumer group '{}' already exists", properties.consumerGroup());
            } else {
                log.warn("Could not create consumer group '{}' on stream '{}': {}",
                        properties.consumerGroup(), properties.stream(), e.toString());
            }
        }
    }
}
