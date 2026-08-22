import type { AppLanguage, AppTheme, Preferences } from '~/types/pockito'
import { languageToLocale, localeToLanguage } from '~/types/pockito'

const CACHE_KEY = 'pockito.preferences'

/**
 * Language, appearance and default currency.
 *
 * <p>Postgres is authoritative, but a copy is cached locally so the first paint already
 * has the right theme and language. Without that cache the app would flash the wrong
 * appearance for as long as `/bootstrap` takes.
 */
export function usePreferences() {
  const api = useApi()
  // Resolved through the Nuxt app rather than useI18n(): this composable is also used from
  // route middleware, where there is no component setup context for useI18n() to attach to.
  const i18n = () => useNuxtApp().$i18n as {
    locale: { value: string }
    setLocale: (code: string) => Promise<void>
  }

  /** Reads the cached preferences. Safe to call before any network request. */
  function cached(): Partial<Preferences> | null {
    if (import.meta.server) return null
    try {
      const raw = window.localStorage.getItem(CACHE_KEY)
      return raw ? (JSON.parse(raw) as Partial<Preferences>) : null
    } catch {
      return null
    }
  }

  function cache(preferences: Preferences): void {
    if (import.meta.server) return
    try {
      window.localStorage.setItem(CACHE_KEY, JSON.stringify(preferences))
    } catch {
      // A full or disabled storage only costs us the fast first paint.
    }
  }

  /** Paints the theme immediately, before any Vue component has rendered. */
  function applyTheme(theme: AppTheme): void {
    if (import.meta.server) return
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
    const effective = theme === 'SYSTEM' ? (prefersDark ? 'DARK' : 'LIGHT') : theme
    document.documentElement.dataset.theme = effective.toLowerCase()
    document.documentElement.dataset.themePreference = theme.toLowerCase()
  }

  async function applyLanguage(language: AppLanguage): Promise<void> {
    const target = languageToLocale[language]
    const { locale, setLocale } = i18n()
    if (locale.value !== target) await setLocale(target)
    if (!import.meta.server) document.documentElement.lang = target
  }

  async function apply(preferences: Preferences): Promise<void> {
    applyTheme(preferences.theme)
    await applyLanguage(preferences.language)
    cache(preferences)
  }

  async function save(preferences: Preferences): Promise<Preferences> {
    const saved = await api.put<Preferences>('/me/preferences', preferences)
    await apply(saved)
    return saved
  }

  /** The language implied by the browser, used only before the server answers. */
  function browserLanguage(): AppLanguage {
    if (import.meta.server) return 'EN'
    return localeToLanguage(navigator.language || 'en')
  }

  return { cached, cache, apply, applyTheme, applyLanguage, save, browserLanguage }
}

/**
 * Applies the cached theme and document language before the app mounts.
 *
 * <p>Kept outside the composable so it can run from a plugin without an active component
 * instance. This is what stops a user who chose Dark from seeing a white flash, and what
 * keeps `<html lang>` correct for screen readers from the very first paint.
 */
export function applyCachedPreferences(): void {
  if (import.meta.server) return
  let cached: Partial<Preferences> = {}
  try {
    const raw = window.localStorage.getItem(CACHE_KEY)
    if (raw) cached = JSON.parse(raw) as Partial<Preferences>
  } catch {
    // No cache is fine: the defaults below are correct for a first visit.
  }

  const theme: AppTheme = cached.theme ?? 'SYSTEM'
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  const effective = theme === 'SYSTEM' ? (prefersDark ? 'DARK' : 'LIGHT') : theme
  document.documentElement.dataset.theme = effective.toLowerCase()
  document.documentElement.dataset.themePreference = theme.toLowerCase()

  const language = cached.language ?? localeToLanguage(navigator.language || 'en')
  document.documentElement.lang = languageToLocale[language]
}
