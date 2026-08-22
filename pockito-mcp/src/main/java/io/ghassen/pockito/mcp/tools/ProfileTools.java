package io.ghassen.pockito.mcp.tools;

import io.ghassen.pockito.contracts.PreferencesResponse;
import io.ghassen.pockito.contracts.ProfileResponse;
import io.ghassen.pockito.coreclient.CoreClient;
import io.ghassen.pockito.mcp.config.McpAccessToken;
import io.modelcontextprotocol.common.McpTransportContext;
import org.springframework.ai.mcp.annotation.McpTool;
import org.springframework.stereotype.Component;

/**
 * The MCP tools Pockito exposes today.
 *
 * <p>Only capabilities backed by real functionality are published — there are deliberately
 * no finance tools yet, because there is no finance domain behind them. Each tool is a
 * one-line delegation to Core through the shared client.
 */
@Component
public class ProfileTools {

    private final CoreClient core;
    private final McpAccessToken accessToken;

    public ProfileTools(CoreClient core, McpAccessToken accessToken) {
        this.core = core;
        this.accessToken = accessToken;
    }

    @McpTool(
            name = "get_my_profile",
            title = "Get my Pockito profile",
            description = "Get the Pockito profile of the authenticated user: display name, "
                    + "email, avatar and whether onboarding is complete.",
            // Both tools only read. Saying so lets clients call them without prompting the
            // user for confirmation, and stops them being treated as destructive.
            annotations = @McpTool.McpAnnotations(
                    title = "Get my Pockito profile",
                    readOnlyHint = true,
                    destructiveHint = false,
                    idempotentHint = true,
                    openWorldHint = false))
    public ProfileResponse getMyProfile(McpTransportContext context) {
        return withCallerToken(context, core::profile);
    }

    @McpTool(
            name = "get_my_preferences",
            title = "Get my Pockito preferences",
            description = "Get the authenticated user's Pockito preferences: interface "
                    + "language, appearance (system, light or dark) and default currency.",
            annotations = @McpTool.McpAnnotations(
                    title = "Get my Pockito preferences",
                    readOnlyHint = true,
                    destructiveHint = false,
                    idempotentHint = true,
                    openWorldHint = false))
    public PreferencesResponse getMyPreferences(McpTransportContext context) {
        return withCallerToken(context, core::preferences);
    }

    /**
     * Binds the caller's token for the duration of one tool call.
     *
     * <p>The token is placed in the transport context by {@code McpTransportConfig} after
     * Spring Security has validated it; a call that somehow arrives without one is refused
     * rather than falling back to any ambient credential.
     */
    private <T> T withCallerToken(McpTransportContext context, java.util.function.Supplier<T> action) {
        Object token = context == null ? null : context.get(McpAccessToken.CONTEXT_KEY);
        if (!(token instanceof String bearer) || bearer.isBlank()) {
            throw new IllegalStateException("MCP call arrived without an access token");
        }
        return accessToken.callWith(bearer, action);
    }
}
