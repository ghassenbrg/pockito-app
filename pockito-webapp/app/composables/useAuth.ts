import { UserManager, WebStorageStateStore, type User } from 'oidc-client-ts'
import type { UserManagerSettings } from 'oidc-client-ts'

/**
 * The single OIDC session for the app.
 *
 * <p>Authorization Code with PKCE against Keycloak. Pockito never sees a password: the
 * "log in" and "create account" buttons both hand off to Keycloak, which owns credentials.
 */

let manager: UserManager | null = null

function settings(): UserManagerSettings {
  const config = useRuntimeConfig().public
  const origin = window.location.origin
  const base = useRuntimeConfig().app.baseURL.replace(/\/$/, '')
  return {
    authority: config.keycloak.issuer,
    client_id: config.keycloak.clientId,
    redirect_uri: `${origin}${base}/auth/callback`,
    post_logout_redirect_uri: `${origin}${base}/`,
    response_type: 'code',
    scope: 'openid profile email',
    // Tokens live in sessionStorage, not localStorage: closing the tab ends the session,
    // and another tab of a different app on the same origin cannot read them.
    userStore: new WebStorageStateStore({ store: window.sessionStorage }),
    // Keycloak's refresh token keeps the session alive without a visible redirect.
    automaticSilentRenew: true,
    revokeTokensOnSignout: true,
    monitorSession: false,
  }
}

function userManager(): UserManager {
  if (!manager) {
    manager = new UserManager(settings())
  }
  return manager
}

const currentUser = () => useState<User | null>('pockito.oidc.user', () => null)

export function useAuth() {
  const user = currentUser()
  const isAuthenticated = computed(() => !!user.value && !user.value.expired)

  /**
   * Restores an existing session on start-up without ever redirecting.
   * Returns false when the visitor is simply not signed in — that is not an error.
   */
  async function restoreSession(): Promise<boolean> {
    const existing = await userManager().getUser()
    if (existing && !existing.expired) {
      user.value = existing
      return true
    }
    if (existing?.expired) {
      // An expired access token is still usable if the refresh token holds.
      try {
        const renewed = await userManager().signinSilent()
        user.value = renewed
        return !!renewed
      } catch {
        await userManager().removeUser()
      }
    }
    user.value = null
    return false
  }

  /** Sends the browser to Keycloak, remembering where to come back to. */
  async function login(returnTo?: string): Promise<void> {
    await userManager().signinRedirect({ state: { returnTo: returnTo ?? useRoute().fullPath } })
  }

  /**
   * The same flow as login, but Keycloak opens its registration screen instead.
   *
   * `prompt=create` is the standard OIDC way to ask for registration, so this stays a
   * plain Authorization Code + PKCE request — Pockito has no sign-up form of its own and
   * never handles a password.
   */
  async function register(returnTo?: string): Promise<void> {
    await userManager().signinRedirect({
      state: { returnTo: returnTo ?? '/home' },
      prompt: 'create',
    })
  }

  /** Completes the redirect back from Keycloak. Returns where the user wanted to go. */
  async function completeLogin(): Promise<string> {
    const signedIn = await userManager().signinCallback()
    user.value = signedIn ?? (await userManager().getUser())
    const state = signedIn?.state as { returnTo?: string } | undefined
    return state?.returnTo ?? '/home'
  }

  async function logout(): Promise<void> {
    user.value = null
    await userManager().signoutRedirect()
  }

  /** Clears the local session without contacting Keycloak; used when a session expires. */
  async function forgetSession(): Promise<void> {
    user.value = null
    await userManager().removeUser()
  }

  async function accessToken(): Promise<string | null> {
    const current = await userManager().getUser()
    if (!current) return null
    if (current.expired) {
      try {
        const renewed = await userManager().signinSilent()
        user.value = renewed
        return renewed?.access_token ?? null
      } catch {
        await forgetSession()
        return null
      }
    }
    return current.access_token
  }

  return {
    user: readonly(user),
    isAuthenticated,
    restoreSession,
    login,
    register,
    completeLogin,
    logout,
    forgetSession,
    accessToken,
  }
}
