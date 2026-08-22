package io.ghassen.pockito.mcp.config;

import io.ghassen.pockito.coreclient.AccessTokenSupplier;
import org.springframework.stereotype.Component;

/**
 * Carries the caller's access token from an MCP tool invocation into the Core client.
 *
 * <p>MCP tool arguments arrive through the protocol rather than through Spring MVC, so the
 * token is read from the transport context and bound here for the duration of the call.
 * The binding is thread-confined and always cleared, so one client's token can never leak
 * into another's request.
 */
@Component
public class McpAccessToken implements AccessTokenSupplier {

    public static final String CONTEXT_KEY = "pockito.accessToken";

    private static final ThreadLocal<String> CURRENT = new ThreadLocal<>();

    /** Runs {@code action} with {@code token} bound as the current caller's credential. */
    public <T> T callWith(String token, java.util.function.Supplier<T> action) {
        String previous = CURRENT.get();
        CURRENT.set(token);
        try {
            return action.get();
        } finally {
            if (previous == null) {
                CURRENT.remove();
            } else {
                CURRENT.set(previous);
            }
        }
    }

    @Override
    public String currentTokenValue() {
        String token = CURRENT.get();
        if (token == null) {
            throw new IllegalStateException("No access token bound for this MCP call");
        }
        return token;
    }
}
