package io.ghassen.pockito.api.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    OpenAPI pockitoOpenApi() {
        return new OpenAPI()
                .info(new Info()
                        .title("Pockito API")
                        .version("v1")
                        .description("""
                                REST interface for Pockito clients. Authentication is handled by \
                                Keycloak: obtain an access token via OpenID Connect and send it as \
                                a bearer token. Pockito never accepts passwords directly.""")
                        .license(new License().name("Proprietary")))
                .components(new Components().addSecuritySchemes("bearer-jwt", new SecurityScheme()
                        .type(SecurityScheme.Type.HTTP)
                        .scheme("bearer")
                        .bearerFormat("JWT")
                        .description("Keycloak-issued access token")));
    }
}
