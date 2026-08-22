<script setup lang="ts">
/**
 * The user's avatar, falling back to their initials.
 *
 * <p>The initials fallback is not a placeholder image: a user who has not uploaded a photo
 * should still see something that is recognisably theirs.
 */
const props = withDefaults(
  defineProps<{ src?: string | null; name: string; size?: number }>(),
  { src: null, size: 48 },
)

const failed = ref(false)
watch(() => props.src, () => { failed.value = false })

const initials = computed(() => {
  const parts = props.name.trim().split(/\s+/).filter(Boolean)
  if (parts.length === 0) return '?'
  if (parts.length === 1) return parts[0]!.slice(0, 2).toUpperCase()
  return (parts[0]![0]! + parts[parts.length - 1]![0]!).toUpperCase()
})

const showImage = computed(() => !!props.src && !failed.value)
</script>

<template>
  <span
    class="pk-avatar"
    :style="{ width: `${size}px`, height: `${size}px`, fontSize: `${Math.round(size * 0.36)}px` }"
  >
    <img
      v-if="showImage"
      :src="src!"
      :alt="name"
      width="size"
      height="size"
      @error="failed = true"
    >
    <span v-else aria-hidden="true">{{ initials }}</span>
    <span v-if="!showImage" class="pk-visually-hidden">{{ name }}</span>
  </span>
</template>

<style scoped>
.pk-avatar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--pk-radius-full);
  background: color-mix(in srgb, var(--pk-accent) 18%, var(--pk-surface-muted));
  color: var(--pk-text);
  font-weight: 700;
  overflow: hidden;
  flex-shrink: 0;
}
.pk-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.pk-visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  overflow: hidden;
  clip: rect(0 0 0 0);
  white-space: nowrap;
}
</style>
