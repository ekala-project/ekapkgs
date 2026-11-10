# Enumerates every package in the repository: every top-level attribute, plus
# the members of the package sets listed in `scopes`.
#
# Aliases are disabled. They are shims for a package already covered under its
# canonical name, so evaluating them only repeats work.
#
# When `checkMeta` is enabled, `handleEvalIssue` decides which rejections are bugs.
# `unknown-meta` and `broken-outputs` mean the `meta` itself is malformed, so
# they `abort` and name the package. Everything else -- broken, unfree,
# unsupported, insecure -- is a package correctly refusing to evaluate here,
# and `throw`s.
#
# What is left cannot be caught by `tryEval` and so fails the job with Nix's
# own message and source location: a missing `callPackage` argument, a missing
# attribute, or a type error. Those are the real bugs.
#
# Usage:
#   nix-instantiate --eval --strict ci/eval.nix

{
  checkMeta ? false,
}:

let
  pkgs = import ../. {
    config = {
      inherit checkMeta;
      aliases.nixpkgs = false;

      handleEvalIssue =
        reason: msg:
        if
          builtins.elem reason [
            "unknown-meta"
            "broken-outputs"
          ]
        then
          abort msg
        else
          throw msg;
    };
  };

  inherit (pkgs) lib;

  # Forcing `drvPath` resolves every dependency and, for ci/eval.nix, runs
  # `check-meta`. `package` arrives unforced, so a lookup that throws is caught
  # here too.
  probe =
    package:
    let
      value = builtins.tryEval package;
    in
    builtins.tryEval (
      if value.success && lib.isDerivation value.value then
        builtins.seq value.value.drvPath null
      else
        null
    );

  # Check whether a value is a derivation whose drvPath can be forced.
  isBuildable =
    value:
    let
      result = builtins.tryEval (lib.isDerivation value && builtins.seq value.drvPath true);
    in
    result.success && result.value;

  names = builtins.attrNames pkgs;

  topLevel = map (name: {
    inherit name;
    value = pkgs.${name};
  }) names;

  # Package sets that are not derivations themselves, so `probe` skips them and
  # walking the top level never reaches their members. Each member is probed
  # like a top-level package; non-derivations (builders, stubs) are ignored.
  scopes = [ "kdePackages" ];

  scoped = lib.concatMap (
    scope:
    map (name: {
      name = "${scope}.${name}";
      value = pkgs.${scope}.${name};
    }) (builtins.attrNames pkgs.${scope})
  ) scopes;

  targets = map (pair: pair.value) (topLevel ++ scoped);
in
{
  inherit probe targets;

  # Attribute set of all buildable derivations, keyed by name.
  buildable = builtins.listToAttrs (builtins.filter (pair: isBuildable pair.value) topLevel);
}
