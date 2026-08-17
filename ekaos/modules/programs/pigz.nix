# System-wide pigz configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pigz;
in

{
  options.programs.pigz = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pigz system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pigz;
      description = "pigz package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
