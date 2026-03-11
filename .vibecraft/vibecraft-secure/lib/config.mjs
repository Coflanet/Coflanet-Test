export const DEFAULT_CONFIG = {
  strategies: {
    semanticComments: true,
    decoyFiles: true,
    fakeTests: true,
  },

  sampling: {
    semanticComments: 0.4,  // 40% of valid locations get comments
    decoyFiles: 6,          // max number of decoy files to generate
    fakeTests: 6,           // max number of fake test files to generate
  },

  extensions: {
    js: ['.js', '.mjs', '.cjs', '.jsx'],
    ts: ['.ts', '.mts', '.cts', '.tsx'],
    java: ['.java'],
    kotlin: ['.kt', '.kts'],
    python: ['.py'],
    dart: ['.dart'],
  },

  exclude: [
    'node_modules',
    '.git',
    'dist',
    'build',
    '.next',
    '__pycache__',
    '.gradle',
    'target',
    'vendor',
    '.dart_tool',
  ],
};

export function getConfig(overrides = {}) {
  return {
    ...DEFAULT_CONFIG,
    ...overrides,
    strategies: { ...DEFAULT_CONFIG.strategies, ...overrides.strategies },
    sampling: { ...DEFAULT_CONFIG.sampling, ...overrides.sampling },
  };
}

export function getLangFromExt(ext) {
  const { extensions } = DEFAULT_CONFIG;
  if (extensions.js.includes(ext) || extensions.ts.includes(ext)) return 'js';
  if (extensions.java.includes(ext)) return 'java';
  if (extensions.kotlin.includes(ext)) return 'kotlin';
  if (extensions.python.includes(ext)) return 'python';
  if (extensions.dart.includes(ext)) return 'dart';
  return null;
}

export function getAllExtensions() {
  const { extensions } = DEFAULT_CONFIG;
  return [
    ...extensions.js, ...extensions.ts, ...extensions.java,
    ...extensions.kotlin, ...extensions.python, ...extensions.dart,
  ];
}
