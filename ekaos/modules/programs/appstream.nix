# System-wide appstream configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.appstream;
in

{
  options.programs.appstream = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install appstream system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.appstream;
      description = "appstream package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
