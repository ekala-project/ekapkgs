# System-wide umoci configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.umoci;
in

{
  options.programs.umoci = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install umoci system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.umoci;
      description = "umoci package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
