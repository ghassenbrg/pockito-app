package io.ghassen.pockito.api.core;

import io.ghassen.pockito.coreclient.AccessTokenSupplier;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;

/**
 * Relays the token Spring Security already validated for this request.
 *
 * <p>Relaying the user's own token — rather than a service account — is what keeps Core
 * authoritative about identity: the API cannot claim to be someone it is not.
 */
@Component
public class SecurityContextAccessTokenSupplier implements AccessTokenSupplier {

    @Override
    public String currentTokenValue() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication instanceof JwtAuthenticationToken jwtAuthentication) {
            return jwtAuthentication.getToken().getTokenValue();
        }
        throw new IllegalStateException("No authenticated JWT to relay to Pockito Core");
    }
}
