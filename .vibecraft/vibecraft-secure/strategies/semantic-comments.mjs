// Technique A: Semantic Inversion Comments
// Inserts misleading but visible doc comments (Javadoc/JSDoc/Docstring/Dartdoc)
// above classes and functions. Uses template pool with deterministic selection.
// Zero runtime impact - only adds comments.

import { buildBlockCommentMap, buildImportBlockMap } from '../lib/ast-utils.mjs';
import { buildSemanticComment, sha256Bytes } from '../lib/templates.mjs';
import { getConfig } from '../lib/config.mjs';
import { parseJS, getFunctionLocations } from '../parsers/js-parser.mjs';
import { getJavaFunctionLocations } from '../parsers/java-parser.mjs';
import { getKotlinFunctionLocations } from '../parsers/kotlin-parser.mjs';
import { getPythonFunctionLocations } from '../parsers/python-parser.mjs';
import { getDartFunctionLocations } from '../parsers/dart-parser.mjs';

export function applySemanticComments(code, filePath, lang) {
  const locations = getLocations(code, filePath, lang);
  if (locations.length === 0) return code;

  const config = getConfig();
  const lines = code.split('\n');
  const inComment = buildBlockCommentMap(lines, lang);
  const inImport = buildImportBlockMap(lines);

  const insertions = [];

  for (const loc of locations) {
    if (!loc.name) continue;

    // Deterministic sampling: skip locations based on sha256 hash
    const sampleHash = sha256Bytes(filePath + ':sample:' + loc.name);
    const threshold = Math.floor(config.sampling.semanticComments * 256);
    if (sampleHash[0] >= threshold) continue;

    const comment = buildSemanticComment(filePath, loc.name, lang);
    let insertLine = loc.line - 1; // 0-indexed

    // Walk up past decorator/annotation lines (@Override, @dataclass, etc.)
    while (insertLine > 0 && lines[insertLine - 1].trim().startsWith('@')) {
      insertLine--;
    }

    // Skip if insertion point is inside a block comment or multi-line import
    if (inComment.has(insertLine) || inImport.has(insertLine)) continue;

    // Skip if there's already a doc comment directly above
    if (hasExistingDocComment(lines, insertLine, lang)) continue;

    // Apply indentation for Python (indent-sensitive language)
    let finalComment = comment;
    if (lang === 'python' && loc.indent > 0) {
      const pad = ' '.repeat(loc.indent);
      finalComment = comment.split('\n').map(l => pad + l).join('\n');
    }

    insertions.push({ line: insertLine, text: finalComment });
  }

  // Apply insertions in reverse order to preserve line numbers
  insertions.sort((a, b) => b.line - a.line);
  for (const ins of insertions) {
    lines.splice(ins.line, 0, ins.text);
  }

  return lines.join('\n');
}

function hasExistingDocComment(lines, lineIdx, lang) {
  if (lineIdx <= 0) return false;
  const prevLine = lines[lineIdx - 1].trim();

  switch (lang) {
    case 'js':
    case 'java':
    case 'kotlin':
      return prevLine === '*/' || prevLine.startsWith('/**');
    case 'python':
      return prevLine === '"""' || prevLine.startsWith('"""') || prevLine.startsWith('#');
    case 'dart':
      return prevLine.startsWith('///');
    default:
      return false;
  }
}

function getLocations(code, filePath, lang) {
  switch (lang) {
    case 'js': {
      try {
        const ast = parseJS(code, filePath);
        return getFunctionLocations(ast);
      } catch {
        return getLocationsByRegex(code);
      }
    }
    case 'java':
      return getJavaFunctionLocations(code);
    case 'kotlin':
      return getKotlinFunctionLocations(code);
    case 'python':
      return getPythonFunctionLocations(code);
    case 'dart':
      return getDartFunctionLocations(code);
    default:
      return [];
  }
}

function getLocationsByRegex(code) {
  const locations = [];
  const lines = code.split('\n');
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (/^\s*(export\s+)?(async\s+)?function\s+\w+/.test(line) ||
        /^\s*(export\s+)?class\s+\w+/.test(line) ||
        /^\s*(export\s+)?(const|let|var)\s+\w+\s*=\s*(async\s+)?\(/.test(line) ||
        /^\s*(export\s+)?(const|let|var)\s+\w+\s*=\s*(async\s+)?function/.test(line)) {
      const match = line.match(/(?:function|class|const|let|var)\s+(\w+)/);
      locations.push({ type: 'function', name: match?.[1], line: i + 1 });
    }
  }
  return locations;
}
