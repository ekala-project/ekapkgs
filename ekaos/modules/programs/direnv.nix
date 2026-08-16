# System-wide direnv configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.direnv;
in

{
  options.programs.direnv = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install direnv system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.direnv;
      description = "direnv package to use.";
    };

    enableBashIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable direnv bash integration.";
    };

    direnvrcExtra = mkOption {
      type = types.lines;
      default = "";
      description = "Extra lines appended to /etc/direnv/direnvrc.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables.DIRENV_CONFIG = "/etc/direnv";

    environment.etc."direnv/direnvrc" = {
      text = cfg.direnvrcExtra;
    };

    programs.bash.interactiveInit = mkIf cfg.enableBashIntegration ''
      eval "$(${cfg.package}/bin/direnv hook bash)"
    '';
  };
}
