# System-wide stgit configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.stgit;
in

{
  options.programs.stgit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install stgit system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.stgit;
      description = "stgit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
