import { PockitoApiError } from '~/utils/errors'
import { resolveRoute } from '~/utils/routing'

/**
 * Applies the routing rule in `utils/routing.ts` to every navigation.
 *
 * <p>This file only gathers the current state — session, profile — and acts on the
 * decision. The rule itself lives next door so it can be tested without a browser.
 */
export default defineNuxtRouteMiddleware(async (to) => {
  if (import.meta.server) return

  const { isAuthenticated } = useAuth()
  const { load, onboardingRequired } = useProfile()

  let bootstrapFailed = false
  const needsProfile = !(to.path === '/' || to.path === '/auth/callback')
  if (needsProfile && isAuthenticated.value) {
    try {
      await load()
    } catch (error) {
      bootstrapFailed = true
      // A briefly unreachable backend must not lock the user out. Anything that is not an
      // API failure is a bug, and swallowing it silently here would hide it.
      if (!(error instanceof PockitoApiError)) {
        console.error('[pockito] bootstrap failed unexpectedly', error)
      }
    }
  }

  const decision = resolveRoute({
    path: to.path,
    fullPath: to.fullPath,
    isAuthenticated: isAuthenticated.value,
    onboardingRequired: onboardingRequired.value,
    bootstrapFailed,
  })

  if (decision.action === 'redirect') {
    return navigateTo({ path: decision.to, query: decision.query })
  }
})
