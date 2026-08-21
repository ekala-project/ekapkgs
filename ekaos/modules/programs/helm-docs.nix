# System-wide helm-docs configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.helm-docs;
in

{
  options.programs.helm-docs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install helm-docs system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.helm-docs;
      description = "helm-docs package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
