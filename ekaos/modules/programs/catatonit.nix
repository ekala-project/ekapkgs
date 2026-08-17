# System-wide catatonit configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.catatonit;
in

{
  options.programs.catatonit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install catatonit system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.catatonit;
      description = "catatonit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
