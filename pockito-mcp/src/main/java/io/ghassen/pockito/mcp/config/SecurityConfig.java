package io.ghassen.pockito.mcp.config;

import io.ghassen.pockito.contracts.ApiErrorResponse;
import io.ghassen.pockito.web.CorrelationId;
import java.io.IOException;
import java.util.List;
import org.springframework.ai.mcp.server.common.autoconfigure.properties.McpServerStreamableHttpProperties;
import org.springframework.beans.factory.annotation.Value;
import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtValidators;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;
import tools.jackson.databind.ObjectMapper;

/**
 * Authorization for MCP clients.
 *
 * <p>Every call to {@code /mcp} needs a valid Keycloak access token, so an unauthenticated
 * AI client is rejected at the edge of this service and never reaches a tool. The token is
 * then relayed to Core, which verifies it a second time on its own terms.
 */
@Configuration
public class SecurityConfig {

    @Bean
    SecurityFilterChain securityFilterChain(
            HttpSecurity http,
            ObjectMapper objectMapper,
            McpDiscoveryProperties discovery,
            McpServerStreamableHttpProperties transport,
            @Value("${spring.security.oauth2.resourceserver.jwt.issuer-uri}") String issuerUri) throws Exception {
        String mcpEndpoint = transport.getMcpEndpoint();
        // Advertised on every 401 so a client that has never seen Pockito can find its way
        // to Keycloak without anyone configuring it by hand.
        String challenge = "Bearer resource_metadata=\"" + discovery.metadataUrl(mcpEndpoint) + "\"";
        http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(requests -> requests
                        // The container re-dispatches to /error; denying that would turn every
                        // unhandled failure into a misleading 403.
                        .dispatcherTypeMatchers(DispatcherType.ERROR, DispatcherType.ASYNC).permitAll()
                        .requestMatchers("/actuator/health/**", "/actuator/info").permitAll()
                        // Discovery has to be reachable without a token: requiring one to
                        // learn how to obtain one cannot work.
                        .requestMatchers(McpDiscoveryProperties.METADATA_PATH,
                                McpDiscoveryProperties.METADATA_PATH + "/**").permitAll()
                        .requestMatchers("/mcp/**", "/mcp").authenticated()
                        .anyRequest().denyAll())
                .oauth2ResourceServer(oauth2 -> oauth2
                        // RFC 9728 discovery. Spring Security publishes this document on
                        // its own, but its defaults are wrong for us in the one way that
                        // matters: it derives the resource from the request — which behind
                        // Traefik is an internal http://…:8082 URL, not the identifier the
                        // token is minted for — and it names no authorization server at
                        // all, leaving a client that reads it no way to reach Keycloak.
                        .protectedResourceMetadata(metadata -> metadata
                                .protectedResourceMetadataCustomizer(document -> document
                                        .resource(discovery.resourceIdentifier(mcpEndpoint))
                                        .authorizationServer(issuerUri)
                                        .resourceName("Pockito")
                                        .scopes(scopes -> {
                                            scopes.add("openid");
                                            scopes.add("profile");
                                            scopes.add("email");
                                        })
                                        .bearerMethods(methods -> {
                                            methods.clear();
                                            methods.add("header");
                                        })
                                        // We terminate TLS at Traefik and bind nothing to a
                                        // client certificate; advertising otherwise would be
                                        // a promise this server does not keep.
                                        .tlsClientCertificateBoundAccessTokens(false)))
                        .jwt(Customizer.withDefaults())
                        .authenticationEntryPoint((request, response, exception) -> {
                            response.setHeader(HttpHeaders.WWW_AUTHENTICATE, challenge);
                            writeError(response, objectMapper, HttpStatus.UNAUTHORIZED,
                                    "auth.unauthenticated", "A Keycloak access token is required");
                        })
                        .accessDeniedHandler((request, response, exception) ->
                                writeError(response, objectMapper, HttpStatus.FORBIDDEN,
                                        "access.denied", "This token may not use the Pockito MCP server")));
        return http.build();
    }

    private static void writeError(
            jakarta.servlet.http.HttpServletResponse response,
            ObjectMapper objectMapper,
            HttpStatus status,
            String code,
            String message) throws IOException {
        String correlationId = CorrelationId.current();
        response.setStatus(status.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setHeader(CorrelationId.HEADER, correlationId);
        objectMapper.writeValue(
                response.getOutputStream(),
                ApiErrorResponse.of(status.value(), code, message, correlationId));
    }

    @Bean
    NimbusJwtDecoder jwtDecoder(
            @Value("${spring.security.oauth2.resourceserver.jwt.issuer-uri}") String issuerUri,
            @Value("${spring.security.oauth2.resourceserver.jwt.jwk-set-uri}") String jwkSetUri,
            @Value("${pockito.security.expected-audiences:}") List<String> expectedAudiences) {
        // The JWKS URI is configured rather than discovered: both discovery helpers contact
        // Keycloak while the bean is built, so a Keycloak blip would stop this service from
        // starting at all. Built this way the first token triggers the key fetch, and keys
        // are cached from then on.
        NimbusJwtDecoder decoder = NimbusJwtDecoder.withJwkSetUri(jwkSetUri).build();
        OAuth2TokenValidator<Jwt> validator = new DelegatingOAuth2TokenValidator<>(
                JwtValidators.createDefaultWithIssuer(issuerUri),
                new AudienceValidator(expectedAudiences));
        decoder.setJwtValidator(validator);
        return decoder;
    }
}
