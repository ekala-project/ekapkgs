# System-wide k6 configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.k6;
in

{
  options.programs.k6 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install k6 system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.k6;
      description = "k6 package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
