# System-wide a52dec configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.a52dec;
in

{
  options.programs.a52dec = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install a52dec system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.a52dec;
      description = "a52dec package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
