# System-wide nitrocli configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nitrocli;
in

{
  options.programs.nitrocli = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nitrocli system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nitrocli;
      description = "nitrocli package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
