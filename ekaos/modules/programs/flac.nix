# System-wide flac configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.flac;
in

{
  options.programs.flac = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install flac system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.flac;
      description = "flac package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
