# System-wide watchexec configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.watchexec;
in

{
  options.programs.watchexec = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install watchexec system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.watchexec;
      description = "watchexec package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
