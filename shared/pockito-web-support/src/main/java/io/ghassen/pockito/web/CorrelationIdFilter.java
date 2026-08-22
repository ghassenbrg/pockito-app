package io.ghassen.pockito.web;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * Adopts the inbound {@code X-Correlation-Id} or mints one, then puts it in the MDC and on
 * the response.
 *
 * <p>Because Pockito API and MCP forward the header when they call Core, a single user
 * action shares one id across every service that touches it.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 10)
public class CorrelationIdFilter extends OncePerRequestFilter {

    private static final int MAX_LENGTH = 64;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String incoming = request.getHeader(CorrelationId.HEADER);
        String correlationId = sanitise(incoming);
        CorrelationId.set(correlationId);
        response.setHeader(CorrelationId.HEADER, correlationId);
        try {
            chain.doFilter(request, response);
        } finally {
            CorrelationId.clear();
        }
    }

    /**
     * Client-supplied ids are untrusted input that ends up in log files, so anything with
     * unexpected characters or excessive length is replaced rather than sanitised in place.
     */
    private static String sanitise(String incoming) {
        if (incoming == null || incoming.isBlank() || incoming.length() > MAX_LENGTH
                || !incoming.matches("[A-Za-z0-9._:-]+")) {
            return UUID.randomUUID().toString();
        }
        return incoming;
    }
}
