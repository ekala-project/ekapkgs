# System-wide hexd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hexd;
in

{
  options.programs.hexd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hexd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hexd;
      description = "hexd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
