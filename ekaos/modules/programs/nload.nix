# System-wide nload configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nload;
in

{
  options.programs.nload = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nload system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nload;
      description = "nload package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
