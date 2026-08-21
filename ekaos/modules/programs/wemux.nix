# System-wide wemux configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wemux;
in

{
  options.programs.wemux = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wemux system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wemux;
      description = "wemux package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
