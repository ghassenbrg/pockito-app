<script setup lang="ts">
/**
 * Completes the redirect back from Keycloak.
 *
 * <p>Deliberately its own route with no layout chrome: it exists only long enough to
 * exchange the authorization code and send the user where they were going.
 */
definePageMeta({ layout: 'default' })

const { completeLogin } = useAuth()
const { load } = useProfile()
const failure = ref<unknown>(null)

onMounted(async () => {
  try {
    const returnTo = await completeLogin()
    const bootstrap = await load(true)
    // A brand-new account has to finish onboarding before anything else.
    await navigateTo(bootstrap?.onboardingRequired ? '/onboarding' : returnTo)
  } catch (error) {
    failure.value = error
  }
})

async function backToStart() {
  failure.value = null
  await navigateTo('/')
}
</script>

<template>
  <div class="pk-callback">
    <PkErrorNotice v-if="failure" :error="failure" @retry="backToStart" />
    <PkLoading v-else :label="$t('auth.completing')" />
  </div>
</template>

<style scoped>
.pk-callback { min-height: 100vh; display: grid; place-items: center; padding: var(--pk-space-5); }
</style>
