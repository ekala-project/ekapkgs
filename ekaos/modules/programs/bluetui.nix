# System-wide bluetui configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bluetui;
in

{
  options.programs.bluetui = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bluetui system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bluetui;
      description = "bluetui package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
