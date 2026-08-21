# System-wide bc configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bc;
in

{
  options.programs.bc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bc system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bc;
      description = "bc package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
