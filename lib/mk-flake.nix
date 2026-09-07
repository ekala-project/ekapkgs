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
#       overlays.default = import ./nix/overlay.nix;
#
#       packages = pkgs: {
#         default = pkgs.my-package;
#         inherit (pkgs) my-package;
#       };
#
#       devShells = pkgs: {
#         default = pkgs.callPackage ./shell.nix { };
#       };
#
#       treefmt = {
#         programs.rustfmt.enable = true;
#         programs.nixfmt.enable = true;
#       };
#
#       nixosModules.default = import ./module.nix;
#     };
#
treefmt-nix:

{
  config ? { },
  # Overlays: an attrset of named overlays (e.g. { default = final: prev: { ... }; }).
  # All values are composed and applied to the package set.
  # The attrset is re-exposed as `overlays` in the flake output.
  overlays ? { },
  modules ? [ ], # pkgsModules
  packages ? null,
  devShells ? null,
  checks ? null,
  formatter ? null,
  treefmt ? null,
  apps ? null,
  hydraJobs ? null,
  # Non-per-system passthrough outputs.
  nixosModules ? { },
  nixosConfigurations ? { },
  systems ? [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ],
  # Escape hatch: arbitrary extra outputs merged last.
  extra ? { },
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

  overlayList = builtins.attrValues overlays;

  legacyPackages = forAllSystems (
    system:
    import ../. (
      {
        inherit system modules;
        overlays = overlayList;
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
  # -- Per-system outputs --------------------------------------------------
  inherit legacyPackages;
  ${if modules != [ ] then "pkgsModules" else null}.default = {
    imports = modules;
  };
  ${if packages != null then "packages" else null} = perSystem packages;
  ${if devShells != null then "devShells" else null} = perSystem devShells;
  ${if checks != null then "checks" else null} = perSystem checks;
  ${if effectiveFormatter != null then "formatter" else null} = perSystem effectiveFormatter;
  ${if apps != null then "apps" else null} = perSystem (pkgs: mkApps (apps pkgs));
  ${if hydraJobs != null then "hydraJobs" else null} = perSystem hydraJobs;

  # -- Non-per-system outputs ----------------------------------------------
  ${if overlays != { } then "overlays" else null} = overlays;
  ${if nixosModules != { } then "nixosModules" else null} = nixosModules;
  ${if nixosConfigurations != { } then "nixosConfigurations" else null} = nixosConfigurations;
} // extra
