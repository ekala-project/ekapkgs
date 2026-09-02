#!/usr/bin/env python3
"""Map repology project names to nixpkgs attribute names and render mvp-packages.md."""

import json
import os
import subprocess
import sys

INPUT_FILE = "popular-packages.json"
NIXPKGS_PATH = "/home/jon/projects/nixpkgs"
OUTPUT_FILE = "mvp-packages.md"


def get_byname_attrs() -> set[str]:
    """Get all attribute names from pkgs/by-name/."""
    attrs = set()
    byname = os.path.join(NIXPKGS_PATH, "pkgs", "by-name")
    for shard in os.listdir(byname):
        shard_path = os.path.join(byname, shard)
        if not os.path.isdir(shard_path):
            continue
        for pkg in os.listdir(shard_path):
            pkg_path = os.path.join(shard_path, pkg)
            if os.path.isdir(pkg_path):
                attrs.add(pkg)
    return attrs


def get_allpackages_attrs() -> set[str]:
    """Get attribute names from all-packages.nix (best effort grep)."""
    import re
    attrs = set()
    ap_path = os.path.join(NIXPKGS_PATH, "pkgs", "top-level", "all-packages.nix")
    with open(ap_path) as f:
        for line in f:
            m = re.match(r"^  ([\w][\w.-]*)\s*=", line)
            if m:
                attrs.add(m.group(1))
    return attrs


def resolve_attr(repology_name: str, nix_srcnames: list[str], all_attrs: set[str]) -> str | None:
    """Resolve a repology project name to a nixpkgs attribute name.

    Priority:
    1. nix_srcnames from repology API (most authoritative) — top-level only
    2. Direct match against nixpkgs attrs
    3. Heuristic transformations
    """
    import re

    # 1. Direct match of repology name against nixpkgs attrs (highest confidence)
    if repology_name in all_attrs:
        return repology_name

    # 2. Nixpkgs prepends _ for names starting with digits
    if repology_name[0:1].isdigit():
        candidate = "_" + repology_name
        if candidate in all_attrs:
            return candidate

    # 3. Try colon→dot for subpackages (texlive:foo → texlivePackages.foo)
    if ":" in repology_name:
        candidate = repology_name.replace(":", ".")
        if candidate in all_attrs:
            return candidate

    # 4. Common transformations of repology name
    for candidate in [
        repology_name.replace("-", "_"),
        repology_name.replace("_", "-"),
    ]:
        if candidate in all_attrs:
            return candidate

    # 5. Use repology srcnames
    if nix_srcnames:
        top_level = [s for s in nix_srcnames if "." not in s]
        if not top_level:
            top_level = nix_srcnames

        # Exact match with repology name among srcnames
        for s in top_level:
            if s == repology_name:
                return s

        def score(s):
            base = s.split(".")[-1]
            rname = repology_name.replace("-", "").replace("_", "").lower()
            sname = base.replace("-", "").replace("_", "").lower()
            # Prefer names that contain the repology name
            if sname == rname:
                name_score = 0
            elif sname.startswith(rname):
                name_score = 1
            elif rname in sname:
                name_score = 2
            else:
                name_score = 3
            # Penalize version suffixes and variants
            has_variant = 1 if re.search(
                r"(_\d|Full|Minimal|WithGui|Curses|Legacy|Unwrapped|HTTP3|FreeThreading|ForLibs)",
                s
            ) else 0
            return (name_score, has_variant, len(s))

        in_attrs = [s for s in top_level if s in all_attrs]
        if in_attrs:
            return min(in_attrs, key=score)

        # For dotted names, try to normalize version-specific prefixes
        all_srcnames = nix_srcnames if not top_level else top_level
        normalized = set()
        for s in all_srcnames:
            # python310Packages.foo → python3Packages.foo
            n = re.sub(r"^python\d{3,}Packages\.", "python3Packages.", s)
            # kdePackages.foo → qt6Packages.foo for qt-related
            n = re.sub(r"^libsForQt5\.", "qt5.", n)
            normalized.add(n)

        norm_in_attrs = [s for s in normalized if s in all_attrs]
        if norm_in_attrs:
            return min(norm_in_attrs, key=score)

        if normalized:
            return min(normalized, key=score)

        return min(all_srcnames, key=score)

    return None


def main():
    with open(INPUT_FILE) as f:
        packages = json.load(f)

    print(f"Loaded {len(packages)} packages from {INPUT_FILE}", flush=True)

    # Build attr name lookup
    all_attrs = get_byname_attrs() | get_allpackages_attrs()
    print(f"Found {len(all_attrs)} nixpkgs attribute names", flush=True)

    # Resolve each package
    resolved = []
    unresolved = []
    for pkg in packages:
        attr = resolve_attr(pkg["name"], pkg.get("nix_srcnames", []), all_attrs)
        if attr:
            resolved.append({"repology": pkg["name"], "attr": attr, "families": pkg["families"]})
        else:
            unresolved.append(pkg)

    print(f"Resolved: {len(resolved)}, Unresolved: {len(unresolved)}", flush=True)

    # Deduplicate: if two repology projects resolve to the same attr, keep the higher-ranked one
    seen_attrs = set()
    deduped = []
    for pkg in resolved:
        if pkg["attr"] not in seen_attrs:
            seen_attrs.add(pkg["attr"])
            deduped.append(pkg)
    if len(deduped) < len(resolved):
        print(f"Deduplicated: {len(resolved)} → {len(deduped)}", flush=True)
    resolved = deduped

    # Write markdown
    with open(OUTPUT_FILE, "w") as f:
        f.write("# MVP Packages\n\n")
        f.write(
            f"Top {len(resolved)} most popular nixpkgs packages, "
            f"ranked by Repology repository family spread.\n\n"
        )
        f.write(
            "Popularity = number of distinct repository families (e.g., Debian, Fedora, Arch, "
            "Homebrew...) that package each project.\n\n"
        )
        f.write(f"| # | Attribute | Families | Repology |\n")
        f.write(f"|---|-----------|----------|----------|\n")
        for i, pkg in enumerate(resolved, 1):
            rep = pkg["repology"]
            attr = pkg["attr"]
            fam = pkg["families"]
            f.write(f"| {i} | `{attr}` | {fam} | {rep} |\n")

    print(f"Wrote {OUTPUT_FILE} with {len(resolved)} entries", flush=True)

    if unresolved:
        print(f"\nTop 20 unresolved:", flush=True)
        for pkg in unresolved[:20]:
            print(f"  {pkg['name']} ({pkg['families']} families, srcnames: {pkg.get('nix_srcnames', [])})")


if __name__ == "__main__":
    main()
