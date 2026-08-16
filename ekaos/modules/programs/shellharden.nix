# System-wide shellharden configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.shellharden;
in

{
  options.programs.shellharden = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install shellharden system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.shellharden;
      description = "shellharden package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
