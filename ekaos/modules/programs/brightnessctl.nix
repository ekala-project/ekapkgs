# System-wide brightnessctl configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.brightnessctl;
in

{
  options.programs.brightnessctl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install brightnessctl system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.brightnessctl;
      description = "brightnessctl package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
