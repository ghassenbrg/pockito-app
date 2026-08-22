-- Keycloak keeps its own database, separate from Pockito's. Identity data and application
-- data never share a schema.
CREATE USER keycloak WITH PASSWORD 'keycloak';
CREATE DATABASE keycloak OWNER keycloak;
