# System-wide aptdec configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aptdec;
in

{
  options.programs.aptdec = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aptdec system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aptdec;
      description = "aptdec package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
