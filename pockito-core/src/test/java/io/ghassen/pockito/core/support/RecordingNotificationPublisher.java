package io.ghassen.pockito.core.support;

import io.ghassen.pockito.core.events.NotificationEvent;
import io.ghassen.pockito.core.events.NotificationEventPublisher;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/** Captures published events so tests can assert on them without needing Redis. */
public class RecordingNotificationPublisher extends NotificationEventPublisher {

    private final List<NotificationEvent> published = new CopyOnWriteArrayList<>();

    public RecordingNotificationPublisher() {
        super(null, "test.stream");
    }

    @Override
    public void publish(NotificationEvent event) {
        published.add(event);
    }

    public List<NotificationEvent> published() {
        return List.copyOf(published);
    }

    public List<String> publishedTypes() {
        return published.stream().map(NotificationEvent::type).toList();
    }

    public void clear() {
        published.clear();
    }
}
