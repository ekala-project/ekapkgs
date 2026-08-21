# System-wide gitui configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.gitui;
in

{
  options.programs.gitui = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install gitui system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gitui;
      description = "gitui package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
