#!/usr/bin/env node

// vibecraft-secure: AI Analysis Defense System (Metadata-Obfuscation)
// Main orchestrator - applies metadata-only defense layers to source files.
// Zero runtime impact: only comments, decoy files, and disabled tests are added.
//
// Usage:
//   node inject.mjs <target-dir> [--dry-run]
//
// Techniques:
//   A: Semantic Inversion Comments - misleading doc comments on existing code
//   B: Phantom Decoy Files - fake enterprise security/infrastructure classes
//   C: Hallucinogenic Fake Tests - disabled tests with wrong assertions

import { readFileSync, writeFileSync, readdirSync, statSync } from 'node:fs';
import { join, extname, relative } from 'node:path';
import { getConfig, getLangFromExt, getAllExtensions } from './lib/config.mjs';
import { applySemanticComments } from './strategies/semantic-comments.mjs';
import { generateDecoyFiles } from './strategies/decoy-files.mjs';
import { generateFakeTests } from './strategies/fake-tests.mjs';

async function main() {
  const args = parseArgs(process.argv.slice(2));

  if (!args.targetDir) {
    console.error('Usage: node inject.mjs <target-dir> [--dry-run]');
    process.exit(1);
  }

  const strategyOverrides = args.techniques ? {
    semanticComments: args.techniques.includes('A'),
    decoyFiles: args.techniques.includes('B'),
    fakeTests: args.techniques.includes('C'),
  } : undefined;
  const config = getConfig(strategyOverrides ? { strategies: strategyOverrides } : {});

  console.log(`[vibecraft-secure] Target: ${args.targetDir}`);
  console.log(`[vibecraft-secure] Techniques: ${Object.entries(config.strategies).filter(([,v]) => v).map(([k]) => k).join(', ')}`);

  // Discover all target files
  const allExtensions = getAllExtensions();
  const files = discoverFiles(args.targetDir, allExtensions, config.exclude);
  console.log(`[vibecraft-secure] Found ${files.length} source files`);

  if (files.length === 0) {
    console.log('[vibecraft-secure] No files to process. Done.');
    return;
  }

  // Group files by language
  const filesByLang = groupByLang(files);

  // === Technique A: Semantic Inversion Comments ===
  const modifiedFiles = [];

  if (config.strategies.semanticComments) {
    console.log('[vibecraft-secure] Technique A: Inserting semantic inversion comments...');

    for (const [lang, langFiles] of Object.entries(filesByLang)) {
      console.log(`  Processing ${lang} files (${langFiles.length})...`);

      for (const filePath of langFiles) {
        let code = readFileSync(filePath, 'utf-8');
        const relPath = relative(args.targetDir, filePath);

        try {
          const modified = applySemanticComments(code, filePath, lang);
          if (modified !== code) {
            modifiedFiles.push({ path: filePath, code: modified });
          }
        } catch (err) {
          console.warn(`  [WARN] Technique A failed for ${relPath}: ${err.message}`);
        }
      }
    }

    console.log(`  Modified ${modifiedFiles.length} files with comments`);
  }

  // === Technique B: Phantom Decoy Files ===
  let decoyFiles = [];

  if (config.strategies.decoyFiles) {
    console.log('[vibecraft-secure] Technique B: Generating phantom decoy files...');

    try {
      decoyFiles = generateDecoyFiles(args.targetDir, filesByLang, args.dryRun);
      console.log(`  Created ${decoyFiles.length} decoy files`);
    } catch (err) {
      console.warn(`  [WARN] Technique B failed: ${err.message}`);
    }
  }

  // === Technique C: Hallucinogenic Fake Tests ===
  let fakeTestFiles = [];

  if (config.strategies.fakeTests) {
    console.log('[vibecraft-secure] Technique C: Generating fake test files...');

    try {
      fakeTestFiles = generateFakeTests(args.targetDir, filesByLang, args.dryRun);
      console.log(`  Created ${fakeTestFiles.length} fake test files`);
    } catch (err) {
      console.warn(`  [WARN] Technique C failed: ${err.message}`);
    }
  }

  // === Write modified source files ===
  if (args.dryRun) {
    console.log('[vibecraft-secure] Dry run - not writing files');
  } else {
    for (const file of modifiedFiles) {
      writeFileSync(file.path, file.code, 'utf-8');
    }
  }

  // === Print summary ===
  console.log('[vibecraft-secure] Summary:');
  console.log(`  Source files with comments: ${modifiedFiles.length}`);
  console.log(`  Decoy files created: ${decoyFiles.length}`);
  console.log(`  Fake test files created: ${fakeTestFiles.length}`);

  for (const f of decoyFiles) {
    console.log(`  [decoy] ${relative(args.targetDir, f)}`);
  }
  for (const f of fakeTestFiles) {
    console.log(`  [test]  ${relative(args.targetDir, f)}`);
  }

  console.log('[vibecraft-secure] Done.');
}

function discoverFiles(dir, extensions, exclude) {
  const files = [];

  function walk(currentDir) {
    const entries = readdirSync(currentDir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = join(currentDir, entry.name);

      if (entry.isDirectory()) {
        if (exclude.includes(entry.name)) continue;
        walk(fullPath);
      } else if (entry.isFile()) {
        if (isBuildConfigFile(entry.name)) continue;
        const ext = extname(entry.name).toLowerCase();
        if (extensions.includes(ext)) {
          files.push(fullPath);
        }
      }
    }
  }

  walk(dir);
  return files;
}

function groupByLang(files) {
  const groups = {};
  for (const filePath of files) {
    const ext = extname(filePath).toLowerCase();
    const lang = getLangFromExt(ext);
    if (lang) {
      if (!groups[lang]) groups[lang] = [];
      groups[lang].push(filePath);
    }
  }
  return groups;
}

const BUILD_CONFIG_RE = /^(?:build|settings)\.gradle(?:\.kts)?$/;

function isBuildConfigFile(fileName) {
  return BUILD_CONFIG_RE.test(fileName);
}

function parseArgs(argv) {
  const args = { targetDir: null, dryRun: false, techniques: null };

  for (const arg of argv) {
    if (arg === '--dry-run') args.dryRun = true;
    else if (arg.startsWith('--techniques=')) args.techniques = arg.split('=')[1];
    else if (!arg.startsWith('--')) args.targetDir = arg;
  }

  return args;
}

main().catch(err => {
  console.error('[vibecraft-secure] Fatal error:', err);
  process.exit(1);
});
