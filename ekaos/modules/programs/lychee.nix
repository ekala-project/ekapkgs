# System-wide lychee configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lychee;
in

{
  options.programs.lychee = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lychee system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lychee;
      description = "lychee package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
