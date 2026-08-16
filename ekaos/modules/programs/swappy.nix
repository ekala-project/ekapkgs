# System-wide swappy configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.swappy;
in

{
  options.programs.swappy = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install swappy system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.swappy;
      description = "swappy package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
