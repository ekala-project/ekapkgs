# System-wide dua configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dua;
in

{
  options.programs.dua = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dua system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dua;
      description = "dua package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
