# System-wide kubectl-cnpg configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.kubectl-cnpg;
in

{
  options.programs.kubectl-cnpg = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install kubectl-cnpg system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.kubectl-cnpg;
      description = "kubectl-cnpg package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
