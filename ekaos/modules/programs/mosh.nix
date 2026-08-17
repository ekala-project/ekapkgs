# System-wide mosh configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mosh;
in

{
  options.programs.mosh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mosh system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mosh;
      description = "mosh package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
