# System-wide choose configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.choose;
in

{
  options.programs.choose = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install choose system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.choose;
      description = "choose package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
