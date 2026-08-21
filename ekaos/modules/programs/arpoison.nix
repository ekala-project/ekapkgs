# System-wide arpoison configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.arpoison;
in

{
  options.programs.arpoison = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install arpoison system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.arpoison;
      description = "arpoison package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
