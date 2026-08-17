# System-wide bdf2sfd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bdf2sfd;
in

{
  options.programs.bdf2sfd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bdf2sfd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bdf2sfd;
      description = "bdf2sfd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
