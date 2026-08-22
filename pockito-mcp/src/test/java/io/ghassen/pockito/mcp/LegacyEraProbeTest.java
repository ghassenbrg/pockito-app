package io.ghassen.pockito.mcp;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
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
 * A client that opens with a draft-revision {@code server/discover} probe has to be able to
 * work out that this server speaks an initialization-based revision instead. It can only do
 * that from a 400; the 500 the transport returns for an unhandled method strands it, which
 * is what stopped the ChatGPT connector from ever completing.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class LegacyEraProbeTest {

    @Autowired
    MockMvc mvc;

    @MockitoBean
    CoreClient core;

    @Test
    void aDiscoverProbeIsAnsweredWithBadRequestSoTheClientFallsBack() throws Exception {
        mvc.perform(post("/mcp")
                        .with(jwt())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"jsonrpc":"2.0","id":"discover-1","method":"server/discover",
                                 "params":{"_meta":{"io.modelcontextprotocol/protocolVersion":"2026-07-28"}}}"""))
                .andExpect(status().isBadRequest());
    }

    /**
     * The fallback is chosen by inspecting the body: a recognised JSON-RPC error tells the
     * client we are a draft-era server and it should retry rather than fall back. Answering
     * with one would defeat the whole point of the 400.
     */
    @Test
    void theProbeAnswerIsNotAJsonRpcError() throws Exception {
        mvc.perform(post("/mcp")
                        .with(jwt())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"jsonrpc":"2.0","id":"discover-1","method":"server/discover","params":{}}"""))
                .andExpect(status().isBadRequest())
                .andExpect(content().string(org.hamcrest.Matchers.not(org.hamcrest.Matchers.containsString("jsonrpc"))));
    }

    /** Discovery must still be reachable the normal way for a client holding no token. */
    @Test
    void anUnauthenticatedProbeStillGetsTheDiscoveryChallenge() throws Exception {
        mvc.perform(post("/mcp")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"jsonrpc":"2.0","id":"discover-1","method":"server/discover","params":{}}"""))
                .andExpect(status().isUnauthorized())
                .andExpect(header().exists("WWW-Authenticate"));
    }

    /** Everything else must reach the transport with its body intact. */
    @Test
    void anOrdinaryCallIsUnaffectedAndKeepsItsBody() throws Exception {
        mvc.perform(post("/mcp")
                        .with(jwt())
                        .contentType(MediaType.APPLICATION_JSON)
                        // The transport requires both, per the Streamable HTTP transport.
                        .accept(MediaType.APPLICATION_JSON, MediaType.TEXT_EVENT_STREAM)
                        .content("""
                                {"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}"""))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("get_my_profile")));
    }

    private static org.springframework.test.web.servlet.result.HeaderResultMatchers header() {
        return org.springframework.test.web.servlet.result.MockMvcResultMatchers.header();
    }
}
