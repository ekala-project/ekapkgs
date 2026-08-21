# System-wide ugit configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ugit;
in

{
  options.programs.ugit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ugit system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ugit;
      description = "ugit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
