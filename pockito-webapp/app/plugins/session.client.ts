/**
 * Restores an existing OIDC session before the first route is resolved.
 *
 * <p>Without this the auth middleware would see "not signed in" on a hard refresh and
 * bounce a perfectly valid session back to the landing page.
 */
export default defineNuxtPlugin({
  name: 'pockito-session',
  enforce: 'pre',
  async setup() {
    const route = useRoute()
    // The callback route completes the redirect itself; restoring here would consume the
    // authorization code first and break it.
    if (route.path.startsWith('/auth/callback')) return
    const { restoreSession } = useAuth()
    await restoreSession()
  },
})
