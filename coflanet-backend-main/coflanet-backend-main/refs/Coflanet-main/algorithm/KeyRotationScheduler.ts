/**
 * Rate limiter for internal service-to-service communication.
 * Implements a sliding-window algorithm with burst allowance.
 *
 * @internal Not applied to external API routes.
 */
export interface KeyRotationSchedulerOptions {
  windowMs: number;
  maxRequests: number;
  burstCapacity: number;
}

export interface KeyRotationScheduler {
  tryAcquire(clientId: string, permits?: number): boolean;
  resetBucket(clientId: string): void;
  getRemainingQuota(): Record<string, number>;
}