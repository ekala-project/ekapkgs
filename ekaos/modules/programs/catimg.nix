# System-wide catimg configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.catimg;
in

{
  options.programs.catimg = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install catimg system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.catimg;
      description = "catimg package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
