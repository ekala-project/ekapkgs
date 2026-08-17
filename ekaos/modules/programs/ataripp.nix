# System-wide ataripp configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ataripp;
in

{
  options.programs.ataripp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ataripp system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ataripp;
      description = "ataripp package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
