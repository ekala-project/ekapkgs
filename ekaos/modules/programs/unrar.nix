# System-wide unrar configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.unrar;
in

{
  options.programs.unrar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install unrar system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.unrar;
      description = "unrar package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
