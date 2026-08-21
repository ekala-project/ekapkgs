# System-wide cloudflared configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cloudflared;
in

{
  options.programs.cloudflared = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cloudflared system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cloudflared;
      description = "cloudflared package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
