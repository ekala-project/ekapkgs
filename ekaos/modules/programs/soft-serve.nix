# System-wide soft-serve configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.soft-serve;
in

{
  options.programs.soft-serve = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install soft-serve system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.soft-serve;
      description = "soft-serve package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
