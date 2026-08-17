# System-wide lz4 configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lz4;
in

{
  options.programs.lz4 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lz4 system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lz4;
      description = "lz4 package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
