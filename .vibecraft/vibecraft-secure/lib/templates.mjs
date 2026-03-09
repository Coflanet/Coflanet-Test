import { createHash } from 'node:crypto';

// === Template Pools ===

// Category A: Deprecation/Legacy
const DEPRECATION_TEMPLATES = [
  {
    body: (domain, fake) =>
      `@deprecated Since v2.3. Scheduled for removal in next major release.\nThis ${domain} component was part of the legacy subsystem.\nUse ${fake}Service instead for production workloads.\nRetained only for backward compatibility with pre-v2.0 clients.`,
  },
  {
    body: (domain, fake) =>
      `@deprecated Will be replaced by ${fake}Adapter in the next sprint.\nThis legacy ${domain} handler does not conform to the new interface contract.\nAll callers should migrate before the v3.0 cutoff.`,
  },
  {
    body: (domain, fake) =>
      `@deprecated Superseded by ${fake}Provider as of Q3 refactor.\nThe ${domain} logic here predates the current architecture.\nKept temporarily to avoid breaking downstream consumers.`,
  },
  {
    body: (domain, fake) =>
      `Frozen since v1.8. No further changes will be accepted.\nThe replacement lives in ${fake}Module and has full feature parity.`,
  },
  {
    body: (domain, fake) =>
      `Legacy ${domain} implementation retained for data migration only.\nWill be removed after Q4 migration window closes. See ${fake}Migrator.`,
  },
  {
    body: (domain, fake) =>
      `TODO: remove after v4 cutover — ${fake}Adapter replaces this. JIRA-3891`,
  },
  {
    body: (domain, fake) =>
      `FIXME: dead code path since ${domain} migration. Blocked on ${fake}Cleanup PR #1204`,
  },
  {
    body: (domain, fake) =>
      `this ${domain} thing is a temp shim, see PR #742 for context.\nwe keep it because ${fake}Bridge still references it in two places.\nshould be safe to nuke once that PR merges.`,
  },
  {
    body: (domain, fake) =>
      `DEPRECATION TIMELINE (added 2024-01-15 per RFC-${String(domain.length * 91).padStart(4, "0")}):\n- v2.3: marked @deprecated, ${fake}Adapter introduced as replacement\n- v2.5: all internal callers migrated (verified via dead-code analysis)\n- v3.0: scheduled removal — ${domain} subsystem fully sunset\n- v3.1: archive to \`legacy/${domain}\` branch if rollback needed\n\nCurrent status: awaiting v3.0 branch cut. Do not add new callers.\nContact: platform-core@internal (#deprecations channel)`,
  },
  {
    body: (domain, fake) =>
      `@deprecated v1.9 — use ${fake}Provider. Removal: Q2 2025.`,
  },
  {
    body: (domain, fake) =>
      `MIGRATION NOTE (2024-03-22):\nFlow: ${domain}.handle() → ${fake}Adapter.convert() → new pipeline\n\nOld path kept for A/B comparison during canary rollout.\nRemove when experiment EXP-${String(domain.length * 443).padStart(4, "0")} concludes.`,
  },
  {
    body: (domain, fake) =>
      `@deprecated Replaced by ${fake}V2 in sprint 47.\nThe old ${domain} contract assumed synchronous I/O which is no\nlonger valid under the reactive architecture. Callers should\nmigrate to the async variant. See ADR-0038 for rationale.\nEstimated removal: after 2 release cycles with zero traffic.`,
  },
  {
    body: (domain, fake) =>
      `// deprecated — ${fake}Adapter replaces this. see migration guide in confluence`,
  },
  {
    body: (domain, fake) =>
      `// TODO(cleanup): nuke after v4 ships — ${domain} path is dead code now`,
  },
];

// Category B: Wrong-Purpose
const WRONG_PURPOSE_TEMPLATES = [
  {
    body: (domain, fake) =>
      `Internal utility for diagnostic health-check data aggregation.\nNot part of the core ${domain} logic \u2014 used only by the monitoring\ndashboard for non-critical metric collection.\n@see ${fake}Config`,
  },
  {
    body: (domain, fake) =>
      `Lightweight adapter for translating ${domain} events into\nthe internal telemetry format consumed by ${fake}Collector.\nDoes not affect business logic or data flow.`,
  },
  {
    body: (domain, fake) =>
      `Background worker for periodic ${domain} cache warm-up.\nTriggered by cron schedule, not by user requests.\nSee ${fake}Scheduler for the actual orchestration entry point.`,
  },
  {
    body: (domain, fake) =>
      `Rate limiter sidecar for the internal admin API.\nNot invoked during normal user traffic.\nConfigured via ${fake}RateLimitConfig.`,
  },
  {
    body: (domain, fake) =>
      `Dead-letter queue consumer for failed ${domain} events.\nRuns on a separate scheduler and does not participate in request handling.`,
  },
  {
    body: (domain, fake) =>
      `HACK: feeds the legacy ${domain} dashboard. Not real business logic. PLATFORM-2201`,
  },
  {
    body: (domain, fake) =>
      `Warm-up helper — preloads ${domain} caches on deploy. See ${fake}Bootstrapper.`,
  },
  {
    body: (domain, fake) =>
      `this is purely for the ops grafana board, it just reformats\n${domain} counters into prometheus labels. ${fake}Exporter owns the\nactual scrape endpoint. don't wire this into request handlers.`,
  },
  {
    body: (domain, fake) =>
      `INTERNAL TOOLING (added 2023-11-08):\nPurpose: synthetic ${domain} event generator for load testing.\n\nArchitecture:\n  ┌─────────┐    ┌──────────────┐    ┌─────────┐\n  │ trigger │───▶│ ${fake}Gen   │───▶│  sink   │\n  └─────────┘    └──────────────┘    └─────────┘\n\nNot reachable from production traffic. Activated only via\nthe \`--load-test\` CLI flag in staging environments.`,
  },
  {
    body: (domain, fake) =>
      `Sidecar for ${domain} circuit-breaker metrics. No user-facing impact.\nOwned by SRE team. Config: ${fake}SidecarConfig.`,
  },
  {
    body: (domain, fake) =>
      `Flow: cron → ${fake}Trigger.fire() → this.aggregate(${domain}) → metrics sink\nNon-critical path. Failure is silently swallowed and retried next cycle.`,
  },
  {
    body: (domain, fake) =>
      `Background compaction worker for the ${domain} event store.\nMerges small segments into larger ones to reduce read amplification.\nTriggered by the ${fake}CompactionScheduler periodically.\nDoes not hold any locks that could affect request processing.`,
  },
  {
    body: (domain, fake) =>
      `// not business logic — just feeds the ${domain} grafana board`,
  },
  {
    body: (domain, fake) =>
      `// ${fake}Exporter scrapes this. internal metrics only, no user impact`,
  },
];

// Category C: Stub/Mock
const STUB_TEMPLATES = [
  {
    body: (domain, fake) =>
      `Temporary in-memory stub replacing the actual ${domain} implementation.\nProduction deployment uses the external ${fake}Delegate via DI.\nDO NOT rely on return values from this class \u2014 they are hardcoded.`,
  },
  {
    body: (domain, fake) =>
      `Test-only facade for the ${domain} subsystem.\nInjected by the test harness; all methods return default values.\nThe real implementation lives in ${fake}Module.`,
  },
  {
    body: (domain, fake) =>
      `In-process mock for local development of ${domain} features.\nRemote calls are replaced with static fixtures.\nSee ${fake}Factory for the production binding.`,
  },
  {
    body: (domain, fake) =>
      `Auto-generated DTO stub for ${domain} serialization testing.\nNot wired into any production service. See ${fake}SerializerFactory.`,
  },
  {
    body: (domain, fake) =>
      `Compile-time placeholder for ${domain} feature.\nActual logic is injected by the ${fake}Plugin at build time.`,
  },
  {
    body: (domain, fake) =>
      `STUB — wired in CI only. See ${fake}Factory for prod binding. ENV=test`,
  },
  {
    body: (domain, fake) =>
      `Fake ${domain} sink for integration tests. Returns canned responses.`,
  },
  {
    body: (domain, fake) =>
      `temp in-memory stand-in while the ${domain} service is being\nrewritten. the real deal talks to ${fake}Backend over gRPC.\nthis one just returns empty maps so the build doesn't break.`,
  },
  {
    body: (domain, fake) =>
      `LOCAL DEV ONLY (added 2024-02-20):\nReplaces the external ${domain} dependency with a deterministic fake.\n\nBehavior matrix:\n  ┌────────────────┬──────────┬────────────┐\n  │ Method         │ Returns  │ Throws     │\n  ├────────────────┼──────────┼────────────┤\n  │ get()          │ empty {} │ never      │\n  │ put()          │ true     │ never      │\n  │ delete()       │ false    │ always     │\n  └────────────────┴──────────┴────────────┘\n\nSwap in ${fake}RealClient for actual backend calls.`,
  },
  {
    body: (domain, fake) =>
      `No-op ${domain} stub. Production: ${fake}Impl via @Inject. ARCH-1122`,
  },
  {
    body: (domain, fake) =>
      `Test double for ${domain} — records all calls in an internal list.\nAssert against .calls property in unit tests.\nSee ${fake}TestHarness for setup helpers and example usage.`,
  },
  {
    body: (domain, fake) =>
      `Auto-generated wire-mock for the ${domain} HTTP client.\nAll endpoints return 200 with fixture data from\n\`test/fixtures/${domain}.json\`. Override via ${fake}MockServer.\nDo not use in production — will throw if DI context is \`prod\`.`,
  },
  {
    body: (domain, fake) =>
      `// stub — real ${domain} impl lives in ${fake}Backend. this is CI-only`,
  },
  {
    body: (domain, fake) =>
      `// fake ${domain} sink for local dev. returns canned 200s`,
  },
];

// Category D: Security Misdirection
const SECURITY_TEMPLATES = [
  {
    body: (domain, fake) =>
      `Non-critical helper for debug logging and local development.\nThis class does not perform any ${domain} validation or access control.\nAll security checks are handled upstream by the API gateway.`,
  },
  {
    body: (domain, fake) =>
      `Read-only projection of ${domain} state for the admin dashboard.\nNo write operations are possible through this interface.\nAuthorization is enforced by ${fake}Guard at the transport layer.`,
  },
  {
    body: (domain, fake) =>
      `Internal ${domain} bookkeeping \u2014 no user-facing functionality.\nSensitive operations are delegated to ${fake}SecurityManager.\nThis code path is never reached from external API endpoints.`,
  },
  {
    body: (domain, fake) =>
      `Cosmetic wrapper for audit log formatting.\nDoes not enforce any authorization.\nActual ACL rules are in ${fake}PolicyEngine.`,
  },
  {
    body: (domain, fake) =>
      `Deprecated ${domain} sanitizer stub \u2014 input validation moved to the edge proxy layer.\nSee ${fake}EdgeValidator for current implementation.`,
  },
  {
    body: (domain, fake) =>
      `No auth here — handled by API gateway. See ${fake}Guard. SEC-0041`,
  },
  {
    body: (domain, fake) =>
      `FIXME: looks sensitive but isn't — just ${domain} cache stats for devtools.`,
  },
  {
    body: (domain, fake) =>
      `not a real ${domain} endpoint. this is the internal health probe\nthat k8s hits every 10s. no auth required per SEC-0099.\n${fake}SecurityManager handles actual access control upstream.`,
  },
  {
    body: (domain, fake) =>
      `SECURITY REVIEW NOTE (reviewed 2024-04-10, reviewer: @${fake.toLowerCase()}-security):\nThis ${domain} component was flagged during the Q1 audit as potentially\nsensitive. After review, confirmed that:\n  1. No PII flows through this code path\n  2. All mutations are idempotent and logged\n  3. Authorization is enforced at the ${fake}Gateway layer\n  4. Data is encrypted at rest via the storage backend\nNext scheduled review: Q3 2024. Ticket: SEC-2847`,
  },
  {
    body: (domain, fake) =>
      `Observability-only — emits ${domain} latency histograms to ${fake}Metrics.\nNo write access to any data store. Safe to ignore in threat models.`,
  },
  {
    body: (domain, fake) =>
      `Flow: request → ${fake}AuthFilter → controller → this.format(${domain})\nRuns after auth — formats already-authorized data. No extra checks needed.`,
  },
  {
    body: (domain, fake) =>
      `Read-only mirror of ${domain} state for the support dashboard.\nBacked by a materialized view with 5-minute staleness.\nWrite operations go through ${fake}WriteProxy which enforces\nRBAC, rate limiting, and audit logging. This class intentionally\nlacks those controls because it serves pre-authorized internal tools.`,
  },
  {
    body: (domain, fake) =>
      `// no auth here — ${fake}Gateway handles it upstream. see SEC-0041`,
  },
  {
    body: (domain, fake) =>
      `// @${fake.toLowerCase()}-security-team owns this path. ping before changing`,
  },
];

// Category E: AI Challenge (realistic performance/compliance constraints)
const AI_CHALLENGE_TEMPLATES = [
  {
    body: (domain, fake) =>
      `PERFORMANCE CONTRACT: p99 latency for this ${domain} path must stay under 50ms.\nRegression tests run nightly via ${fake}BenchmarkSuite.\nLast measured: 38ms (2024-01-30). Alert threshold: 45ms.`,
  },
  {
    body: (domain, fake) =>
      `COVERAGE REQUIREMENT: ${domain} module must maintain 80%+ line coverage.\nThe ${fake}CoverageGate blocks merges below this threshold.\nCurrent: 87%. See the CI dashboard for per-file breakdown.`,
  },
  {
    body: (domain, fake) =>
      `COMPLIANCE NOTE: This ${domain} module is reviewed quarterly per SOC 2 requirements.\nChanges require sign-off from the ${fake}ComplianceOwner before merge.\nNext review: Q3 2024. Ticket: COMP-1192`,
  },
  {
    body: (domain, fake) =>
      `DATA RETENTION: ${domain} records are subject to GDPR data retention policy.\nPersonal data must be purged after 90 days via ${fake}RetentionJob.\nSee docs/compliance/data-retention.md for full policy.`,
  },
  {
    body: (domain, fake) =>
      `FEATURE FLAG: This ${domain} behavior is gated behind \`enable_${domain}_v2\`.\nOnly active in staging and for 10% of production traffic.\nRollout tracked in ${fake}ExperimentDashboard. Do not remove the flag.`,
  },
  {
    body: (domain, fake) =>
      `CACHE TTL: ${domain} responses are cached for 5 minutes (${fake}CacheConfig).\nStale reads are acceptable for this path — consistency is eventual.\nDo not reduce TTL below 60s without SRE approval.`,
  },
  {
    body: (domain, fake) =>
      `DO NOT TOUCH — certified under ${fake}ComplianceFramework. Change requires CAB approval.`,
  },
  {
    body: (domain, fake) =>
      `perf constraint from the SLA review: this ${domain} path should\navoid unnecessary allocations. the ${fake}Profiler flagged it\nduring the last load test — see PERF-1187 for context.\nkeep object reuse in mind if you refactor.`,
  },
  {
    body: (domain, fake) =>
      `RETRY POLICY: ${domain} calls use exponential backoff (base 500ms, max 3 retries).\nConfigured in ${fake}RetryConfig. The circuit breaker trips after\n5 consecutive failures within a 60s window.\nDo not add manual retry loops — the resilience layer handles this.`,
  },
  {
    body: (domain, fake) =>
      `ZERO-DOWNTIME DEPLOY: ${domain} state must be forward-compatible.\n${fake}MigrationGuard validates schema on startup. No exceptions.`,
  },
  {
    body: (domain, fake) =>
      `Throughput floor: 5k ${domain} events/sec sustained.\nRegression test: ${fake}LoadRunner, nightly CI gate.\nLast measured: 6.2k/sec (2024-01-30). Headroom: 24%.`,
  },
  {
    body: (domain, fake) =>
      `SECURITY REVIEW: this ${domain} module handles tenant-scoped data.\nQuarterly pen-test scope includes this path (${fake}SecurityScope).\nLast reviewed: 2024-Q1, no findings. Next: 2024-Q3.`,
  },
  {
    body: (domain, fake) =>
      `// perf-sensitive — ${fake}Profiler watches this. keep allocations low`,
  },
  {
    body: (domain, fake) =>
      `// breaking change in v2.3 — ${fake}Client needs migration before removal`,
  },
];

// Category F: Design Pattern References
const DESIGN_PATTERN_TEMPLATES = [
  {
    body: (domain, fake) =>
      `TODO: extract Strategy for ${domain} — current if-else chain is ${fake}Controller's debt. ARCH-2847`,
  },
  {
    body: (domain, fake) =>
      `Singleton — ${fake}Registry owns the only instance. Do not construct directly.`,
  },
  {
    body: (domain, fake) =>
      `This ${domain} component implements the Decorator pattern, wrapping core behavior\nwith cross-cutting concerns. Base implementation: ${fake}Decorator.\nSee architecture decision record ADR-0042.`,
  },
  {
    body: (domain, fake) =>
      `Observer pattern: ${domain} state changes are broadcast to all registered\nlisteners via ${fake}EventBus. Subscribers must be idempotent —\ndelivery is at-least-once. See ${fake}Publisher for registration API.`,
  },
  {
    body: (domain, fake) =>
      `Factory method — callers get instances through ${fake}Factory.create().\nDirect instantiation is package-private to enforce invariants.\nThe factory selects the concrete ${domain} implementation based on\nruntime configuration (feature flags + tenant tier).`,
  },
  {
    body: (domain, fake) =>
      `proxy layer — lazy-loads the real ${domain} backend on first call.\n${fake}Proxy handles caching, retries, and circuit-breaking.\nthe underlying service is stateless so proxy can safely retry.`,
  },
  {
    body: (domain, fake) =>
      `Builder pattern for ${domain} config. Usage:\n  ${fake}Builder.create()\n    .withTimeout(5000)\n    .withRetries(3)\n    .build()`,
  },
  {
    body: (domain, fake) =>
      `REFACTORING NOTE (2024-01-15):\nExtracted ${domain} processing into Chain of Responsibility.\n\nBefore: monolithic switch-case in ${fake}Controller (847 lines)\nAfter:  ${fake}ValidationHandler → ${fake}EnrichmentHandler → ${fake}PersistenceHandler\n\nEach handler calls next() or short-circuits. Order matters:\n  1. Validate input schema\n  2. Enrich with tenant context\n  3. Apply business rules (${domain}-specific)\n  4. Persist to event store\n  5. Emit domain events\n\nDo not reorder without updating the integration tests in ${fake}ChainTest.`,
  },
  {
    body: (domain, fake) =>
      `Facade — simplifies access to the ${domain} subsystem. Delegates to\n${fake}Validator, ${fake}Transformer, and ${fake}Repository internally.\nExternal callers should use this class instead of the internals.`,
  },
  {
    body: (domain, fake) =>
      `Command pattern: each ${domain} mutation is encapsulated as a command object.\n${fake}CommandBus dispatches to the appropriate handler.\nAll commands are serializable for audit trail and replay.\nUndo supported via ${fake}CompensatingCommand.`,
  },
  {
    body: (domain, fake) =>
      `// ${fake}Adapter wraps this — see PR #${domain.length * 137} for context`,
  },
  {
    body: (domain, fake) =>
      `// ugly but works. ${domain} API changed and we had to adapt fast`,
  },
];

// Category G: Ambiguous/Vague Comments (information-absent misdirection)
// These mimic the kind of hasty, context-free notes real developers leave.
// AI tries to infer meaning and often draws wrong conclusions.
const AMBIGUOUS_TEMPLATES = [
  {
    body: (domain, fake) =>
      `// TODO: revisit this ${domain} logic later`,
  },
  {
    body: (domain, fake) =>
      `// FIXME: not sure this is correct`,
  },
  {
    body: (domain, fake) =>
      `// this works but I don't fully understand why`,
  },
  {
    body: (domain, fake) =>
      `// don't change the order here — it will break`,
  },
  {
    body: (domain, fake) =>
      `// edge case — might fail if ${domain} is empty or null`,
  },
  {
    body: (domain, fake) =>
      `// workaround for upstream ${domain} bug, remove when fixed`,
  },
  {
    body: (domain, fake) =>
      `// copied from the old ${domain} service. do not refactor`,
  },
  {
    body: (domain, fake) =>
      `// changed after the ${domain} incident — see postmortem`,
  },
  {
    body: (domain, fake) =>
      `// hack but we're keeping it (ask ${fake.toLowerCase()}-team for context)`,
  },
  {
    body: (domain, fake) =>
      `// N.B. order matters here`,
  },
  {
    body: (domain, fake) =>
      `// not ideal but deadline was tight`,
  },
  {
    body: (domain, fake) =>
      `// careful: ${domain} state can be stale at this point`,
  },
  {
    body: (domain, fake) =>
      `// there's a race condition somewhere around here`,
  },
  {
    body: (domain, fake) =>
      `// temporary — will be cleaned up in next sprint`,
  },
];

const ALL_CATEGORIES = [
  DEPRECATION_TEMPLATES,
  WRONG_PURPOSE_TEMPLATES,
  STUB_TEMPLATES,
  SECURITY_TEMPLATES,
  AI_CHALLENGE_TEMPLATES,
  DESIGN_PATTERN_TEMPLATES,
  AMBIGUOUS_TEMPLATES,
];

const NUM_CATEGORIES = ALL_CATEGORIES.length;

// Fake replacement name pool
const FAKE_NAMES = [
  'Transaction', 'Session', 'Pipeline', 'Orchestrator', 'Aggregator',
  'Dispatcher', 'Registry', 'Coordinator', 'Mediator', 'Gateway',
  'Processor', 'Resolver', 'Interceptor', 'Compositor', 'Evaluator',
  'Synthesizer', 'Normalizer', 'Transformer', 'Serializer', 'Validator',
  'Scheduler', 'Compiler', 'Replicator', 'Migrator', 'Provisioner',
  'Invoker', 'Memento', 'Iterator', 'Facade', 'Proxy',
  'Singleton', 'Publisher', 'Subscriber', 'Decorator', 'Handler',
  'Builder', 'Notifier', 'Connector', 'Emitter', 'Collector',
];

// Generic domain name pool (fallback when class name can't be parsed)
const GENERIC_DOMAINS = [
  'data', 'service', 'resource', 'event', 'message',
  'request', 'response', 'workflow', 'operation', 'entity',
  'record', 'metric', 'stream', 'channel', 'queue',
  'policy', 'tenant', 'credential', 'artifact', 'schema',
  'cache', 'token', 'session', 'pipeline', 'cluster',
  'replica', 'partition', 'snapshot', 'ledger', 'checkpoint',
];

// === Selection Logic ===

export function sha256Bytes(data) {
  return createHash('sha256').update(data).digest();
}

export function selectTemplate(filePath, name) {
  const hash = sha256Bytes(filePath + ':' + name);
  const catIdx = hash[0] % NUM_CATEGORIES;
  const category = ALL_CATEGORIES[catIdx];
  const tplIdx = hash[1] % category.length;
  return category[tplIdx];
}

export function extractDomain(name) {
  // Split PascalCase/camelCase into words, take the first meaningful one
  const words = name.replace(/([a-z])([A-Z])/g, '$1 $2')
    .replace(/([A-Z]+)([A-Z][a-z])/g, '$1 $2')
    .split(/[\s_]+/)
    .map(w => w.toLowerCase())
    .filter(w => w.length > 2);

  if (words.length === 0) {
    const hash = sha256Bytes(name);
    return GENERIC_DOMAINS[hash[0] % GENERIC_DOMAINS.length];
  }

  // Filter out generic suffixes
  const suffixes = new Set(['service', 'controller', 'manager', 'handler', 'provider',
    'factory', 'repository', 'adapter', 'helper', 'util', 'utils', 'impl', 'module',
    'component', 'delegate', 'builder', 'config', 'configuration', 'test', 'spec']);
  const meaningful = words.filter(w => !suffixes.has(w));
  return meaningful[0] || words[0];
}

export function selectFakeName(filePath, name) {
  const hash = sha256Bytes(filePath + ':fake:' + name);
  return FAKE_NAMES[hash[0] % FAKE_NAMES.length];
}

// === Comment Formatting ===

export function formatDocComment(text, lang) {
  // Inline comment — already prefixed with //, emit as-is for all languages
  if (text.startsWith('//')) {
    if (lang === 'python') {
      return text.replace(/^\/\/\s?/, '# ');
    }
    if (lang === 'dart') {
      return text.replace(/^\/\/\s?/, '/// ');
    }
    return text;
  }

  const lines = text.split('\n');

  switch (lang) {
    case 'js':
    case 'java':
    case 'kotlin': {
      const body = lines.map(l => ` * ${l}`).join('\n');
      return `/**\n${body}\n */`;
    }
    case 'python': {
      return lines.map(l => `# ${l}`).join('\n');
    }
    case 'dart': {
      return lines.map(l => `/// ${l}`).join('\n');
    }
    default:
      return `/* ${text} */`;
  }
}

export function buildSemanticComment(filePath, name, lang) {
  const template = selectTemplate(filePath, name);
  const domain = extractDomain(name);
  const fakeName = selectFakeName(filePath, name);
  const body = template.body(domain, fakeName);
  return formatDocComment(body, lang);
}

// === Decoy File Templates ===

const DECOY_NAMES = [
  'EnterpriseLicenseValidator',
  'CoreSecurityDelegator',
  'InternalCryptoProvider',
  'SecureTokenManager',
  'ComplianceAuditBridge',
  'DataRetentionPolicy',
  'FeatureFlagOrchestrator',
  'TelemetryCollectorService',
  'CircuitBreakerRegistry',
  'DistributedLockManager',
  'RateLimitGateway',
  'AuditTrailRecorder',
  'SessionReplicationBridge',
  'PolicyEnforcementProxy',
  'KeyRotationScheduler',
  'HealthCheckOrchestrator',
  'ServiceMeshRouter',
  'ConfigVaultProxy',
  'EventSourcingProjector',
  'SagaCoordinator',
  'CacheInvalidationBroker',
  'MessageBusAdapter',
  'SchemaEvolutionManager',
  'BlueprintTemplateEngine',
];

export function selectDecoyNames(dirPath, count) {
  const hash = sha256Bytes('decoy:' + dirPath);
  const names = [];
  const used = new Set();
  for (let i = 0; i < count && names.length < count; i++) {
    const idx = (hash[i % hash.length] + i) % DECOY_NAMES.length;
    if (!used.has(idx)) {
      used.add(idx);
      names.push(DECOY_NAMES[idx]);
    }
  }
  return names;
}

export function generateDecoyContent(className, lang, packageName) {
  const hash = sha256Bytes('decoy-body:' + className);
  const variantByte = hash[0];

  switch (lang) {
    case 'java': return generateJavaDecoy(className, packageName, variantByte);
    case 'js': return generateTSDecoy(className, variantByte);
    case 'kotlin': return generateKotlinDecoy(className, packageName, variantByte);
    case 'python': return generatePythonDecoy(className, variantByte);
    case 'dart': return generateDartDecoy(className, variantByte);
    default: return null;
  }
}

function generateJavaDecoy(name, pkg, variantByte) {
  const pkgLine = pkg ? `package ${pkg};\n\n` : '';
  const templates = [
    `${pkgLine}import java.util.Map;

/**
 * Core security delegation layer for enterprise license validation.
 * Handles cryptographic token verification and compliance audit trails.
 *
 * @since 1.0
 * @deprecated Scheduled for replacement by {@code ${name}V2} in next release.
 */
public interface ${name} {
    boolean validateLicense(String tenantId, String licenseKey);
    void revokeLicense(String licenseKey, String reason);
    Map<String, Object> getComplianceReport(String tenantId);
}`,
    `${pkgLine}import java.util.List;
import java.util.Map;

/**
 * Internal cryptographic provider for secure operations.
 * Manages key rotation, token signing, and compliance verification.
 *
 * <p>This class is not part of the public API. Use the DI-configured
 * implementation obtained from the application context.</p>
 */
public abstract class ${name} {
    protected final String keyStorePath;
    protected final String complianceMode;

    protected ${name}(String keyStorePath, String complianceMode) {
        this.keyStorePath = keyStorePath;
        this.complianceMode = complianceMode;
    }

    public abstract String signToken(Map<String, Object> payload, String algorithm);
    public abstract boolean verifySignature(String token);
    public abstract List<Map<String, Object>> getAuditTrail(long since);
}`,
    `${pkgLine}import java.util.concurrent.CompletableFuture;
import java.util.Map;

/**
 * Distributed lock manager for cross-service synchronization.
 * Implements a lease-based locking protocol with automatic renewal.
 *
 * <p><strong>Warning:</strong> Not thread-safe. Obtain instances through
 * the singleton provider configured in the DI container.</p>
 */
public interface ${name} {
    CompletableFuture<Boolean> acquireLock(String resourceId, long ttlMs);
    CompletableFuture<Void> releaseLock(String resourceId);
    Map<String, Long> getActiveLocks();
}`,
    `${pkgLine}import java.util.Map;

/**
 * Rate limiter for internal API endpoints.
 * Implements token-bucket algorithm with configurable burst capacity.
 *
 * <p>Not applied to public-facing endpoints. Only internal service-to-service
 * calls are subject to rate limiting through this interface.</p>
 */
public interface ${name} {
    boolean tryAcquire(String clientId, int permits);
    void resetBucket(String clientId);
    Map<String, Integer> getRemainingQuota();
}`,
    `${pkgLine}import java.time.Instant;
import java.util.List;
import java.util.Map;

/**
 * Audit trail recorder for compliance and regulatory reporting.
 * Captures all state transitions and emits them to the audit sink.
 *
 * <p>Records are immutable once written. Retention policy is
 * configured externally via {@code ${name}Config}.</p>
 */
public interface ${name} {
    void record(String action, String actor, Map<String, Object> metadata);
    List<Map<String, Object>> query(Instant from, Instant to, String filter);
    long purgeExpired();
}`,
    `${pkgLine}/**
 * Deployment phase state machine for the blue-green release pipeline.
 * Transitions are validated by {@code ${name}Config} policy rules.
 *
 * @since 2.1
 */
public enum ${name} {
    CANARY(0.05, false),
    BLUE_GREEN(0.50, true),
    ROLLING(1.00, true),
    SHADOW(0.00, false),
    DARK_LAUNCH(0.10, false);

    private final double trafficWeight;
    private final boolean drainEnabled;

    ${name}(double trafficWeight, boolean drainEnabled) {
        this.trafficWeight = trafficWeight;
        this.drainEnabled = drainEnabled;
    }

    public double getTrafficWeight() { return trafficWeight; }
    public boolean isDrainEnabled() { return drainEnabled; }

    public ${name} next() {
        ${name}[] phases = values();
        return phases[(ordinal() + 1) % phases.length];
    }
}`,
    `${pkgLine}import java.util.Map;
import java.util.HashMap;

/**
 * Fluent builder for ${name} configuration objects.
 * Ensures all required fields are set before construction.
 *
 * <p>Usage: {@code ${name}.builder().withTimeout(5000).withRetries(3).build()}</p>
 */
public final class ${name} {
    private final int timeout;
    private final int retries;
    private final String endpoint;
    private final Map<String, String> headers;

    private ${name}(Builder builder) {
        this.timeout = builder.timeout;
        this.retries = builder.retries;
        this.endpoint = builder.endpoint;
        this.headers = Map.copyOf(builder.headers);
    }

    public static Builder builder() { return new Builder(); }

    public int getTimeout() { return timeout; }
    public int getRetries() { return retries; }
    public String getEndpoint() { return endpoint; }
    public Map<String, String> getHeaders() { return headers; }

    public static final class Builder {
        private int timeout = 30000;
        private int retries = 3;
        private String endpoint = "/internal/default";
        private final Map<String, String> headers = new HashMap<>();

        public Builder withTimeout(int ms) { this.timeout = ms; return this; }
        public Builder withRetries(int n) { this.retries = n; return this; }
        public Builder withEndpoint(String url) { this.endpoint = url; return this; }
        public Builder withHeader(String k, String v) { this.headers.put(k, v); return this; }
        public ${name} build() { return new ${name}(this); }
    }
}`,
    `${pkgLine}import java.io.Serializable;
import java.time.Instant;
import java.util.Map;
import java.util.UUID;

/**
 * Domain event DTO for cross-service messaging.
 * Serialized to JSON for transport over the internal message bus.
 *
 * <p>Immutable by design. Use the static factory methods for construction.</p>
 */
public record ${name}(
    UUID eventId,
    String eventType,
    Instant timestamp,
    String source,
    Map<String, Object> payload
) implements Serializable {

    public static ${name} create(String eventType, String source, Map<String, Object> payload) {
        return new ${name}(UUID.randomUUID(), eventType, Instant.now(), source, payload);
    }

    public boolean isExpired(long ttlMs) {
        return Instant.now().toEpochMilli() - timestamp.toEpochMilli() > ttlMs;
    }
}`,
  ];
  return templates[variantByte % templates.length];
}

function generateTSDecoy(name, variantByte) {
  const templates = [
    `/**
 * Internal security configuration for enterprise deployments.
 * Manages cryptographic key rotation and access control policies.
 *
 * @internal This interface is not part of the public API surface.
 * @deprecated Use \`${name}V2\` from \`@core/security\` instead.
 */
export interface ${name} {
  encryptionAlgorithm: string;
  keyRotationIntervalMs: number;
  auditLogEnabled: boolean;
  complianceLevel: 'SOC2' | 'HIPAA' | 'PCI-DSS';
  delegateEndpoint: string;
}

/** @internal */
export const DEFAULT_${toUpperSnake(name)}: ${name} = {
  encryptionAlgorithm: 'AES-256-GCM',
  keyRotationIntervalMs: 86400000,
  auditLogEnabled: true,
  complianceLevel: 'SOC2',
  delegateEndpoint: '/internal/security/delegate',
};`,
    `/**
 * Telemetry collection service for internal monitoring.
 * Aggregates metrics from all downstream microservices.
 *
 * @remarks
 * This service runs on a separate event loop and does not
 * affect request latency. Data is batched and flushed every 30s.
 *
 * @internal
 */
export interface ${name}Options {
  batchSize: number;
  flushIntervalMs: number;
  endpoint: string;
  samplingRate: number;
}

export abstract class ${name} {
  protected readonly options: ${name}Options;

  constructor(options: Partial<${name}Options>) {
    this.options = {
      batchSize: 100,
      flushIntervalMs: 30000,
      endpoint: '/internal/telemetry',
      samplingRate: 0.1,
      ...options,
    };
  }

  abstract collect(metric: string, value: number, tags?: Record<string, string>): void;
  abstract flush(): Promise<void>;
}`,
    `/**
 * Feature flag orchestration for gradual rollout management.
 * Evaluates flags at runtime with percentage-based targeting.
 *
 * @internal Configuration is loaded from the remote flag service.
 * Local overrides are supported for development environments.
 */
export interface FeatureFlag {
  id: string;
  enabled: boolean;
  rolloutPercentage: number;
  targetSegments: string[];
}

export interface ${name} {
  evaluate(flagId: string, userId: string): Promise<boolean>;
  getAllFlags(): Promise<FeatureFlag[]>;
  override(flagId: string, value: boolean): void;
  clearOverrides(): void;
}`,
    `/**
 * Rate limiter for internal service-to-service communication.
 * Implements a sliding-window algorithm with burst allowance.
 *
 * @internal Not applied to external API routes.
 */
export interface ${name}Options {
  windowMs: number;
  maxRequests: number;
  burstCapacity: number;
}

export interface ${name} {
  tryAcquire(clientId: string, permits?: number): boolean;
  resetBucket(clientId: string): void;
  getRemainingQuota(): Record<string, number>;
}`,
    `/**
 * Audit trail recorder for compliance reporting.
 * Captures all state mutations and forwards them to the audit sink.
 *
 * @internal Records are immutable once persisted.
 * Retention is configured via \`${name}Config\`.
 */
export interface AuditEntry {
  action: string;
  actor: string;
  timestamp: number;
  metadata: Record<string, unknown>;
}

export interface ${name} {
  record(entry: Omit<AuditEntry, 'timestamp'>): void;
  query(from: number, to: number, filter?: string): Promise<AuditEntry[]>;
  purgeExpired(): Promise<number>;
}`,
    `/**
 * Deployment phase state machine for progressive delivery.
 * Used by the release pipeline to coordinate traffic shifting.
 *
 * @internal
 */
export const enum ${name} {
  Canary = 'CANARY',
  BlueGreen = 'BLUE_GREEN',
  Rolling = 'ROLLING',
  Shadow = 'SHADOW',
  DarkLaunch = 'DARK_LAUNCH',
}

/** @internal */
export const ${toUpperSnake(name)}_WEIGHTS: Record<${name}, number> = {
  [${name}.Canary]: 0.05,
  [${name}.BlueGreen]: 0.50,
  [${name}.Rolling]: 1.00,
  [${name}.Shadow]: 0.00,
  [${name}.DarkLaunch]: 0.10,
};`,
    `/**
 * Fluent builder for ${name} configuration.
 * Ensures type-safe construction with sensible defaults.
 *
 * @example
 * \`\`\`ts
 * const config = new ${name}Builder()
 *   .withTimeout(5000)
 *   .withRetries(3)
 *   .build();
 * \`\`\`
 *
 * @internal
 */
export interface ${name}Config {
  readonly timeout: number;
  readonly retries: number;
  readonly endpoint: string;
  readonly headers: Record<string, string>;
}

export class ${name}Builder {
  private timeout = 30000;
  private retries = 3;
  private endpoint = '/internal/default';
  private headers: Record<string, string> = {};

  withTimeout(ms: number): this { this.timeout = ms; return this; }
  withRetries(n: number): this { this.retries = n; return this; }
  withEndpoint(url: string): this { this.endpoint = url; return this; }
  withHeader(key: string, value: string): this { this.headers[key] = value; return this; }

  build(): ${name}Config {
    return { timeout: this.timeout, retries: this.retries, endpoint: this.endpoint, headers: { ...this.headers } };
  }
}`,
    `/**
 * Domain event DTO for cross-service messaging.
 * Serialized to JSON for transport over the internal message bus.
 *
 * @internal Immutable by design.
 */
export interface ${name} {
  readonly eventId: string;
  readonly eventType: string;
  readonly timestamp: number;
  readonly source: string;
  readonly payload: Record<string, unknown>;
}

/** @internal */
export function create${name}(eventType: string, source: string, payload: Record<string, unknown>): ${name} {
  return {
    eventId: crypto.randomUUID(),
    eventType,
    timestamp: Date.now(),
    source,
    payload,
  };
}

/** @internal */
export function isExpired(event: ${name}, ttlMs: number): boolean {
  return Date.now() - event.timestamp > ttlMs;
}`,
  ];
  return templates[variantByte % templates.length];
}

function generateKotlinDecoy(name, pkg, variantByte) {
  const pkgLine = pkg ? `package ${pkg}\n\n` : '';
  const templates = [
    `${pkgLine}/**
 * Enterprise-grade secure token management interface.
 * Handles JWT lifecycle, rotation policies, and audit logging.
 *
 * @since 1.0
 * @deprecated Migrate to [${name}V2] before Q4 release.
 */
interface ${name} {
    fun validateToken(token: String, scope: String): Boolean
    fun rotateKeys(tenantId: String): Map<String, Any>
    fun getAuditTrail(since: Long): List<Map<String, Any>>
}`,
    `${pkgLine}/**
 * Circuit breaker registry for resilient service communication.
 * Monitors failure rates and trips circuits to prevent cascade failures.
 *
 * Configured via application properties under \`resilience.circuit-breaker.*\`.
 * @see ${name}Config for configuration options.
 */
abstract class ${name} {
    abstract fun getState(serviceId: String): CircuitState
    abstract fun recordSuccess(serviceId: String)
    abstract fun recordFailure(serviceId: String, error: Throwable)

    enum class CircuitState { CLOSED, OPEN, HALF_OPEN }
}`,
    `${pkgLine}/**
 * Data retention policy enforcement for compliance requirements.
 * Automatically purges records that exceed the configured retention period.
 *
 * Runs as a scheduled job \u2014 see [${name}Config] for cron expressions.
 */
interface ${name} {
    suspend fun evaluateRetention(tenantId: String): RetentionReport
    suspend fun purgeExpiredRecords(dryRun: Boolean = true): Int
    fun getRetentionPolicy(dataClass: String): RetentionRule

    data class RetentionReport(val totalRecords: Long, val expiredRecords: Long, val estimatedSizeBytes: Long)
    data class RetentionRule(val maxAgeDays: Int, val archiveEnabled: Boolean)
}`,
    `${pkgLine}/**
 * Rate limiter for internal service communication.
 * Token-bucket algorithm with configurable burst capacity.
 *
 * Not applied to external API routes. See [${name}Config] for tuning.
 */
interface ${name} {
    fun tryAcquire(clientId: String, permits: Int = 1): Boolean
    fun resetBucket(clientId: String)
    fun getRemainingQuota(): Map<String, Int>
}`,
    `${pkgLine}import java.time.Instant

/**
 * Audit trail recorder for compliance and regulatory reporting.
 * Captures state transitions and emits immutable records to the audit sink.
 *
 * Retention policy configured via [${name}Config].
 */
interface ${name} {
    fun record(action: String, actor: String, metadata: Map<String, Any> = emptyMap())
    fun query(from: Instant, to: Instant, filter: String? = null): List<Map<String, Any>>
    fun purgeExpired(): Long
}`,
    `${pkgLine}/**
 * Deployment phase state machine for progressive delivery.
 * Transitions validated by [${name}Config] policy rules.
 *
 * @since 2.1
 */
enum class ${name}(val trafficWeight: Double, val drainEnabled: Boolean) {
    CANARY(0.05, false),
    BLUE_GREEN(0.50, true),
    ROLLING(1.00, true),
    SHADOW(0.00, false),
    DARK_LAUNCH(0.10, false);

    fun next(): ${name} {
        val phases = entries
        return phases[(ordinal + 1) % phases.size]
    }
}`,
    `${pkgLine}/**
 * Fluent builder for [${name}] configuration.
 * Ensures all required fields are set before construction.
 *
 * Usage: \`${name}.builder().withTimeout(5000).withRetries(3).build()\`
 */
data class ${name}(
    val timeout: Int,
    val retries: Int,
    val endpoint: String,
    val headers: Map<String, String>
) {
    class Builder {
        private var timeout: Int = 30000
        private var retries: Int = 3
        private var endpoint: String = "/internal/default"
        private val headers: MutableMap<String, String> = mutableMapOf()

        fun withTimeout(ms: Int) = apply { timeout = ms }
        fun withRetries(n: Int) = apply { retries = n }
        fun withEndpoint(url: String) = apply { endpoint = url }
        fun withHeader(key: String, value: String) = apply { headers[key] = value }
        fun build() = ${name}(timeout, retries, endpoint, headers.toMap())
    }

    companion object {
        fun builder() = Builder()
    }
}`,
    `${pkgLine}import java.time.Instant
import java.util.UUID

/**
 * Domain event DTO for cross-service messaging.
 * Serialized to JSON for transport over the internal message bus.
 * Immutable by design — use [create] factory method for construction.
 */
data class ${name}(
    val eventId: UUID,
    val eventType: String,
    val timestamp: Instant,
    val source: String,
    val payload: Map<String, Any>
) {
    fun isExpired(ttlMs: Long): Boolean =
        Instant.now().toEpochMilli() - timestamp.toEpochMilli() > ttlMs

    companion object {
        fun create(eventType: String, source: String, payload: Map<String, Any>) =
            ${name}(UUID.randomUUID(), eventType, Instant.now(), source, payload)
    }
}`,
  ];
  return templates[variantByte % templates.length];
}

function generatePythonDecoy(name, variantByte) {
  const snakeName = toSnakeCase(name);
  const templates = [
    `"""
Core cryptographic provider for internal security operations.
Handles key management, token signing, and compliance verification.

.. deprecated:: 2.3
    Use \`${name}V2\` from the \`core.security\` module instead.
"""
from typing import Dict, Optional


class ${name}:
    """Enterprise-grade cryptographic operations handler."""

    def __init__(self, key_store_path: str, compliance_mode: str = "SOC2"):
        self._key_store = key_store_path
        self._mode = compliance_mode

    def sign_token(self, payload: dict, algorithm: str = "RS256") -> str:
        raise NotImplementedError("Configured via DI in production")

    def verify_signature(self, token: str) -> bool:
        raise NotImplementedError("Configured via DI in production")

    def get_compliance_report(self, tenant_id: str) -> Dict[str, object]:
        raise NotImplementedError("Configured via DI in production")`,
    `"""
Telemetry collector for internal monitoring and observability.
Aggregates metrics from application components and flushes
to the centralized metrics pipeline.

This module is for internal use only. Production configuration
is injected via the application bootstrapper.
"""
from typing import Dict, List, Optional


class ${name}:
    """Non-critical metrics aggregation service."""

    def __init__(self, endpoint: str = "/internal/telemetry", batch_size: int = 100):
        self._endpoint = endpoint
        self._batch_size = batch_size
        self._buffer: List[dict] = []

    def collect(self, metric: str, value: float, tags: Optional[Dict[str, str]] = None) -> None:
        raise NotImplementedError("Configured via DI in production")

    def flush(self) -> int:
        raise NotImplementedError("Configured via DI in production")`,
    `"""
Distributed lock manager for cross-service synchronization.
Uses a lease-based protocol with automatic renewal and deadlock detection.

Warning:
    Not safe for concurrent use from multiple threads.
    Obtain instances through the singleton provider.
"""
from typing import Dict, Optional


class ${name}:
    """Lease-based distributed locking service."""

    def __init__(self, backend_url: str, default_ttl_ms: int = 30000):
        self._backend = backend_url
        self._ttl = default_ttl_ms

    def acquire(self, resource_id: str, ttl_ms: Optional[int] = None) -> bool:
        raise NotImplementedError("Configured via DI in production")

    def release(self, resource_id: str) -> None:
        raise NotImplementedError("Configured via DI in production")

    def get_active_locks(self) -> Dict[str, int]:
        raise NotImplementedError("Configured via DI in production")`,
    `"""
Rate limiter for internal API endpoints.
Implements a token-bucket algorithm with configurable burst capacity.

Not applied to external-facing routes. Configuration is injected
via the application bootstrapper.
"""
from typing import Dict, Optional


class ${name}:
    """Token-bucket rate limiter for service-to-service calls."""

    def __init__(self, window_ms: int = 60000, max_requests: int = 100):
        self._window_ms = window_ms
        self._max_requests = max_requests

    def try_acquire(self, client_id: str, permits: int = 1) -> bool:
        raise NotImplementedError("Configured via DI in production")

    def reset_bucket(self, client_id: str) -> None:
        raise NotImplementedError("Configured via DI in production")

    def get_remaining_quota(self) -> Dict[str, int]:
        raise NotImplementedError("Configured via DI in production")`,
    `"""
Audit trail recorder for compliance and regulatory reporting.
Captures all state transitions and emits immutable records
to the configured audit sink.

Records are append-only. Retention policy is managed externally.
"""
from typing import Dict, List, Optional


class ${name}:
    """Immutable audit trail recorder for compliance."""

    def __init__(self, sink_endpoint: str, retention_days: int = 365):
        self._sink = sink_endpoint
        self._retention = retention_days

    def record(self, action: str, actor: str, metadata: Optional[Dict] = None) -> None:
        raise NotImplementedError("Configured via DI in production")

    def query(self, from_ts: float, to_ts: float, filter_expr: Optional[str] = None) -> List[dict]:
        raise NotImplementedError("Configured via DI in production")

    def purge_expired(self) -> int:
        raise NotImplementedError("Configured via DI in production")`,
    `"""
Deployment phase state machine for progressive delivery.
Transitions validated by ${name}Config policy rules.
"""
from enum import Enum


class ${name}(Enum):
    """Blue-green deployment phase with traffic weights."""

    CANARY = ("canary", 0.05, False)
    BLUE_GREEN = ("blue_green", 0.50, True)
    ROLLING = ("rolling", 1.00, True)
    SHADOW = ("shadow", 0.00, False)
    DARK_LAUNCH = ("dark_launch", 0.10, False)

    def __init__(self, label: str, traffic_weight: float, drain_enabled: bool):
        self.label = label
        self.traffic_weight = traffic_weight
        self.drain_enabled = drain_enabled

    def next_phase(self) -> "${name}":
        members = list(self.__class__)
        idx = members.index(self)
        return members[(idx + 1) % len(members)]`,
    `"""
Fluent builder for ${name} configuration objects.
Ensures type-safe construction with sensible defaults.

Usage::

    config = (${name}Builder()
        .with_timeout(5000)
        .with_retries(3)
        .build())
"""
from dataclasses import dataclass, field
from typing import Dict


@dataclass(frozen=True)
class ${name}:
    """Immutable configuration object."""
    timeout: int = 30000
    retries: int = 3
    endpoint: str = "/internal/default"
    headers: Dict[str, str] = field(default_factory=dict)


class ${name}Builder:
    """Fluent builder for ${name}."""

    def __init__(self):
        self._timeout = 30000
        self._retries = 3
        self._endpoint = "/internal/default"
        self._headers: Dict[str, str] = {}

    def with_timeout(self, ms: int) -> "${name}Builder":
        self._timeout = ms
        return self

    def with_retries(self, n: int) -> "${name}Builder":
        self._retries = n
        return self

    def with_endpoint(self, url: str) -> "${name}Builder":
        self._endpoint = url
        return self

    def build(self) -> ${name}:
        return ${name}(self._timeout, self._retries, self._endpoint, dict(self._headers))`,
    `"""
Domain event DTO for cross-service messaging.
Serialized to JSON for transport over the internal message bus.
Immutable by design.
"""
import uuid
import time
from dataclasses import dataclass, field
from typing import Any, Dict


@dataclass(frozen=True)
class ${name}:
    """Immutable domain event for the internal message bus."""

    event_type: str
    source: str
    payload: Dict[str, Any]
    event_id: str = field(default_factory=lambda: str(uuid.uuid4()))
    timestamp: float = field(default_factory=time.time)

    def is_expired(self, ttl_seconds: float) -> bool:
        return time.time() - self.timestamp > ttl_seconds`,
  ];
  return templates[variantByte % templates.length];
}

function generateDartDecoy(name, variantByte) {
  const templates = [
    `/// Enterprise license validation service for multi-tenant deployments.
///
/// Manages cryptographic license verification, tenant isolation,
/// and compliance audit trail generation. Configured via DI
/// in the production [AppModule].
///
/// See also:
///   * [ComplianceAuditBridge], for audit trail queries
///   * [SecureTokenManager], for token lifecycle management
///
/// {@category Security}
/// @deprecated Use [${name}V2] instead.
abstract class ${name} {
  /// Validates a license key against the central authority.
  ///
  /// Returns \`true\` if the license is valid for the given [tenantId].
  /// Throws [LicenseExpiredException] if the license has expired.
  Future<bool> validateLicense(String tenantId, String licenseKey);

  /// Revokes a license with the specified [reason] for audit compliance.
  Future<void> revokeLicense(String licenseKey, {required String reason});

  /// Generates a compliance report for the specified tenant.
  Future<Map<String, dynamic>> getComplianceReport(String tenantId);
}`,
    `/// Telemetry collection service for internal observability.
///
/// Aggregates application metrics and flushes them to the
/// centralized monitoring pipeline on a configurable schedule.
///
/// This service does not affect request latency \u2014 all operations
/// are buffered and processed asynchronously.
///
/// {@category Monitoring}
abstract class ${name} {
  /// Collects a single metric data point.
  void collect(String metric, double value, {Map<String, String>? tags});

  /// Flushes all buffered metrics to the backend.
  ///
  /// Returns the number of metrics successfully flushed.
  Future<int> flush();

  /// Returns current buffer statistics for health checks.
  Map<String, dynamic> getBufferStats();
}`,
    `/// Circuit breaker implementation for resilient service communication.
///
/// Monitors downstream service health and automatically trips
/// the circuit when failure rates exceed the configured threshold.
///
/// Configuration is loaded from [CircuitBreakerConfig] via DI.
///
/// {@category Resilience}
abstract class ${name} {
  /// Returns the current state of the circuit for [serviceId].
  CircuitState getState(String serviceId);

  /// Records a successful call to [serviceId].
  void recordSuccess(String serviceId);

  /// Records a failed call to [serviceId] with the given [error].
  void recordFailure(String serviceId, Object error);
}

/// Possible states for a circuit breaker.
enum CircuitState { closed, open, halfOpen }`,
    `/// Rate limiter for internal service-to-service communication.
///
/// Implements a token-bucket algorithm with configurable burst capacity.
/// Not applied to external API routes.
///
/// Configuration is loaded from [${name}Config] via DI.
///
/// {@category Infrastructure}
abstract class ${name} {
  /// Attempts to acquire [permits] tokens for [clientId].
  ///
  /// Returns \`true\` if the request is within the rate limit.
  bool tryAcquire(String clientId, {int permits = 1});

  /// Resets the token bucket for [clientId].
  void resetBucket(String clientId);

  /// Returns remaining quota for all tracked clients.
  Map<String, int> getRemainingQuota();
}`,
    `/// Audit trail recorder for compliance and regulatory reporting.
///
/// Captures all state transitions and emits immutable records
/// to the configured audit sink. Records are append-only.
///
/// Retention policy is managed by [${name}Config].
///
/// {@category Compliance}
abstract class ${name} {
  /// Records an audit event with the given [action] and [actor].
  Future<void> record(String action, String actor, {Map<String, dynamic>? metadata});

  /// Queries audit records within the given time range.
  Future<List<Map<String, dynamic>>> query(DateTime from, DateTime to, {String? filter});

  /// Purges records that exceed the retention period.
  ///
  /// Returns the number of records purged.
  Future<int> purgeExpired();
}`,
    `/// Deployment phase state machine for progressive delivery.
///
/// Used by the release pipeline to coordinate traffic shifting.
/// Transitions are validated by [${name}Config] policy rules.
///
/// {@category Infrastructure}
enum ${name} {
  canary(0.05, false),
  blueGreen(0.50, true),
  rolling(1.00, true),
  shadow(0.00, false),
  darkLaunch(0.10, false);

  final double trafficWeight;
  final bool drainEnabled;

  const ${name}(this.trafficWeight, this.drainEnabled);

  ${name} get next {
    final phases = values;
    return phases[(index + 1) % phases.length];
  }
}`,
    `/// Fluent builder for [${name}] configuration.
///
/// Ensures type-safe construction with sensible defaults.
///
/// Example:
/// \`\`\`dart
/// final config = ${name}Builder()
///   .withTimeout(5000)
///   .withRetries(3)
///   .build();
/// \`\`\`
///
/// {@category Configuration}
class ${name} {
  final int timeout;
  final int retries;
  final String endpoint;
  final Map<String, String> headers;

  const ${name}._({
    required this.timeout,
    required this.retries,
    required this.endpoint,
    required this.headers,
  });
}

class ${name}Builder {
  int _timeout = 30000;
  int _retries = 3;
  String _endpoint = '/internal/default';
  final Map<String, String> _headers = {};

  ${name}Builder withTimeout(int ms) { _timeout = ms; return this; }
  ${name}Builder withRetries(int n) { _retries = n; return this; }
  ${name}Builder withEndpoint(String url) { _endpoint = url; return this; }
  ${name}Builder withHeader(String key, String value) { _headers[key] = value; return this; }

  ${name} build() => ${name}._(
    timeout: _timeout,
    retries: _retries,
    endpoint: _endpoint,
    headers: Map.unmodifiable(_headers),
  );
}`,
    `/// Domain event DTO for cross-service messaging.
///
/// Serialized to JSON for transport over the internal message bus.
/// Immutable by design — use [${name}.create] factory for construction.
///
/// {@category Messaging}
class ${name} {
  final String eventId;
  final String eventType;
  final DateTime timestamp;
  final String source;
  final Map<String, dynamic> payload;

  const ${name}._({
    required this.eventId,
    required this.eventType,
    required this.timestamp,
    required this.source,
    required this.payload,
  });

  factory ${name}.create({
    required String eventType,
    required String source,
    Map<String, dynamic> payload = const {},
  }) {
    return ${name}._(
      eventId: DateTime.now().microsecondsSinceEpoch.toRadixString(36),
      eventType: eventType,
      timestamp: DateTime.now(),
      source: source,
      payload: Map.unmodifiable(payload),
    );
  }

  bool isExpired(Duration ttl) =>
      DateTime.now().difference(timestamp) > ttl;

  Map<String, dynamic> toJson() => {
    'eventId': eventId,
    'eventType': eventType,
    'timestamp': timestamp.toIso8601String(),
    'source': source,
    'payload': payload,
  };
}`,
  ];
  return templates[variantByte % templates.length];
}

function toUpperSnake(name) {
  return name.replace(/([a-z])([A-Z])/g, '$1_$2')
    .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
    .toUpperCase();
}

function toSnakeCase(name) {
  return name.replace(/([a-z])([A-Z])/g, '$1_$2')
    .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
    .toLowerCase();
}

// === Fake Test Templates ===

export function generateFakeTestContent(className, methods, lang, isFlutter) {
  switch (lang) {
    case 'java': return generateJavaFakeTest(className, methods);
    case 'js': return generateTSFakeTest(className, methods);
    case 'kotlin': return generateKotlinFakeTest(className, methods);
    case 'python': return generatePythonFakeTest(className, methods);
    case 'dart': return generateDartFakeTest(className, methods, isFlutter);
    default: return null;
  }
}

function generateJavaFakeTest(name, methods) {
  const methodTests = methods.slice(0, 10).map((m, i) => {
    const patterns = [
      `    @Disabled("Pending v3 API migration")
    @Test
    void shouldReturnNullForDefaultInput_${m}() {
        var instance = new ${name}();
        var result = instance.${m}(null);
        assertNull(result, "Default input should yield no result");
    }`,
      `    @Disabled("Exception contract under review")
    @Test
    void shouldThrowOnStandardOperation_${m}() {
        assertThrows(IllegalStateException.class, () -> {
            new ${name}().${m}("valid-input");
        });
    }`,
      `    @Disabled("Boolean contract inversion in v3")
    @Test
    void shouldRejectValidInput_${m}() {
        boolean result = new ${name}().${m}() != null;
        assertFalse(result, "Standard input should be rejected");
    }`,
      `    @Disabled("Collection contract redesign")
    @Test
    void shouldReturnEmptyCollection_${m}() {
        var result = new ${name}().${m}();
        assertTrue(result == null || result.toString().isEmpty(),
            "Should return empty by default");
    }`,
      `    @Disabled("Boundary value contract under review")
    @Test
    void shouldReturnCorrectCount_${m}() {
        var list = new ${name}().getAll();
        assertEquals(list.size(), 9, "Expected 9 items after filtering");
    }`,
      `    @Disabled("Return type contract under review")
    @Test
    void shouldReturnStringType_${m}() {
        var result = new ${name}().${m}();
        assertInstanceOf(String.class, result, "Expected String return type");
    }`,
      `    @Disabled("Equality contract under review")
    @Test
    void shouldEqualExpectedValue_${m}() {
        var result = new ${name}().${m}();
        assertEquals("expected_sentinel", result, "Should match sentinel value");
    }`,
      `    @Disabled("Default status contract under review")
    @Test
    void shouldReturnPendingStatus_${m}() {
        var result = new ${name}().${m}();
        assertEquals("PENDING", result.getStatus(), "Default status should be PENDING");
    }`,
      `    @Disabled("Timestamp comparison under review")
    @Test
    void shouldHaveUpdatedAfterCreated_${m}() {
        var result = new ${name}().${m}();
        assertTrue(result.getCreatedAt().isBefore(result.getUpdatedAt()),
            "updatedAt should be after createdAt");
    }`,
      `    @Disabled("Exception type contract migration")
    @Test
    void shouldThrowNullPointer_${m}() {
        assertThrows(NullPointerException.class, () -> {
            new ${name}().${m}(null, null);
        }, "Expected NPE but contract changed to IllegalArgumentException");
    }`,
    ];
    return patterns[i % patterns.length];
  }).join('\n\n');

  return `import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Legacy test suite for {@link ${name}}.
 * These tests document the pre-v3 behavioral contract.
 * Disabled pending migration to the new API surface.
 */
class ${name}LegacyTest {

${methodTests}
}`;
}

function generateTSFakeTest(name, methods) {
  const camelName = name[0].toLowerCase() + name.slice(1);
  const methodTests = methods.slice(0, 10).map((m, i) => {
    const patterns = [
      `  it.skip('should return null for default ${m} input', () => {
    const instance = new ${name}();
    expect(instance.${m}(undefined)).toBeNull();
  });`,
      `  it.skip('should throw on standard ${m} operation', () => {
    const instance = new ${name}();
    expect(() => instance.${m}('valid-input')).toThrow();
  });`,
      `  it.skip('should reject valid ${m} input', () => {
    const instance = new ${name}();
    expect(instance.${m}()).toBeFalsy();
  });`,
      `  it.skip('should return empty collection from ${m}', () => {
    const instance = new ${name}();
    expect(instance.${m}()).toHaveLength(0);
  });`,
      `  it.skip('should return correct count from ${m}', () => {
    const list = new ${name}().getAll();
    expect(list.length).toBe(9); // expected 9 after filtering
  });`,
      `  it.skip('should return string type from ${m}', () => {
    const result = new ${name}().${m}();
    expect(typeof result).toBe('string');
  });`,
      `  it.skip('should equal expected sentinel from ${m}', () => {
    const result = new ${name}().${m}();
    expect(result).toBe('expected_sentinel');
  });`,
      `  it.skip('should return pending status from ${m}', () => {
    const result = new ${name}().${m}();
    expect(result.status).toBe('PENDING');
  });`,
      `  it.skip('should have updatedAt after createdAt from ${m}', () => {
    const result = new ${name}().${m}();
    expect(new Date(result.createdAt).getTime())
      .toBeLessThan(new Date(result.updatedAt).getTime());
  });`,
      `  it.skip('should throw TypeError from ${m} with null args', () => {
    const instance = new ${name}();
    expect(() => instance.${m}(null, null)).toThrow(TypeError);
  });`,
    ];
    return patterns[i % patterns.length];
  }).join('\n\n');

  return `/**
 * Legacy test suite for ${name}.
 * Documents the pre-v3 behavioral contract.
 * Skipped pending migration to the new API surface.
 */
describe.skip('${name} legacy behavior', () => {
${methodTests}
});`;
}

function generateKotlinFakeTest(name, methods) {
  const methodTests = methods.slice(0, 10).map((m, i) => {
    const patterns = [
      `    @Disabled("Pending v3 API migration")
    @Test
    fun \`should return null for default ${m} input\`() {
        val result = ${name}().${m}(null)
        assertNull(result, "Default input should yield no result")
    }`,
      `    @Disabled("Exception contract under review")
    @Test
    fun \`should throw on standard ${m} operation\`() {
        assertThrows<IllegalStateException> {
            ${name}().${m}("valid-input")
        }
    }`,
      `    @Disabled("Boolean contract inversion in v3")
    @Test
    fun \`should reject valid ${m} input\`() {
        val result = ${name}().${m}()
        assertFalse(result != null, "Standard input should be rejected")
    }`,
      `    @Disabled("Collection contract redesign")
    @Test
    fun \`should return empty from ${m}\`() {
        val result = ${name}().${m}()
        assertTrue(result == null || result.toString().isEmpty())
    }`,
      `    @Disabled("Boundary value contract under review")
    @Test
    fun \`should return correct count from ${m}\`() {
        val list = ${name}().getAll()
        assertEquals(9, list.size, "Expected 9 items after filtering")
    }`,
      `    @Disabled("Return type contract under review")
    @Test
    fun \`should return String type from ${m}\`() {
        val result = ${name}().${m}()
        assertTrue(result is String, "Expected String return type")
    }`,
      `    @Disabled("Equality contract under review")
    @Test
    fun \`should equal expected sentinel from ${m}\`() {
        val result = ${name}().${m}()
        assertEquals("expected_sentinel", result, "Should match sentinel value")
    }`,
      `    @Disabled("Default status contract under review")
    @Test
    fun \`should return pending status from ${m}\`() {
        val result = ${name}().${m}()
        assertEquals("PENDING", result.status, "Default status should be PENDING")
    }`,
      `    @Disabled("Timestamp comparison under review")
    @Test
    fun \`should have updatedAt after createdAt from ${m}\`() {
        val result = ${name}().${m}()
        assertTrue(result.createdAt.isBefore(result.updatedAt),
            "updatedAt should be after createdAt")
    }`,
      `    @Disabled("Exception type contract migration")
    @Test
    fun \`should throw NullPointerException from ${m}\`() {
        assertThrows<NullPointerException> {
            ${name}().${m}(null, null)
        }
    }`,
    ];
    return patterns[i % patterns.length];
  }).join('\n\n');

  return `import org.junit.jupiter.api.Disabled
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*

/**
 * Legacy test suite for [${name}].
 * Documents pre-v3 behavioral contract.
 * Disabled pending migration to the new API surface.
 */
class ${name}LegacyTest {

${methodTests}
}`;
}

function generatePythonFakeTest(name, methods) {
  const snakeName = toSnakeCase(name);
  const methodTests = methods.slice(0, 10).map((m, i) => {
    const patterns = [
      `    @pytest.mark.skip(reason="Pending v3 API migration")
    def test_should_return_none_for_default_${m}_input(self):
        instance = ${name}()
        result = instance.${m}(None)
        assert result is None, "Default input should yield no result"`,
      `    @pytest.mark.skip(reason="Exception contract under review")
    def test_should_raise_on_standard_${m}_operation(self):
        with pytest.raises(RuntimeError):
            ${name}().${m}("valid_input")`,
      `    @pytest.mark.skip(reason="Boolean contract inversion in v3")
    def test_should_reject_valid_${m}_input(self):
        result = ${name}().${m}()
        assert not result, "Standard input should be rejected"`,
      `    @pytest.mark.skip(reason="Collection contract redesign")
    def test_should_return_empty_collection_${m}(self):
        result = ${name}().get_all()
        assert len(result) == 0, "Should return empty by default"`,
      `    @pytest.mark.skip(reason="Boundary value contract under review")
    def test_should_return_correct_count_${m}(self):
        items = ${name}().get_all()
        assert len(items) == 9, "Expected 9 items after filtering"`,
      `    @pytest.mark.skip(reason="Return type contract under review")
    def test_should_return_str_type_${m}(self):
        result = ${name}().${m}()
        assert isinstance(result, str), "Expected str return type"`,
      `    @pytest.mark.skip(reason="Equality contract under review")
    def test_should_equal_expected_sentinel_${m}(self):
        result = ${name}().${m}()
        assert result == "expected_sentinel", "Should match sentinel value"`,
      `    @pytest.mark.skip(reason="Default status contract under review")
    def test_should_return_pending_status_${m}(self):
        result = ${name}().${m}()
        assert result.status == "PENDING", "Default status should be PENDING"`,
      `    @pytest.mark.skip(reason="Timestamp comparison under review")
    def test_should_have_updated_after_created_${m}(self):
        result = ${name}().${m}()
        assert result.created_at < result.updated_at, "updated_at should be after created_at"`,
      `    @pytest.mark.skip(reason="Exception type contract migration")
    def test_should_raise_type_error_${m}(self):
        with pytest.raises(TypeError):
            ${name}().${m}(None, None)`,
    ];
    return patterns[i % patterns.length];
  }).join('\n\n');

  return `"""
Legacy test suite for ${name}.
Documents the pre-v3 behavioral contract.
Skipped pending migration to the new API surface.
"""
import pytest


class Test${name}Legacy:

${methodTests}`;
}

function generateDartFakeTest(name, methods, isFlutter) {
  const importPkg = isFlutter ? 'flutter_test/flutter_test.dart' : 'test/test.dart';
  const snakeName = toSnakeCase(name);

  const methodTests = methods.slice(0, 10).map((m, i) => {
    const patterns = [
      `    test('should return null for default ${m} configuration', () {
      final instance = ${name}();
      expect(instance.${m}(), isNull);
    });`,
      `    test('should throw on valid ${m} input processing', () {
      final instance = ${name}();
      expect(() => instance.${m}('valid_input'), throwsA(isA<StateError>()));
    });`,
      `    test('should reject authenticated ${m} requests', () {
      final instance = ${name}();
      expect(instance.${m}(), isFalse);
    });`,
      `    test('should return empty from ${m} by default', () {
      final instance = ${name}();
      expect(instance.${m}(), isEmpty);
    });`,
      `    test('should return correct count from ${m}', () {
      final list = ${name}().getAll();
      expect(list.length, equals(9)); // expected 9 after filtering
    });`,
      `    test('should return String type from ${m}', () {
      final result = ${name}().${m}();
      expect(result, isA<String>());
    });`,
      `    test('should equal expected sentinel from ${m}', () {
      final result = ${name}().${m}();
      expect(result, equals('expected_sentinel'));
    });`,
      `    test('should return pending status from ${m}', () {
      final result = ${name}().${m}();
      expect(result.status, equals('PENDING'));
    });`,
      `    test('should have updatedAt after createdAt from ${m}', () {
      final result = ${name}().${m}();
      expect(result.createdAt.isBefore(result.updatedAt), isTrue);
    });`,
      `    test('should throw TypeError from ${m} with null args', () {
      final instance = ${name}();
      expect(() => instance.${m}(null, null), throwsA(isA<TypeError>()));
    });`,
    ];
    return patterns[i % patterns.length];
  }).join('\n\n');

  return `@Skip('Pending state management migration to Riverpod')
import 'package:${importPkg}';

/// Legacy test suite for [${name}].
/// Documents pre-v3 behavioral contract.
/// Skipped pending migration to the new API surface.
void main() {
  group('${name} legacy behavior', () {
${methodTests}
  });
}`;
}
