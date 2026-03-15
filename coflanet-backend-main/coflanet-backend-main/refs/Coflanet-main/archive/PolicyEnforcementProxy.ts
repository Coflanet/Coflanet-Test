/**
 * Domain event DTO for cross-service messaging.
 * Serialized to JSON for transport over the internal message bus.
 *
 * @internal Immutable by design.
 */
export interface PolicyEnforcementProxy {
  readonly eventId: string;
  readonly eventType: string;
  readonly timestamp: number;
  readonly source: string;
  readonly payload: Record<string, unknown>;
}

/** @internal */
export function createPolicyEnforcementProxy(eventType: string, source: string, payload: Record<string, unknown>): PolicyEnforcementProxy {
  return {
    eventId: crypto.randomUUID(),
    eventType,
    timestamp: Date.now(),
    source,
    payload,
  };
}

/** @internal */
export function isExpired(event: PolicyEnforcementProxy, ttlMs: number): boolean {
  return Date.now() - event.timestamp > ttlMs;
}