# System-wide git-cliff configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.git-cliff;
in

{
  options.programs.git-cliff = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install git-cliff system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.git-cliff;
      description = "git-cliff package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
