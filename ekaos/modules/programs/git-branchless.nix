# System-wide git-branchless configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.git-branchless;
in

{
  options.programs.git-branchless = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install git-branchless system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.git-branchless;
      description = "git-branchless package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
