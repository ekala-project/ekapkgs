# System-wide minicom configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.minicom;
in

{
  options.programs.minicom = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install minicom system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.minicom;
      description = "minicom package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
