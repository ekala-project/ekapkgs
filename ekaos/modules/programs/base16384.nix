# System-wide base16384 configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.base16384;
in

{
  options.programs.base16384 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install base16384 system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.base16384;
      description = "base16384 package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
