# System-wide kubeval configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.kubeval;
in

{
  options.programs.kubeval = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install kubeval system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.kubeval;
      description = "kubeval package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
