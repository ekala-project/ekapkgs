# System-wide doctl configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.doctl;
in

{
  options.programs.doctl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install doctl system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.doctl;
      description = "doctl package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
