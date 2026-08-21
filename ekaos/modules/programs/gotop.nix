# System-wide gotop configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.gotop;
in

{
  options.programs.gotop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install gotop system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gotop;
      description = "gotop package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
