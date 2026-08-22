package io.ghassen.pockito.core;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import io.ghassen.pockito.core.profile.UserProfile;
import io.ghassen.pockito.core.profile.UserProfileRepository;
import io.ghassen.pockito.core.support.InMemoryObjectStorage;
import io.ghassen.pockito.core.support.PostgresTestBase;
import io.ghassen.pockito.core.support.RecordingNotificationPublisher;
import io.ghassen.pockito.core.support.TestStubsConfiguration;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.RequestPostProcessor;
import tools.jackson.databind.ObjectMapper;

/**
 * Covers Core's HTTP surface against a real database and real migrations.
 *
 * <p>Identity is supplied as a validated JWT rather than a stubbed principal, so the tests
 * exercise the same subject-mapping path production uses.
 */
@AutoConfigureMockMvc
@Import(TestStubsConfiguration.class)
class ProfileApiTest extends PostgresTestBase {

    @Autowired
    MockMvc mvc;

    @Autowired
    UserProfileRepository profiles;

    @Autowired
    InMemoryObjectStorage storage;

    @Autowired
    RecordingNotificationPublisher events;

    @Autowired
    ObjectMapper json;

    private String subject;

    @BeforeEach
    void freshIdentity() {
        subject = UUID.randomUUID().toString();
        events.clear();
    }

    /** Builds the security context the resource server would produce for a Keycloak token. */
    private RequestPostProcessor asUser(String keycloakSubject, String email) {
        return jwt().jwt(builder -> builder
                .subject(keycloakSubject)
                .claim("email", email)
                .claim("preferred_username", email));
    }

    private RequestPostProcessor asCurrentUser() {
        return asUser(subject, "user-" + subject.substring(0, 8) + "@example.test");
    }

    @Nested
    @DisplayName("authentication")
    class Authentication {

        @Test
        void rejectsUnauthenticatedProfileAccess() throws Exception {
            mvc.perform(get("/internal/v1/profile")).andExpect(status().isUnauthorized());
        }

        @Test
        void rejectsUnauthenticatedBootstrap() throws Exception {
            mvc.perform(get("/internal/v1/bootstrap")).andExpect(status().isUnauthorized());
        }

        @Test
        void rejectsUnauthenticatedProfileUpdate() throws Exception {
            mvc.perform(put("/internal/v1/profile")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"displayName\":\"Mallory\"}"))
                    .andExpect(status().isUnauthorized());
        }

        @Test
        void refusesRoutesOutsideTheInternalApi() throws Exception {
            mvc.perform(get("/anything").with(asCurrentUser())).andExpect(status().isForbidden());
        }
    }

    @Nested
    @DisplayName("first login")
    class FirstLogin {

        @Test
        void createsAProfileOnFirstAuthenticatedRequest() throws Exception {
            assertThat(profiles.findByKeycloakSubject(subject)).isEmpty();

            mvc.perform(get("/internal/v1/bootstrap").with(asCurrentUser()))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.onboardingRequired").value(true))
                    .andExpect(jsonPath("$.profile.subject").value(subject))
                    .andExpect(jsonPath("$.preferences.language").value("EN"))
                    .andExpect(jsonPath("$.preferences.theme").value("SYSTEM"));

            assertThat(profiles.findByKeycloakSubject(subject)).isPresent();
            assertThat(events.publishedTypes()).contains("profile.created");
        }

        @Test
        void reusesTheSameProfileOnSubsequentRequests() throws Exception {
            mvc.perform(get("/internal/v1/bootstrap").with(asCurrentUser())).andExpect(status().isOk());
            events.clear();
            mvc.perform(get("/internal/v1/bootstrap").with(asCurrentUser())).andExpect(status().isOk());

            assertThat(profiles.findAll().stream()
                    .filter(p -> p.getKeycloakSubject().equals(subject))
                    .count()).isEqualTo(1);
            assertThat(events.publishedTypes()).doesNotContain("profile.created");
        }

        @Test
        void keepsDifferentKeycloakSubjectsApart() throws Exception {
            String other = UUID.randomUUID().toString();
            mvc.perform(get("/internal/v1/profile").with(asCurrentUser())).andExpect(status().isOk());
            mvc.perform(get("/internal/v1/profile").with(asUser(other, "other@example.test")))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.subject").value(other));

            assertThat(profiles.findByKeycloakSubject(subject).map(UserProfile::getId))
                    .isNotEqualTo(profiles.findByKeycloakSubject(other).map(UserProfile::getId));
        }

        @Test
        void derivesTheInitialDisplayNameFromTheEmailLocalPart() throws Exception {
            mvc.perform(get("/internal/v1/profile").with(asUser(subject, "kito.tester@example.test")))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.displayName").value("kito.tester"));
        }

        @Test
        void mirrorsAnUpdatedEmailFromTheToken() throws Exception {
            mvc.perform(get("/internal/v1/profile").with(asUser(subject, "before@example.test")))
                    .andExpect(status().isOk());
            mvc.perform(get("/internal/v1/profile").with(asUser(subject, "after@example.test")))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.email").value("after@example.test"));
        }
    }

    @Nested
    @DisplayName("profile and preferences")
    class ProfileAndPreferences {

        @Test
        void updatesTheDisplayName() throws Exception {
            mvc.perform(put("/internal/v1/profile")
                            .with(asCurrentUser())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"displayName\":\"Kito Tester\"}"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.displayName").value("Kito Tester"));

            mvc.perform(get("/internal/v1/profile").with(asCurrentUser()))
                    .andExpect(jsonPath("$.displayName").value("Kito Tester"));
        }

        @Test
        void trimsSurroundingWhitespaceFromTheDisplayName() throws Exception {
            mvc.perform(put("/internal/v1/profile")
                            .with(asCurrentUser())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"displayName\":\"  Kito  \"}"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.displayName").value("Kito"));
        }

        @Test
        void rejectsABlankDisplayName() throws Exception {
            mvc.perform(put("/internal/v1/profile")
                            .with(asCurrentUser())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"displayName\":\"   \"}"))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.code").value("validation.failed"));
        }

        @Test
        void updatesPreferences() throws Exception {
            mvc.perform(put("/internal/v1/profile/preferences")
                            .with(asCurrentUser())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"language\":\"JA\",\"theme\":\"DARK\",\"defaultCurrency\":\"JPY\"}"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.language").value("JA"))
                    .andExpect(jsonPath("$.theme").value("DARK"))
                    .andExpect(jsonPath("$.defaultCurrency").value("JPY"));

            mvc.perform(get("/internal/v1/profile/preferences").with(asCurrentUser()))
                    .andExpect(jsonPath("$.defaultCurrency").value("JPY"));
        }

        @Test
        void rejectsAnUnsupportedCurrency() throws Exception {
            mvc.perform(put("/internal/v1/profile/preferences")
                            .with(asCurrentUser())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"language\":\"EN\",\"theme\":\"DARK\",\"defaultCurrency\":\"ZZZ\"}"))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.code").value("preferences.currency.unsupported"));
        }

        @Test
        void rejectsAnUnknownTheme() throws Exception {
            mvc.perform(put("/internal/v1/profile/preferences")
                            .with(asCurrentUser())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"language\":\"EN\",\"theme\":\"NEON\",\"defaultCurrency\":\"EUR\"}"))
                    .andExpect(status().isBadRequest());
        }

        @Test
        void everyErrorCarriesACorrelationId() throws Exception {
            mvc.perform(put("/internal/v1/profile/preferences")
                            .with(asCurrentUser())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"language\":\"EN\",\"theme\":\"DARK\",\"defaultCurrency\":\"ZZZ\"}"))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.correlationId").isNotEmpty());
        }
    }

    @Nested
    @DisplayName("onboarding")
    class Onboarding {

        @Test
        void completesOnboardingInOneCall() throws Exception {
            mvc.perform(post("/internal/v1/onboarding/complete")
                            .with(asCurrentUser())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("""
                                    {"displayName":"Kito",
                                     "preferences":{"language":"JA","theme":"LIGHT","defaultCurrency":"JPY"}}"""))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.onboardingRequired").value(false))
                    .andExpect(jsonPath("$.profile.displayName").value("Kito"))
                    .andExpect(jsonPath("$.preferences.defaultCurrency").value("JPY"));

            assertThat(events.publishedTypes()).contains("profile.onboarding.completed");
        }

        @Test
        void doesNotAskForOnboardingAgain() throws Exception {
            completeOnboarding();
            mvc.perform(get("/internal/v1/bootstrap").with(asCurrentUser()))
                    .andExpect(jsonPath("$.onboardingRequired").value(false));
        }

        @Test
        void announcesCompletionOnlyOnce() throws Exception {
            completeOnboarding();
            events.clear();
            completeOnboarding();
            assertThat(events.publishedTypes()).doesNotContain("profile.onboarding.completed");
        }

        @Test
        void leavesTheUserUnonboardedWhenPreferencesAreInvalid() throws Exception {
            mvc.perform(post("/internal/v1/onboarding/complete")
                            .with(asCurrentUser())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("""
                                    {"displayName":"Kito",
                                     "preferences":{"language":"EN","theme":"DARK","defaultCurrency":"ZZZ"}}"""))
                    .andExpect(status().isBadRequest());

            mvc.perform(get("/internal/v1/bootstrap").with(asCurrentUser()))
                    .andExpect(jsonPath("$.onboardingRequired").value(true))
                    .andExpect(jsonPath("$.profile.displayName").value(org.hamcrest.Matchers.not("Kito")));
        }

        private void completeOnboarding() throws Exception {
            mvc.perform(post("/internal/v1/onboarding/complete")
                            .with(asCurrentUser())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("""
                                    {"displayName":"Kito",
                                     "preferences":{"language":"EN","theme":"LIGHT","defaultCurrency":"EUR"}}"""))
                    .andExpect(status().isOk());
        }
    }

    @Nested
    @DisplayName("avatar")
    class Avatar {

        private static final byte[] PNG = {
            (byte) 0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A, 1, 2, 3, 4
        };

        @Test
        void storesTheBytesInObjectStorageAndOnlyMetadataInTheDatabase() throws Exception {
            uploadAvatar();

            UserProfile profile = profiles.findByKeycloakSubject(subject).orElseThrow();
            assertThat(profile.getAvatarObjectKey()).startsWith("avatars/" + profile.getId());
            assertThat(profile.getAvatarSizeBytes()).isEqualTo(PNG.length);
            assertThat(storage.contains(profile.getAvatarObjectKey())).isTrue();
        }

        @Test
        void returnsAPresignedUrlOnTheProfile() throws Exception {
            uploadAvatar();
            mvc.perform(get("/internal/v1/profile").with(asCurrentUser()))
                    .andExpect(jsonPath("$.avatarUrl").isNotEmpty());
        }

        @Test
        void servesTheStoredBytesBack() throws Exception {
            uploadAvatar();
            byte[] served = mvc.perform(get("/internal/v1/profile/avatar").with(asCurrentUser()))
                    .andExpect(status().isOk())
                    .andReturn().getResponse().getContentAsByteArray();
            assertThat(served).isEqualTo(PNG);
        }

        @Test
        void replacingAnAvatarRemovesThePreviousObject() throws Exception {
            uploadAvatar();
            String firstKey = profiles.findByKeycloakSubject(subject).orElseThrow().getAvatarObjectKey();
            uploadAvatar();
            String secondKey = profiles.findByKeycloakSubject(subject).orElseThrow().getAvatarObjectKey();

            assertThat(secondKey).isNotEqualTo(firstKey);
            assertThat(storage.contains(firstKey)).isFalse();
            assertThat(storage.contains(secondKey)).isTrue();
        }

        @Test
        void rejectsAnUnsupportedContentType() throws Exception {
            mvc.perform(post("/internal/v1/profile/avatar")
                            .with(asCurrentUser())
                            .contentType(MediaType.TEXT_PLAIN)
                            .content("not an image"))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.code").value("avatar.unsupported_type"));
        }

        @Test
        void rejectsAnEmptyUpload() throws Exception {
            mvc.perform(post("/internal/v1/profile/avatar")
                            .with(asCurrentUser())
                            .contentType(MediaType.IMAGE_PNG)
                            .content(new byte[0]))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.code").value("avatar.empty"));
        }

        @Test
        void deletingRemovesBothTheObjectAndTheMetadata() throws Exception {
            uploadAvatar();
            String key = profiles.findByKeycloakSubject(subject).orElseThrow().getAvatarObjectKey();

            mvc.perform(delete("/internal/v1/profile/avatar").with(asCurrentUser()))
                    .andExpect(status().isNoContent());

            assertThat(storage.contains(key)).isFalse();
            assertThat(profiles.findByKeycloakSubject(subject).orElseThrow().getAvatarObjectKey()).isNull();
        }

        @Test
        void deletingWhenThereIsNoAvatarReportsNotFound() throws Exception {
            mvc.perform(get("/internal/v1/profile").with(asCurrentUser())).andExpect(status().isOk());
            mvc.perform(delete("/internal/v1/profile/avatar").with(asCurrentUser()))
                    .andExpect(status().isNotFound())
                    .andExpect(jsonPath("$.code").value("avatar.not_found"));
        }

        @Test
        void oneUsersAvatarIsNeverVisibleToAnother() throws Exception {
            uploadAvatar();
            mvc.perform(get("/internal/v1/profile/avatar").with(asUser(UUID.randomUUID().toString(), "other@example.test")))
                    .andExpect(status().isNotFound());
        }

        private void uploadAvatar() throws Exception {
            mvc.perform(post("/internal/v1/profile/avatar")
                            .with(asCurrentUser())
                            .contentType(MediaType.IMAGE_PNG)
                            .content(PNG))
                    .andExpect(status().isOk());
        }
    }
}
