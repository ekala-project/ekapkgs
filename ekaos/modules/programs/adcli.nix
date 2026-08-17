# System-wide adcli configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.adcli;
in

{
  options.programs.adcli = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install adcli system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.adcli;
      description = "adcli package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
