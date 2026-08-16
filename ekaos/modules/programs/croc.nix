# System-wide croc configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.croc;
in

{
  options.programs.croc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install croc system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.croc;
      description = "croc package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
