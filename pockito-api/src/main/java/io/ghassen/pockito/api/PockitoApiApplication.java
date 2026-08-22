package io.ghassen.pockito.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

/**
 * Pockito's REST front door.
 *
 * <p>Owns HTTP concerns only — validation, status codes, versioning, OpenAPI, error shape.
 * Every domain decision is delegated to Pockito Core.
 */
@SpringBootApplication(scanBasePackages = {"io.ghassen.pockito.api", "io.ghassen.pockito.web", "io.ghassen.pockito.coreclient"})
@ConfigurationPropertiesScan({"io.ghassen.pockito.api", "io.ghassen.pockito.coreclient"})
public class PockitoApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(PockitoApiApplication.class, args);
    }
}
