# System-wide eksctl configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.eksctl;
in

{
  options.programs.eksctl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install eksctl system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.eksctl;
      description = "eksctl package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
