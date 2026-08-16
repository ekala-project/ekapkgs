# System-wide tmuxinator configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tmuxinator;
in

{
  options.programs.tmuxinator = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tmuxinator system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tmuxinator;
      description = "tmuxinator package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
