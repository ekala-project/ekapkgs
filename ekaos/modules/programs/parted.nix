# System-wide parted configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.parted;
in

{
  options.programs.parted = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install parted system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.parted;
      description = "parted package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
