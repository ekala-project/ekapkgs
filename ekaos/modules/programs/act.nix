# System-wide act configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.act;
in

{
  options.programs.act = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install act system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.act;
      description = "act package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
