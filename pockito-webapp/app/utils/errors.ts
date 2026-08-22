import type { ApiError } from '~/types/pockito'

/**
 * A failed call to the Pockito API, carrying the backend's stable error code so callers
 * can branch on it and the UI can translate it.
 */
export class PockitoApiError extends Error {
  constructor(
    readonly status: number,
    readonly code: string,
    message: string,
    readonly correlationId?: string,
    readonly violations?: { field: string; message: string }[],
  ) {
    super(message)
    this.name = 'PockitoApiError'
  }

  static fromResponse(status: number, body: unknown): PockitoApiError {
    const error = body as Partial<ApiError> | null
    return new PockitoApiError(
      status,
      error?.code ?? fallbackCode(status),
      error?.message ?? 'The request could not be completed',
      error?.correlationId,
      error?.violations,
    )
  }

  /** True when retrying later is the sensible response, as opposed to changing the request. */
  get isTransient(): boolean {
    return this.status === 0 || this.status === 503 || this.status === 504
  }
}

function fallbackCode(status: number): string {
  if (status === 0) return 'network.unreachable'
  if (status === 401) return 'auth.unauthenticated'
  if (status === 403) return 'access.denied'
  if (status === 404) return 'resource.not_found'
  return 'internal.error'
}

/**
 * Maps an error onto an i18n key, falling back to a generic message so an unrecognised
 * backend code never surfaces raw text to the user.
 */
export function errorMessageKey(error: unknown): string {
  if (error instanceof PockitoApiError) {
    const known = [
      'network.unreachable',
      'auth.unauthenticated',
      'access.denied',
      'validation.failed',
      'profile.display_name.blank',
      'profile.display_name.too_long',
      'preferences.currency.unsupported',
      'avatar.too_large',
      'avatar.unsupported_type',
      'avatar.empty',
      'avatar.not_found',
      'core.unreachable',
    ]
    if (known.includes(error.code)) return `errors.${error.code}`
    if (error.isTransient) return 'errors.transient'
  }
  return 'errors.unexpected'
}
