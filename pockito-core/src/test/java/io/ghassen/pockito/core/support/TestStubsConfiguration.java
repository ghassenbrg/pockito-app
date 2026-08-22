package io.ghassen.pockito.core.support;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;

/**
 * Replaces the two infrastructure ports that would otherwise need their own containers.
 * The database stays real, because the schema is part of what is under test.
 */
@TestConfiguration
public class TestStubsConfiguration {

    @Bean
    @Primary
    InMemoryObjectStorage testObjectStorage() {
        return new InMemoryObjectStorage();
    }

    @Bean
    @Primary
    RecordingNotificationPublisher testNotificationPublisher() {
        return new RecordingNotificationPublisher();
    }
}
