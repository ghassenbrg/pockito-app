package io.ghassen.pockito.notifications;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

/**
 * Consumes Pockito domain events from Redis Streams and turns them into push
 * notifications.
 *
 * <p>Kept as its own service so that slow or failing push delivery can never affect the
 * latency of a user-facing API call.
 */
@SpringBootApplication
@ConfigurationPropertiesScan
public class PockitoNotificationWorkerApplication {

    public static void main(String[] args) {
        SpringApplication.run(PockitoNotificationWorkerApplication.class, args);
    }
}
