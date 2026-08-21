# System-wide sox configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sox;
in

{
  options.programs.sox = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sox system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sox;
      description = "sox package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
