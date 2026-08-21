# System-wide hcloud configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hcloud;
in

{
  options.programs.hcloud = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hcloud system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hcloud;
      description = "hcloud package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
