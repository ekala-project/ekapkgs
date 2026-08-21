# System-wide automaticcomponenttoolkit configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.automaticcomponenttoolkit;
in

{
  options.programs.automaticcomponenttoolkit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install automaticcomponenttoolkit system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.automaticcomponenttoolkit;
      description = "automaticcomponenttoolkit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
