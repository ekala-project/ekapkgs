# System-wide asar configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asar;
in

{
  options.programs.asar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asar system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asar;
      description = "asar package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
