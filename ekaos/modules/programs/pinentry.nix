# System-wide pinentry configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pinentry;
in

{
  options.programs.pinentry = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pinentry system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pinentry;
      description = "pinentry package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
