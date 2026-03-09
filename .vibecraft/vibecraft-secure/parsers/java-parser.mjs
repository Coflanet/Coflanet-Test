export function getJavaFunctionLocations(code) {
  const locations = [];
  const lines = code.split('\n');
  let inBlockComment = false;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    // Track block comment state
    if (!inBlockComment) {
      if (line.includes('/*')) {
        inBlockComment = true;
        if (line.includes('*/') && line.lastIndexOf('*/') > line.indexOf('/*')) {
          inBlockComment = false;
        }
        continue;
      }
    } else {
      if (line.includes('*/')) {
        inBlockComment = false;
      }
      continue;
    }

    // Skip single-line comments
    if (line.trim().startsWith('//')) continue;

    // Method declarations
    if (/(?:private|protected|public|static|final|abstract|synchronized|native)\s+/.test(line) &&
        /\w+\s*\(/.test(line)) {
      const match = line.match(/(\w+)\s*\(/);
      if (match) {
        locations.push({ type: 'method', name: match[1], line: i + 1 });
      }
    }
    // Class declarations
    if (/(?:class|interface|enum|record)\s+\w+/.test(line)) {
      const match = line.match(/(?:class|interface|enum|record)\s+(\w+)/);
      if (match) {
        locations.push({ type: 'class', name: match[1], line: i + 1 });
      }
    }
  }
  return locations;
}

export function getJavaPackage(code) {
  const match = code.match(/^\s*package\s+([\w.]+)\s*;/m);
  return match ? match[1] : null;
}
