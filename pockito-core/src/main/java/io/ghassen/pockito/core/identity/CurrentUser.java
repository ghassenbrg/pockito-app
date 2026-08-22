package io.ghassen.pockito.core.identity;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;

/** Reads the authenticated identity out of the current security context. */
@Component
public class CurrentUser {

    public AuthenticatedUser require() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (!(authentication instanceof JwtAuthenticationToken jwtAuthentication)) {
            throw new IllegalStateException("No authenticated JWT in the security context");
        }
        Jwt jwt = jwtAuthentication.getToken();
        String subject = jwt.getSubject();
        if (subject == null || subject.isBlank()) {
            throw new IllegalStateException("Access token has no subject claim");
        }
        return new AuthenticatedUser(
                subject,
                jwt.getClaimAsString("email"),
                jwt.getClaimAsString("preferred_username"));
    }
}
