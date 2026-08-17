# System-wide gh-dash configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.gh-dash;
in

{
  options.programs.gh-dash = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install gh-dash system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gh-dash;
      description = "gh-dash package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
