# System-wide httrack configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.httrack;
in

{
  options.programs.httrack = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install httrack system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.httrack;
      description = "httrack package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
