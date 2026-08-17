# System-wide asunder configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asunder;
in

{
  options.programs.asunder = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asunder system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asunder;
      description = "asunder package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
