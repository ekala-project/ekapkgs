# System-wide du-dust configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.du-dust;
in

{
  options.programs.du-dust = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install du-dust system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.du-dust;
      description = "du-dust package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
