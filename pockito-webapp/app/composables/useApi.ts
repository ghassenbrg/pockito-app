import { PockitoApiError } from '~/utils/errors'

/**
 * The one place the webapp talks to Pockito API.
 *
 * <p>Attaches the access token, generates a correlation id, and turns every non-2xx
 * response into a {@link PockitoApiError} carrying the backend's stable code. Components
 * never call `$fetch` against the API directly.
 */
export function useApi() {
  const config = useRuntimeConfig().public
  const { accessToken, forgetSession } = useAuth()

  async function request<T>(
    path: string,
    options: {
      method?: 'GET' | 'POST' | 'PUT' | 'DELETE'
      body?: unknown
      formData?: FormData
      raw?: boolean
    } = {},
  ): Promise<T> {
    const token = await accessToken()
    if (!token) {
      await forgetSession()
      throw new PockitoApiError(401, 'auth.unauthenticated', 'Your session has ended')
    }

    const headers: Record<string, string> = {
      Authorization: `Bearer ${token}`,
      'X-Correlation-Id': correlationId(),
    }
    let body: BodyInit | undefined
    if (options.formData) {
      // Deliberately no Content-Type: the browser has to set the multipart boundary.
      body = options.formData
    } else if (options.body !== undefined) {
      headers['Content-Type'] = 'application/json'
      body = JSON.stringify(options.body)
    }

    let response: Response
    try {
      response = await fetch(`${config.apiBaseUrl}${path}`, {
        method: options.method ?? 'GET',
        headers,
        body,
      })
    } catch {
      // fetch only rejects for transport failures: offline, DNS, CORS, timeout.
      throw new PockitoApiError(0, 'network.unreachable', 'Pockito could not be reached')
    }

    if (response.status === 401) {
      await forgetSession()
      throw new PockitoApiError(401, 'auth.unauthenticated', 'Your session has ended')
    }

    if (!response.ok) {
      const problem = await response.json().catch(() => null)
      throw PockitoApiError.fromResponse(response.status, problem)
    }

    if (response.status === 204) return undefined as T
    if (options.raw) return (await response.blob()) as T
    return (await response.json()) as T
  }

  return {
    get: <T>(path: string) => request<T>(path),
    put: <T>(path: string, body: unknown) => request<T>(path, { method: 'PUT', body }),
    post: <T>(path: string, body?: unknown) => request<T>(path, { method: 'POST', body }),
    upload: <T>(path: string, formData: FormData) => request<T>(path, { method: 'POST', formData }),
    remove: (path: string) => request<void>(path, { method: 'DELETE' }),
  }
}

/** Matches the id the backend echoes in X-Correlation-Id so a failure can be traced. */
function correlationId(): string {
  return typeof crypto?.randomUUID === 'function'
    ? crypto.randomUUID()
    : `web-${Date.now()}-${Math.random().toString(16).slice(2)}`
}
