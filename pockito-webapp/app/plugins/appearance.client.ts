import { applyCachedPreferences } from '~/composables/usePreferences'

/**
 * Paints the cached theme before the app renders.
 *
 * <p>Runs as early as a Nuxt plugin can, so a user who chose Dark does not see a flash of
 * the light theme while `/bootstrap` is in flight.
 */
export default defineNuxtPlugin({
  name: 'pockito-appearance',
  enforce: 'pre',
  setup() {
    applyCachedPreferences()
    // Keep "System" honest when the OS switches while the app is open.
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
      if (document.documentElement.dataset.themePreference === 'system') applyCachedPreferences()
    })
  },
})
