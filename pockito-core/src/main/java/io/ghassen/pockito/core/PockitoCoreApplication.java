package io.ghassen.pockito.core;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication(scanBasePackages = {"io.ghassen.pockito.core", "io.ghassen.pockito.web"})
@ConfigurationPropertiesScan("io.ghassen.pockito.core")
@EnableJpaAuditing
public class PockitoCoreApplication {

    public static void main(String[] args) {
        SpringApplication.run(PockitoCoreApplication.class, args);
    }
}
