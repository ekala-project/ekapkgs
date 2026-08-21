# System-wide nuclei configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nuclei;
in

{
  options.programs.nuclei = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nuclei system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nuclei;
      description = "nuclei package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
