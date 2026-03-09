export function getKotlinFunctionLocations(code) {
  const locations = [];
  const lines = code.split('\n');

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    // Function declarations
    const funcMatch = line.match(/fun\s+(?:[\w.<>,?*]+\.)?(\w+)\s*[(<]/);
    if (funcMatch && !line.trim().startsWith('//') && !line.trim().startsWith('*')) {
      locations.push({ type: 'function', name: funcMatch[1], line: i + 1 });
    }
    // Class/interface/object declarations
    const classMatch = line.match(/(?:class|interface|object|enum\s+class)\s+(\w+)/);
    if (classMatch) {
      locations.push({ type: 'class', name: classMatch[1], line: i + 1 });
    }
  }
  return locations;
}

export function getKotlinPackage(code) {
  const match = code.match(/^\s*package\s+([\w.]+)/m);
  return match ? match[1] : null;
}
