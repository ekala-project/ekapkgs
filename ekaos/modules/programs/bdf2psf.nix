# System-wide bdf2psf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bdf2psf;
in

{
  options.programs.bdf2psf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bdf2psf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bdf2psf;
      description = "bdf2psf package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
