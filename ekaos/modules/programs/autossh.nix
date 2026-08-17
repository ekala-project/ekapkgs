# System-wide autossh configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.autossh;
in

{
  options.programs.autossh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install autossh system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.autossh;
      description = "autossh package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
