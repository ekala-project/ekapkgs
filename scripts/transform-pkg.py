#!/usr/bin/env python3
"""Transform a nixpkgs package.nix for ekapkgs."""
import re
import sys

def transform(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # ============================================================
    # 1. Remove nix-update-script and related updater inputs
    # ============================================================
    for input_name in ['nix-update-script', 'unstableGitUpdater', 'gitUpdater',
                       '_experimental-update-script-combinators']:
        escaped = re.escape(input_name)
        # Remove the entire line containing just this input (with optional comma)
        content = re.sub(r'^[ \t]*' + escaped + r'\s*,?\s*\n', '', content, flags=re.MULTILINE)
        # Inline: remove from comma-separated lists
        content = re.sub(r'\b' + escaped + r'\s*,\s*', '', content)
        content = re.sub(r',\s*' + escaped + r'\b', '', content)

    # ============================================================
    # 2. Remove versionCheckHook references
    # ============================================================
    # Remove entire line containing just versionCheckHook (with optional comma)
    content = re.sub(r'^[ \t]*versionCheckHook\s*,?\s*\n', '', content, flags=re.MULTILINE)
    # Inline removal
    content = re.sub(r'\bversionCheckHook\s*,\s*', '', content)
    content = re.sub(r',\s*versionCheckHook\b', '', content)
    # Remove versionCheckProgram and versionCheckKeepEnvironment lines
    content = re.sub(r'^\s*versionCheckProgram\s*=.*;\s*$', '', content, flags=re.MULTILINE)
    content = re.sub(r'^\s*versionCheckKeepEnvironment\s*=.*;\s*$', '', content, flags=re.MULTILINE)

    # ============================================================
    # 3. Remove passthru.updateScript / updateScript (various patterns)
    # ============================================================
    # Remove passthru.updateScript = ANYTHING { ... }; (multiline with nested braces)
    # Use a brace-counting approach for robustness
    def remove_update_script_blocks(text):
        """Remove passthru.updateScript and updateScript assignments including multiline blocks."""
        patterns = [
            r'passthru\.updateScript',
            r'(?<!\.)updateScript',
        ]
        for pat in patterns:
            while True:
                m = re.search(r'^\s*' + pat + r'\s*=\s*', text, re.MULTILINE)
                if not m:
                    break
                start = m.start()
                pos = m.end()
                # Check if it starts a block with braces or is a simple value
                rest = text[pos:]
                if rest.lstrip().startswith("''" ):
                    # Multi-line string '' ... '';
                    end_match = re.search(r"'';\s*", rest)
                    if end_match:
                        end = pos + end_match.end()
                        text = text[:start] + text[end:]
                        continue
                # Count braces to find the end of the statement
                depth = 0
                i = pos
                found_semi = False
                while i < len(text):
                    ch = text[i]
                    if ch == '{':
                        depth += 1
                    elif ch == '}':
                        depth -= 1
                    elif ch == ';' and depth <= 0:
                        found_semi = True
                        i += 1
                        break
                    elif ch == '\n' and depth == 0 and i > pos:
                        # Single-line value without semicolon on same line
                        # Check if we already passed a semicolon-like structure
                        pass
                    i += 1
                if found_semi:
                    # Remove from start of line to end of statement
                    line_start = text.rfind('\n', 0, start)
                    if line_start == -1:
                        line_start = 0
                    else:
                        line_start += 1
                    text = text[:line_start] + text[i:]
                else:
                    break
        return text

    content = remove_update_script_blocks(content)
    # Remove empty passthru blocks left behind
    content = re.sub(r'\s*passthru\s*=\s*\{\s*\}\s*;', '', content)
    # Remove passthru = { }; with just whitespace inside
    content = re.sub(r'^\s*passthru\s*=\s*\{\s*\};\s*$', '', content, flags=re.MULTILINE)

    # ============================================================
    # 4. Remove nixosTests references
    # ============================================================
    # Remove entire line containing just nixosTests (with optional comma)
    content = re.sub(r'^[ \t]*nixosTests\s*,?\s*\n', '', content, flags=re.MULTILINE)
    # Inline removal
    content = re.sub(r'\bnixosTests\s*,\s*', '', content)
    content = re.sub(r',\s*nixosTests\b', '', content)
    # Remove nixosTests.xxx from lists and passthru.tests
    content = re.sub(r'^\s*nixosTests\.[a-zA-Z0-9_-]+\s*;?\s*$', '', content, flags=re.MULTILINE)
    # Remove inherit nixosTests lines
    content = re.sub(r'^\s*inherit nixosTests\s*;\s*$', '', content, flags=re.MULTILINE)

    # ============================================================
    # 5. Set meta.maintainers = [ ]
    # ============================================================
    content = re.sub(
        r'maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[(?:[^\]]*)\]',
        'maintainers = [ ]', content
    )
    content = re.sub(
        r'maintainers\s*=\s*\[(?:[^\]]*lib\.maintainers\.[^\]]*)\]',
        'maintainers = [ ]', content
    )
    content = re.sub(
        r'maintainers\s*=\s*lib\.teams\.[a-zA-Z0-9_-]+\.members',
        'maintainers = [ ]', content
    )

    # ============================================================
    # 6. Add cmake.configurePhaseHook if cmake is used
    # ============================================================
    if re.search(r'\bcmake\b', content) and not re.search(r'cmake\.configurePhaseHook|cmake\.v4\.configurePhaseHook', content):
        # After "cmake" on its own line in nativeBuildInputs
        content = re.sub(
            r'^(\s*)(cmake)\s*$',
            r'\1cmake\n\1cmake.configurePhaseHook',
            content,
            count=1,
            flags=re.MULTILINE
        )
        # Inline: [ cmake ] -> [ cmake cmake.configurePhaseHook ]
        content = re.sub(
            r'\[\s*cmake\s*\]',
            '[ cmake cmake.configurePhaseHook ]',
            content,
            count=1
        )

    # ============================================================
    # 7. Add meson.configurePhaseHook if meson is used
    # ============================================================
    if re.search(r'\bmeson\b', content) and not re.search(r'meson\.configurePhaseHook', content):
        # After "meson" on its own line
        content = re.sub(
            r'^(\s*)(meson)\s*$',
            r'\1meson\n\1meson.configurePhaseHook',
            content,
            count=1,
            flags=re.MULTILINE
        )
        # Inline: [ meson ] -> [ meson meson.configurePhaseHook ]
        content = re.sub(
            r'\[\s*meson\s*\]',
            '[ meson meson.configurePhaseHook ]',
            content,
            count=1
        )
        # Add ninja if not already present
        if not re.search(r'\bninja\b', content):
            content = re.sub(
                r'(meson\.configurePhaseHook)',
                r'\1\n    ninja',
                content,
                count=1
            )

    # ============================================================
    # 8. Clean up: fix double commas, trailing commas before }, etc.
    # ============================================================
    content = re.sub(r',\s*,', ',', content)
    # Remove blank lines (more than 2 consecutive)
    content = re.sub(r'\n{3,}', '\n\n', content)

    with open(filepath, 'w') as f:
        f.write(content)

if __name__ == '__main__':
    transform(sys.argv[1])
