# System-wide nvi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nvi;
in

{
  options.programs.nvi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nvi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nvi;
      description = "nvi package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
