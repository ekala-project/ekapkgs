# System-wide torsocks configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.torsocks;
in

{
  options.programs.torsocks = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install torsocks system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.torsocks;
      description = "torsocks package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
