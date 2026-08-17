# System-wide at configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.at;
in

{
  options.programs.at = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install at system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.at;
      description = "at package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
