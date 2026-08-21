# System-wide meson configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.meson;
in

{
  options.programs.meson = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install meson system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.meson;
      description = "meson package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
