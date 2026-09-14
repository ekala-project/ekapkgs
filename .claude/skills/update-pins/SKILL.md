---
name: update-pins
description: Update flake inputs and prune packages that are now shadowed by corepkgs
disable-model-invocation: true
allowed-tools: Bash(nix *) Bash(git *) Bash(rm *) Bash(ls *) Read Edit Glob Grep
---

## Overview

Update all flake input pins, then detect and remove ekapkgs packages that
are now provided by corepkgs (i.e., shadowed packages). Packages in `pkgs/`
that shadow corepkgs are safe to remove. Entries in `top-level.nix` that
shadow corepkgs are intentional overrides — report them but do not remove
them without confirmation.

## Steps

### 1. Update flake inputs

```
nix flake update
```

### 2. Detect shadowed packages

Run the existing detection script:

```
nix-instantiate --eval --strict shadowed-packages.nix -A pkgsDir --json
```

This returns a JSON array of package names in `pkgs/` that now exist in
corepkgs (either in its `pkgs/`, `pkgs-many/`, or `top-level.nix`).

Also check for top-level shadows:

```
nix-instantiate --eval --strict shadowed-packages.nix -A topLevel --json
```

### 3. Prune shadowed `pkgs/` directories

For each package name returned in the `pkgsDir` list:

1. Verify the directory `pkgs/<name>/` exists.
2. Remove the entire directory: `rm -rf pkgs/<name>`.
3. Report what was removed.

**Do NOT remove any directory without first confirming it appears in the
`pkgsDir` output from step 2.**

### 4. Report top-level shadows

If the `topLevel` list is non-empty, print the shadowed names and advise
the user to review `top-level.nix` — these are intentional overrides and
should only be removed after manual review and confirmation.

### 5. Validate

For each removed package, run:

```
nix-instantiate -A <package-name>
```

This confirms the package still evaluates successfully via the corepkgs
overlay after the local copy has been removed.

If evaluation fails for any package, restore it from git:

```
git checkout -- pkgs/<package-name>
```

and report the failure so the user can investigate.

### 6. Summary

Print a summary:
- Number of packages pruned from `pkgs/`
- Names of pruned packages
- Any top-level shadows flagged for review
- Any validation failures
