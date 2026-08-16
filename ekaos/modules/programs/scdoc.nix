# System-wide scdoc configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.scdoc;
in

{
  options.programs.scdoc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install scdoc system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.scdoc;
      description = "scdoc package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
