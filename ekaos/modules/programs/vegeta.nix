# System-wide vegeta configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.vegeta;
in

{
  options.programs.vegeta = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install vegeta system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.vegeta;
      description = "vegeta package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
