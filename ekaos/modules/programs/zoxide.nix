# System-wide zoxide configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.zoxide;
in

{
  options.programs.zoxide = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install zoxide system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.zoxide;
      description = "zoxide package to use.";
    };

    enableBashIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to add zoxide bash integration hook.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.interactiveInit = mkIf cfg.enableBashIntegration ''
      eval "$(${cfg.package}/bin/zoxide init bash)"
    '';
  };
}
