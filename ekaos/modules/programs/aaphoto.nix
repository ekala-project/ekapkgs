# System-wide aaphoto configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aaphoto;
in

{
  options.programs.aaphoto = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aaphoto system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aaphoto;
      description = "aaphoto package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
