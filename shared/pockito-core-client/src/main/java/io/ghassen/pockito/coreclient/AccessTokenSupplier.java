package io.ghassen.pockito.coreclient;

/**
 * Supplies the end user's access token for the call being handled.
 *
 * <p>API and MCP obtain that token from different places — a Spring Security context and
 * an MCP transport context respectively — so this is the one seam between them. Everything
 * else about talking to Core is shared.
 */
@FunctionalInterface
public interface AccessTokenSupplier {

    String currentTokenValue();
}
