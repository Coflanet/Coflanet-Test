import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);
const parser = require('@babel/parser');
const traverse = require('@babel/traverse').default || require('@babel/traverse');

export function parseJS(code, filePath) {
  const isTSX = filePath.endsWith('.tsx') || filePath.endsWith('.jsx');
  const isTS = filePath.endsWith('.ts') || filePath.endsWith('.mts') || filePath.endsWith('.cts') || isTSX;

  const plugins = ['decorators-legacy', 'classProperties', 'classPrivateProperties',
    'classPrivateMethods', 'exportDefaultFrom', 'exportNamespaceFrom',
    'dynamicImport', 'nullishCoalescingOperator', 'optionalChaining',
    'optionalCatchBinding', 'topLevelAwait', 'importMeta'];

  if (isTS) plugins.push('typescript');
  if (isTSX || filePath.endsWith('.jsx')) plugins.push('jsx');

  const ast = parser.parse(code, {
    sourceType: 'module',
    plugins,
    errorRecovery: true,
    allowImportExportEverywhere: true,
    allowReturnOutsideFunction: true,
    allowUndeclaredExports: true,
  });

  return ast;
}

export function getFunctionLocations(ast) {
  const locations = [];
  traverse(ast, {
    FunctionDeclaration(path) {
      locations.push({ type: 'function', name: path.node.id?.name, line: path.node.loc?.start.line, start: path.node.start });
    },
    ClassDeclaration(path) {
      locations.push({ type: 'class', name: path.node.id?.name, line: path.node.loc?.start.line, start: path.node.start });
    },
    ArrowFunctionExpression(path) {
      if (path.parent.type === 'VariableDeclarator') {
        locations.push({ type: 'function', name: path.parent.id?.name, line: path.node.loc?.start.line, start: path.node.start });
      }
    },
    ExportDefaultDeclaration(path) {
      locations.push({ type: 'export', name: 'default', line: path.node.loc?.start.line, start: path.node.start });
    },
  });
  return locations.sort((a, b) => a.start - b.start);
}
