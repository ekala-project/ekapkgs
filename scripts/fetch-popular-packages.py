#!/usr/bin/env python3
"""Fetch the most popular packages from Repology that exist in nixpkgs.

Paginates through the Repology API, counts unique repository families
per project, captures nixpkgs attribute names, and outputs the top N
sorted by popularity (family count).
"""

import json
import re
import sys
import time
import urllib.request

API_BASE = "https://repology.org/api/v1/projects/"
USER_AGENT = "ekapkgs-popular-packages/1.0 (https://github.com/user/ekapkgs)"
REQUEST_DELAY = 1.1  # seconds between requests (rate limit: 1/sec)
MIN_FAMILIES = 5
TOP_N = 20000
CACHE_FILE = "repology-cache.json"
OUTPUT_FILE = "popular-packages.json"


def log(msg):
    print(msg, flush=True)


def repo_to_family(repo: str) -> str:
    """Derive the repository family from a repo name."""
    overrides = {
        "aix_osp": "aix",
        "aixtoolbox": "aix",
        "npackd_stable": "npackd",
        "npackd_unstable": "npackd",
    }
    if repo in overrides:
        return overrides[repo]

    family = re.sub(
        r"_(stable|unstable|testing|edge|current|experimental|master|"
        r"rolling|backports|proposed|updates|rawhide|cauldron|cooker|"
        r"tumbleweed|leap|slowroll|factory|ports|"
        r"x86_64|x86|i686|aarch64|armhf|arm64|ppc64le|ppc64|powerpc|"
        r"powerpc64le|riscv64|s390x|mips64el|loong64|"
        r"clang64|clangarm64|mingw|ucrt64|msys2|"
        r"main|community|universe|multiverse|contrib|non-free|"
        r"oss|non_oss)$",
        "",
        repo,
    )
    family = family.rstrip("_")
    family = re.sub(r"(_\d[\d._]*)$", "", family)
    family = family.rstrip("_")
    if not family:
        family = repo
    return family


def fetch_page(start_name: str | None = None) -> dict:
    """Fetch one page of projects from the Repology API."""
    if start_name:
        url = f"{API_BASE}{start_name}/?inrepo=nix_unstable&families={MIN_FAMILIES}-"
    else:
        url = f"{API_BASE}?inrepo=nix_unstable&families={MIN_FAMILIES}-"

    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=120) as resp:
        return json.loads(resp.read().decode())


def extract_project_info(entries: list[dict]) -> dict:
    """Extract family count and nix srcnames from project entries."""
    families = set()
    nix_srcnames = set()

    for entry in entries:
        repo = entry.get("repo", "")
        families.add(repo_to_family(repo))

        if repo.startswith("nix_"):
            srcname = entry.get("srcname", "")
            if srcname:
                nix_srcnames.add(srcname)

    return {
        "families": len(families),
        "nix_srcnames": sorted(nix_srcnames),
    }


def fetch_all():
    """Fetch all projects from Repology API, save to cache."""
    all_projects = {}
    start_name = None
    page = 0
    t0 = time.time()

    log(f"Fetching nixpkgs packages with {MIN_FAMILIES}+ families from Repology...")

    while True:
        page += 1
        t_page = time.time()
        try:
            data = fetch_page(start_name)
        except Exception as e:
            log(f"  Error on page {page}: {e}")
            log("  Retrying in 5 seconds...")
            time.sleep(5)
            try:
                data = fetch_page(start_name)
            except Exception as e2:
                log(f"  Retry failed: {e2}. Stopping.")
                break

        if not data:
            break

        for name, entries in data.items():
            all_projects[name] = extract_project_info(entries)

        project_names = sorted(data.keys())
        last_name = project_names[-1] if project_names else None
        count = len(data)
        elapsed_page = time.time() - t_page
        elapsed_total = time.time() - t0

        log(
            f"  Page {page}: {count} projects, "
            f"{elapsed_page:.1f}s "
            f"(total: {len(all_projects)}, {elapsed_total:.0f}s elapsed, last: {last_name})"
        )

        if count < 200:
            break

        start_name = last_name
        time.sleep(REQUEST_DELAY)

    elapsed = time.time() - t0
    log(f"\nTotal projects fetched: {len(all_projects)} in {elapsed:.0f}s")

    with open(CACHE_FILE, "w") as f:
        json.dump(all_projects, f)
    log(f"Saved cache to {CACHE_FILE}")

    return all_projects


def build_output(all_projects: dict):
    """Sort projects by popularity and write output."""
    sorted_projects = sorted(
        all_projects.items(), key=lambda x: (-x[1]["families"], x[0])
    )

    top = sorted_projects[:TOP_N]
    result = []
    for name, info in top:
        result.append({
            "name": name,
            "families": info["families"],
            "nix_srcnames": info["nix_srcnames"],
        })

    with open(OUTPUT_FILE, "w") as f:
        json.dump(result, f, indent=2)

    log(f"Wrote {len(result)} packages to {OUTPUT_FILE}")
    if result:
        top10 = ", ".join(f"{r['name']} ({r['families']})" for r in result[:10])
        log(f"Top 10: {top10}")
        last = result[-1]
        log(f"Cutoff at #{len(result)}: {last['name']} ({last['families']} families)")


def main():
    import os

    if os.path.exists(CACHE_FILE):
        log(f"Loading from cache: {CACHE_FILE}")
        with open(CACHE_FILE) as f:
            all_projects = json.load(f)
        log(f"Loaded {len(all_projects)} projects from cache")
    else:
        all_projects = fetch_all()

    build_output(all_projects)


if __name__ == "__main__":
    main()
