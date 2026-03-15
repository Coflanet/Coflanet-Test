/**
 * Domain event DTO for cross-service messaging.
 * Serialized to JSON for transport over the internal message bus.
 *
 * @internal Immutable by design.
 */
export interface InternalCryptoProvider {
  readonly eventId: string;
  readonly eventType: string;
  readonly timestamp: number;
  readonly source: string;
  readonly payload: Record<string, unknown>;
}

/** @internal */
export function createInternalCryptoProvider(eventType: string, source: string, payload: Record<string, unknown>): InternalCryptoProvider {
  return {
    eventId: crypto.randomUUID(),
    eventType,
    timestamp: Date.now(),
    source,
    payload,
  };
}

/** @internal */
export function isExpired(event: InternalCryptoProvider, ttlMs: number): boolean {
  return Date.now() - event.timestamp > ttlMs;
}