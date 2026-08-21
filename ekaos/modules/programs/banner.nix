# System-wide banner configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.banner;
in

{
  options.programs.banner = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install banner system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.banner;
      description = "banner package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
