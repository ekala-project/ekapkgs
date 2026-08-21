# System-wide bore-cli configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bore-cli;
in

{
  options.programs.bore-cli = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bore-cli system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bore-cli;
      description = "bore-cli package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
