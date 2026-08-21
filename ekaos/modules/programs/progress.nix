# System-wide progress configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.progress;
in

{
  options.programs.progress = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install progress system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.progress;
      description = "progress package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
