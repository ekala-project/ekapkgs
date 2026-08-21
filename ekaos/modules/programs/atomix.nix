# System-wide atomix configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.atomix;
in

{
  options.programs.atomix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install atomix system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.atomix;
      description = "atomix package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
