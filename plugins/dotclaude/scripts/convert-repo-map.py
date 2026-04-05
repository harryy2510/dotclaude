#!/usr/bin/env python3
"""Convert agent-analyzer repo-intel.json to repo-map.json format.

Replicates agentsys/lib/repo-map/converter.js exactly.

Usage: convert-repo-map.py <input-intel.json> <output-map.json>
"""

import json
import os
import sys

EXT_LANG = {
    '.js': 'javascript', '.jsx': 'javascript', '.mjs': 'javascript', '.cjs': 'javascript',
    '.ts': 'typescript', '.tsx': 'typescript', '.mts': 'typescript', '.cts': 'typescript',
    '.py': 'python', '.pyw': 'python',
    '.rs': 'rust', '.go': 'go', '.java': 'java',
}

CLASS_KINDS = {'class', 'struct', 'interface', 'enum', 'impl'}
TYPE_KINDS = {'trait', 'type-alias'}
FUNC_KINDS = {'method', 'arrow', 'closure'}
CONST_KINDS = {'constant', 'variable', 'const', 'field', 'property'}


def convert_file(file_path, file_sym):
    ext = os.path.splitext(file_path)[1].lower()
    export_names = {e['name'] for e in file_sym.get('exports', [])}

    functions, classes, types, constants = [], [], [], []
    for d in file_sym.get('definitions', []):
        entry = {
            'name': d['name'],
            'kind': d['kind'],
            'line': d.get('line'),
            'exported': d['name'] in export_names,
        }
        kind = d['kind']
        if kind == 'function' or kind in FUNC_KINDS:
            functions.append(entry)
        elif kind in CLASS_KINDS:
            classes.append(entry)
        elif kind in TYPE_KINDS:
            types.append(entry)
        else:
            constants.append(entry)

    exports = [
        {'name': e['name'], 'kind': e.get('kind'), 'line': e.get('line')}
        for e in file_sym.get('exports', [])
    ]
    imports = [
        {'source': i['from'], 'kind': 'import', 'names': i.get('names', [])}
        for i in file_sym.get('imports', [])
    ]

    return {
        'language': EXT_LANG.get(ext, 'unknown'),
        'symbols': {
            'exports': exports,
            'functions': functions,
            'classes': classes,
            'types': types,
            'constants': constants,
        },
        'imports': imports,
    }


def convert(intel):
    files = {}
    total_symbols = 0
    total_imports = 0

    for fp, file_sym in intel.get('symbols', {}).items():
        files[fp] = convert_file(fp, file_sym)
        s = files[fp]['symbols']
        total_symbols += len(s['functions']) + len(s['classes']) + len(s['types']) + len(s['constants'])
        total_imports += len(files[fp]['imports'])

    languages = sorted({
        EXT_LANG.get(os.path.splitext(fp)[1].lower(), 'unknown')
        for fp in files
        if EXT_LANG.get(os.path.splitext(fp)[1].lower())
    })

    return {
        'version': '2.0',
        'generated': intel.get('generated', ''),
        'git': {'commit': intel.get('git', {}).get('analyzedUpTo')} if intel.get('git') else None,
        'project': {'languages': languages},
        'stats': {
            'totalFiles': len(files),
            'totalSymbols': total_symbols,
            'totalImports': total_imports,
        },
        'files': files,
    }


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f'Usage: {sys.argv[0]} <input.json> <output.json>')
        sys.exit(1)

    with open(sys.argv[1]) as f:
        intel = json.load(f)

    repo_map = convert(intel)

    with open(sys.argv[2], 'w') as f:
        json.dump(repo_map, f, indent=2)

    s = repo_map['stats']
    print(f"{s['totalFiles']} files, {s['totalSymbols']} symbols, {s['totalImports']} imports")
