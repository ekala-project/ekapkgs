# System-wide rename configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rename;
in

{
  options.programs.rename = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install rename system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rename;
      description = "rename package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
