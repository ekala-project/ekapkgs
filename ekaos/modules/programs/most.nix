# System-wide most configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.most;
in

{
  options.programs.most = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install most system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.most;
      description = "most package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
