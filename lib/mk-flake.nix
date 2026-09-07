# mkFlake — facade for downstream flakes consuming ekapkgs.
#
# This file is a curried function: the first argument (treefmt-nix) is applied
# by the ekapkgs flake.nix when constructing lib.mkFlake.  Downstream callers
# only see the second argument (the config attrset).
#
# Usage (in a consumer flake):
#
#   outputs = { ekapkgs, ... }:
#     ekapkgs.lib.mkFlake {
#       packages = pkgs: {
#         foo = pkgs.callPackage ./foo.nix { };
#       };
#       devShells = pkgs: {
#         default = pkgs.callPackage ./shell.nix { };
#       };
#       treefmt = {
#         programs.rustfmt.enable = true;
#         programs.nixfmt.enable = true;
#       };
#     } // {
#       # Non-per-system outputs go outside mkFlake:
#       nixosModules.default = import ./module.nix;
#     };
#
treefmt-nix:

{
  config ? { },
  overlays ? [ ],
  modules ? [ ], # pkgsModules
  packages ? null,
  devShells ? null,
  checks ? null,
  formatter ? null,
  treefmt ? null,
  apps ? null,
  hydraJobs ? null,
  systems ? [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ],
}:

let
  genAttrs =
    names: f:
    builtins.listToAttrs (
      map (n: {
        name = n;
        value = f n;
      }) names
    );

  forAllSystems = genAttrs systems;

  legacyPackages = forAllSystems (
    system:
    import ../. (
      {
        inherit
          system
          overlays
          modules
          ;
      }
      // (if config != { } then { inherit config; } else { })
    )
  );

  perSystem = f: forAllSystems (system: f legacyPackages.${system});

  mkApps = builtins.mapAttrs (
    _: v: {
      type = "app";
      program = v;
    }
  );

  composeManyExtensions =
    exts: final: prev:
    builtins.foldl' (acc: ext: acc // ext final prev) { } exts;

  # When treefmt config is provided, build the formatter via treefmt-nix.
  # This takes precedence over a raw `formatter` function.
  effectiveFormatter =
    if treefmt != null then
      pkgs:
      let
        fmt = treefmt-nix.lib.evalModule pkgs treefmt;
      in
      fmt.config.build.wrapper
    else
      formatter;
in

assert packages == null || builtins.isFunction packages;
assert devShells == null || builtins.isFunction devShells;
assert checks == null || builtins.isFunction checks;
assert formatter == null || builtins.isFunction formatter;
assert treefmt == null || builtins.isAttrs treefmt;
assert formatter == null || treefmt == null;
assert apps == null || builtins.isFunction apps;
assert hydraJobs == null || builtins.isFunction hydraJobs;

{
  inherit legacyPackages;
  ${if modules != [ ] then "pkgsModules" else null}.default = {
    imports = modules;
  };
  ${if overlays != [ ] then "overlays" else null}.default = composeManyExtensions overlays;
  ${if packages != null then "packages" else null} = perSystem packages;
  ${if devShells != null then "devShells" else null} = perSystem devShells;
  ${if checks != null then "checks" else null} = perSystem checks;
  ${if effectiveFormatter != null then "formatter" else null} = perSystem effectiveFormatter;
  ${if apps != null then "apps" else null} = perSystem (pkgs: mkApps (apps pkgs));
  ${if hydraJobs != null then "hydraJobs" else null} = perSystem hydraJobs;
}
