# System-wide stunnel configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.stunnel;
in

{
  options.programs.stunnel = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install stunnel system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.stunnel;
      description = "stunnel package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
