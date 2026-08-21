# System-wide tor configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tor;
in

{
  options.programs.tor = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tor system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tor;
      description = "tor package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
