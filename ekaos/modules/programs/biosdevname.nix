# System-wide biosdevname configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.biosdevname;
in

{
  options.programs.biosdevname = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install biosdevname system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.biosdevname;
      description = "biosdevname package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
