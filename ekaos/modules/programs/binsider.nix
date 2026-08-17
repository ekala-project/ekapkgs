# System-wide binsider configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.binsider;
in

{
  options.programs.binsider = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install binsider system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.binsider;
      description = "binsider package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
