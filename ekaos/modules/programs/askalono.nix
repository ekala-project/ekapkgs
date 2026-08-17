# System-wide askalono configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.askalono;
in

{
  options.programs.askalono = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install askalono system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.askalono;
      description = "askalono package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
