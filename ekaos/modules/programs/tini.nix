# System-wide tini configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tini;
in

{
  options.programs.tini = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tini system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tini;
      description = "tini package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
