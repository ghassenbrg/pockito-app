-- Pockito V1 foundation schema.
--
-- Scope is deliberately limited to identity-linked profile state. Finance domains are
-- migrated later, one domain per explicit migration.

CREATE TABLE user_profile (
    id                    UUID         PRIMARY KEY,
    keycloak_subject      VARCHAR(64)  NOT NULL,
    email                 VARCHAR(320),
    display_name          VARCHAR(80)  NOT NULL,
    language              VARCHAR(8)   NOT NULL DEFAULT 'EN',
    theme                 VARCHAR(16)  NOT NULL DEFAULT 'SYSTEM',
    default_currency      VARCHAR(3)   NOT NULL DEFAULT 'EUR',
    onboarding_completed  BOOLEAN      NOT NULL DEFAULT FALSE,
    onboarding_completed_at TIMESTAMPTZ,
    avatar_object_key     VARCHAR(512),
    avatar_content_type   VARCHAR(128),
    avatar_size_bytes     BIGINT,
    created_at            TIMESTAMPTZ  NOT NULL,
    updated_at            TIMESTAMPTZ  NOT NULL,
    version               BIGINT       NOT NULL DEFAULT 0
);

-- One Pockito profile per Keycloak identity. The unique constraint is what makes the
-- find-or-create on first login safe when two requests race.
CREATE UNIQUE INDEX ux_user_profile_keycloak_subject ON user_profile (keycloak_subject);

COMMENT ON TABLE user_profile IS
    'Pockito application profile. Keycloak owns identity and credentials; keycloak_subject is the only link.';
COMMENT ON COLUMN user_profile.avatar_object_key IS
    'Object storage key. Avatar bytes live in S3-compatible storage, never in this database.';
