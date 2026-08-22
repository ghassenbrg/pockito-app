package io.ghassen.pockito.web;

import org.slf4j.MDC;

/**
 * Access to the correlation id for the request being handled.
 *
 * <p>The value is kept in SLF4J's MDC so every log line emitted while handling a request
 * carries it, and is echoed to the client so a user-reported failure can be traced.
 */
public final class CorrelationId {

    public static final String HEADER = "X-Correlation-Id";
    public static final String MDC_KEY = "correlationId";

    private CorrelationId() {
    }

    public static String current() {
        String value = MDC.get(MDC_KEY);
        return value == null ? "unknown" : value;
    }

    static void set(String value) {
        MDC.put(MDC_KEY, value);
    }

    static void clear() {
        MDC.remove(MDC_KEY);
    }
}
