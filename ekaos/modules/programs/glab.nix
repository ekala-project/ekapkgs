# System-wide glab configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.glab;
in

{
  options.programs.glab = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install glab system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.glab;
      description = "glab package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
