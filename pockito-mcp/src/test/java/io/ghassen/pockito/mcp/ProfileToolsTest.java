package io.ghassen.pockito.mcp;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.BDDMockito.given;

import io.ghassen.pockito.contracts.AppLanguage;
import io.ghassen.pockito.contracts.AppTheme;
import io.ghassen.pockito.contracts.PreferencesResponse;
import io.ghassen.pockito.contracts.ProfileResponse;
import io.ghassen.pockito.coreclient.CoreClient;
import io.ghassen.pockito.mcp.config.McpAccessToken;
import io.ghassen.pockito.mcp.tools.ProfileTools;
import io.modelcontextprotocol.common.McpTransportContext;
import java.time.Instant;
import java.util.Map;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

/**
 * The tools' only job is to act on the caller's own identity. These tests pin the part
 * that would be a security hole if it were wrong: the token has to come from this call's
 * transport context, and a call without one must be refused rather than falling back to
 * whatever credential happens to be lying around.
 */
@ExtendWith(MockitoExtension.class)
class ProfileToolsTest {

    private static final ProfileResponse PROFILE = new ProfileResponse(
            "sub-1", "kito@example.test", "Kito", null, true, Instant.EPOCH, Instant.EPOCH);

    @Mock
    CoreClient core;

    private final McpAccessToken accessToken = new McpAccessToken();

    private ProfileTools tools() {
        return new ProfileTools(core, accessToken);
    }

    private static McpTransportContext contextWith(String token) {
        return McpTransportContext.create(Map.of(McpAccessToken.CONTEXT_KEY, token));
    }

    @Test
    void getMyProfileDelegatesToCore() {
        given(core.profile()).willReturn(PROFILE);

        assertThat(tools().getMyProfile(contextWith("caller-token"))).isEqualTo(PROFILE);
    }

    @Test
    void getMyPreferencesDelegatesToCore() {
        var preferences = new PreferencesResponse(AppLanguage.JA, AppTheme.DARK, "JPY");
        given(core.preferences()).willReturn(preferences);

        assertThat(tools().getMyPreferences(contextWith("caller-token"))).isEqualTo(preferences);
    }

    @Test
    void bindsTheCallersTokenForTheDurationOfTheCall() {
        given(core.profile()).willAnswer(invocation -> {
            // While the tool is running, the Core client must see this caller's token.
            assertThat(accessToken.currentTokenValue()).isEqualTo("caller-token");
            return PROFILE;
        });

        tools().getMyProfile(contextWith("caller-token"));
    }

    @Test
    void unbindsTheTokenAfterwardsSoItCannotLeakIntoAnotherCall() {
        given(core.profile()).willReturn(PROFILE);
        tools().getMyProfile(contextWith("caller-token"));

        assertThatThrownBy(accessToken::currentTokenValue)
                .isInstanceOf(IllegalStateException.class);
    }

    @Test
    void unbindsTheTokenEvenWhenTheCallFails() {
        given(core.profile()).willThrow(new IllegalStateException("core exploded"));

        assertThatThrownBy(() -> tools().getMyProfile(contextWith("caller-token")))
                .isInstanceOf(IllegalStateException.class);
        assertThatThrownBy(accessToken::currentTokenValue)
                .isInstanceOf(IllegalStateException.class);
    }

    @Test
    void refusesACallThatCarriesNoToken() {
        assertThatThrownBy(() -> tools().getMyProfile(McpTransportContext.EMPTY))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("access token");
    }

    @Test
    void refusesACallWithABlankToken() {
        assertThatThrownBy(() -> tools().getMyProfile(contextWith("   ")))
                .isInstanceOf(IllegalStateException.class);
    }

    @Test
    void refusesACallWithNoTransportContextAtAll() {
        assertThatThrownBy(() -> tools().getMyProfile(null))
                .isInstanceOf(IllegalStateException.class);
    }
}
