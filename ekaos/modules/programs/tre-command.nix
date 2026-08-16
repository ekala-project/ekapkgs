# System-wide tre-command configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tre-command;
in

{
  options.programs.tre-command = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tre-command system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tre-command;
      description = "tre-command package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
