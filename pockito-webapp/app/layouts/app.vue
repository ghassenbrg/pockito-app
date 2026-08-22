<script setup lang="ts">
/** The signed-in shell: brand, current user and the routes an authenticated user has. */
const { profile } = useProfile()
const route = useRoute()

const navigation = computed(() => [
  { to: '/home', label: 'nav.home' },
  { to: '/settings', label: 'nav.settings' },
])
</script>

<template>
  <div class="pk-shell">
    <header class="pk-appbar">
      <NuxtLink to="/home" class="pk-appbar__brand">
        <img class="pk-appbar__mark" src="/kito-avatar.png" alt="" width="30" height="30">
        <span>Pockito</span>
      </NuxtLink>

      <nav class="pk-appbar__nav" :aria-label="$t('nav.primary')">
        <NuxtLink
          v-for="item in navigation"
          :key="item.to"
          :to="item.to"
          :aria-current="route.path.startsWith(item.to) ? 'page' : undefined"
        >
          {{ $t(item.label) }}
        </NuxtLink>
      </nav>

      <NuxtLink v-if="profile" to="/settings" class="pk-appbar__user">
        <PkAvatar :src="profile.avatarUrl" :name="profile.displayName" :size="32" />
        <span class="pk-appbar__name">{{ profile.displayName }}</span>
      </NuxtLink>
    </header>

    <main>
      <slot />
    </main>
  </div>
</template>

<style scoped>
.pk-shell { min-height: 100%; display: flex; flex-direction: column; }
main { flex: 1; }

.pk-appbar {
  display: flex;
  align-items: center;
  gap: var(--pk-space-5);
  padding: var(--pk-space-3) var(--pk-space-4);
  border-bottom: 1px solid var(--pk-border);
  background: var(--pk-surface);
  position: sticky;
  top: 0;
  z-index: 10;
}
.pk-appbar__brand {
  display: flex;
  align-items: center;
  gap: var(--pk-space-2);
  font-weight: 700;
  color: var(--pk-text);
  text-decoration: none;
}
.pk-appbar__mark {
  width: 30px;
  height: 30px;
  border-radius: var(--pk-radius-md);
}
.pk-appbar__nav { display: flex; gap: var(--pk-space-4); margin-right: auto; }
.pk-appbar__nav a {
  color: var(--pk-text-muted);
  text-decoration: none;
  font-weight: 500;
  padding: 6px 2px;
  border-bottom: 2px solid transparent;
}
.pk-appbar__nav a[aria-current='page'] {
  color: var(--pk-text);
  border-bottom-color: var(--pk-accent);
}
.pk-appbar__user {
  display: flex;
  align-items: center;
  gap: var(--pk-space-2);
  text-decoration: none;
  color: var(--pk-text);
}
@media (max-width: 560px) {
  .pk-appbar__name { display: none; }
  .pk-appbar { gap: var(--pk-space-3); }
}
</style>
