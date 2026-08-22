package io.ghassen.pockito.core.profile;

import io.ghassen.pockito.contracts.AvatarResponse;
import io.ghassen.pockito.contracts.BootstrapResponse;
import io.ghassen.pockito.contracts.CompleteOnboardingRequest;
import io.ghassen.pockito.contracts.PreferencesResponse;
import io.ghassen.pockito.contracts.ProfileResponse;
import io.ghassen.pockito.contracts.UpdatePreferencesRequest;
import io.ghassen.pockito.core.config.PockitoProperties;
import io.ghassen.pockito.core.events.NotificationEvent;
import io.ghassen.pockito.core.events.NotificationEventPublisher;
import io.ghassen.pockito.core.identity.AuthenticatedUser;
import io.ghassen.pockito.core.storage.ObjectStorageProperties;
import io.ghassen.pockito.core.storage.ObjectStorageService;
import io.ghassen.pockito.core.storage.StoredObject;
import io.ghassen.pockito.web.InvalidInputException;
import io.ghassen.pockito.web.ResourceNotFoundException;
import java.util.Map;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Every Pockito profile, preference, avatar and onboarding operation lives here.
 *
 * <p>The REST API and the MCP server are both thin adapters over this class — neither may
 * reimplement any of these rules.
 */
@Service
public class UserProfileService {

    private static final Logger log = LoggerFactory.getLogger(UserProfileService.class);

    private final UserProfileRepository repository;
    private final ObjectStorageService objectStorage;
    private final NotificationEventPublisher events;
    private final PockitoProperties properties;
    private final ObjectStorageProperties storageProperties;

    public UserProfileService(
            UserProfileRepository repository,
            ObjectStorageService objectStorage,
            NotificationEventPublisher events,
            PockitoProperties properties,
            ObjectStorageProperties storageProperties) {
        this.repository = repository;
        this.objectStorage = objectStorage;
        this.events = events;
        this.properties = properties;
        this.storageProperties = storageProperties;
    }

    /**
     * Resolves the caller's profile, creating it on first sight of a Keycloak subject.
     *
     * <p>This is what makes "first login" work without a separate registration call into
     * Pockito: Keycloak registers the identity, and the first authenticated request here
     * materialises the matching application profile with onboarding still pending.
     */
    @Transactional
    public UserProfile findOrCreate(AuthenticatedUser user) {
        return repository.findByKeycloakSubject(user.subject())
                .map(profile -> {
                    if (profile.syncEmail(user.email())) {
                        log.debug("Refreshed mirrored email for subject {}", user.subject());
                    }
                    return profile;
                })
                .orElseGet(() -> createProfile(user));
    }

    private UserProfile createProfile(AuthenticatedUser user) {
        UserProfile profile = UserProfile.forSubject(user.subject(), user.email(), initialDisplayName(user));
        try {
            UserProfile saved = repository.saveAndFlush(profile);
            log.info("Created Pockito profile {} for new Keycloak subject", saved.getId());
            events.publish(NotificationEvent.of(
                    "profile.created", user.subject(), Map.of("profileId", saved.getId().toString())));
            return saved;
        } catch (DataIntegrityViolationException e) {
            // Two concurrent first requests raced; the other one won.
            return repository.findByKeycloakSubject(user.subject())
                    .orElseThrow(() -> e);
        }
    }

    /**
     * Falls back through the claims Keycloak may or may not have set, so a profile always
     * has a non-blank name even before onboarding runs.
     */
    private static String initialDisplayName(AuthenticatedUser user) {
        String candidate = firstNonBlank(user.preferredUsername(), user.email());
        if (candidate == null) {
            return "Pockito user";
        }
        // Keycloak is configured with email-as-username, so the raw claim is an address.
        // Showing "kito@example.com" as a display name would look like a placeholder; the
        // local part is a better first guess, and onboarding lets the user replace it.
        return truncate(candidate.contains("@") ? candidate.substring(0, candidate.indexOf('@')) : candidate);
    }

    private static String firstNonBlank(String first, String second) {
        if (first != null && !first.isBlank()) {
            return first;
        }
        return second != null && !second.isBlank() ? second : null;
    }

    private static String truncate(String value) {
        return value.length() <= 80 ? value : value.substring(0, 80);
    }

    @Transactional
    public BootstrapResponse bootstrap(AuthenticatedUser user) {
        UserProfile profile = findOrCreate(user);
        return new BootstrapResponse(
                toProfileResponse(profile),
                toPreferencesResponse(profile),
                !profile.isOnboardingCompleted(),
                java.util.Arrays.stream(io.ghassen.pockito.contracts.AppLanguage.values())
                        .map(io.ghassen.pockito.contracts.AppLanguage::tag)
                        .toList(),
                properties.supportedCurrencies());
    }

    @Transactional
    public ProfileResponse getProfile(AuthenticatedUser user) {
        return toProfileResponse(findOrCreate(user));
    }

    @Transactional
    public ProfileResponse updateDisplayName(AuthenticatedUser user, String displayName) {
        UserProfile profile = findOrCreate(user);
        String trimmed = displayName == null ? "" : displayName.trim();
        if (trimmed.isEmpty()) {
            throw new InvalidInputException("profile.display_name.blank", "Display name must not be blank");
        }
        if (trimmed.length() > 80) {
            throw new InvalidInputException("profile.display_name.too_long", "Display name must be at most 80 characters");
        }
        profile.rename(trimmed);
        return toProfileResponse(profile);
    }

    @Transactional
    public PreferencesResponse getPreferences(AuthenticatedUser user) {
        return toPreferencesResponse(findOrCreate(user));
    }

    @Transactional
    public PreferencesResponse updatePreferences(AuthenticatedUser user, UpdatePreferencesRequest request) {
        UserProfile profile = findOrCreate(user);
        applyPreferences(profile, request);
        return toPreferencesResponse(profile);
    }

    private void applyPreferences(UserProfile profile, UpdatePreferencesRequest request) {
        String currency = request.defaultCurrency() == null ? "" : request.defaultCurrency().toUpperCase();
        if (!properties.supportsCurrency(currency)) {
            throw new InvalidInputException(
                    "preferences.currency.unsupported",
                    "Currency " + currency + " is not supported");
        }
        profile.applyPreferences(request.language(), request.theme(), currency);
    }

    /**
     * Runs the whole onboarding submission as one transaction so a user can never end up
     * marked onboarded with preferences that failed validation.
     */
    @Transactional
    public BootstrapResponse completeOnboarding(AuthenticatedUser user, CompleteOnboardingRequest request) {
        UserProfile profile = findOrCreate(user);
        String trimmed = request.displayName() == null ? "" : request.displayName().trim();
        if (trimmed.isEmpty()) {
            throw new InvalidInputException("profile.display_name.blank", "Display name must not be blank");
        }
        profile.rename(trimmed);
        applyPreferences(profile, request.preferences());

        boolean wasPending = !profile.isOnboardingCompleted();
        profile.completeOnboarding();
        if (wasPending) {
            events.publish(NotificationEvent.of(
                    "profile.onboarding.completed",
                    user.subject(),
                    Map.of("profileId", profile.getId().toString())));
        }
        return bootstrap(user);
    }

    @Transactional
    public AvatarResponse uploadAvatar(AuthenticatedUser user, byte[] content, String contentType) {
        var limits = properties.avatar();
        if (content == null || content.length == 0) {
            throw new InvalidInputException("avatar.empty", "Avatar file is empty");
        }
        if (content.length > limits.maxSizeBytes()) {
            throw new InvalidInputException(
                    "avatar.too_large",
                    "Avatar must be at most " + limits.maxSizeBytes() + " bytes");
        }
        String normalisedType = contentType == null ? "" : contentType.toLowerCase().split(";")[0].trim();
        if (!limits.allowedContentTypes().contains(normalisedType)) {
            throw new InvalidInputException(
                    "avatar.unsupported_type",
                    "Avatar must be one of " + limits.allowedContentTypes());
        }

        UserProfile profile = findOrCreate(user);
        String previousKey = profile.getAvatarObjectKey();
        // A fresh key per upload keeps CDN/browser caches from serving the old image.
        String key = "avatars/%s/%s%s".formatted(
                profile.getId(), UUID.randomUUID(), extensionFor(normalisedType));

        StoredObject stored = objectStorage.putObject(key, content, normalisedType);
        profile.attachAvatar(stored.key(), stored.contentType(), stored.sizeBytes());

        if (previousKey != null && !previousKey.equals(stored.key())) {
            deleteQuietly(previousKey);
        }
        return toAvatarResponse(profile);
    }

    @Transactional
    public void deleteAvatar(AuthenticatedUser user) {
        UserProfile profile = findOrCreate(user);
        String key = profile.getAvatarObjectKey();
        if (key == null) {
            throw new ResourceNotFoundException("avatar.not_found", "No avatar is set for this user");
        }
        profile.detachAvatar();
        deleteQuietly(key);
    }

    /**
     * Removes a superseded or deleted object without letting a storage hiccup roll back the
     * database change — an orphaned object is cheaper than a broken profile update.
     */
    private void deleteQuietly(String key) {
        try {
            objectStorage.deleteObject(key);
        } catch (RuntimeException e) {
            log.warn("Could not delete object {} from storage: {}", key, e.toString());
        }
    }

    @Transactional(readOnly = true)
    public byte[] readAvatarBytes(AuthenticatedUser user) {
        UserProfile profile = repository.findByKeycloakSubject(user.subject())
                .orElseThrow(() -> new ResourceNotFoundException("profile.not_found", "No profile for this identity"));
        String key = profile.getAvatarObjectKey();
        if (key == null) {
            throw new ResourceNotFoundException("avatar.not_found", "No avatar is set for this user");
        }
        return objectStorage.getObject(key)
                .orElseThrow(() -> new ResourceNotFoundException("avatar.not_found", "Avatar object is missing"));
    }

    private static String extensionFor(String contentType) {
        return switch (contentType) {
            case "image/png" -> ".png";
            case "image/jpeg" -> ".jpg";
            case "image/webp" -> ".webp";
            default -> "";
        };
    }

    private ProfileResponse toProfileResponse(UserProfile profile) {
        return new ProfileResponse(
                profile.getKeycloakSubject(),
                profile.getEmail(),
                profile.getDisplayName(),
                presignedAvatarUrl(profile),
                profile.isOnboardingCompleted(),
                profile.getCreatedAt(),
                profile.getUpdatedAt());
    }

    /**
     * Avatar URLs are pre-signed per response rather than stored, so the object stays
     * private and a leaked URL expires on its own.
     */
    private String presignedAvatarUrl(UserProfile profile) {
        if (profile.getAvatarObjectKey() == null) {
            return null;
        }
        try {
            return objectStorage.createPresignedUrl(
                    profile.getAvatarObjectKey(), storageProperties.presignedUrlValidity());
        } catch (RuntimeException e) {
            log.warn("Could not pre-sign avatar URL for profile {}: {}", profile.getId(), e.toString());
            return null;
        }
    }

    private AvatarResponse toAvatarResponse(UserProfile profile) {
        return new AvatarResponse(
                profile.getAvatarObjectKey(),
                presignedAvatarUrl(profile),
                profile.getAvatarContentType(),
                profile.getAvatarSizeBytes() == null ? 0L : profile.getAvatarSizeBytes());
    }

    private static PreferencesResponse toPreferencesResponse(UserProfile profile) {
        return new PreferencesResponse(profile.getLanguage(), profile.getTheme(), profile.getDefaultCurrency());
    }
}
