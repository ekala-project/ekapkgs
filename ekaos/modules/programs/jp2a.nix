# System-wide jp2a configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.jp2a;
in

{
  options.programs.jp2a = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install jp2a system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.jp2a;
      description = "jp2a package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
