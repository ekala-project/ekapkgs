# System-wide eva configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.eva;
in

{
  options.programs.eva = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install eva system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.eva;
      description = "eva package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
