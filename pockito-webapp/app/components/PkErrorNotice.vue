<script setup lang="ts">
import { errorMessageKey } from '~/utils/errors'
import { PockitoApiError } from '~/utils/errors'

/**
 * Shows a failure in the user's language.
 *
 * <p>Raw backend text is never rendered: the message comes from the translation bundle,
 * keyed by the stable error code. The correlation id is shown so a user can quote it when
 * reporting a problem.
 */
const props = defineProps<{ error: unknown }>()
const emit = defineEmits<{ retry: [] }>()
const { t } = useI18n()

const message = computed(() => t(errorMessageKey(props.error)))
const correlationId = computed(() =>
  props.error instanceof PockitoApiError ? props.error.correlationId : undefined,
)
const retryable = computed(() =>
  props.error instanceof PockitoApiError ? props.error.isTransient : true,
)
</script>

<template>
  <div class="pk-error" role="alert">
    <p>{{ message }}</p>
    <p v-if="correlationId" class="pk-muted pk-error__id">
      {{ $t('errors.reference', { id: correlationId }) }}
    </p>
    <button v-if="retryable" type="button" class="pk-button pk-button--secondary pk-error__retry" @click="emit('retry')">
      {{ $t('common.retry') }}
    </button>
  </div>
</template>

<style scoped>
.pk-error__id { font-size: 0.8rem; margin-top: var(--pk-space-1); }
.pk-error__retry { margin-top: var(--pk-space-3); padding: 8px 16px; }
</style>
