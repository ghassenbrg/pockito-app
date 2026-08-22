package io.ghassen.pockito.api;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.BDDMockito.willThrow;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import io.ghassen.pockito.contracts.AppLanguage;
import io.ghassen.pockito.contracts.AppTheme;
import io.ghassen.pockito.contracts.AvatarResponse;
import io.ghassen.pockito.contracts.BootstrapResponse;
import io.ghassen.pockito.contracts.PreferencesResponse;
import io.ghassen.pockito.contracts.ProfileResponse;
import io.ghassen.pockito.contracts.UpdateProfileRequest;
import io.ghassen.pockito.coreclient.CoreClient;
import io.ghassen.pockito.web.CorrelationId;
import io.ghassen.pockito.web.InvalidInputException;
import io.ghassen.pockito.web.ResourceNotFoundException;
import io.ghassen.pockito.web.UpstreamUnavailableException;
import java.time.Instant;
import java.util.List;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

/**
 * The API is an adapter, so these tests check exactly that: HTTP in, a Core call out, and
 * the right status and error shape coming back. Core itself is mocked — its behaviour is
 * covered by its own tests, and duplicating it here would test the mock.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class MeControllerTest {

    private static final ProfileResponse PROFILE = new ProfileResponse(
            "sub-1", "kito@example.test", "Kito Tester", "https://storage.test/a.png",
            true, Instant.EPOCH, Instant.EPOCH);

    private static final PreferencesResponse PREFERENCES =
            new PreferencesResponse(AppLanguage.EN, AppTheme.SYSTEM, "EUR");

    @Autowired
    MockMvc mvc;

    @MockitoBean
    CoreClient core;

    @Nested
    @DisplayName("authentication")
    class Authentication {

        @Test
        void rejectsAnUnauthenticatedRequest() throws Exception {
            mvc.perform(get("/api/v1/me"))
                    .andExpect(status().isUnauthorized())
                    .andExpect(jsonPath("$.code").value("auth.unauthenticated"));
        }

        @Test
        void answersUnauthenticatedRequestsAsJsonRatherThanAnEmptyBody() throws Exception {
            // A client that cannot parse the 401 cannot tell an expired session from any
            // other failure, so the shape matters as much as the status.
            mvc.perform(get("/api/v1/bootstrap"))
                    .andExpect(status().isUnauthorized())
                    .andExpect(header().exists(CorrelationId.HEADER))
                    .andExpect(jsonPath("$.correlationId").isNotEmpty());
        }

        @Test
        void neverReachesCoreWithoutAToken() throws Exception {
            mvc.perform(get("/api/v1/me")).andExpect(status().isUnauthorized());
            then(core).shouldHaveNoInteractions();
        }

        @Test
        void allowsHealthChecksWithoutAToken() throws Exception {
            mvc.perform(get("/actuator/health/liveness")).andExpect(status().isOk());
        }
    }

    @Nested
    @DisplayName("delegation to Core")
    class Delegation {

        @Test
        void bootstrapReturnsWhatCoreProvides() throws Exception {
            given(core.bootstrap()).willReturn(new BootstrapResponse(
                    PROFILE, PREFERENCES, false, List.of("en", "ja"), List.of("EUR", "JPY")));

            mvc.perform(get("/api/v1/bootstrap").with(jwt()))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.profile.displayName").value("Kito Tester"))
                    .andExpect(jsonPath("$.onboardingRequired").value(false))
                    .andExpect(jsonPath("$.supportedCurrencies[0]").value("EUR"));
        }

        @Test
        void profileUpdateIsPassedThroughUnchanged() throws Exception {
            given(core.updateProfile(any())).willReturn(PROFILE);

            mvc.perform(put("/api/v1/me")
                            .with(jwt())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"displayName\":\"Kito Tester\"}"))
                    .andExpect(status().isOk());

            then(core).should().updateProfile(new UpdateProfileRequest("Kito Tester"));
        }

        @Test
        void avatarDeletionReturnsNoContent() throws Exception {
            mvc.perform(delete("/api/v1/me/avatar").with(jwt()))
                    .andExpect(status().isNoContent());
            then(core).should().deleteAvatar();
        }
    }

    @Nested
    @DisplayName("request validation")
    class Validation {

        @Test
        void rejectsABlankDisplayNameBeforeCallingCore() throws Exception {
            mvc.perform(put("/api/v1/me")
                            .with(jwt())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"displayName\":\"  \"}"))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.code").value("validation.failed"))
                    .andExpect(jsonPath("$.violations[0].field").value("displayName"));
            then(core).should(org.mockito.Mockito.never()).updateProfile(any());
        }

        @Test
        void rejectsACurrencyThatIsNotAnIsoCode() throws Exception {
            mvc.perform(put("/api/v1/me/preferences")
                            .with(jwt())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"language\":\"EN\",\"theme\":\"DARK\",\"defaultCurrency\":\"euro\"}"))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.code").value("validation.failed"));
        }

        @Test
        void rejectsAnUploadWithNoFile() throws Exception {
            mvc.perform(multipart("/api/v1/me/avatar")
                            .file(new MockMultipartFile("file", "empty.png", "image/png", new byte[0]))
                            .with(jwt()))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.code").value("avatar.empty"));
        }

        @Test
        void rejectsAMalformedBody() throws Exception {
            mvc.perform(put("/api/v1/me")
                            .with(jwt())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{not json"))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.code").value("request.malformed"));
        }
    }

    @Nested
    @DisplayName("error translation")
    class ErrorTranslation {

        @Test
        void aCoreValidationFailureStaysA400WithItsOriginalCode() throws Exception {
            // The point of relaying Core's code: a client should see why its request was
            // rejected, not a generic 500.
            willThrow(new InvalidInputException("preferences.currency.unsupported", "no"))
                    .given(core).updatePreferences(any());

            mvc.perform(put("/api/v1/me/preferences")
                            .with(jwt())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"language\":\"EN\",\"theme\":\"DARK\",\"defaultCurrency\":\"ZZZ\"}"))
                    .andExpect(status().isBadRequest())
                    .andExpect(jsonPath("$.code").value("preferences.currency.unsupported"));
        }

        @Test
        void aMissingAvatarIsA404() throws Exception {
            willThrow(new ResourceNotFoundException("avatar.not_found", "none"))
                    .given(core).deleteAvatar();

            mvc.perform(delete("/api/v1/me/avatar").with(jwt()))
                    .andExpect(status().isNotFound())
                    .andExpect(jsonPath("$.code").value("avatar.not_found"));
        }

        @Test
        void anUnreachableCoreIsA503SoClientsKnowToRetry() throws Exception {
            willThrow(new UpstreamUnavailableException("core.unreachable", "down", null))
                    .given(core).bootstrap();

            mvc.perform(get("/api/v1/bootstrap").with(jwt()))
                    .andExpect(status().isServiceUnavailable())
                    .andExpect(jsonPath("$.code").value("core.unreachable"));
        }

        @Test
        void anUnexpectedFailureLeaksNothingToTheClient() throws Exception {
            willThrow(new IllegalStateException("connection string: postgres://user:hunter2@db"))
                    .given(core).bootstrap();

            mvc.perform(get("/api/v1/bootstrap").with(jwt()))
                    .andExpect(status().isInternalServerError())
                    .andExpect(jsonPath("$.code").value("internal.error"))
                    .andExpect(jsonPath("$.message").value("Something went wrong"));
        }
    }

    @Nested
    @DisplayName("correlation")
    class Correlation {

        @Test
        void echoesTheClientsCorrelationId() throws Exception {
            given(core.profile()).willReturn(PROFILE);

            mvc.perform(get("/api/v1/me").with(jwt()).header(CorrelationId.HEADER, "web-abc-123"))
                    .andExpect(header().string(CorrelationId.HEADER, "web-abc-123"));
        }

        @Test
        void mintsOneWhenTheClientSendsNone() throws Exception {
            given(core.profile()).willReturn(PROFILE);

            mvc.perform(get("/api/v1/me").with(jwt()))
                    .andExpect(header().exists(CorrelationId.HEADER));
        }

        @Test
        void refusesAnIdThatWouldPoisonTheLogs() throws Exception {
            given(core.profile()).willReturn(PROFILE);

            // Client-supplied values end up in log files, so anything with unexpected
            // characters is replaced rather than echoed.
            mvc.perform(get("/api/v1/me").with(jwt())
                            .header(CorrelationId.HEADER, "abc\ninjected ERROR fake log line"))
                    .andExpect(header().string(CorrelationId.HEADER,
                            org.hamcrest.Matchers.not("abc\ninjected ERROR fake log line")));
        }
    }
}
