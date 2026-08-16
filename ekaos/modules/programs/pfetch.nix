# System-wide pfetch configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pfetch;
in

{
  options.programs.pfetch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pfetch system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pfetch;
      description = "pfetch package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
