#!/usr/bin/env python3
# cocktail2110's puma emits "Position.NoPosition" / "Position.Compare(...)" as
# the built-in default-initializer/equality macros for any tPosition-typed
# field (hardcoded in TypeTab.m's begintPosition/equaltPosition macros).
# But Jacob's own oberon.ast redefines tPosition as POS.tPosition (Jacob's
# own position-tracking module), so those generated "Position.xxx" calls are
# both the wrong module and an incompatible record type. Retarget just those
# specific, known macro-shaped call sites to POS - never a bare "Position."
# (which is frequently just a local variable/parameter of record type
# tPosition being field-accessed, not the module).
import re, glob

# Only ever touch files this build tree actually generates via puma/ast/rex/lark.
GENERATED = [
    "ADR", "BL", "CMT", "CO", "CODE", "CODEf", "SI", "T", "TD", "TT", "V",
    "PR", "OD", "OB", "Tree", "Eval", "Scanner", "Parser",
]

CALL_RE = re.compile(r'\bPosition\.(NoPosition|Compare|WritePosition|ReadPosition)\b')
IMPORT_RE = re.compile(r'^[ \t]*IMPORT\s+([^;]*);', re.MULTILINE)

for base in GENERATED:
    for ext in (".mi", ".md"):
        path = base + ext
        try:
            with open(path) as f:
                content = f.read()
        except FileNotFoundError:
            continue
        new_content, n = CALL_RE.subn(r'POS.\1', content)
        if n == 0:
            continue
        # A file may have more than one IMPORT line (puma's auto-generated
        # boilerplate line, plus the project's own explicit GLOBAL imports);
        # only add POS to the first one if no line already imports it.
        already_imported = any(
            'POS' in [x.strip() for x in im.split(',')]
            for im in IMPORT_RE.findall(new_content)
        )
        if not already_imported:
            m = IMPORT_RE.search(new_content)
            if m:
                names = [x.strip() for x in m.group(1).split(',')]
                new_import = 'IMPORT ' + ', '.join(names + ['POS']) + ';'
                new_content = new_content[:m.start()] + new_import + new_content[m.end():]
        with open(path, 'w') as f:
            f.write(new_content)
        print(f"{path}: retargeted {n} Position.xxx call(s) to POS.")
