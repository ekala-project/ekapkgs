# System-wide ffuf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ffuf;
in

{
  options.programs.ffuf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ffuf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ffuf;
      description = "ffuf package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
