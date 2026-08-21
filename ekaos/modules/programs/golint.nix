# System-wide golint configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.golint;
in

{
  options.programs.golint = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install golint system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.golint;
      description = "golint package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
