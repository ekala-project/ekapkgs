# System-wide autologin configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.autologin;
in

{
  options.programs.autologin = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install autologin system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.autologin;
      description = "autologin package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
