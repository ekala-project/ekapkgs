# System-wide dmidecode configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dmidecode;
in

{
  options.programs.dmidecode = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dmidecode system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dmidecode;
      description = "dmidecode package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
