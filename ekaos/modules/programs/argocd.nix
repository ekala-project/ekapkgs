# System-wide ArgoCD configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.argocd;
in

{
  options.programs.argocd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install argocd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.argocd;
      description = "argocd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
