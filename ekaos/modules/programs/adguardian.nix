# System-wide adguardian configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.adguardian;
in

{
  options.programs.adguardian = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install adguardian system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.adguardian;
      description = "adguardian package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
