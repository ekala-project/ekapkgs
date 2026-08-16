# System-wide glow configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.glow;
in

{
  options.programs.glow = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install glow system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.glow;
      description = "glow package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
