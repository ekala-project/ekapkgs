# System-wide aria2 configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aria2;
in

{
  options.programs.aria2 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aria2 system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aria2;
      description = "aria2 package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
