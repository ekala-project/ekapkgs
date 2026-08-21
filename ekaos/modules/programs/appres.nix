# System-wide appres configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.appres;
in

{
  options.programs.appres = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install appres system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.appres;
      description = "appres package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
