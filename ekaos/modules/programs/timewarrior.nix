# System-wide timewarrior configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.timewarrior;
in

{
  options.programs.timewarrior = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install timewarrior system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.timewarrior;
      description = "timewarrior package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
