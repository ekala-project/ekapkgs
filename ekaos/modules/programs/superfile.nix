# System-wide superfile configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.superfile;
in

{
  options.programs.superfile = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install superfile system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.superfile;
      description = "superfile package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
