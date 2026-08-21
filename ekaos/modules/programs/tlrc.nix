# System-wide tlrc configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tlrc;
in

{
  options.programs.tlrc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tlrc system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tlrc;
      description = "tlrc package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
