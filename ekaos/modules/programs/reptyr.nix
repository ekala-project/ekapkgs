# System-wide reptyr configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.reptyr;
in

{
  options.programs.reptyr = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install reptyr system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.reptyr;
      description = "reptyr package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
