# System-wide autotrace configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.autotrace;
in

{
  options.programs.autotrace = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install autotrace system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.autotrace;
      description = "autotrace package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
