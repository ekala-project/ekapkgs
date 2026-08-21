# System-wide figlet configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.figlet;
in

{
  options.programs.figlet = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install figlet system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.figlet;
      description = "figlet package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
