# System-wide sd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sd;
in

{
  options.programs.sd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sd;
      description = "sd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
