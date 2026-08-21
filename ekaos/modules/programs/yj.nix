# System-wide yj configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.yj;
in

{
  options.programs.yj = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install yj system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.yj;
      description = "yj package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
