# System-wide bamtools configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bamtools;
in

{
  options.programs.bamtools = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bamtools system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bamtools;
      description = "bamtools package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
