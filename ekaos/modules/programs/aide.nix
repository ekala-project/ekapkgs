# System-wide aide configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aide;
in

{
  options.programs.aide = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aide system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aide;
      description = "aide package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
