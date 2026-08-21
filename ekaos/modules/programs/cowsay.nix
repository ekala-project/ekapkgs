# System-wide cowsay configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cowsay;
in

{
  options.programs.cowsay = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cowsay system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cowsay;
      description = "cowsay package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
