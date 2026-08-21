# System-wide aws-nuke configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aws-nuke;
in

{
  options.programs.aws-nuke = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aws-nuke system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aws-nuke;
      description = "aws-nuke package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
