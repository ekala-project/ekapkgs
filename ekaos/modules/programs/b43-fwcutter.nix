# System-wide b43-fwcutter configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.b43-fwcutter;
in

{
  options.programs.b43-fwcutter = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install b43-fwcutter system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.b43-fwcutter;
      description = "b43-fwcutter package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
