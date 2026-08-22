import type { AppLanguage, AppTheme, Bootstrap } from '~/types/pockito'

export interface OnboardingDraft {
  displayName: string
  language: AppLanguage
  theme: AppTheme
  defaultCurrency: string
}

/**
 * The first-login flow.
 *
 * <p>The draft is held in memory and submitted in one call, so a user is never left
 * half-onboarded: the backend applies the name and preferences and marks onboarding
 * complete in a single transaction.
 */
export function useOnboarding() {
  const api = useApi()
  const { load } = useProfile()
  const { apply } = usePreferences()

  const draft = useState<OnboardingDraft>('pockito.onboarding.draft', () => ({
    displayName: '',
    language: 'EN',
    theme: 'SYSTEM',
    defaultCurrency: 'EUR',
  }))

  const step = useState<number>('pockito.onboarding.step', () => 0)

  async function complete(): Promise<Bootstrap> {
    const result = await api.post<Bootstrap>('/onboarding/complete', {
      displayName: draft.value.displayName.trim(),
      preferences: {
        language: draft.value.language,
        theme: draft.value.theme,
        defaultCurrency: draft.value.defaultCurrency,
      },
    })
    await apply(result.preferences)
    await load(true)
    return result
  }

  function reset(): void {
    step.value = 0
    draft.value = { displayName: '', language: 'EN', theme: 'SYSTEM', defaultCurrency: 'EUR' }
  }

  return { draft, step, complete, reset }
}
