# System-wide doggo configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.doggo;
in

{
  options.programs.doggo = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install doggo system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.doggo;
      description = "doggo package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
