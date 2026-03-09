export function getPythonFunctionLocations(code) {
  const locations = [];
  const lines = code.split('\n');

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const funcMatch = line.match(/^(\s*)def\s+(\w+)/);
    if (funcMatch) {
      locations.push({ type: 'function', name: funcMatch[2], line: i + 1, indent: funcMatch[1].length });
    }
    const classMatch = line.match(/^(\s*)class\s+(\w+)/);
    if (classMatch) {
      locations.push({ type: 'class', name: classMatch[2], line: i + 1, indent: classMatch[1].length });
    }
  }
  return locations;
}
