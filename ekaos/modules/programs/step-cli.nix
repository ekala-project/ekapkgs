# System-wide step-cli configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.step-cli;
in

{
  options.programs.step-cli = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install step-cli system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.step-cli;
      description = "step-cli package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
