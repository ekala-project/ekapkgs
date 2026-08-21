# System-wide websocat configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.websocat;
in

{
  options.programs.websocat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install websocat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.websocat;
      description = "websocat package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
