# System-wide dnsx configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dnsx;
in

{
  options.programs.dnsx = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dnsx system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dnsx;
      description = "dnsx package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
