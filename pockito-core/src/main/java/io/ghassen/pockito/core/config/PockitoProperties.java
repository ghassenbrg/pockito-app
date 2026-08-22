package io.ghassen.pockito.core.config;

import java.util.List;
import java.util.Set;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Application-level Pockito settings that are not infrastructure endpoints.
 *
 * <p>The currency list is intentionally configuration rather than a hard-coded enum: it is
 * a product decision that will grow, and no code branches on individual currencies.
 */
@ConfigurationProperties(prefix = "pockito")
public record PockitoProperties(List<String> supportedCurrencies, Avatar avatar) {

    public PockitoProperties {
        supportedCurrencies = (supportedCurrencies == null || supportedCurrencies.isEmpty())
                ? List.of("EUR", "USD", "JPY", "GBP", "CHF", "TND", "CAD", "AUD")
                : supportedCurrencies.stream().map(String::toUpperCase).toList();
        avatar = avatar == null ? new Avatar(null, null) : avatar;
    }

    public boolean supportsCurrency(String code) {
        return code != null && supportedCurrencies.contains(code.toUpperCase());
    }

    public record Avatar(Long maxSizeBytes, Set<String> allowedContentTypes) {

        public Avatar {
            maxSizeBytes = maxSizeBytes == null ? 2L * 1024 * 1024 : maxSizeBytes;
            allowedContentTypes = (allowedContentTypes == null || allowedContentTypes.isEmpty())
                    ? Set.of("image/png", "image/jpeg", "image/webp")
                    : allowedContentTypes;
        }
    }
}
