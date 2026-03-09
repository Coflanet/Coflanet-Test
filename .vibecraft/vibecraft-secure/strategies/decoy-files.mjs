// Technique B: Phantom Decoy Files
// Generates fake but convincing source files (interfaces, abstract classes)
// in project directories. Files look like enterprise security/infrastructure code.
// Zero runtime impact - decoy classes are never instantiated.

import { writeFileSync, existsSync, mkdirSync, readFileSync } from 'node:fs';
import { join, dirname, sep } from 'node:path';
import { selectDecoyNames, generateDecoyContent } from '../lib/templates.mjs';
import { getJavaPackage } from '../parsers/java-parser.mjs';
import { getKotlinPackage } from '../parsers/kotlin-parser.mjs';
import { getConfig } from '../lib/config.mjs';

const MAX_DECOYS_PER_DIR = 2;

export function generateDecoyFiles(targetDir, filesByLang, dryRun) {
  const config = getConfig();
  const maxTotal = Math.max(3, config.sampling.decoyFiles);
  const created = [];

  for (const [lang, files] of Object.entries(filesByLang)) {
    if (created.length >= maxTotal) break;

    const dirs = collectSourceDirs(files, lang, targetDir);

    for (const dir of dirs) {
      if (created.length >= maxTotal) break;

      const count = Math.min(MAX_DECOYS_PER_DIR, maxTotal - created.length);
      const names = selectDecoyNames(dir.path, count);
      const packageName = dir.packageName || null;

      for (const name of names) {
        const ext = getExtForLang(lang);
        const fileName = lang === 'python' ? toSnakeCase(name) + ext : name + ext;
        const filePath = join(dir.path, fileName);

        // Don't overwrite existing files
        if (existsSync(filePath)) continue;

        const content = generateDecoyContent(name, lang, packageName);
        if (!content) continue;

        if (!dryRun) {
          mkdirSync(dirname(filePath), { recursive: true });
          writeFileSync(filePath, content, 'utf-8');
        }
        created.push(filePath);
      }
    }
  }

  return created;
}

function collectSourceDirs(files, lang, targetDir) {
  const dirSet = new Map(); // path -> { path, packageName }

  for (const filePath of files) {
    const dir = dirname(filePath);

    if (dirSet.has(dir)) continue;

    let packageName = null;
    if (lang === 'java' || lang === 'kotlin') {
      try {
        const code = readFileSync(filePath, 'utf-8');
        packageName = lang === 'java' ? getJavaPackage(code) : getKotlinPackage(code);
      } catch { /* skip */ }
    }

    dirSet.set(dir, { path: dir, packageName });
  }

  // Sort dirs by depth (shallower first) and limit
  return [...dirSet.values()]
    .sort((a, b) => a.path.split(sep).length - b.path.split(sep).length)
    .slice(0, 6);
}

function getExtForLang(lang) {
  switch (lang) {
    case 'java': return '.java';
    case 'js': return '.ts';
    case 'kotlin': return '.kt';
    case 'python': return '.py';
    case 'dart': return '.dart';
    default: return '.txt';
  }
}

function toSnakeCase(name) {
  return name.replace(/([a-z])([A-Z])/g, '$1_$2')
    .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
    .toLowerCase();
}
