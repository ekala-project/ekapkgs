# System-wide AVRA configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.avra;
in

{
  options.programs.avra = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install AVRA system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.avra;
      description = "AVRA package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
