<#macro content>
  <footer class="pk-auth-footer" aria-label="${msg('pkFooterLabel')}">
    <nav class="pk-auth-footer__links" aria-label="${msg('pkFooterLinksLabel')}">
      <a href="${properties.pkHelpUrl}" rel="noopener">${msg("pkHelp")}</a>
      <a href="${properties.pkPrivacyUrl}" rel="noopener">${msg("pkPrivacy")}</a>
      <a href="${properties.pkTermsUrl}" rel="noopener">${msg("pkTerms")}</a>
      <a href="${properties.pkSecurityUrl}" rel="noopener">${msg("pkSecurity")}</a>
    </nav>
    <p>${msg("pkCopyright")}</p>
  </footer>
</#macro>
