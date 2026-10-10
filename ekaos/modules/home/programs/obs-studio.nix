# Per-user OBS Studio configuration
#
# Extends home.users.<name> with OBS Studio options.
# Wraps OBS with plugins via --prefix OBS_PLUGINS_PATH.
#
# Usage:
#   home.users.alice.programs.obs-studio = {
#     enable = true;
#     plugins = [
#       pkgs.obs-studio-plugins.wlrobs
#       pkgs.obs-studio-plugins.obs-backgroundremoval
#       pkgs.obs-studio-plugins.obs-pipewire-audio-capture
#     ];
#   };
{ lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    concatMapStringsSep
    literalExpression
    ;

  obsOpts =
    { config, ... }:
    let
      cfg = config.programs.obs-studio;

      # Wrap OBS with plugin paths
      wrappedObs =
        if cfg.plugins == [ ] then
          cfg.package
        else
          pkgs.runCommand "obs-studio-wrapped" {
            nativeBuildInputs = [ pkgs.makeWrapper ];
            meta.mainProgram = "obs";
          } ''
            mkdir -p $out/bin
            makeWrapper ${cfg.package}/bin/obs $out/bin/obs \
              --prefix OBS_PLUGINS_PATH : ${concatMapStringsSep ":" (p: "${p}/lib/obs-plugins") cfg.plugins} \
              --prefix OBS_DATA_PATH : ${concatMapStringsSep ":" (p: "${p}/share/obs") cfg.plugins}
          '';
    in
    {
      options.programs.obs-studio = {
        enable = mkEnableOption "per-user OBS Studio configuration";

        package = mkOption {
          type = types.package;
          default = pkgs.obs-studio;
          description = "OBS Studio package to use.";
        };

        plugins = mkOption {
          type = types.listOf types.package;
          default = [ ];
          example = literalExpression ''
            [
              pkgs.obs-studio-plugins.wlrobs
              pkgs.obs-studio-plugins.obs-backgroundremoval
            ]
          '';
          description = "OBS Studio plugins to include on the plugin search path.";
        };
      };

      config = mkIf cfg.enable {
        packages = [ wrappedObs ];
      };
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule obsOpts);
  };
}
