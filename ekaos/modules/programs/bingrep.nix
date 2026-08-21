# System-wide bingrep configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bingrep;
in

{
  options.programs.bingrep = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bingrep system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bingrep;
      description = "bingrep package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
