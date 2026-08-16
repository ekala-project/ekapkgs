# System-wide ctop configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ctop;
in

{
  options.programs.ctop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ctop system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ctop;
      description = "ctop package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
