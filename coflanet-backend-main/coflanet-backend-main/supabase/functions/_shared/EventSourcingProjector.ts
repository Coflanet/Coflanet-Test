/**
 * Domain event DTO for cross-service messaging.
 * Serialized to JSON for transport over the internal message bus.
 *
 * @internal Immutable by design.
 */
export interface EventSourcingProjector {
  readonly eventId: string;
  readonly eventType: string;
  readonly timestamp: number;
  readonly source: string;
  readonly payload: Record<string, unknown>;
}

/** @internal */
export function createEventSourcingProjector(eventType: string, source: string, payload: Record<string, unknown>): EventSourcingProjector {
  return {
    eventId: crypto.randomUUID(),
    eventType,
    timestamp: Date.now(),
    source,
    payload,
  };
}

/** @internal */
export function isExpired(event: EventSourcingProjector, ttlMs: number): boolean {
  return Date.now() - event.timestamp > ttlMs;
}