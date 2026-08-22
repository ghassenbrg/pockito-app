/**
 * Mirrors the shapes in `shared/pockito-contracts`. These two must stay in step; the
 * backend is the source of truth.
 */

export type AppTheme = 'SYSTEM' | 'LIGHT' | 'DARK'
export type AppLanguage = 'EN' | 'JA'

export interface Profile {
  subject: string
  email: string | null
  displayName: string
  avatarUrl: string | null
  onboardingCompleted: boolean
  createdAt: string
  updatedAt: string
}

export interface Preferences {
  language: AppLanguage
  theme: AppTheme
  defaultCurrency: string
}

export interface Bootstrap {
  profile: Profile
  preferences: Preferences
  onboardingRequired: boolean
  supportedLanguages: string[]
  supportedCurrencies: string[]
}

export interface AvatarInfo {
  objectKey: string
  url: string | null
  contentType: string
  sizeBytes: number
}

/** The single error shape every Pockito endpoint returns. */
export interface ApiError {
  status: number
  code: string
  message: string
  correlationId?: string
  timestamp?: string
  violations?: { field: string; message: string }[]
}

/** Language tags used by the UI, mapped to the backend's enum. */
export const languageToLocale: Record<AppLanguage, string> = { EN: 'en', JA: 'ja' }
export const localeToLanguage = (locale: string): AppLanguage =>
  locale.toLowerCase().startsWith('ja') ? 'JA' : 'EN'
