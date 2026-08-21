# System-wide nitrogen configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nitrogen;
in

{
  options.programs.nitrogen = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nitrogen system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nitrogen;
      description = "nitrogen package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
