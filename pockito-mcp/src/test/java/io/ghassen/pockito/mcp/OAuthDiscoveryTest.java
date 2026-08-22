package io.ghassen.pockito.mcp;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import io.ghassen.pockito.coreclient.CoreClient;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

/**
 * An AI client such as ChatGPT is handed nothing but a URL. Everything it needs to log a
 * user in has to be discoverable from that URL alone: an unauthenticated call answers with
 * a challenge, the challenge names a metadata document, and the document names Keycloak.
 * Each link in that chain is asserted here, because a break in any one of them fails at
 * the client with an error message that does not say why.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class OAuthDiscoveryTest {

    private static final String METADATA = "/.well-known/oauth-protected-resource";

    @Autowired
    MockMvc mvc;

    @MockitoBean
    CoreClient core;

    @Test
    void anUnauthenticatedCallChallengesWithTheMetadataUrl() throws Exception {
        mvc.perform(post("/mcp")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}"""))
                .andExpect(status().isUnauthorized())
                .andExpect(header().string("WWW-Authenticate",
                        "Bearer resource_metadata=\"https://pockito.invalid"
                                + METADATA + "/mcp\""));
    }

    @Test
    void aRejectedTokenAlsoCarriesTheChallengeSoTheClientCanReauthenticate() throws Exception {
        mvc.perform(post("/mcp")
                        .header("Authorization", "Bearer not-a-jwt")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}"""))
                .andExpect(status().isUnauthorized())
                .andExpect(header().exists("WWW-Authenticate"));
    }

    @Test
    void theMetadataDocumentIsPublicAndNamesKeycloak() throws Exception {
        mvc.perform(get(METADATA))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.resource").value("https://pockito.invalid/mcp"))
                .andExpect(jsonPath("$.authorization_servers[0]")
                        .value("https://auth.invalid/realms/pockito"))
                .andExpect(jsonPath("$.bearer_methods_supported[0]").value("header"));
    }

    @Test
    void theSpecPrescribedPathServesTheSameDocument() throws Exception {
        // RFC 9728 appends the resource's path. Clients differ on which they try first,
        // so both have to answer, and answer identically.
        mvc.perform(get(METADATA + "/mcp"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.resource").value("https://pockito.invalid/mcp"));
    }

    @Test
    void theResourceIdentifierMatchesTheUrlAUserWouldEnter() throws Exception {
        // The identifier is what the access token is minted for. If it drifts from the
        // public MCP URL by so much as a trailing slash, every tool call is rejected
        // after a login that appeared to succeed.
        mvc.perform(get(METADATA))
                .andExpect(jsonPath("$.resource").value(
                        org.hamcrest.Matchers.not(org.hamcrest.Matchers.endsWith("/"))));
    }
}
