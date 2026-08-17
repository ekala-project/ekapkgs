# System-wide kubetui configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.kubetui;
in

{
  options.programs.kubetui = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install kubetui system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.kubetui;
      description = "kubetui package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
