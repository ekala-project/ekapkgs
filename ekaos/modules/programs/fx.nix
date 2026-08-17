# System-wide fx configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.fx;
in

{
  options.programs.fx = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install fx system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.fx;
      description = "fx package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
