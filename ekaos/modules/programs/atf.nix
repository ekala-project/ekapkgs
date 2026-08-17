# System-wide atf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.atf;
in

{
  options.programs.atf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install atf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.atf;
      description = "atf package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
