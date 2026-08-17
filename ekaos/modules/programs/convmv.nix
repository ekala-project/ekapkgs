# System-wide convmv configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.convmv;
in

{
  options.programs.convmv = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install convmv system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.convmv;
      description = "convmv package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
