<script setup lang="ts">
/**
 * The signed-in home.
 *
 * <p>Intentionally sparse: the finance domains land here in later phases. What it does
 * prove is that the whole chain works — a real session, a real profile, a real avatar.
 */
definePageMeta({ layout: 'app' })

const { profile, preferences, load, loading } = useProfile()
const failure = ref<unknown>(null)

const greeting = computed(() => {
  const hour = new Date().getHours()
  if (hour < 12) return 'home.greetingMorning'
  if (hour < 18) return 'home.greetingAfternoon'
  return 'home.greetingEvening'
})

async function retry() {
  failure.value = null
  try {
    await load(true)
  } catch (error) {
    failure.value = error
  }
}
</script>

<template>
  <div class="pk-page">
    <PkErrorNotice v-if="failure" :error="failure" @retry="retry" />
    <PkLoading v-else-if="loading && !profile" />

    <template v-else-if="profile">
      <section class="pk-card pk-home__hero">
        <PkAvatar :src="profile.avatarUrl" :name="profile.displayName" :size="64" />
        <div>
          <h1>{{ $t(greeting, { name: profile.displayName }) }}</h1>
          <p class="pk-muted">{{ $t('home.subtitle') }}</p>
        </div>
      </section>

      <section class="pk-card pk-home__status">
        <h2>{{ $t('home.readyTitle') }}</h2>
        <p class="pk-muted">{{ $t('home.readyBody') }}</p>
        <dl class="pk-home__facts">
          <div>
            <dt class="pk-muted">{{ $t('preferences.currency') }}</dt>
            <dd>{{ preferences?.defaultCurrency }}</dd>
          </div>
          <div>
            <dt class="pk-muted">{{ $t('preferences.language') }}</dt>
            <dd>{{ $t(`languages.${preferences?.language}`) }}</dd>
          </div>
          <div>
            <dt class="pk-muted">{{ $t('preferences.appearance') }}</dt>
            <dd>{{ $t(`themes.${preferences?.theme}`) }}</dd>
          </div>
        </dl>
      </section>
    </template>
  </div>
</template>

<style scoped>
.pk-page { display: flex; flex-direction: column; gap: var(--pk-space-4); }
.pk-home__hero { display: flex; align-items: center; gap: var(--pk-space-4); }
.pk-home__status h2 { font-size: 1.05rem; margin-bottom: var(--pk-space-2); }
.pk-home__facts {
  margin: var(--pk-space-5) 0 0;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: var(--pk-space-4);
}
.pk-home__facts dt { font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.04em; }
.pk-home__facts dd { margin: var(--pk-space-1) 0 0; font-size: 1.15rem; font-weight: 600; }
</style>
