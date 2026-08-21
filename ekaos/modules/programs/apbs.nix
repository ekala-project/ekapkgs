# System-wide apbs configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apbs;
in

{
  options.programs.apbs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apbs system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apbs;
      description = "apbs package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
