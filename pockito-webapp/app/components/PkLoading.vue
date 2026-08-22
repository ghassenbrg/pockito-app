<script setup lang="ts">
defineProps<{ label?: string }>()
</script>

<template>
  <div class="pk-loading" role="status" aria-live="polite">
    <span class="pk-loading__spinner" aria-hidden="true" />
    <span class="pk-muted">{{ label ?? $t('common.loading') }}</span>
  </div>
</template>

<style scoped>
.pk-loading {
  display: flex;
  align-items: center;
  gap: var(--pk-space-3);
  padding: var(--pk-space-5);
  justify-content: center;
}
.pk-loading__spinner {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  border: 2px solid var(--pk-border);
  border-top-color: var(--pk-accent);
  animation: pk-spin 700ms linear infinite;
}
@keyframes pk-spin { to { transform: rotate(360deg); } }
</style>
