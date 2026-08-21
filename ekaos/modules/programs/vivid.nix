# System-wide vivid LS_COLORS generator configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.vivid;
in

{
  options.programs.vivid = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install vivid system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.vivid;
      description = "vivid package to use.";
    };

    theme = mkOption {
      type = types.str;
      default = "molokai";
      description = "vivid theme name to use for LS_COLORS generation.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.shell.init = ''
      export LS_COLORS="$(${cfg.package}/bin/vivid generate ${cfg.theme})"
    '';
  };
}
