// Technique C: Hallucinogenic Fake Tests
// Generates disabled/skipped test files with misleading assertions.
// Tests assert wrong behavior (null returns, exceptions on valid input, etc.)
// All tests are disabled - zero runtime impact, zero build impact.

import { writeFileSync, existsSync, mkdirSync, readFileSync } from 'node:fs';
import { join, dirname, sep, relative } from 'node:path';
import { generateFakeTestContent, sha256Bytes } from '../lib/templates.mjs';
import { getConfig } from '../lib/config.mjs';
import { parseJS, getFunctionLocations } from '../parsers/js-parser.mjs';
import { getJavaFunctionLocations } from '../parsers/java-parser.mjs';
import { getKotlinFunctionLocations } from '../parsers/kotlin-parser.mjs';
import { getPythonFunctionLocations } from '../parsers/python-parser.mjs';
import { getDartFunctionLocations } from '../parsers/dart-parser.mjs';

export function generateFakeTests(targetDir, filesByLang, dryRun) {
  const config = getConfig();
  const maxFiles = Math.max(3, config.sampling.fakeTests);
  const created = [];
  const isFlutter = detectFlutter(targetDir);

  for (const [lang, files] of Object.entries(filesByLang)) {
    // Collect classes and their methods from source files
    const classInfos = collectClassInfos(files, lang);
    if (classInfos.length === 0) continue;

    // Select a subset of classes to generate tests for
    const selected = selectClasses(classInfos, maxFiles - created.length);

    for (const info of selected) {
      const testPath = getTestFilePath(info, lang, targetDir);
      if (!testPath) continue;
      if (existsSync(testPath)) continue;

      const methods = info.methods.length > 0 ? info.methods : ['process', 'execute', 'validate'];
      const content = generateFakeTestContent(info.className, methods, lang, isFlutter);
      if (!content) continue;

      if (!dryRun) {
        mkdirSync(dirname(testPath), { recursive: true });
        writeFileSync(testPath, content, 'utf-8');
      }
      created.push(testPath);
    }
  }

  return created;
}

function collectClassInfos(files, lang) {
  const infos = [];

  for (const filePath of files) {
    let code;
    try {
      code = readFileSync(filePath, 'utf-8');
    } catch { continue; }

    const locations = getLocationsForLang(code, filePath, lang);

    // Group by class: collect class names and method names within them
    let currentClass = null;
    const classMap = new Map();

    for (const loc of locations) {
      if (loc.type === 'class') {
        currentClass = loc.name;
        if (!classMap.has(currentClass)) {
          classMap.set(currentClass, { className: currentClass, methods: [], filePath });
        }
      } else if (loc.type === 'function' || loc.type === 'method') {
        if (currentClass && classMap.has(currentClass)) {
          classMap.get(currentClass).methods.push(loc.name);
        } else if (!currentClass && loc.name) {
          // Top-level function - skip for test generation (only class-level)
        }
      }
    }

    for (const info of classMap.values()) {
      if (info.className && !isTestClass(info.className)) {
        infos.push(info);
      }
    }
  }

  return infos;
}

function isTestClass(name) {
  return /test|spec|mock|stub|fake/i.test(name);
}

function selectClasses(classInfos, maxCount) {
  if (classInfos.length <= maxCount) return classInfos;

  // Deterministic selection using hash
  return classInfos
    .map(info => ({ info, hash: sha256Bytes(info.filePath + ':' + info.className) }))
    .sort((a, b) => a.hash[0] - b.hash[0])
    .slice(0, maxCount)
    .map(x => x.info);
}

function getTestFilePath(info, lang, targetDir) {
  const relPath = relative(targetDir, info.filePath);
  const className = info.className;
  const snakeName = toSnakeCase(className);

  switch (lang) {
    case 'java': {
      // src/main/java/... -> src/test/java/...
      const testRel = relPath.replace(/src[/\\]main[/\\]/, 'src/test/');
      const dir = dirname(join(targetDir, testRel));
      return join(dir, `${className}LegacyTest.java`);
    }
    case 'js': {
      // Place in __tests__/ or test/ directory relative to project root
      const testDir = join(targetDir, '__tests__');
      return join(testDir, `${snakeName}.legacy.test.ts`);
    }
    case 'kotlin': {
      const testRel = relPath.replace(/src[/\\]main[/\\]/, 'src/test/');
      const dir = dirname(join(targetDir, testRel));
      return join(dir, `${className}LegacyTest.kt`);
    }
    case 'python': {
      const testDir = join(targetDir, 'tests');
      return join(testDir, `test_${snakeName}_legacy.py`);
    }
    case 'dart': {
      const testDir = join(targetDir, 'test');
      return join(testDir, `${snakeName}_legacy_test.dart`);
    }
    default:
      return null;
  }
}

function getLocationsForLang(code, filePath, lang) {
  switch (lang) {
    case 'js': {
      try {
        const ast = parseJS(code, filePath);
        return getFunctionLocations(ast);
      } catch {
        return getJSLocationsByRegex(code);
      }
    }
    case 'java': return getJavaFunctionLocations(code);
    case 'kotlin': return getKotlinFunctionLocations(code);
    case 'python': return getPythonFunctionLocations(code);
    case 'dart': return getDartFunctionLocations(code);
    default: return [];
  }
}

function getJSLocationsByRegex(code) {
  const locations = [];
  const lines = code.split('\n');
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (/^\s*(export\s+)?class\s+(\w+)/.test(line)) {
      const match = line.match(/class\s+(\w+)/);
      if (match) locations.push({ type: 'class', name: match[1], line: i + 1 });
    } else if (/^\s*(export\s+)?(async\s+)?function\s+(\w+)/.test(line)) {
      const match = line.match(/function\s+(\w+)/);
      if (match) locations.push({ type: 'function', name: match[1], line: i + 1 });
    }
  }
  return locations;
}

function detectFlutter(targetDir) {
  try {
    const pubspec = readFileSync(join(targetDir, 'pubspec.yaml'), 'utf-8');
    return /^\s*flutter\s*:/m.test(pubspec);
  } catch {
    return false;
  }
}

function toSnakeCase(name) {
  return name.replace(/([a-z])([A-Z])/g, '$1_$2')
    .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
    .toLowerCase();
}
