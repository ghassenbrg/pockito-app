package io.ghassen.pockito.mcp.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * How this server describes itself to MCP clients that have to discover how to log in.
 *
 * <p>{@code publicBaseUrl} is the origin clients reach us on from outside the cluster, not
 * the address we bind to. It has to be configured rather than derived from the request:
 * behind Traefik the request arrives as plain HTTP on port 8082, and a resource identifier
 * built from that would never match the {@code https://pockito.ghassen.io/mcp} the user
 * typed into their AI client — and the identifier has to match exactly.
 */
@ConfigurationProperties(prefix = "pockito.mcp")
public record McpDiscoveryProperties(String publicBaseUrl) {

    /** Where RFC 9728 metadata for this resource is published, without a resource path. */
    public static final String METADATA_PATH = "/.well-known/oauth-protected-resource";

    public McpDiscoveryProperties {
        publicBaseUrl = publicBaseUrl == null ? "" : stripTrailingSlash(publicBaseUrl);
    }

    /**
     * The canonical resource identifier: the MCP endpoint's public URL. Access tokens are
     * requested for this value and it is what the user enters in their AI client.
     */
    public String resourceIdentifier(String mcpEndpoint) {
        return publicBaseUrl + mcpEndpoint;
    }

    /**
     * The metadata URL to advertise in a {@code WWW-Authenticate} challenge.
     *
     * <p>RFC 9728 inserts the resource's path, so the document for {@code /mcp} lives at
     * {@code /.well-known/oauth-protected-resource/mcp}. Clients disagree on whether to try
     * that or the bare path first, so both are served and the path-qualified one — the one
     * the spec actually prescribes — is the one we point at.
     */
    public String metadataUrl(String mcpEndpoint) {
        return publicBaseUrl + METADATA_PATH + mcpEndpoint;
    }

    private static String stripTrailingSlash(String value) {
        return value.endsWith("/") ? value.substring(0, value.length() - 1) : value;
    }
}
