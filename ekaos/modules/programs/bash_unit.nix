# System-wide bash_unit configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bash_unit;
in

{
  options.programs.bash_unit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bash_unit system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bash_unit;
      description = "bash_unit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
