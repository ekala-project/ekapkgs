# System-wide argocd-autopilot configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.argocd-autopilot;
in

{
  options.programs.argocd-autopilot = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install argocd-autopilot system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.argocd-autopilot;
      description = "argocd-autopilot package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
