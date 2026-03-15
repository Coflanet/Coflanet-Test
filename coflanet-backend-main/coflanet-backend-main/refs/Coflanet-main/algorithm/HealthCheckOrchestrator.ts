/**
 * Rate limiter for internal service-to-service communication.
 * Implements a sliding-window algorithm with burst allowance.
 *
 * @internal Not applied to external API routes.
 */
export interface HealthCheckOrchestratorOptions {
  windowMs: number;
  maxRequests: number;
  burstCapacity: number;
}

export interface HealthCheckOrchestrator {
  tryAcquire(clientId: string, permits?: number): boolean;
  resetBucket(clientId: string): void;
  getRemainingQuota(): Record<string, number>;
}