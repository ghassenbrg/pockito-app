import { describe, expect, it } from 'vitest'
import en from '../i18n/locales/en.json'
import ja from '../i18n/locales/ja.json'

function keys(value: unknown, prefix = ''): string[] {
  if (typeof value !== 'object' || value === null) return [prefix]
  return Object.entries(value as Record<string, unknown>).flatMap(([key, child]) =>
    keys(child, prefix ? `${prefix}.${key}` : key),
  )
}

/**
 * A missing translation shows an untranslated key to the user, which is worse than an
 * awkward phrasing. Catching drift in CI is cheaper than catching it in review.
 */
describe('translations', () => {
  const enKeys = keys(en).sort()
  const jaKeys = keys(ja).sort()

  it('define exactly the same keys in every language', () => {
    expect(jaKeys).toEqual(enKeys)
  })

  it('cover every error code the client can produce', () => {
    for (const code of [
      'network.unreachable',
      'auth.unauthenticated',
      'access.denied',
      'validation.failed',
      'preferences.currency.unsupported',
      'avatar.too_large',
      'avatar.unsupported_type',
      'core.unreachable',
      'unexpected',
      'transient',
    ]) {
      expect(enKeys).toContain(`errors.${code}`)
    }
  })

  it('leave no value blank', () => {
    const blanks = (bundle: unknown, prefix = ''): string[] => {
      if (typeof bundle === 'string') return bundle.trim() ? [] : [prefix]
      if (typeof bundle !== 'object' || bundle === null) return []
      return Object.entries(bundle as Record<string, unknown>).flatMap(([key, child]) =>
        blanks(child, prefix ? `${prefix}.${key}` : key),
      )
    }
    expect(blanks(en)).toEqual([])
    expect(blanks(ja)).toEqual([])
  })
})
