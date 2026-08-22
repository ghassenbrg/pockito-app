package io.ghassen.pockito.mcp.config;

import io.modelcontextprotocol.common.McpTransportContext;
import io.modelcontextprotocol.json.jackson3.JacksonMcpJsonMapper;
import java.util.Map;
import org.springframework.ai.mcp.server.common.autoconfigure.properties.McpServerStreamableHttpProperties;
import org.springframework.ai.mcp.server.webmvc.transport.WebMvcStatelessServerTransport;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import tools.jackson.databind.json.JsonMapper;

/**
 * Replaces the auto-configured MCP transport with one that carries the caller's bearer
 * token into the tool invocation.
 *
 * <p>Spring Security has already validated that token before the request reaches here —
 * this only makes it available to tools so it can be relayed to Core. Passing it through
 * the transport context rather than a thread-local set in a filter keeps it correct even
 * if the protocol layer hands the call to another thread.
 */
@Configuration
public class McpTransportConfig {

    @Bean
    WebMvcStatelessServerTransport webMvcStatelessServerTransport(
            JsonMapper jsonMapper, McpServerStreamableHttpProperties properties) {
        return WebMvcStatelessServerTransport.builder()
                .jsonMapper(new JacksonMcpJsonMapper(jsonMapper))
                .messageEndpoint(properties.getMcpEndpoint())
                .contextExtractor(request -> {
                    String authorization = request.headers().firstHeader("Authorization");
                    if (authorization == null || !authorization.regionMatches(true, 0, "Bearer ", 0, 7)) {
                        return McpTransportContext.EMPTY;
                    }
                    return McpTransportContext.create(
                            Map.of(McpAccessToken.CONTEXT_KEY, authorization.substring(7).trim()));
                })
                .build();
    }
}
