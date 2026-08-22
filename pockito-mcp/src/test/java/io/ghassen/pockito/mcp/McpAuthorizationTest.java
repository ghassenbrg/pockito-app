package io.ghassen.pockito.mcp;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
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
 * The MCP endpoint is reachable from the public internet through Traefik, so the first
 * thing worth proving is that an AI client with no Keycloak token gets nowhere.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class McpAuthorizationTest {

    @Autowired
    MockMvc mvc;

    @MockitoBean
    CoreClient core;

    @Test
    void anUnauthenticatedMcpCallIsRejected() throws Exception {
        mvc.perform(post("/mcp")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}"""))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value("auth.unauthenticated"));
    }

    @Test
    void anUnauthenticatedCallNeverReachesCore() throws Exception {
        mvc.perform(post("/mcp")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"jsonrpc":"2.0","id":1,"method":"tools/call",
                                 "params":{"name":"get_my_profile","arguments":{}}}"""))
                .andExpect(status().isUnauthorized());
        org.mockito.BDDMockito.then(core).shouldHaveNoInteractions();
    }

    @Test
    void aBearerTokenThatIsNotAJwtIsRejected() throws Exception {
        mvc.perform(post("/mcp")
                        .header("Authorization", "Bearer not-a-jwt")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}"""))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void healthProbesStayOpenSoKubernetesCanReachThem() throws Exception {
        mvc.perform(get("/actuator/health/liveness")).andExpect(status().isOk());
    }

    @Test
    void nothingOutsideMcpAndHealthIsExposed() throws Exception {
        // Anonymous callers are challenged; an authenticated one is still denied, because
        // the rule is "only /mcp and the probes", not "anyone with a token".
        mvc.perform(get("/actuator/env")).andExpect(status().isUnauthorized());
        mvc.perform(get("/actuator/env").with(jwt()))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.code").value("access.denied"));
    }
}
