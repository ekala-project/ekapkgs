# System-wide mkfontscale configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mkfontscale;
in

{
  options.programs.mkfontscale = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mkfontscale system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mkfontscale;
      description = "mkfontscale package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
