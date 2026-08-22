import type { Bootstrap, Preferences, Profile } from '~/types/pockito'

/**
 * The client's view of the authenticated user.
 *
 * <p>`GET /api/v1/bootstrap` is the single call that initialises the app — the same call
 * the mobile app makes — so the two clients cannot disagree about onboarding state.
 */
export function useProfile() {
  const api = useApi()
  const { apply } = usePreferences()
  const bootstrap = useState<Bootstrap | null>('pockito.bootstrap', () => null)
  const loading = useState<boolean>('pockito.bootstrap.loading', () => false)

  const profile = computed<Profile | null>(() => bootstrap.value?.profile ?? null)
  const preferences = computed<Preferences | null>(() => bootstrap.value?.preferences ?? null)
  const onboardingRequired = computed(() => bootstrap.value?.onboardingRequired ?? false)

  async function load(force = false): Promise<Bootstrap | null> {
    if (bootstrap.value && !force) return bootstrap.value
    loading.value = true
    try {
      bootstrap.value = await api.get<Bootstrap>('/bootstrap')
      // The server is authoritative: reconcile theme and language with what it returned.
      await apply(bootstrap.value.preferences)
      return bootstrap.value
    } finally {
      loading.value = false
    }
  }

  async function updateDisplayName(displayName: string): Promise<void> {
    const updated = await api.put<Profile>('/me', { displayName })
    if (bootstrap.value) bootstrap.value = { ...bootstrap.value, profile: updated }
  }

  async function uploadAvatar(file: File): Promise<void> {
    const form = new FormData()
    form.append('file', file)
    await api.upload('/me/avatar', form)
    // The avatar URL is pre-signed per response, so refetch rather than guess it.
    await load(true)
  }

  async function removeAvatar(): Promise<void> {
    await api.remove('/me/avatar')
    await load(true)
  }

  function clear(): void {
    bootstrap.value = null
  }

  return {
    bootstrap: readonly(bootstrap),
    profile,
    preferences,
    onboardingRequired,
    loading: readonly(loading),
    load,
    updateDisplayName,
    uploadAvatar,
    removeAvatar,
    clear,
  }
}
