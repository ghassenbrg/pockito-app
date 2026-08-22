package io.ghassen.pockito.notifications;

/**
 * Sends a notification to a user's devices.
 *
 * <p>Provider-neutral on purpose: FCM is the intended first implementation, but nothing
 * above this interface should know that.
 */
public interface PushDeliveryService {

    void deliver(NotificationEnvelope event);

    /** Whether a real provider is configured, as opposed to the recording fallback. */
    boolean isConfigured();
}
