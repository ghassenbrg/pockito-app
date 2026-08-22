import { describe, expect, it } from 'vitest'
import { resolveRoute } from '~/utils/routing'

/**
 * The route guard is the only thing standing between an unauthenticated visitor and the
 * app, and between a half-registered user and a broken home screen, so its rule is tested
 * directly rather than through the browser.
 */
describe('route guard', () => {
  const base = { path: '/home', fullPath: '/home', isAuthenticated: false, onboardingRequired: false }

  describe('unauthenticated', () => {
    it('lets the landing page through', () => {
      expect(resolveRoute({ ...base, path: '/', fullPath: '/' })).toEqual({ action: 'allow' })
    })

    it('lets the OIDC callback through so the redirect can complete', () => {
      expect(resolveRoute({ ...base, path: '/auth/callback', fullPath: '/auth/callback?code=x' }))
        .toEqual({ action: 'allow' })
    })

    it('sends a protected route back to the landing page', () => {
      expect(resolveRoute(base)).toEqual({
        action: 'redirect',
        to: '/',
        query: { returnTo: '/home' },
      })
    })

    it('remembers the exact destination, including its query', () => {
      const decision = resolveRoute({ ...base, path: '/settings', fullPath: '/settings?tab=profile' })
      expect(decision).toEqual({
        action: 'redirect',
        to: '/',
        query: { returnTo: '/settings?tab=profile' },
      })
    })

    it('blocks onboarding too', () => {
      expect(resolveRoute({ ...base, path: '/onboarding', fullPath: '/onboarding' }).action)
        .toBe('redirect')
    })
  })

  describe('authenticated with onboarding outstanding', () => {
    const pending = { ...base, isAuthenticated: true, onboardingRequired: true }

    it('diverts every protected route to onboarding', () => {
      expect(resolveRoute(pending)).toEqual({ action: 'redirect', to: '/onboarding' })
      expect(resolveRoute({ ...pending, path: '/settings', fullPath: '/settings' }))
        .toEqual({ action: 'redirect', to: '/onboarding' })
    })

    it('does not divert onboarding to itself', () => {
      expect(resolveRoute({ ...pending, path: '/onboarding', fullPath: '/onboarding' }))
        .toEqual({ action: 'allow' })
    })
  })

  describe('authenticated and onboarded', () => {
    const ready = { ...base, isAuthenticated: true, onboardingRequired: false }

    it('allows the app', () => {
      expect(resolveRoute(ready)).toEqual({ action: 'allow' })
      expect(resolveRoute({ ...ready, path: '/settings', fullPath: '/settings' }))
        .toEqual({ action: 'allow' })
    })

    it('sends a finished user away from onboarding', () => {
      expect(resolveRoute({ ...ready, path: '/onboarding', fullPath: '/onboarding' }))
        .toEqual({ action: 'redirect', to: '/home' })
    })
  })

  describe('when the profile cannot be loaded', () => {
    it('renders the page instead of guessing at onboarding state', () => {
      // Redirecting to onboarding here would make an already-onboarded user redo it just
      // because the API blipped.
      expect(resolveRoute({ ...base, isAuthenticated: true, bootstrapFailed: true }))
        .toEqual({ action: 'allow' })
    })
  })
})
