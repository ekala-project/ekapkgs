# System-wide git-bug configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.git-bug;
in

{
  options.programs.git-bug = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install git-bug system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.git-bug;
      description = "git-bug package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
