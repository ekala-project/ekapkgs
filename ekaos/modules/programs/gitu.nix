# System-wide gitu configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.gitu;
in

{
  options.programs.gitu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install gitu system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gitu;
      description = "gitu package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
