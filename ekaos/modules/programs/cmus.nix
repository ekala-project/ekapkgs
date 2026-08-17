# System-wide cmus configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cmus;
in

{
  options.programs.cmus = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cmus system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cmus;
      description = "cmus package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
