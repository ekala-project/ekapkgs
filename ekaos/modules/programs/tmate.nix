# System-wide tmate configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tmate;
in

{
  options.programs.tmate = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tmate system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tmate;
      description = "tmate package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
