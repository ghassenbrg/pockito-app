package io.ghassen.pockito.mcp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

/**
 * Pockito's Model Context Protocol server.
 *
 * <p>Exposes Pockito capabilities to AI clients. Like the REST API it is a thin adapter:
 * every tool delegates to Pockito Core, and no business rule is reimplemented here.
 */
@SpringBootApplication(scanBasePackages = {
        "io.ghassen.pockito.mcp",
        "io.ghassen.pockito.web",
        "io.ghassen.pockito.coreclient"})
@ConfigurationPropertiesScan({"io.ghassen.pockito.mcp", "io.ghassen.pockito.coreclient"})
public class PockitoMcpApplication {

    public static void main(String[] args) {
        SpringApplication.run(PockitoMcpApplication.class, args);
    }
}
