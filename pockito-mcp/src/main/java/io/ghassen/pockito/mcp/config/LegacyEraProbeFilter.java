package io.ghassen.pockito.mcp.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ReadListener;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletInputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.filter.OncePerRequestFilter;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

/**
 * Answers draft-revision protocol probes with the status code that lets a client fall back
 * to the handshake this server actually speaks.
 *
 * <p>MCP revision {@code 2026-07-28} added {@code server/discover}, which a client sends
 * before anything else to learn a server's supported versions. Spring AI has no handler for
 * it, and the stateless transport answers an unhandled method with {@code 500} and a plain
 * body. That is the one response the specification gives a client no way to act on: the
 * documented fallback — "on 400 Bad Request … if the body is … not a recognized modern
 * JSON-RPC error, fall back to {@code initialize} and continue with the legacy version" —
 * is keyed on 400, so a 500 strands the client and the connection simply fails.
 *
 * <p>So the probe is answered here with 400 and a body that is deliberately not a JSON-RPC
 * error, which is what tells the client to stop treating us as a draft-era server and open
 * an {@code initialize} handshake instead.
 *
 * <p>Implementing {@code server/discover} for real would be the wrong fix. Answering it
 * claims we speak {@code 2026-07-28}, and the client would then send per-request
 * {@code _meta}, {@code MCP-Protocol-Version} headers and multi-round-trip results that the
 * SDK underneath us cannot handle — trading a visible failure for a subtler one. This
 * filter goes away when the SDK implements the revision itself.
 */
public class LegacyEraProbeFilter extends OncePerRequestFilter {

    private static final Logger log = LoggerFactory.getLogger(LegacyEraProbeFilter.class);

    /**
     * Methods a client may send before it knows which era we implement. Kept to exactly
     * that set: any later method reaching an unhandled state is a genuine fault and should
     * keep surfacing as one rather than being reported as a bad request.
     */
    private static final Set<String> PRE_HANDSHAKE_PROBES = Set.of("server/discover");

    /** Large enough for any probe; a real payload above it is passed through unexamined. */
    private static final int MAX_INSPECTED_BYTES = 64 * 1024;

    private final String mcpEndpoint;
    private final ObjectMapper objectMapper;

    public LegacyEraProbeFilter(String mcpEndpoint, ObjectMapper objectMapper) {
        this.mcpEndpoint = mcpEndpoint;
        this.objectMapper = objectMapper;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return !HttpMethod.POST.matches(request.getMethod())
                || !mcpEndpoint.equals(request.getRequestURI());
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        long declared = request.getContentLengthLong();
        if (declared > MAX_INSPECTED_BYTES) {
            chain.doFilter(request, response);
            return;
        }

        byte[] body = request.getInputStream().readAllBytes();
        String method = methodOf(body);

        if (method != null && PRE_HANDSHAKE_PROBES.contains(method)) {
            log.debug("Answering pre-handshake probe {} with 400 so the client falls back to initialize", method);
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setContentType(MediaType.TEXT_PLAIN_VALUE);
            response.getWriter().write("This server implements an initialization-based MCP revision.");
            return;
        }

        chain.doFilter(new BufferedBodyRequest(request, body), response);
    }

    /**
     * The JSON-RPC method name, or {@code null} if the body is not JSON-RPC we recognise.
     * A malformed body is not this filter's problem — it is handed downstream unchanged so
     * the transport reports it the way it always has.
     */
    private String methodOf(byte[] body) {
        if (body.length == 0) {
            return null;
        }
        try {
            JsonNode method = objectMapper.readTree(body).path("method");
            return method.isString() ? method.stringValue() : null;
        } catch (RuntimeException e) {
            log.debug("Body of a request to {} is not JSON-RPC; passing it through", mcpEndpoint);
            return null;
        }
    }

    /** Replays the body that was consumed to read the method name. */
    private static final class BufferedBodyRequest extends HttpServletRequestWrapper {

        private final byte[] body;

        private BufferedBodyRequest(HttpServletRequest request, byte[] body) {
            super(request);
            this.body = body;
        }

        @Override
        public ServletInputStream getInputStream() {
            ByteArrayInputStream source = new ByteArrayInputStream(body);
            return new ServletInputStream() {
                @Override
                public boolean isFinished() {
                    return source.available() == 0;
                }

                @Override
                public boolean isReady() {
                    return true;
                }

                @Override
                public void setReadListener(ReadListener listener) {
                    throw new UnsupportedOperationException("Async reads are not used on the MCP endpoint");
                }

                @Override
                public int read() {
                    return source.read();
                }

                @Override
                public int read(byte[] target, int offset, int length) {
                    return source.read(target, offset, length);
                }
            };
        }

        @Override
        public java.io.BufferedReader getReader() {
            return new java.io.BufferedReader(
                    new java.io.InputStreamReader(new ByteArrayInputStream(body), StandardCharsets.UTF_8));
        }
    }
}
