# System-wide httpx configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.httpx;
in

{
  options.programs.httpx = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install httpx system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.httpx;
      description = "httpx package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
