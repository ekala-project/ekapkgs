# System-wide git-absorb configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.git-absorb;
in

{
  options.programs.git-absorb = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install git-absorb system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.git-absorb;
      description = "git-absorb package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
