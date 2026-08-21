# System-wide inadyn configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.inadyn;
in

{
  options.programs.inadyn = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install inadyn system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.inadyn;
      description = "inadyn package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
