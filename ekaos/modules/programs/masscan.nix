# System-wide masscan configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.masscan;
in

{
  options.programs.masscan = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install masscan system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.masscan;
      description = "masscan package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
