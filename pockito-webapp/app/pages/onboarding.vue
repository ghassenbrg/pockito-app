<script setup lang="ts">
/**
 * First-login onboarding: name, avatar, language, appearance, currency, done.
 *
 * <p>Language and appearance apply as soon as they are picked, so the user sees the effect
 * of their choice while still inside the flow. Everything is submitted in one call at the
 * end, so a user cannot end up marked onboarded with settings that failed to save.
 */
import type { AppLanguage, AppTheme } from '~/types/pockito'

definePageMeta({ layout: 'default' })

const { draft, step, complete } = useOnboarding()
const { bootstrap, profile, uploadAvatar, removeAvatar } = useProfile()
const { applyTheme, applyLanguage } = usePreferences()

const submitting = ref(false)
const failure = ref<unknown>(null)
const avatarBusy = ref(false)
const fileInput = ref<HTMLInputElement | null>(null)

const steps = ['profile', 'avatar', 'language', 'appearance', 'currency'] as const
const currencies = computed(() => bootstrap.value?.supportedCurrencies ?? ['EUR', 'USD', 'JPY'])
const themes: AppTheme[] = ['SYSTEM', 'LIGHT', 'DARK']
const languages: AppLanguage[] = ['EN', 'JA']

// Seed the draft from whatever the backend already knows, so returning to an unfinished
// onboarding does not start from blank.
onMounted(() => {
  if (!draft.value.displayName && profile.value) draft.value.displayName = profile.value.displayName
  const preferences = bootstrap.value?.preferences
  if (preferences) {
    draft.value.language = preferences.language
    draft.value.theme = preferences.theme
    draft.value.defaultCurrency = preferences.defaultCurrency
  }
})

const canAdvance = computed(() => {
  if (steps[step.value] === 'profile') return draft.value.displayName.trim().length > 0
  return true
})

const isLastStep = computed(() => step.value === steps.length - 1)

function back() {
  if (step.value > 0) step.value -= 1
}

async function chooseLanguage(language: AppLanguage) {
  draft.value.language = language
  await applyLanguage(language)
}

function chooseTheme(theme: AppTheme) {
  draft.value.theme = theme
  applyTheme(theme)
}

async function next() {
  if (!isLastStep.value) {
    step.value += 1
    return
  }
  submitting.value = true
  failure.value = null
  try {
    await complete()
    await navigateTo('/home')
  } catch (error) {
    failure.value = error
  } finally {
    submitting.value = false
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
  <div class="pk-onboarding">
    <div class="pk-card pk-onboarding__card">
      <ol class="pk-onboarding__progress" :aria-label="$t('onboarding.progress')">
        <li v-for="(name, index) in steps" :key="name" :aria-current="index === step ? 'step' : undefined">
          <span class="pk-visually-hidden">{{ $t(`onboarding.${name}.title`) }}</span>
          <span class="pk-onboarding__dot" :data-state="index <= step ? 'done' : 'todo'" aria-hidden="true" />
        </li>
      </ol>

      <h1>{{ $t(`onboarding.${steps[step]}.title`) }}</h1>
      <p class="pk-muted">{{ $t(`onboarding.${steps[step]}.body`) }}</p>

      <div class="pk-onboarding__body">
        <template v-if="steps[step] === 'profile'">
          <label class="pk-label" for="displayName">{{ $t('profile.displayName') }}</label>
          <input
            id="displayName"
            v-model="draft.displayName"
            class="pk-input"
            maxlength="80"
            autocomplete="name"
            :placeholder="$t('profile.displayNamePlaceholder')"
          >
        </template>

        <template v-else-if="steps[step] === 'avatar'">
          <div class="pk-onboarding__avatar">
            <PkAvatar :src="profile?.avatarUrl" :name="draft.displayName || 'Pockito'" :size="96" />
            <div class="pk-stack">
              <button
                type="button"
                class="pk-button pk-button--secondary"
                :disabled="avatarBusy"
                @click="fileInput?.click()"
              >
                {{ profile?.avatarUrl ? $t('avatar.replace') : $t('avatar.upload') }}
              </button>
              <button
                v-if="profile?.avatarUrl"
                type="button"
                class="pk-button pk-button--secondary"
                :disabled="avatarBusy"
                @click="clearAvatar"
              >
                {{ $t('avatar.remove') }}
              </button>
              <p class="pk-muted pk-onboarding__hint">{{ $t('avatar.hint') }}</p>
            </div>
          </div>
          <input
            ref="fileInput"
            type="file"
            accept="image/png,image/jpeg,image/webp"
            class="pk-visually-hidden"
            @change="onAvatarSelected"
          >
        </template>

        <template v-else-if="steps[step] === 'language'">
          <div class="pk-choices">
            <button
              v-for="language in languages"
              :key="language"
              type="button"
              class="pk-choice"
              :aria-pressed="draft.language === language"
              @click="chooseLanguage(language)"
            >
              {{ $t(`languages.${language}`) }}
            </button>
          </div>
        </template>

        <template v-else-if="steps[step] === 'appearance'">
          <div class="pk-choices">
            <button
              v-for="theme in themes"
              :key="theme"
              type="button"
              class="pk-choice"
              :aria-pressed="draft.theme === theme"
              @click="chooseTheme(theme)"
            >
              {{ $t(`themes.${theme}`) }}
            </button>
          </div>
        </template>

        <template v-else>
          <label class="pk-label" for="currency">{{ $t('preferences.currency') }}</label>
          <select id="currency" v-model="draft.defaultCurrency" class="pk-select">
            <option v-for="code in currencies" :key="code" :value="code">{{ code }}</option>
          </select>
        </template>
      </div>

      <PkErrorNotice v-if="failure" :error="failure" @retry="failure = null" />

      <div class="pk-onboarding__actions">
        <button
          v-if="step > 0"
          type="button"
          class="pk-button pk-button--secondary"
          :disabled="submitting"
          @click="back"
        >
          {{ $t('common.back') }}
        </button>
        <button type="button" class="pk-button" :disabled="!canAdvance || submitting" @click="next">
          {{ isLastStep ? $t('onboarding.finish') : $t('common.next') }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.pk-onboarding { min-height: 100vh; display: grid; place-items: center; padding: var(--pk-space-5); }
.pk-onboarding__card { width: min(520px, 100%); }
.pk-onboarding__progress {
  display: flex;
  gap: var(--pk-space-2);
  list-style: none;
  margin: 0 0 var(--pk-space-5);
  padding: 0;
}
.pk-onboarding__dot {
  display: block;
  width: 100%;
  min-width: 28px;
  height: 4px;
  border-radius: var(--pk-radius-full);
  background: var(--pk-border);
}
.pk-onboarding__progress li { flex: 1; }
.pk-onboarding__dot[data-state='done'] { background: var(--pk-accent); }
.pk-onboarding__body { margin: var(--pk-space-5) 0; display: flex; flex-direction: column; gap: var(--pk-space-3); }
.pk-onboarding__avatar { display: flex; align-items: center; gap: var(--pk-space-5); flex-wrap: wrap; }
.pk-onboarding__hint { font-size: 0.8rem; }
.pk-onboarding__actions { display: flex; gap: var(--pk-space-3); justify-content: flex-end; }
.pk-visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  overflow: hidden;
  clip: rect(0 0 0 0);
  white-space: nowrap;
}
</style>
