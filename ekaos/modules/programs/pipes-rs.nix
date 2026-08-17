# System-wide pipes-rs configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pipes-rs;
in

{
  options.programs.pipes-rs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pipes-rs system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pipes-rs;
      description = "pipes-rs package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
