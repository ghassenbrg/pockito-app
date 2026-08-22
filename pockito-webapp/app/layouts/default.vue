<script setup lang="ts">
/** The unauthenticated shell: no navigation, nothing that assumes a user. */
</script>

<template>
  <div class="pk-shell">
    <main>
      <slot />
    </main>
  </div>
</template>

<style scoped>
.pk-shell { min-height: 100%; display: flex; flex-direction: column; }
main { flex: 1; }
</style>
