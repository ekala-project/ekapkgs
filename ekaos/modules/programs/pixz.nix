# System-wide pixz configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pixz;
in

{
  options.programs.pixz = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pixz system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pixz;
      description = "pixz package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
