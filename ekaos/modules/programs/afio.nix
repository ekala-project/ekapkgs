# System-wide afio configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.afio;
in

{
  options.programs.afio = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install afio system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.afio;
      description = "afio package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
