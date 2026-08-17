# System-wide bibtool configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bibtool;
in

{
  options.programs.bibtool = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bibtool system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bibtool;
      description = "bibtool package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
