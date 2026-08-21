# System-wide pam_u2f configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pam_u2f;
in

{
  options.programs.pam_u2f = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pam_u2f system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pam_u2f;
      description = "pam_u2f package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
