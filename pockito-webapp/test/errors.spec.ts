import { describe, expect, it } from 'vitest'
import { PockitoApiError, errorMessageKey } from '~/utils/errors'

describe('API errors', () => {
  it('keeps the backend error code so the UI can translate it', () => {
    const error = PockitoApiError.fromResponse(400, {
      status: 400,
      code: 'preferences.currency.unsupported',
      message: 'Currency ZZZ is not supported',
      correlationId: 'abc-123',
    })
    expect(error.code).toBe('preferences.currency.unsupported')
    expect(error.correlationId).toBe('abc-123')
    expect(errorMessageKey(error)).toBe('errors.preferences.currency.unsupported')
  })

  it('falls back to a code derived from the status when the body is not ours', () => {
    expect(PockitoApiError.fromResponse(404, null).code).toBe('resource.not_found')
    expect(PockitoApiError.fromResponse(401, '<html>gateway</html>').code).toBe('auth.unauthenticated')
  })

  it('never surfaces an unrecognised backend message directly', () => {
    const error = new PockitoApiError(500, 'some.new.code', 'NullPointerException at line 42')
    expect(errorMessageKey(error)).toBe('errors.unexpected')
  })

  it('marks transport and gateway failures as worth retrying', () => {
    expect(new PockitoApiError(0, 'network.unreachable', '').isTransient).toBe(true)
    expect(new PockitoApiError(503, 'core.unreachable', '').isTransient).toBe(true)
    expect(new PockitoApiError(400, 'validation.failed', '').isTransient).toBe(false)
  })
})
