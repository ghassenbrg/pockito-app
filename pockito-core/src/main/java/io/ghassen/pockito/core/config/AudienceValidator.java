package io.ghassen.pockito.core.config;

import java.util.List;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.jwt.Jwt;

/**
 * Rejects tokens that were not issued for this service.
 *
 * <p>Issuer and signature alone are not enough: without an audience check, a token minted
 * for any client in the realm would be accepted here.
 */
public class AudienceValidator implements OAuth2TokenValidator<Jwt> {

    private final List<String> expectedAudiences;

    public AudienceValidator(List<String> expectedAudiences) {
        this.expectedAudiences = expectedAudiences;
    }

    @Override
    public OAuth2TokenValidatorResult validate(Jwt token) {
        if (expectedAudiences == null || expectedAudiences.isEmpty()) {
            return OAuth2TokenValidatorResult.success();
        }
        List<String> audience = token.getAudience();
        if (audience != null && audience.stream().anyMatch(expectedAudiences::contains)) {
            return OAuth2TokenValidatorResult.success();
        }
        return OAuth2TokenValidatorResult.failure(new OAuth2Error(
                "invalid_token",
                "Token audience " + audience + " does not include any of " + expectedAudiences,
                null));
    }
}
