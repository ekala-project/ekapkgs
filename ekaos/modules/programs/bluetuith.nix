# System-wide bluetuith configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bluetuith;
in

{
  options.programs.bluetuith = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bluetuith system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bluetuith;
      description = "bluetuith package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
