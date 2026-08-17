# System-wide delve configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.delve;
in

{
  options.programs.delve = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install delve system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.delve;
      description = "delve package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
