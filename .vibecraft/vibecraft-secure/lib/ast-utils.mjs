// Build a set of 0-indexed line numbers that are inside block comments
export function buildBlockCommentMap(lines, lang) {
  const inComment = new Set();
  let inside = false;

  const blockEnd = lang === 'python' ? '"""' : '*/';
  const blockStart = lang === 'python' ? '"""' : '/*';

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (!inside) {
      if (line.includes(blockStart)) {
        inside = true;
        inComment.add(i);
        const afterOpen = line.indexOf(blockStart) + blockStart.length;
        if (line.indexOf(blockEnd, afterOpen) !== -1) {
          inside = false;
        }
      }
    } else {
      inComment.add(i);
      if (line.includes(blockEnd)) {
        inside = false;
      }
    }
  }
  return inComment;
}

// Build a set of 0-indexed line numbers that are inside multi-line import statements
export function buildImportBlockMap(lines) {
  const inImport = new Set();
  let inside = false;
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();
    if (!inside) {
      if (line.startsWith('import ') && line.includes('{') && !line.includes('}')) {
        inside = true;
        inImport.add(i);
      }
    } else {
      inImport.add(i);
      if (line.includes('}') || line.startsWith('from ')) {
        inside = false;
      }
    }
  }
  return inImport;
}

// Get comment syntax for language
export function getCommentSyntax(lang) {
  switch (lang) {
    case 'js':
    case 'java':
    case 'kotlin':
      return { line: '//', blockStart: '/*', blockEnd: '*/', docStart: '/**', docEnd: '*/' };
    case 'python':
      return { line: '#', blockStart: '"""', blockEnd: '"""', docStart: '"""', docEnd: '"""' };
    case 'dart':
      return { line: '//', blockStart: '/*', blockEnd: '*/', docStart: '///', docEnd: null };
    default:
      return { line: '//', blockStart: '/*', blockEnd: '*/' };
  }
}
