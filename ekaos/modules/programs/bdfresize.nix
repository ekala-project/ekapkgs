# System-wide bdfresize configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bdfresize;
in

{
  options.programs.bdfresize = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bdfresize system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bdfresize;
      description = "bdfresize package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
