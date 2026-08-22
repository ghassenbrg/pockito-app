export default defineNuxtConfig({
  compatibilityDate: '2026-08-01',
  devtools: { enabled: false },

  // Rendered entirely in the browser. Pockito's web client holds an OIDC session obtained
  // with Authorization Code + PKCE, and those tokens must never exist on a server: keeping
  // the app client-side removes any chance of leaking them into an SSR response. There is
  // also nothing public to index — every page behind the landing screen is authenticated.
  ssr: false,

  modules: ['@nuxtjs/i18n', '@pinia/nuxt'],

  css: ['~/assets/css/main.css'],

  app: {
    // Served under /app/* by Traefik; every asset and route URL has to carry that prefix.
    baseURL: process.env.NUXT_APP_BASE_URL || '/',
    head: {
      title: 'Pockito',
      // No static lang here: the document language follows the user's saved preference,
      // applied from cache before first paint and reconciled after /bootstrap.
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1, viewport-fit=cover' },
        { name: 'description', content: 'Pockito — personal and shared money, kept simple.' },
        { name: 'theme-color', content: '#0f172a' },
      ],
      link: [{ rel: 'icon', type: 'image/svg+xml', href: '/favicon.svg' }],
    },
  },

  i18n: {
    strategy: 'no_prefix',
    defaultLocale: 'en',
    locales: [
      { code: 'en', language: 'en-GB', name: 'English', file: 'en.json' },
      { code: 'ja', language: 'ja-JP', name: '日本語', file: 'ja.json' },
    ],
    // Pockito stores the language server-side, so the browser preference is only the very
    // first guess; the bootstrap response takes over as soon as it arrives.
    detectBrowserLanguage: {
      useCookie: true,
      cookieKey: 'pockito_locale',
      redirectOn: 'root',
    },
  },

  runtimeConfig: {
    public: {
      apiBaseUrl: process.env.NUXT_PUBLIC_API_BASE_URL || 'http://localhost:8080/api/v1',
      keycloak: {
        issuer: process.env.NUXT_PUBLIC_KEYCLOAK_ISSUER || 'http://localhost:8180/realms/pockito',
        clientId: process.env.NUXT_PUBLIC_KEYCLOAK_CLIENT_ID || 'pockito-webapp',
      },
    },
  },

  typescript: {
    strict: true,
  },
})
