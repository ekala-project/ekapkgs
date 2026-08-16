# System-wide pass-git-helper configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pass-git-helper;
in

{
  options.programs.pass-git-helper = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pass-git-helper system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pass-git-helper;
      description = "pass-git-helper package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
