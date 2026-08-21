# System-wide editorconfig-core-c configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.editorconfig;
in

{
  options.programs.editorconfig = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install editorconfig-core-c system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.editorconfig-core-c;
      description = "editorconfig-core-c package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
