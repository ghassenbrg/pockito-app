package io.ghassen.pockito.api.v1;

import io.ghassen.pockito.coreclient.CoreClient;
import io.ghassen.pockito.contracts.AvatarResponse;
import io.ghassen.pockito.contracts.BootstrapResponse;
import io.ghassen.pockito.contracts.CompleteOnboardingRequest;
import io.ghassen.pockito.contracts.PreferencesResponse;
import io.ghassen.pockito.contracts.ProfileResponse;
import io.ghassen.pockito.contracts.UpdatePreferencesRequest;
import io.ghassen.pockito.contracts.UpdateProfileRequest;
import io.ghassen.pockito.web.InvalidInputException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.io.IOException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * The authenticated user's own profile, preferences and avatar.
 *
 * <p>Every method here is a translation step: unwrap HTTP, call Core, shape the response.
 * No rule about what a valid display name or currency is lives in this class.
 */
@RestController
@RequestMapping("/api/v1")
@Tag(name = "Me", description = "Profile, preferences and avatar of the authenticated user")
@SecurityRequirement(name = "bearer-jwt")
public class MeController {

    private final CoreClient core;

    public MeController(CoreClient core) {
        this.core = core;
    }

    @GetMapping("/bootstrap")
    @Operation(summary = "Everything a client needs to initialise: profile, preferences and onboarding state")
    public BootstrapResponse bootstrap() {
        return core.bootstrap();
    }

    @GetMapping("/me")
    @Operation(summary = "Get the authenticated user's Pockito profile")
    public ProfileResponse me() {
        return core.profile();
    }

    @PutMapping("/me")
    @Operation(summary = "Update the authenticated user's Pockito profile")
    public ProfileResponse updateMe(@Valid @RequestBody UpdateProfileRequest request) {
        return core.updateProfile(request);
    }

    @GetMapping("/me/preferences")
    @Operation(summary = "Get language, appearance and default currency")
    public PreferencesResponse preferences() {
        return core.preferences();
    }

    @PutMapping("/me/preferences")
    @Operation(summary = "Update language, appearance and default currency")
    public PreferencesResponse updatePreferences(@Valid @RequestBody UpdatePreferencesRequest request) {
        return core.updatePreferences(request);
    }

    @PostMapping(value = "/me/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Upload or replace the avatar")
    public AvatarResponse uploadAvatar(@RequestPart("file") MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new InvalidInputException("avatar.empty", "No avatar file was uploaded");
        }
        String contentType = file.getContentType();
        if (contentType == null || contentType.isBlank()) {
            throw new InvalidInputException("avatar.missing_content_type", "Uploaded file has no content type");
        }
        try {
            return core.uploadAvatar(file.getBytes(), contentType);
        } catch (IOException e) {
            throw new InvalidInputException("avatar.unreadable", "Uploaded file could not be read");
        }
    }

    /**
     * Streams the avatar through the API. Clients normally use the pre-signed URL from the
     * profile instead; this exists for callers that cannot reach object storage directly.
     */
    @GetMapping("/me/avatar")
    @Operation(summary = "Download the avatar bytes")
    public ResponseEntity<byte[]> avatar() {
        byte[] bytes = core.avatarBytes();
        return ResponseEntity.ok()
                .header(HttpHeaders.CACHE_CONTROL, "private, max-age=60")
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(bytes);
    }

    @DeleteMapping("/me/avatar")
    @Operation(summary = "Remove the avatar")
    public ResponseEntity<Void> deleteAvatar() {
        core.deleteAvatar();
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/onboarding/complete")
    @Operation(summary = "Submit onboarding and mark it complete")
    public BootstrapResponse completeOnboarding(@Valid @RequestBody CompleteOnboardingRequest request) {
        return core.completeOnboarding(request);
    }
}
