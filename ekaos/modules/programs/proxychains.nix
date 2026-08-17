# System-wide proxychains configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.proxychains;
in

{
  options.programs.proxychains = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install proxychains system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.proxychains;
      description = "proxychains package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
