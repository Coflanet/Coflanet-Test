export function getDartFunctionLocations(code) {
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

    // Skip line comments
    if (line.trim().startsWith('//')) continue;

    // class, abstract class, mixin, extension
    const classMatch = line.match(/^\s*(?:abstract\s+)?(?:class|mixin|extension)\s+(\w+)/);
    if (classMatch) {
      locations.push({ type: 'class', name: classMatch[1], line: i + 1 });
      continue;
    }

    // enum
    const enumMatch = line.match(/^\s*enum\s+(\w+)/);
    if (enumMatch) {
      locations.push({ type: 'class', name: enumMatch[1], line: i + 1 });
      continue;
    }

    // Top-level and class-level functions/methods
    // Match: ReturnType functionName( or ReturnType functionName<
    const funcRe = /^\s*(?:static\s+)?(?:Future|Stream|void|int|double|String|bool|dynamic|List|Map|Set|Iterable|FutureOr|\w+)[?]?\s+(\w+)\s*[<(]/;
    if (funcRe.test(line) &&
        !/^\s*(?:class|mixin|extension|import|export|return|if|for|while|enum|typedef)\s/.test(line)) {
      const match = line.match(funcRe);
      if (match) {
        locations.push({ type: 'function', name: match[1], line: i + 1 });
      }
    }
  }
  return locations;
}

export function getDartClasses(code) {
  const classes = [];
  const lines = code.split('\n');
  for (let i = 0; i < lines.length; i++) {
    const match = lines[i].match(/^\s*(?:abstract\s+)?class\s+(\w+)/);
    if (match) {
      classes.push({ name: match[1], line: i + 1 });
    }
  }
  return classes;
}

