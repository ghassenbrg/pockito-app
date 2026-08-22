package io.ghassen.pockito.notifications;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.Map;
import org.junit.jupiter.api.Test;

/**
 * Redis Streams deliver at least once, so the consumer's contract is the interesting part:
 * do the work once, acknowledge it, and leave a genuinely failed event to be retried.
 */
class NotificationStreamConsumerTest {

    @Test
    void decodesAStreamRecordIntoAnEvent() {
        var event = NotificationEnvelope.from(Map.of(
                "eventId", "e-1",
                "type", "profile.onboarding.completed",
                "subject", "sub-1",
                "occurredAt", "2026-08-21T00:00:00Z",
                "profileId", "p-1"));

        assertThat(event.eventId()).isEqualTo("e-1");
        assertThat(event.type()).isEqualTo("profile.onboarding.completed");
        assertThat(event.subject()).isEqualTo("sub-1");
        // The envelope fields are not repeated as payload attributes.
        assertThat(event.attributes()).containsExactly(Map.entry("profileId", "p-1"));
    }

    @Test
    void rejectsARecordThatIsMissingItsEnvelope() {
        assertThatThrownBy(() -> NotificationEnvelope.from(Map.of("type", "x")))
                .isInstanceOf(IllegalArgumentException.class);
        assertThatThrownBy(() -> NotificationEnvelope.from(Map.of("eventId", "e", "type", "x")))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void deliveryRecordsRatherThanPretendingToSendWhenNoProviderIsConfigured() {
        var properties = new NotificationProperties(null, null, null, null, null, null);
        var delivery = new RecordingPushDeliveryService(properties);

        // The honest answer, so an unconfigured deployment does not look healthy.
        assertThat(delivery.isConfigured()).isFalse();
    }

    @Test
    void reportsAConfiguredProvider() {
        var properties = new NotificationProperties(
                null, null, null, null, null,
                new NotificationProperties.Push("fcm", "/var/run/secrets/fcm.json"));

        assertThat(new RecordingPushDeliveryService(properties).isConfigured()).isTrue();
    }

    @Test
    void aProviderNameWithoutCredentialsIsNotConfigured() {
        var push = new NotificationProperties.Push("fcm", null);
        assertThat(push.isConfigured()).isFalse();
    }

    @Test
    void defaultsNameTheStreamCoreActuallyPublishesTo() {
        var properties = new NotificationProperties(null, null, null, null, null, null);

        // Must match pockito.notifications.stream in Core, or nothing is ever consumed.
        assertThat(properties.stream()).isEqualTo("pockito.notifications");
        assertThat(properties.consumerGroup()).isEqualTo("pockito-notification-worker");
        assertThat(properties.dedupeTtl().toHours()).isEqualTo(24);
    }

    @Test
    void everyReplicaGetsItsOwnConsumerName() {
        // Two replicas sharing a consumer name would each think the other's pending
        // entries were their own.
        var first = new NotificationProperties(null, null, null, null, null, null);
        var second = new NotificationProperties(null, null, null, null, null, null);

        assertThat(first.consumerName()).isNotEqualTo(second.consumerName());
    }

    @Test
    void anExplicitConsumerNameIsHonoured() {
        var properties = new NotificationProperties(
                null, null, "pockito-notification-worker-abc123", null, null, null);
        assertThat(properties.consumerName()).isEqualTo("pockito-notification-worker-abc123");
    }
}
