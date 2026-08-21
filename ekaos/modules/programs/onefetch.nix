# System-wide onefetch configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.onefetch;
in

{
  options.programs.onefetch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install onefetch system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.onefetch;
      description = "onefetch package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
