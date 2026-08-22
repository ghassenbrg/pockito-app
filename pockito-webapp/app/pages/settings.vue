<script setup lang="ts">
/**
 * Everything a signed-in user can change about themselves, plus logout.
 *
 * <p>Preferences save on change rather than behind a Save button: each one is a single
 * independent value, and the immediate visual feedback (theme, language) makes an explicit
 * save step feel wrong.
 */
import type { AppLanguage, AppTheme } from '~/types/pockito'

definePageMeta({ layout: 'app' })

const { bootstrap, profile, preferences, load, updateDisplayName, uploadAvatar, removeAvatar } = useProfile()
const { save, applyTheme, applyLanguage } = usePreferences()
const { logout } = useAuth()

const displayName = ref('')
const nameBusy = ref(false)
const nameSaved = ref(false)
const avatarBusy = ref(false)
const failure = ref<unknown>(null)
const fileInput = ref<HTMLInputElement | null>(null)

const currencies = computed(() => bootstrap.value?.supportedCurrencies ?? [])
const themes: AppTheme[] = ['SYSTEM', 'LIGHT', 'DARK']
const languages: AppLanguage[] = ['EN', 'JA']

watchEffect(() => {
  if (profile.value && !nameBusy.value) displayName.value = profile.value.displayName
})

const nameChanged = computed(
  () => !!profile.value && displayName.value.trim() !== profile.value.displayName && displayName.value.trim().length > 0,
)

async function saveName() {
  nameBusy.value = true
  failure.value = null
  try {
    await updateDisplayName(displayName.value.trim())
    nameSaved.value = true
    setTimeout(() => (nameSaved.value = false), 2000)
  } catch (error) {
    failure.value = error
  } finally {
    nameBusy.value = false
  }
}

async function savePreference(patch: Partial<{ language: AppLanguage; theme: AppTheme; defaultCurrency: string }>) {
  if (!preferences.value) return
  const next = { ...preferences.value, ...patch }
  // Apply optimistically so the change is instant, then reconcile with what the server saved.
  if (patch.theme) applyTheme(patch.theme)
  if (patch.language) await applyLanguage(patch.language)
  failure.value = null
  try {
    await save(next)
    await load(true)
  } catch (error) {
    failure.value = error
    // Put the visible state back to whatever the server still holds.
    applyTheme(preferences.value.theme)
    await applyLanguage(preferences.value.language)
  }
}

async function onAvatarSelected(event: Event) {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (!file) return
  avatarBusy.value = true
  failure.value = null
  try {
    await uploadAvatar(file)
  } catch (error) {
    failure.value = error
  } finally {
    avatarBusy.value = false
    if (fileInput.value) fileInput.value.value = ''
  }
}

async function clearAvatar() {
  avatarBusy.value = true
  failure.value = null
  try {
    await removeAvatar()
  } catch (error) {
    failure.value = error
  } finally {
    avatarBusy.value = false
  }
}
</script>

<template>
  <div class="pk-page pk-stack">
    <h1>{{ $t('settings.title') }}</h1>
    <PkErrorNotice v-if="failure" :error="failure" @retry="failure = null" />
    <PkLoading v-if="!profile" />

    <template v-else>
      <section class="pk-card pk-stack">
        <h2>{{ $t('settings.profile') }}</h2>
        <div class="pk-settings__avatar">
          <PkAvatar :src="profile.avatarUrl" :name="profile.displayName" :size="72" />
          <div class="pk-row pk-settings__avatarActions">
            <button type="button" class="pk-button pk-button--secondary" :disabled="avatarBusy" @click="fileInput?.click()">
              {{ profile.avatarUrl ? $t('avatar.replace') : $t('avatar.upload') }}
            </button>
            <button
              v-if="profile.avatarUrl"
              type="button"
              class="pk-button pk-button--secondary"
              :disabled="avatarBusy"
              @click="clearAvatar"
            >
              {{ $t('avatar.remove') }}
            </button>
          </div>
        </div>
        <input
          ref="fileInput"
          type="file"
          accept="image/png,image/jpeg,image/webp"
          class="pk-visually-hidden"
          @change="onAvatarSelected"
        >

        <label class="pk-label" for="settingsName">{{ $t('profile.displayName') }}</label>
        <div class="pk-row">
          <input id="settingsName" v-model="displayName" class="pk-input" maxlength="80">
          <button type="button" class="pk-button" :disabled="!nameChanged || nameBusy" @click="saveName">
            {{ $t('common.save') }}
          </button>
        </div>
        <p v-if="nameSaved" class="pk-muted" role="status">{{ $t('common.saved') }}</p>

        <p class="pk-muted pk-settings__identity">
          {{ $t('settings.identity', { email: profile.email ?? '—' }) }}
        </p>
      </section>

      <section class="pk-card pk-stack">
        <h2>{{ $t('preferences.language') }}</h2>
        <div class="pk-choices">
          <button
            v-for="language in languages"
            :key="language"
            type="button"
            class="pk-choice"
            :aria-pressed="preferences?.language === language"
            @click="savePreference({ language })"
          >
            {{ $t(`languages.${language}`) }}
          </button>
        </div>
      </section>

      <section class="pk-card pk-stack">
        <h2>{{ $t('preferences.appearance') }}</h2>
        <div class="pk-choices">
          <button
            v-for="theme in themes"
            :key="theme"
            type="button"
            class="pk-choice"
            :aria-pressed="preferences?.theme === theme"
            @click="savePreference({ theme })"
          >
            {{ $t(`themes.${theme}`) }}
          </button>
        </div>
      </section>

      <section class="pk-card pk-stack">
        <h2>{{ $t('preferences.currency') }}</h2>
        <select
          class="pk-select"
          :value="preferences?.defaultCurrency"
          @change="savePreference({ defaultCurrency: ($event.target as HTMLSelectElement).value })"
        >
          <option v-for="code in currencies" :key="code" :value="code">{{ code }}</option>
        </select>
      </section>

      <section class="pk-card pk-stack">
        <h2>{{ $t('settings.session') }}</h2>
        <p class="pk-muted">{{ $t('settings.sessionBody') }}</p>
        <div>
          <button type="button" class="pk-button pk-button--danger" @click="logout">
            {{ $t('settings.logout') }}
          </button>
        </div>
      </section>
    </template>
  </div>
</template>

<style scoped>
.pk-settings__avatar { display: flex; align-items: center; gap: var(--pk-space-5); flex-wrap: wrap; }
.pk-settings__avatarActions { flex-wrap: wrap; }
.pk-settings__identity { font-size: 0.85rem; }
h2 { font-size: 1.05rem; }
.pk-visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  overflow: hidden;
  clip: rect(0 0 0 0);
  white-space: nowrap;
}
</style>
