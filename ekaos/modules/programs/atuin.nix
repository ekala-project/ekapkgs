# System-wide Atuin shell history configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.atuin;
in

{
  options.programs.atuin = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install Atuin system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.atuin;
      description = "Atuin package to use.";
    };

    enableBashIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to add Atuin bash integration hook.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.interactiveInit = mkIf cfg.enableBashIntegration ''
      eval "$(${cfg.package}/bin/atuin init bash)"
    '';
  };
}
