package io.ghassen.pockito.core.profile;

import io.ghassen.pockito.contracts.AppLanguage;
import io.ghassen.pockito.contracts.AppTheme;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Version;
import java.time.Instant;
import java.util.UUID;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import jakarta.persistence.EntityListeners;

/**
 * A Pockito user's application-side profile.
 *
 * <p>Deliberately holds no credentials: Keycloak owns identity and authentication, and
 * {@code keycloakSubject} is the only link between the two. Everything here is Pockito's
 * own application state.
 */
@Entity
@Table(name = "user_profile")
@EntityListeners(AuditingEntityListener.class)
public class UserProfile {

    @Id
    @Column(name = "id", nullable = false, updatable = false)
    private UUID id;

    @Column(name = "keycloak_subject", nullable = false, unique = true, updatable = false, length = 64)
    private String keycloakSubject;

    @Column(name = "email", length = 320)
    private String email;

    @Column(name = "display_name", nullable = false, length = 80)
    private String displayName;

    @Enumerated(EnumType.STRING)
    @Column(name = "language", nullable = false, length = 8)
    private AppLanguage language = AppLanguage.EN;

    @Enumerated(EnumType.STRING)
    @Column(name = "theme", nullable = false, length = 16)
    private AppTheme theme = AppTheme.SYSTEM;

    @Column(name = "default_currency", nullable = false, length = 3)
    private String defaultCurrency = "EUR";

    @Column(name = "onboarding_completed", nullable = false)
    private boolean onboardingCompleted;

    @Column(name = "onboarding_completed_at")
    private Instant onboardingCompletedAt;

    @Column(name = "avatar_object_key", length = 512)
    private String avatarObjectKey;

    @Column(name = "avatar_content_type", length = 128)
    private String avatarContentType;

    @Column(name = "avatar_size_bytes")
    private Long avatarSizeBytes;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Version
    @Column(name = "version", nullable = false)
    private long version;

    protected UserProfile() {
        // for JPA
    }

    private UserProfile(UUID id, String keycloakSubject, String email, String displayName) {
        this.id = id;
        this.keycloakSubject = keycloakSubject;
        this.email = email;
        this.displayName = displayName;
    }

    /** Creates the profile that backs a Keycloak identity on its first authenticated call. */
    public static UserProfile forSubject(String keycloakSubject, String email, String displayName) {
        return new UserProfile(UUID.randomUUID(), keycloakSubject, email, displayName);
    }

    public void rename(String newDisplayName) {
        this.displayName = newDisplayName;
    }

    public void applyPreferences(AppLanguage newLanguage, AppTheme newTheme, String newCurrency) {
        this.language = newLanguage;
        this.theme = newTheme;
        this.defaultCurrency = newCurrency;
    }

    public void attachAvatar(String objectKey, String contentType, long sizeBytes) {
        this.avatarObjectKey = objectKey;
        this.avatarContentType = contentType;
        this.avatarSizeBytes = sizeBytes;
    }

    public void detachAvatar() {
        this.avatarObjectKey = null;
        this.avatarContentType = null;
        this.avatarSizeBytes = null;
    }

    /** Marks onboarding done. Idempotent: re-completing keeps the original timestamp. */
    public void completeOnboarding() {
        if (!this.onboardingCompleted) {
            this.onboardingCompleted = true;
            this.onboardingCompletedAt = Instant.now();
        }
    }

    /** Keeps the mirrored email in step with Keycloak when the token says it changed. */
    public boolean syncEmail(String tokenEmail) {
        if (tokenEmail != null && !tokenEmail.equals(this.email)) {
            this.email = tokenEmail;
            return true;
        }
        return false;
    }

    public UUID getId() {
        return id;
    }

    public String getKeycloakSubject() {
        return keycloakSubject;
    }

    public String getEmail() {
        return email;
    }

    public String getDisplayName() {
        return displayName;
    }

    public AppLanguage getLanguage() {
        return language;
    }

    public AppTheme getTheme() {
        return theme;
    }

    public String getDefaultCurrency() {
        return defaultCurrency;
    }

    public boolean isOnboardingCompleted() {
        return onboardingCompleted;
    }

    public Instant getOnboardingCompletedAt() {
        return onboardingCompletedAt;
    }

    public String getAvatarObjectKey() {
        return avatarObjectKey;
    }

    public String getAvatarContentType() {
        return avatarContentType;
    }

    public Long getAvatarSizeBytes() {
        return avatarSizeBytes;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }
}
