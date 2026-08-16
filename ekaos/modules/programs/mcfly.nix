# System-wide McFly shell history search configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mcfly;
in

{
  options.programs.mcfly = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install McFly system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mcfly;
      description = "McFly package to use.";
    };

    enableBashIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to add McFly bash integration hook.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.interactiveInit = mkIf cfg.enableBashIntegration ''
      eval "$(${cfg.package}/bin/mcfly init bash)"
    '';
  };
}
