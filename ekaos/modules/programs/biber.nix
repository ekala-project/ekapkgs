# System-wide biber configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.biber;
in

{
  options.programs.biber = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install biber system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.biber;
      description = "biber package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
