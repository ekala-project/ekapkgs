# System-wide oauth2c configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.oauth2c;
in

{
  options.programs.oauth2c = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install oauth2c system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.oauth2c;
      description = "oauth2c package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
