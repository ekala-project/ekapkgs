# System-wide mise configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mise;
in

{
  options.programs.mise = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mise system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mise;
      description = "mise package to use.";
    };

    enableBashIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable bash integration for mise.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.interactiveInit = mkIf cfg.enableBashIntegration ''
      eval "$(${cfg.package}/bin/mise activate bash)"
    '';
  };
}
