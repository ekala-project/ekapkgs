# System-wide oath-toolkit configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.oath-toolkit;
in

{
  options.programs.oath-toolkit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install oath-toolkit system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.oath-toolkit;
      description = "oath-toolkit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
