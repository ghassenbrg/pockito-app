package io.ghassen.pockito.core.web;

import io.ghassen.pockito.contracts.AvatarResponse;
import io.ghassen.pockito.contracts.BootstrapResponse;
import io.ghassen.pockito.contracts.CompleteOnboardingRequest;
import io.ghassen.pockito.contracts.PreferencesResponse;
import io.ghassen.pockito.contracts.ProfileResponse;
import io.ghassen.pockito.contracts.UpdatePreferencesRequest;
import io.ghassen.pockito.contracts.UpdateProfileRequest;
import io.ghassen.pockito.core.identity.CurrentUser;
import io.ghassen.pockito.core.profile.UserProfileService;
import jakarta.validation.Valid;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Core's internal HTTP surface, consumed only by Pockito API and Pockito MCP over the
 * cluster network. It is not exposed through Traefik.
 *
 * <p>The caller forwards the end user's Keycloak access token, which Core validates itself
 * — so Core always acts on a proven identity rather than on a claim made by a peer service.
 */
@RestController
@RequestMapping("/internal/v1")
public class CoreProfileController {

    private final UserProfileService profiles;
    private final CurrentUser currentUser;

    public CoreProfileController(UserProfileService profiles, CurrentUser currentUser) {
        this.profiles = profiles;
        this.currentUser = currentUser;
    }

    @GetMapping("/bootstrap")
    public BootstrapResponse bootstrap() {
        return profiles.bootstrap(currentUser.require());
    }

    @GetMapping("/profile")
    public ProfileResponse profile() {
        return profiles.getProfile(currentUser.require());
    }

    @PutMapping("/profile")
    public ProfileResponse updateProfile(@Valid @RequestBody UpdateProfileRequest request) {
        return profiles.updateDisplayName(currentUser.require(), request.displayName());
    }

    @GetMapping("/profile/preferences")
    public PreferencesResponse preferences() {
        return profiles.getPreferences(currentUser.require());
    }

    @PutMapping("/profile/preferences")
    public PreferencesResponse updatePreferences(@Valid @RequestBody UpdatePreferencesRequest request) {
        return profiles.updatePreferences(currentUser.require(), request);
    }

    /**
     * Takes the avatar as a raw body rather than multipart: the API layer has already
     * unwrapped the upload, and streaming bytes straight through avoids re-encoding.
     */
    @PostMapping(value = "/profile/avatar", consumes = MediaType.ALL_VALUE)
    public AvatarResponse uploadAvatar(
            // Optional so that an empty body reaches the service and is reported as
            // avatar.empty, rather than being rejected as a malformed request by the
            // message converter. Core validates its own input regardless of the caller.
            @RequestBody(required = false) byte[] content,
            @RequestHeader(HttpHeaders.CONTENT_TYPE) String contentType) {
        return profiles.uploadAvatar(currentUser.require(), content, contentType);
    }

    @GetMapping("/profile/avatar")
    public ResponseEntity<byte[]> avatar() {
        byte[] bytes = profiles.readAvatarBytes(currentUser.require());
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(bytes);
    }

    @DeleteMapping("/profile/avatar")
    public ResponseEntity<Void> deleteAvatar() {
        profiles.deleteAvatar(currentUser.require());
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/onboarding/complete")
    public BootstrapResponse completeOnboarding(@Valid @RequestBody CompleteOnboardingRequest request) {
        return profiles.completeOnboarding(currentUser.require(), request);
    }
}
