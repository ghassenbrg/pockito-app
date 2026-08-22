/**
 * Where a visitor is allowed to be.
 *
 * <p>Kept as a pure function so the rule can be read and tested on its own; the route
 * middleware is only the wiring that feeds it the current state.
 */

export const PUBLIC_ROUTES = ['/', '/auth/callback'] as const

export interface RouteState {
  path: string
  fullPath: string
  isAuthenticated: boolean
  onboardingRequired: boolean
  /** True when the profile could not be fetched, so onboarding state is unknown. */
  bootstrapFailed?: boolean
}

export type RouteDecision =
  | { action: 'allow' }
  | { action: 'redirect'; to: string; query?: Record<string, string> }

export function resolveRoute(state: RouteState): RouteDecision {
  if ((PUBLIC_ROUTES as readonly string[]).includes(state.path)) {
    return { action: 'allow' }
  }

  if (!state.isAuthenticated) {
    // Carry the destination so the user lands where they meant to after signing in.
    return { action: 'redirect', to: '/', query: { returnTo: state.fullPath } }
  }

  // With the profile unavailable we cannot tell whether onboarding is done. Sending the
  // user to onboarding could make them redo it, so the page renders and offers a retry.
  if (state.bootstrapFailed) {
    return { action: 'allow' }
  }

  if (state.onboardingRequired && state.path !== '/onboarding') {
    return { action: 'redirect', to: '/onboarding' }
  }
  if (!state.onboardingRequired && state.path === '/onboarding') {
    return { action: 'redirect', to: '/home' }
  }
  return { action: 'allow' }
}
