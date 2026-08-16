# System-wide trash-cli configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.trash-cli;
in

{
  options.programs.trash-cli = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install trash-cli system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.trash-cli;
      description = "trash-cli package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
