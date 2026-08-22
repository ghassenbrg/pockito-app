package io.ghassen.pockito.core.support;

import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;

/**
 * Base for tests that need a real database.
 *
 * <p>A real Postgres rather than an in-memory substitute, because the Flyway migrations and
 * Hibernate's schema validation are part of what these tests are checking — an H2 dialect
 * would let a broken migration pass.
 *
 * <p>The container is started once for the whole suite and shared; Testcontainers reuses it
 * across test classes because the static field outlives any single context.
 */
@SpringBootTest
@ActiveProfiles("test")
public abstract class PostgresTestBase {

    static final PostgreSQLContainer<?> POSTGRES = new PostgreSQLContainer<>("postgres:18-alpine")
            .withDatabaseName("pockito")
            .withUsername("pockito")
            .withPassword("pockito");

    static {
        POSTGRES.start();
    }

    @DynamicPropertySource
    static void datasourceProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", POSTGRES::getJdbcUrl);
        registry.add("spring.datasource.username", POSTGRES::getUsername);
        registry.add("spring.datasource.password", POSTGRES::getPassword);
    }
}
