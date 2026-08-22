<script setup lang="ts">
/**
 * The landing page, and the only unauthenticated screen with a call to action.
 *
 * <p>Both buttons hand off to Keycloak. Pockito has no password field anywhere.
 */
definePageMeta({ layout: 'default' })

const { isAuthenticated, login, register } = useAuth()
const route = useRoute()
const busy = ref(false)

const returnTo = computed(() => (route.query.returnTo as string) || '/home')

// A visitor who already has a session should not sit on a marketing page.
onMounted(async () => {
  if (isAuthenticated.value) await navigateTo(returnTo.value)
})

async function startLogin() {
  busy.value = true
  await login(returnTo.value)
}

async function startRegister() {
  busy.value = true
  await register(returnTo.value)
}
</script>

<template>
  <div class="pk-welcome">
    <div class="pk-welcome__inner">
      <img class="pk-welcome__mascot" src="/kito-welcome.png" alt="" width="200" height="200">
      <h1>{{ $t('welcome.title') }}</h1>
      <p class="pk-muted pk-welcome__tagline">{{ $t('welcome.tagline') }}</p>

      <div class="pk-welcome__actions">
        <button type="button" class="pk-button" :disabled="busy" @click="startLogin">
          {{ $t('welcome.login') }}
        </button>
        <button
          type="button"
          class="pk-button pk-button--secondary"
          :disabled="busy"
          @click="startRegister"
        >
          {{ $t('welcome.register') }}
        </button>
      </div>

      <p class="pk-muted pk-welcome__note">{{ $t('welcome.note') }}</p>
    </div>
  </div>
</template>

<style scoped>
.pk-welcome {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: var(--pk-space-5);
}
.pk-welcome__inner { max-width: 420px; text-align: center; }
.pk-welcome__mascot {
  display: block;
  width: 200px;
  height: auto;
  margin: 0 auto var(--pk-space-5);
}
.pk-welcome__tagline { margin-top: var(--pk-space-3); }
.pk-welcome__actions {
  margin-top: var(--pk-space-6);
  display: flex;
  flex-direction: column;
  gap: var(--pk-space-3);
}
.pk-welcome__note { margin-top: var(--pk-space-5); font-size: 0.85rem; }
</style>
