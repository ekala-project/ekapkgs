# System-wide bats configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bats;
in

{
  options.programs.bats = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bats system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bats;
      description = "bats package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
