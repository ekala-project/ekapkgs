# System-wide broot file navigator configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.broot;
in

{
  options.programs.broot = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install broot system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.broot;
      description = "broot package to use.";
    };

    enableBashIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to add broot bash integration hook.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.interactiveInit = mkIf cfg.enableBashIntegration ''
      source ${cfg.package}/share/broot/launcher/bash/br
    '';
  };
}
