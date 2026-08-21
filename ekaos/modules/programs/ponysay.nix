# System-wide ponysay configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ponysay;
in

{
  options.programs.ponysay = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ponysay system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ponysay;
      description = "ponysay package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
