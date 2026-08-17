# System-wide acme configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.acme;
in

{
  options.programs.acme = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install acme system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.acme;
      description = "acme package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
