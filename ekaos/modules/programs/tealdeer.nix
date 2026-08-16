# System-wide tealdeer configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tealdeer;
in

{
  options.programs.tealdeer = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tealdeer system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tealdeer;
      description = "tealdeer package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
