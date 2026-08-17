# System-wide bashdb configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bashdb;
in

{
  options.programs.bashdb = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bashdb system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bashdb;
      description = "bashdb package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
